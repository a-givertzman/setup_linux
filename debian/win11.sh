#!/bin/bash

# Run windows 11 VM on Qemu

qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -smp $(nproc) \
    -cpu host \
    -device ac97 \
    -audiodev alsa,id=snd0,out.buffer-length=500000,out.period-length=726 \
    -show-cursor \
    -usb \
    -device usb-tablet \
    -device virtio-keyboard-pci \
    -net nic \
    -net user \
    -cdrom distro.iso \
    -vga qxl \
    -display spice-app,gl=on \
    -hda disk.qcow2 \
    -machine q35,smm=on \
    -global driver=cfi.pflash01,property=secure,value=on \
    -drive if=pflash,format=raw,unit=0,file=/usr/share/edk2/ovmf/OVMF_CODE.secboot.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=OVMF_VARS.secboot.fd \
    -chardev socket,id=chrtpm,path="${PWD}/.tpm/swtpm-sock" \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -drive file=virtio.iso,media=cdrom