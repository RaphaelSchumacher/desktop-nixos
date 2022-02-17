TAP='macvtap0'
NETWORK="-device e1000,netdev=net0,mac=52:54:00:a1:89:8b -netdev tap,ifname=${TAP},id=net0,script=no"

echo 3 >> /proc/sys/vm/drop_caches

for i in {0..3}
do
    echo  performance >> /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

echo -n "Binding RTX 2060S..."
for dev in "0000:01:00.0" "0000:01:00.1" "0000:01:00.2" "0000:01:00.3"; do
    vendor=$(cat /sys/bus/pci/devices/${dev}/vendor)
    device=$(cat /sys/bus/pci/devices/${dev}/device)
    if [ -e /sys/bus/pci/devices/${dev}/driver ]; then
        echo "${dev}" | tee /sys/bus/pci/devices/${dev}/driver/unbind > /dev/null
        while [ -e /sys/bus/pci/devices/${dev}/driver ]; do
            sleep 0.1
        done
    fi
    echo "${vendor} ${device}" | tee /sys/bus/pci/drivers/vfio-pci/new_id > /dev/null
done
echo "done"

qemu-system-x86_64 \
    -name windows10 \
    -serial none \
    -enable-kvm \
    -nodefaults \
    -no-user-config \
    -M q35,accel=kvm,kernel_irqchip=on,mem-merge=off \
    -m 16000 -mem-prealloc -no-hpet \
    -cpu host,kvm=off,l3-cache=on,kvm-hint-dedicated=on,migratable=no,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_vendor_id=3dfx,+vmx,+invtsc -smp 6,sockets=1,cores=6,threads=1, \
    -smbios type=0,vendor='American Megattrends Inc',version=1.41,date=04/10/2018,release=5.12 -smbios type=1,manufacturer="Micro-Star International Co. Ltd.",product=MS-7B44,uuid=00000000-0000-0000-0000-309c236442bb \
    -global kvm-pit.lost_tick_policy=discard \
    -device pcie-root-port,bus=pcie.0,id=root_port1,chassis=0,slot=0,x-speed=8,x-width=16 \
    -device vfio-pci,host=01:00.0,id=hostdev1,bus=root_port1,addr=0x00,multifunction=on \
    -device vfio-pci,host=01:00.1,id=hostdev2,bus=root_port1,addr=0x00.1 \
    -device vfio-pci,host=01:00.2,id=hostdev3,bus=root_port1,addr=0x00.2 \
    -device vfio-pci,host=01:00.3,id=hostdev4,bus=root_port1,addr=0x00.3 \
    -drive if=pflash,format=raw,readonly,file=./OVMF_CODE.fd \
    -drive if=pflash,format=raw,file=./OVMF_VARS.fd \
    -drive if=none,id=drive1,file=/dev/nvme0n1,format=raw,cache=none,aio=threads\
    -object iothread,id=iothread1\
    -device virtio-blk-pci,drive=drive1,scsi=off,iothread=iothread1\
    -device virtio-mouse-pci,id=input0 \
    -device virtio-keyboard-pci,id=input1 \
    -object input-linux,id=kbd1,evdev=/dev/input/by-id/usb-Corsair_Corsair_STRAFE_Gaming_Keyboard_0600B038AEBE8461563923B6F5001941-event-kbd,grab_all=yes \
    -object input-linux,id=mouse1,evdev=/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse \
    -usb -device usb-host,vendorid=0x1b1c,productid=0x0a4f \
    -cdrom /home/tehrafff/Projects/vfio/win10.iso \
    -drive file=/home/tehrafff/Projects/vfio/virtio-win-0.1.185.iso,format=raw,index=3,media=cdrom \
    -drive file=/home/tehrafff/Projects/vfio/win10.iso,format=raw,index=4,media=cdrom \
    -monitor unix:/tmp/monitor.sock,server,nowait \
    -rtc base=localtime \
    -overcommit mem-lock=on \
    -nographic \
    -boot d \
    ${NETWORK} &
