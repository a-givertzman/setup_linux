# 1. Download GParted here: https://gparted.org/download.php
#    64bit version:         https://downloads.sourceforge.net/gparted/gparted-live-1.4.0-6-amd64.iso

# 2. Create bootable usb
#   sudo dd bs=4M if="gparted-live-1.4.0-6-amd64.iso" of=/dev/usb-disk-name status=progress && sync

# 3. Boot from GParted
#   Then, boot from this live USB drive. You can keep everything default.
#   Just press enter for every question.
#   In the end, you should get to the Live session of Gparted. This is the same Gparted program you may have on your system.
