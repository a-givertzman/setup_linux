Check current linux kernel

uname -a
uname -v


Add backports to apt sources.list:

sudo nano /etc/apt/sources.list

deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye-backports main contrib non-free



To instal the latest backported kernel:

sudo apt update
sudo apt install -t bullseye-backports linux-image-amd64

