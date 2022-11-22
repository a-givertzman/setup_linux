cd /mnt/storage0/
mkdir share
chmod 777 ./share
sudo grdit /etc/samba/smb.conf


add text to [share_name_section]:

[share]
    path = /mnt/storage0/share/
    # allow writing
    writable = yes
    # allow guest user (nobody)
    guest ok = yes
    # looks all as guest user
    guest only = yes
    # set permission [777] when file created
    force create mode = 777
    # set permission [777] when folder created
    force directory mode = 777 


sudo systemctl restart smbd.service
