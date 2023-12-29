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
    sudo ln -s $HOME/utils/fonts/* /usr/share/fonts/TTF/
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
}

plasma() {
    pacman_install plasma-desktop dolphin networkmanager sddm plasma-nm \
        plasma-pa bluedevil spectacle plasma-wayland-session wl-clipboard
    yay_install kwin-bismuth-bin

    if [[ "$(sudo cat /sys/module/nvidia_drm/parameters/modeset)" == 'N' ]]; then
        echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf
        sudo mkinitcpio -P
    fi

    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
}

pipewire() {
    pacman_install pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
    systemctl enable --user pipewire pipewire-pulse.service
}

drive() {
    [[ -d "$2" ]] || (mkdir "$2" && sudo chown $USER:$USER "$2" -R \
            &&  echo "UUID=${1}     "$2"  ext4    defaults,nofail 0 0" \
        | sudo tee -a /etc/fstab)
}

sekuurity() {
    # set kernel parameters: lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1
    pacman_install ufw apparmor
    sudo systemctl enable --now ufw.service apparmor.service auditd.service
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # kdeconnect
    sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto udp
    sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto tcp

    # syncthing
    sudo ufw allow from 192.168.1.0/24 to any port 21027 proto udp
    sudo ufw allow from 192.168.1.0/24 to any port 22000 proto tcp

    sudo ufw enable

    yay -S apparmor.d-git
    echo 'write-cache' | sudo tee -a /etc/apparmor/parser.conf
    echo 'Optimize=compress-fast' | sudo tee -a /etc/apparmor/parser.conf

    sudo aa-enforce /etc/apparmor.d/*

    for line in $(curl https://raw.githubusercontent.com/caferen/dotfiles/master/utils/complain); do
        sudo aa-complain /etc/apparmor.d/"$line"
    done

    yay -S hardened-malloc-git
    echo /usr/lib/libhardened_malloc.so | sudo tee -a /etc/ld.so.preload
    echo "vm.max_map_count = 1048576" | sudo tee -a /etc/sysctl.d/hardened_malloc.conf

    sudo pacman -S firejail
    sudo firecfg
    echo "force-nonewprivs yes" | sudo tee -a /etc/firejail/firejail.config
    curl https://raw.githubusercontent.com/caferen/dotfiles/master/utils/hooks/firejail.hook \
        | sudo tee /etc/pacman.d/hooks/firejail.hook
}

# Initialize a fresh install
if [ "$1" == "--init" ]; then
    sudo pacman -Syu
    pacman_install git base-devel man curl make neovim alacritty linux-zen-headers nvidia-dkms
    install_yay
    sekuurity
    plasma
    pipewire
    sudo systemctl enable systemd-resolved.service
    sudo pacman -Rdd geoclue krunner && pacman -Qtdq | sudo pacman -Rns -
    exit 0
fi

# Bootstrap rest of the system following a reboot after --init
if [ "$1" == "--bootstrap" ]; then
    get_dotfiles
    configure_shell

    pacman_install syncthing gocryptfs
    systemctl enable --user syncthing.service

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    pacman_install python python-pip

    pacman_install steam blender mangohud vlc signal-desktop \
        libusb fzf ripgrep unzip lm_sensors

    yay_install cura-bin heroic-games-launcher-bin spotify \
        coolercontrol vscodium-bin neovim-git mullvad-vpn-bin

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

    drive "703f4ec4-5cd5-4a7e-b3bc-d7429180151a" $HOME/ssd
    drive "963da330-ae54-4d3f-b2fa-a055b98b9308" $HOME/backup
    # drive "3289a1d1-61cd-45bf-9f2d-c9932913bb6f" $HOME/password

    keyboard

    for service in $HOME/.config/systemd/user/*(timer|path|service); do
        systemctl --user enable "$service"
    done

    echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

    exit 0
fi
