#!/bin/bash


# 1 Find your usb device name on Linux and unmount it

df
# Or
lsblk
# Or
dmesg | grep usb

sudo umount /media/lobanov/my_usb_disk 
# Or
sudo umount /dev/sdc1


# 2 Verify .iso CD/DVD image file

file='/home/lobanov/Downloads/debian-11.5.0-amd64-netinst.iso'
SHA512SUMS_checksum='6a6607a05d57b7c62558e9c462fe5c6c04b9cfad2ce160c3e9140aa4617ab73aff7f5f745dfe51bbbe7b33c9b0e219a022ad682d6c327de0e53e40f079abf66a'

# shasum -a 256 $file
echo "$SHA512SUMS_checksum *$file" | shasum -a 256 --check
# must return somesing like:
# Verify Ubuntu .iso CD/DVD image file

# 3 Create a bootable USB stick on Linux
sudo dd if='/home/lobanov/Downloads/debian-11.5.0-amd64-netinst.iso' of=/dev/sdc bs=1M status=progress