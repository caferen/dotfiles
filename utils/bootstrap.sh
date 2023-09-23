#!/bin/bash

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

install_python() {
    pacman_install python
    python -m ensurepip --upgrade
}

helix() {
    [[ -d $HOME/helix ]] || git clone https://github.com/helix-editor/helix.git $HOME/helix
    (
        cd $HOME/helix
        git checkout master && git pull
        cargo install --path helix-term --locked
    )
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
    yay_install plasma-desktop dolphin ark networkmanager sddm plasma-nm \
        plasma-pa kscreen bluedevil spectacle kwin-bismuth
    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
}

sudo pacman -Syu
pacman_install git base-devel man curl make
install_yay
configure_git_and_github
get_dotfiles
configure_shell
yay_install neovim-git ripgrep
helix

yay_install cronie syncthing
sudo systemctl enable cronie.service
sudo systemctl enable syncthing@"$USER".service

install_typescript
install_rust
install_python

if uname -r | grep -v microsoft; then
    yay_install linux-headers nvidia coolercontrol lm-sensors libusb xclip
    plasma
    yay_install ttf-meslo-nerd-font-powerlevel10k alacritty brave-bin vscodium-bin
    # yay_install cuda discord steam blender cura-bin mangohud gamemode

    # echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg

    [[ -f /etc/conf.d/lm_sensors ]] || sudo sensors-detect
    sudo systemctl enable coolercontrold.service
    sudo systemctl enable systemd-resolved.service

    [[ -d $HOME/ssd ]] || (mkdir $HOME/ssd && sudo chown $USER:$USER $HOME/ssd -R && echo "UUID=703f4ec4-5cd5-4a7e-b3bc-d7429180151a       /home/eren/ssd  ext4    defaults        0       0" | sudo tee -a /etc/fstab)

    keyboard
else
    read -p "Windows username: " WINDOWS_USERNAME
    cp $HOME/utils/exes/win32yank.exe /mnt/c/Users/"$WINDOWS_USERNAME"/Arch/
fi
