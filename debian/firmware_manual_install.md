
#### Sound driver:
https://github.com/thesofproject/sof-bin/

rsync -a sof-v1.7/       /lib/firmware/intel/sof/
rsync -a sof-tplg-v1.7/  /lib/firmware/intel/sof-tplg/
rsync tools-v1.7/        /usr/local/bin/

rebuut, then check audio devices:
sudo aplay -l

#### Bluetooth driver
error message:
bluetooth hci0: firmware: failed to load intel/ibt-0040-4150.ddc (-2)

download all from here with name like *0040*
https://anduin.linuxfromscratch.org/sources/linux-firmware/intel/

then copy all containing in name 0040 to the dir:
cp *0040* /usr/lib/firmware/intel/


