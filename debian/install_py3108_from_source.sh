sudo apt update
sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

cd /tmp
wget https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz

tar -xvf Python-3.10.8.tgz

cd Python-3.10.8/
./configure --enable-optimizations

make -j $(nproc)

sudo make altinstall

python3.10 --version

sudo apt install python3-pip