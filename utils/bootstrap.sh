# echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg

pacman_install() {
    sudo pacman -S --noconfirm --needed "$@"
}

yay_install() {
    yay -S --noconfirm --needed "$@"
}

install_yay() {
    if ! which yay; then
        pacman_install git base-devel
        git clone https://aur.archlinux.org/yay-bin.git $HOME/yay-bin
        (
            cd $HOME/yay-bin
            makepkg -si --noconfirm --needed
        )
        rm -rf $HOME/yay-bin
        yay -Y --devel --combinedupgrade --batchinstall --answerclean None \
            --answerdiff None --answerupgrade None --answeredit None --removemake \
            --noconfirm --save
    fi
}

get_dotfiles() {
    pacman_install rsync
    if [[ ! -d $HOME/utils ]]; then
        rm -rf $HOME/dotfiles
        gh repo clone dotfiles $HOME/dotfiles
        rsync -r $HOME/dotfiles/ $HOME
        rm -rf $HOME/dotfiles
    fi
}

configure_git_and_github() {
    if ! which gh; then
        git config --global user.email "eren.simsek@tuta.io"
        git config --global user.name "Eren"
        git config --global push.autoSetupRemote true
        pacman_install github-cli
        gh auth login
        gh auth setup-git
    fi
}

install_rust() {
    if ! which rustup; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        rustup update
    fi
}

install_typescript() {
    yay_install nvm
    source /usr/share/nvm/init-nvm.sh
    if ! which npm; then
        nvm install node
        npm install -g typescript
    else
        nvm install node --reinstall-packages-from=$(nvm current)
    fi
}

configure_shell() {
    pacman_install zsh tmux starship
    [[ -d $HOME/.oh-my-zsh ]] || ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/caferen/dotfiles/master/utils/ohmyzsh.sh)"
}

keyboard() {
    # @formatter:off
    echo 'KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"' \
    | sudo tee /etc/udev/rules.d/50-zsa.rules > /dev/null 2>&1

    echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"' \
    | sudo tee /etc/udev/rules.d/92-viia.rules > /dev/null 2>&1
    # @formatter:on

    sudo groupadd plugdev
    sudo usermod -aG plugdev $USER
    yay_install wally-cli
}

plasma() {
    yay_install plasma-desktop dolphin networkmanager sddm plasma-nm \
        plasma-pa bluedevil spectacle kwin-bismuth plasma-wayland-session wl-clipboard

    if [[ "$(sudo cat /sys/module/nvidia_drm/parameters/modeset)" == 'N' ]]; then
        echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf
        sudo mkinitcpio -P
    fi

    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
}

pipewire() {
    yay_install pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
    systemctl enable --user pipewire-pulse.service
}

drive() {
    if [[ ! -d "$2" ]]; then
        mkdir "$2"
        sudo chown $USER:$USER "$2" -R
        echo "UUID=${1}       "$2"  ext4    defaults,nofail        0 0" \
            | sudo tee -a /etc/fstab

        sudo systemctl daemon-reload
        sudo mount "$2"
    fi
}

services() {
    for service in $HOME/utils/services/*.service; do
        local name=$(basename "$service")
        if [[ ! -f /etc/systemd/system/"$name" ]]; then
            sudo ln -s "$service" /etc/systemd/system
            sudo systemctl enable "$name"
        fi
    done
}

drives() {
    drive "703f4ec4-5cd5-4a7e-b3bc-d7429180151a" $HOME/ssd
    drive "41bd16a6-d7ef-4cda-aed6-0a52f3c0db0a" $HOME/backup
    drive "3289a1d1-61cd-45bf-9f2d-c9932913bb6f" $HOME/password
}

sudo pacman -Syu
pacman_install git base-devel man curl make
install_yay
configure_git_and_github
get_dotfiles
configure_shell
yay_install neovim-git ripgrep unzip helix

yay_install syncthing gocryptfs
systemctl enable --user syncthing.service

install_typescript
install_rust
pacman_install python python-pip

yay
yay_install linux-zen-headers nvidia-dkms coolercontrol lm-sensors libusb
plasma
pipewire
yay_install ttf-meslo-nerd-font-powerlevel10k alacritty brave-bin vscodium-bin fzf
    # @formatter:off
    echo "asvetliakov.vscode-neovim
eamodio.gitlens
GitHub.github-vscode-theme
ms-python.python
rust-lang.rust-analyzer
vadimcn.vscode-lldb" | xargs -L1 codium --install-extension &> /dev/null
    # @formatter:on

yay_install discord steam blender cura-bin mangohud gamemode


[[ -f /etc/conf.d/lm_sensors ]] || sudo sensors-detect
sudo systemctl enable coolercontrold.service
sudo systemctl enable systemd-resolved.service

drives
keyboard
services
