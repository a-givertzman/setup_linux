#!/bin/bash

inetSource="${GREEN}Select internet type connection:\n1 - WI-FI\2 - wired\0 - withot internet${RESET}> "
if [[ $inetSource == 0  ]]; then
    echo "Continue installing wihou internet..."

elif [[ $inetSource == 1 ]]; then
    echo "trying to connect using WI-FI"

elif [[ $inetSource == 2 ]]; then
    echo "trying to connect using wired ethernet"

else
    echo "trying to connect using wired ethernet"
fi


# configure internet connection
dhcpcd


# select the wi-fi intterface by name
ip a

# unblock wifi
rfkill unblock wifi

# use wifi interface by name in this case "wlan0"
ip link set wlan0 up

# connect to wifi using iwctl utiliti:
iwctl
# connect to known wifi point name
station wlan0 connect <Wi-Name>
# then enter wifi password

# then exit iwctl
exit

# test connection

# in not connected, try to check dns cimfig
nano /etc/resolv.conf

# to the end of config file add google dns srvers
nameserver 8.8.8.8
nameserver 8.8.4.4

##########################################
# setup proxy configuration
useProxy="${GREEN}Setup proxy configuration?:\0 - no\1 - yes\${RESET}> "
if [[ $useProxy == 0  ]]; then
    echo "Continue installing without internet proxy..."
    git config --global --unset http.proxy
elif [[ $useProxy == 1 ]]; then
    echo "trying to configure proxy..."
    proxyIP="${GREEN}\tproxy server:${RESET}> "
    proxyPort="${GREEN}\tproxy port:${RESET}> "
    proxyUser="${GREEN}\tproxy user name:${RESET}> "
    proxyPass="${GREEN}\tproxy user pass:${RESET}> "
    git config --global http.proxy $proxyUser:$proxyPass@$proxyIP:$proxyPort
else
    echo "Continue installing without internet proxy..."
    # git config --global --unset http.proxy
fi


##########################################
# prepare disk

fdisk -l

fdisk /dev/sda
d   # DELETE partition if olready have somthing on the disk

g   # creating GPT partition (gibrid partition will work on common bios and UEFI bios)

w   # writing changes to the disk

# create partitions using sfdisk
cfdisk /dev/sda
# create partition 31M type BIOS Boot
# create swap partition type Linux swap 
# create partition 512..1024M type EFI System for linux core
# create partition all free space type Linux file system
# select write in the bottom menu and type "yes" to alter partition table
# select quit

# check partitions
fdisk -l

# make file systems for EFI Sysytem
mkfs.vfat /dev/sda3

# make file systems for Linux swap
mkswap /dev/sda2
# connect swap
swapon /dev/sda2

# make BTRFS for Linux file system
mkfs.btrfs /dev/sda4
mkfs.btrfs -f /dev/sda4 # if theara some errors on used disks


##############
# mount root partition Linux file system
mount /dev/sda4 /mnt

# create nacessary folders
mkdir /mnt/boot

# for UEFI BIOS addittionaly create
mkdir /mnt/boot/EFI

# mount boot partition EFI System
#   if common bios mount to this folder only
    mount /dev/sda3 /mnt/boot
#   if EFI BIOS mount to this folder only 
    mount /dev/sda3 /mnt/boot/EFI



##############################
# insatalling linux
#   linux-zen linux-zen-headers     - fastest
#   linux linux-headers             - fast, but different from zen
#   linux-lts linux-lts-headers     - not so fast bu stable
#   dosfstools btrfs-progs - neccessary tools for selected BTRFS file system
#   intel-ucode / amd-ucode  - depending on yours processor type
#   iucode-tool
pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware dosfstools btrfs-progs nano vim
pacstrap -i /mnt base base-devel linux linux-headers linux-firmware dosfstools btrfs-progs nano vim
pacstrap -i /mnt base base-devel linux-lts linux-lts-headers linux-firmware dosfstools btrfs-progs nano vim


# configuring fstab 
genfstab -U /mnt >> /mnt/etc/fstab

# check fstab config
cat /mnt/etc/fstab
# partition 31M type BIOS Boot will not be present in this fstab config - it's ok


# enter to the installed system by arch-chroot
arch-chroot /mnt

# set hardware clock to current system time
hwclock --systohc

# configure localec
nano /etc/locale.gen
# uncomment en utf-8, ru utf-8 and generte licale
locale-gen
# to translate system to ru for example:
#   nano /etc/locale.conf
# add line
#   LANG=ru_RU.UTF-8
# save and exit

# to translate console log languege
#   nano /etc/vconsole.conf
#   KEYMAP=ru
#   FONT=cyr-sun16

#computer name
nano /etc/hostname

computername

#dns names
nano /etc/hosts

127.0.0.1   localhost
::1         localhost
127.0.0.1   computername.localdomain computername


# core image for load 
mkinitcpio -P   # for load only one defoult installed core
# mkinitcpio -p linux-zen       # for load special core of instaled multopli cores

# setup root password
passwd
# enter and reentter same password

# load and setup boot loader and network utils
pacman -S grub efibootmgr dhcpcd dhclient networkmanager

# install grub
grub-install /dev/sda
# or if not works try this
grub-install --boot-directory=/boot/EFI

# configure grub
grub-mkconfig -o /boot/grub/grub.cfg

# unmount all
umount -R /mnt

reboot

nano /etc/sudoers
# uncomment %wheel ALL=(ALL) ALL for coommon user can execute command

# create common user
useradd -m -G wheel -s /bin/bash alobanov
# password for created user
passwd alobanov

exit
# login to common user
sudo su

#configure network
systemctl enable NetworkManger
reboot

# connect to wi-fi
nmcli d wifi connect wifi-name password xxxxxx

sudo nano /etc/pacman.conf
# uncomment multilib

# install video acceleration drivers
sudo pacman -Syu.....

#install grafical ui interface Xorg (X11)
sudo pacman -S xorg xorg-server plasma plasma-wayland-session kde-applications sddm sddm-kcm packagekit-qt5

# enable kde display manager - sddm 
sudo systemctl enable sddm

