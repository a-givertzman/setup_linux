# creates self signed ssl certificate for gitlab using openssl
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

# root@gitlab:/# grep "^[^#;]" /etc/gitlab/gitlab.rb
#  external_url 'https://gitlab.copdips.local'
#  nginx['redirect_http_to_https'] = true
#  nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.copdips.local.crt"
#  nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.copdips.local.key"


sudo sudo gitlab-ctl reconfigure
