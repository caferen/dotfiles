# echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg

pacman_install() {
    sudo pacman -S --noconfirm --needed "$@"
}

yay_install() {
    yay -S --noconfirm --needed "$@"
}

install_yay() {
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
}

get_dotfiles() {
    pacman_install rsync
    rm -rf $HOME/dotfiles
    git clone https://github.com/caferen/dotfiles.git $HOME/dotfiles
    rsync -r $HOME/dotfiles/ $HOME
    rm -rf $HOME/dotfiles
}

configure_git_and_github() {
    git config --global user.email "eren.simsek@tuta.io"
    git config --global user.name "Eren"
    git config --global push.autoSetupRemote true
    pacman_install github-cli
    gh auth login
    gh auth setup-git
}

install_typescript() {
    yay_install nvm
    source /usr/share/nvm/init-nvm.sh
    nvm install node
    npm install -g typescript
}

configure_shell() {
    pacman_install zsh tmux starship
    [[ -d $HOME/.oh-my-zsh ]] || ZSH= sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/caferen/dotfiles/master/utils/ohmyzsh.sh)"
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
    [[ -d "$2" ]] || (mkdir "$2" && sudo chown $USER:$USER "$2" -R \
            &&  echo "UUID=${1}     "$2"  ext4    defaults,nofail 0 0" \
        | sudo tee -a /etc/fstab)
}

init() {
    sudo pacman -Syu
    pacman_install git base-devel man curl make helix linux-zen-headers nvidia-dkms
    install_yay
    plasma
    pipewire
    yay_install ttf-meslo-nerd-font-powerlevel10k alacritty brave-bin
    exit 0
}

# Initialize a fresh install
if [ "$1" == "--init" ]; then
    init
fi

# Bootstrap rest of the system following a reboot after --init
if [ "$1" == "--bootstrap" ]; then
    configure_git_and_github
    get_dotfiles
    configure_shell

    yay_install syncthing gocryptfs
    systemctl enable --user syncthing.service

    install_typescript
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    pacman_install python python-pip

    yay_install discord steam blender cura-bin mangohud gamemode element-desktop freetube-bin \
        heroic-games-launcher-bin mullvad-vpn thunderbird vlc signal-desktop spotify \
        coolercontrol lm-sensors libusb vscodium-bin fzf neovim-git ripgrep unzip

        # @formatter:off
        echo "asvetliakov.vscode-neovim
    eamodio.gitlens
    GitHub.github-vscode-theme
    ms-python.python
    rust-lang.rust-analyzer
    vadimcn.vscode-lldb" | xargs -L1 codium --install-extension &> /dev/null
        # @formatter:on

    [[ -f /etc/conf.d/lm_sensors ]] || sudo sensors-detect
    sudo systemctl enable coolercontrold.service
    sudo systemctl enable systemd-resolved.service

    drive "703f4ec4-5cd5-4a7e-b3bc-d7429180151a" $HOME/ssd
    drive "963da330-ae54-4d3f-b2fa-a055b98b9308" $HOME/backup
    drive "3289a1d1-61cd-45bf-9f2d-c9932913bb6f" $HOME/password

    keyboard
    exit 0
fi

# Update
yay
rustup self update && rustup update
source /usr/share/nvm/init-nvm.sh && nvm install node --reinstall-packages-from=$(nvm current)

for service in $HOME/utils/services/*.service; do
    sudo systemctl enable "$service"
done
