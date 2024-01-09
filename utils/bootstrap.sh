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
    sudo ln -s $HOME/utils/fonts/* /usr/share/fonts/
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
    pacman_install plasma-desktop dolphin sddm plasma-nm  \
        plasma-pa bluedevil spectacle plasma-wayland-session
    yay_install kwin-bismuth

    sudo systemctl enable sddm.service
}

hyprland() {
    pacman_install hyprland qt5-wayland qt5ct libva xdg-desktop-portal-hyprland \
        qt6-wayland polkit-kde-agent hyprpaper waybar dunst grim slurp swaylock
}

desktop() {
    pacman_install networkmanager kdeconnect wl-clipboard bluez
    yay_install brave-bin

    if [[ "$(sudo cat /sys/module/nvidia_drm/parameters/modeset)" == 'N' ]]; then
        sudo sed -i 's/^MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf
        sudo mkinitcpio -P
    fi

    sudo systemctl enable NetworkManager.service bluetooth.service

    pipewire

    # plasma
    hyprland
}

pipewire() {
    pacman_install pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
    systemctl enable --user pipewire pipewire-pulse.service
}

drive() {
    [[ -d "$2" ]] || (mkdir "$2" && \
            echo "UUID=${1}     "$2"  ext4    defaults,nofail"$3" 0 0" \
        | sudo tee -a /etc/fstab)
    sudo chown $USER:$USER "$2" -R
}

firewall() {
    pacman_install ufw
    sudo systemctl enable --now ufw.service
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # kdeconnect
    sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto udp
    sudo ufw allow from 192.168.1.0/24 to any port 1714:1764 proto tcp

    # syncthing
    sudo ufw allow from 192.168.1.0/24 to any port 21027 proto udp
    sudo ufw allow from 192.168.1.0/24 to any port 22000 proto tcp

    sudo ufw enable
}

sekuurity() {
    firewall

    # https://wiki.archlinux.org/title/Security#Disable_kexec
    echo "kernel.kexec_load_disabled = 1" | sudo tee /etc/sysctl.d/51-kexec-restrict.conf

    # # https://wiki.archlinux.org/title/Security#Linux_Kernel_Runtime_Guard_(LKRG)
    # yay -S lkrg-dkms

    # https://wiki.archlinux.org/title/Security#Sandboxing_applications
    echo "kernel.unprivileged_userns_clone = 1" | sudo tee /etc/sysctl.d/unp_user.conf

    echo "PermitRootLogin no" | sudo tee /etc/ssh/sshd_config.d/20-deny_root.conf

    # https://wiki.archlinux.org/title/Core_dump#Using_systemd
    sudo mkdir /etc/systemd/coredump.conf.d
    # @formatter:off
    echo "[Coredump]
Storage=none
ProcessSizeMax=0" | sudo tee /etc/systemd/coredump.conf.d/disable.conf

    # https://wiki.archlinux.org/title/IPv6#NetworkManager
    echo "[connection]
ipv6.ip6-privacy=2" | sudo tee /etc/NetworkManager/conf.d/ip6-privacy.conf
    # @formatter:on

    pacman_install macchanger
    sudo systemctl enable --now $HOME/utils/services/randomize.service
}

if [ "$1" == "--init" ]; then
    sudo pacman -Syu
    pacman_install git base-devel man curl make alacritty linux-zen-headers nvidia-dkms usbutils \
        python fzf ripgrep unzip steam syncthing mangohud gocryptfs gamemode
    install_yay
    yay_install neovim-git
    get_dotfiles
    configure_shell
    sekuurity
    desktop
    sudo systemctl enable --now systemd-resolved.service
    systemctl enable --user --now syncthing.service

    drive "703f4ec4-5cd5-4a7e-b3bc-d7429180151a" $HOME/ssd ",nosuid,nodev"
    drive "963da330-ae54-4d3f-b2fa-a055b98b9308" $HOME/backup ",noexec,nosuid,nodev"
    drive "3289a1d1-61cd-45bf-9f2d-c9932913bb6f" $HOME/password ",noexec,nosuid,nodev"

    find $HOME/.config/systemd/user/ -maxdepth 1 -regextype egrep -regex \
        '.*(timer|path|service)' -exec systemctl enable --user --now '{}' \;

    find $HOME/.config/systemd/root/ -maxdepth 1 -regextype egrep -regex \
        '.*(timer|path|service)' -exec sudo systemctl enable --now '{}' \;

    exit 0
fi

if [ "$1" == "--bootstrap" ]; then
    if ! which rustup; then curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh; fi
    pacman_install blender vlc signal-desktop libusb lm_sensors github-cli
    yay_install cura-bin heroic-games-launcher-bin coolercontrol vscodium-bin spotify mullvad-vpn-bin

    [[ -f /etc/conf.d/lm_sensors ]] || sudo sensors-detect
    sudo systemctl enable --now coolercontrold.service

    # @formatter:off
    echo "asvetliakov.vscode-neovim
eamodio.gitlens
golf1052.base16-generator
ms-python.python
rust-lang.rust-analyzer
vadimcn.vscode-lldb" | xargs -L1 codium --install-extension &> /dev/null
    # @formatter:on

    keyboard
    gh auth login

    sudo passwd --lock root
    sudo pacman -Rdd geoclue
    pacman -Qtdq | sudo pacman -Rns -

    # echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg
    gsettings set org.gnome.desktop.wm.preferences button-layout ':maximize,close'

    exit 0
fi
