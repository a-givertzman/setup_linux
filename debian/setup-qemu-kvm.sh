# 1. Check Whether Virtualization Extension is enabled or not, returns non zero if enabled

egrep -c '(vmx|svm)' /proc/cpuinfo

# Check what kind op processor you have, 
#     vmx - Intel processor
#     svm - AMD processor.

grep -E --color '(vmx|svm)' /proc/cpuinfo


# 2. Install QEMU-KVM & Libvirt packages along with virt-manager
# kvm, qemu, libvirt and virt-manager packages are available in the default repositories of Debian 10, run the beneath apt command to install these packages,

sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y


# Once above packages are installed successfully then libvirtd service will be started automatically, run the below systemctl command to verify the status

sudo systemctl status libvirtd.service


# 3. Start default network and add vhost_net module
# Run the below virsh command to list available networks for kvm VMs

sudo virsh net-list --all
#  Name      State      Autostart   Persistent
# ----------------------------------------------
#  default   inactive   no          yes

# As we can see in above output, default network is inactive so to make it active and auto-restart across the reboot by running the following commands,

sudo virsh net-start default
# Network default started
sudo virsh net-autostart default
# Network default marked as autostarted
# If you want to offload the mechanism of “virtio-net” and want to improve the performance of KVM VMs then add “vhost_net” kernel module on your system using the beneath command,

sudo modprobe vhost_net
echo "vhost_net" | sudo  tee -a /etc/modules
# vhost_net
lsmod | grep vhost
# vhost_net              24576  0
# vhost                  49152  1 vhost_net
# tap                    28672  1 vhost_net
# tun                    49152  2 vhost_net

# Note: If you want a normal user to use virsh commands then add that user to libvirt and libvirt-qemu group using the following commands
sudo adduser pkumar libvirt
sudo adduser pkumar libvirt-qemu

# To refresh or reload group membership run the followings,
newgrp libvirt && newgrp libvirt-qemu


# 4. Create Linux Bridge(br0) for KVM VMs
# When we install KVM then it automatically creates a bridge with name “virbr0“, this is generally used for all  test environments but if you wish to access your KVM VMs over the network then create Linux bridge which will be attached to physical nic ( or lan card) of your system.

# To create a bridge in Debian 10 , edit the network configuration file “/etc/network/interfaces” and add the following contents,

# In my case ens33 is the physical nic and br0 is the Linux bridge and have assigned same ip address of ens33 to bridge br0. ( Also make sure to remove IP address from ens33). Replace the interface name, bridge name and IP details as per your setup.

sudo vi /etc/network/interfaces
# ..............
#Primary network interface(ens33)
# auto ens33
# iface ens33 inet manual
#Configure bridge and give it a static ip
# auto br0
# iface br0 inet static
#         address 192.168.29.150
#         netmask 255.255.255.0
#         network 192.168.29.1
#         broadcast 192.168.29.255
#         gateway 192.168.29.1
#         bridge_ports ens33
#         bridge_stp off
#         bridge_fd 0
#         bridge_maxwait 0
#         dns-nameservers 8.8.8.8
# ...............
# save and exit the file

# To make the above network changes into the effect we have to reboot the system , so run the below reboot command,
sudo reboot

# Once the system is back online after reboot, we will see that bridge br0 will come up, run the following command to confirm,

ip a s br0

linux-bridge-debian10