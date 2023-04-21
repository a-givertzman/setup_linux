#### list all routes
ip r

#### add new route
ip route add 192.168.120.0/24 via 192.168.120.1 metric 1234
#### delete route
ip route del 192.168.120.0/24 via 192.168.120.1

sudo ip route del 172.20.10.0/28 via 172.20.10.1
sudo ip route del default via 192.168.120.1
