if [[ $# -ne 1 ]]; then
    exit 1
fi

while getopts 'ie' OPTION; do
    case "$OPTION" in
        i)
            driver="i915"
            grep="UHD Graphics\|HD Audio Controller"
            ;;
        e)
            driver="nvidia"
            grep="NVIDIA"
            ;;
        *)
            exit 1
            ;;
    esac
done

device_ids=$(lspci -nn | grep "${grep}"| grep -Po '\[\K.{4}:.{4}\]' | tr -d ']' | paste -sd ",")

sudo sed -i 's/^options.*/& intel_iommu=on vfio-pci.ids='"${device_ids}"'/' /boot/loader/entries/arch.conf

echo 'options vfio-pci ids='"${device_ids}"'
softdep '"${driver}"' pre: vfio pci' | sudo tee /etc/modprobe.d/vfio.conf > /dev/null 2>&1
