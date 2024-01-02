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
    yay_install kwin-bismuth

    if [[ "$(sudo cat /sys/module/nvidia_drm/parameters/modeset)" == 'N' ]]; then
        echo options nvidia_drm modeset=1 | sudo tee /etc/modprobe.d/nvidia_drm.conf
        sudo mkinitcpio -P
    fi

    sudo systemctl enable sddm.service NetworkManager.service bluetooth.service
}

pipewire() {
    pacman_install pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber
    systemctl enable --user pipewire pipewire-pulse.service
}

drive() {
    [[ -d "$2" ]] || (mkdir "$2" && sudo chown $USER:$USER "$2" -R \
            &&  echo "UUID=${1}     "$2"  ext4    defaults,nofail"$3" 0 0" \
        | sudo tee -a /etc/fstab)
}

firejail() {
    sudo pacman -S firejail
    sudo firecfg
    echo "force-nonewprivs yes" | sudo tee -a /etc/firejail/firejail.config
    sudo cp $HOME/utils/hooks/firejail.hook /etc/pacman.d/hooks/firejail.hook
}

apparmor() {
    # set kernel parameters: lsm=landlock,lockdown,yama,integrity,apparmor,bpf audit=1
    sudo systemctl enable --now apparmor.service auditd.service
    pacman_install apparmor
    yay_install apparmor.d-git

    echo 'write-cache' | sudo tee -a /etc/apparmor/parser.conf
    echo 'Optimize=compress-fast' | sudo tee -a /etc/apparmor/parser.conf

    sudo aa-enforce /etc/apparmor.d/*

    while read line ; do
        sudo aa-complain /etc/apparmor.d/"$line"
    done <$HOME/utils/complain

    groupadd -r audit
    gpasswd -a $USER audit
}

clamav() {
    pacman_install clamav
    sudo systemctl enable --now clamav-freshclam.service clamav-daemon.service

    # https://wiki.archlinux.org/title/ClamAV#Troubleshooting
    curl https://secure.eicar.org/eicar.com.txt | clamscan - | grep "stdin: Win.Test.EICAR_HDB-1 FOUND" \
        || echo "ERROR ClamAV is not setup properly"

    yay -S python-fangfrisch
    sudo -u clamav /usr/bin/fangfrisch --conf /etc/fangfrisch/fangfrisch.conf initdb
    sudo systemctl enable --now fangfrisch.timer
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

# hardened malloc breaks steam and spotify for some reason
hardened_malloc() {
    yay -S hardened-malloc-git
    echo /usr/lib/libhardened_malloc.so | sudo tee -a /etc/ld.so.preload
    echo "vm.max_map_count = 1048576" | sudo tee -a /etc/sysctl.d/hardened_malloc.conf
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

    sudo mkdir /etc/systemd/coredump.conf.d
    # @formatter:off
    echo "[Coredump]
Storage=none" | sudo tee /etc/systemd/coredump.conf.d/disable.conf

    echo "[connection]
ipv6.ip6-privacy=2" | sudo tee /etc/NetworkManager/conf.d/ip6-privacy.conf
    # @formatter:on

    pacman_install macchanger
    sudo systemctl enable --now $HOME/utils/services/randomize.service
}

# Initialize a fresh install
if [ "$1" == "--init" ]; then
    sudo pacman -Syu
    pacman_install git base-devel man curl make neovim alacritty linux-zen-headers nvidia-dkms
    install_yay
    plasma
    pipewire
    sudo systemctl enable systemd-resolved.service
    exit 0
fi

# Bootstrap rest of the system following a reboot after --init
if [ "$1" == "--bootstrap" ]; then
    get_dotfiles
    sekuurity
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

    drive "703f4ec4-5cd5-4a7e-b3bc-d7429180151a" $HOME/ssd ",nosuid,nodev"
    drive "963da330-ae54-4d3f-b2fa-a055b98b9308" $HOME/backup ",noexec,nosuid,nodev"
    # drive "3289a1d1-61cd-45bf-9f2d-c9932913bb6f" $HOME/password ",noexec,nosuid,nodev"

    keyboard

    find $HOME/.config/systemd/user/ -maxdepth 1 -regextype egrep -regex \
        '.*(timer|path|service)' -exec systemctl enable --user --now '{}' \;

    echo "unShaderBackgroundProcessingThreads $(nproc)" > $HOME/.local/share/Steam/steam_dev.cfg
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

    sudo passwd --lock root
    sudo pacman -Rdd geoclue
    sudo pacman -Rdd krunner
    pacman -Qtdq | sudo pacman -Rns -

    exit 0
fi
