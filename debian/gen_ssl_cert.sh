# creates self signed ssl certificate using openssl
# new cert & key will have [name]
# and will be copied to the [path]
# certificate will be valid during [days]

name=192.168.120.159
path=/etc/gitlab/ssl
days=365000


sudo openssl req -x509 -nodes -days $days -newkey rsa:2048 \
	-out $name.crt \
	-keyout $name.key \
	-config req.conf \
	-extensions 'v3_req'

sudo openssl x509 -in /etc/gitlab/ssl/$name.crt -noout -text

sudo mkdir -p $path
sudo chmod 700 $path
sudo cp $name.crt $name.key $path

sudo sudo gitlab-ctl reconfigure
