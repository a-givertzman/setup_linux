#### General guide
https://wiki.debian.org/Firmware

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


#### i915
error messages:
4.052473] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_70.bin (-2)
[    4.052479] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_70.bin (-2)
[    4.052485] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_70.1.1.bin (-2)
[    4.052490] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_70.1.1.bin (-2)
[    4.052494] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_69.0.3.bin (-2)
[    4.052499] i915 0000:00:02.0: firmware: failed to load i915/adlp_guc_69.0.3.bin (-2)
[    4.052501] i915 0000:00:02.0: GuC firmware i915/adlp_guc_70.bin: fetch failed with error -2

download from here:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915/

then copy to the dir:
cp *.bin /lib/firmware/i915/

then possible nidded:
sudo update-initramfs -c -k all
