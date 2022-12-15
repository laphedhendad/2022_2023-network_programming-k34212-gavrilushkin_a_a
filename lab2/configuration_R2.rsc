# dec/15/2022 07:48:53 by RouterOS 7.6
# software id = 
#
/interface bridge
add name=loopback
/interface ovpn-client
add certificate=ovpn_1 cipher=aes256 connect-to=51.250.70.58 mac-address=\
    02:CD:5C:45:6E:CF name=ovpn-out1 port=443 user=sasha_mikrotik_2
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing ospf instance
add disabled=no name=default
/routing ospf area
add disabled=no instance=default name=backbone
/ip address
add address=192.168.2.1/24 interface=*5 network=192.168.2.0
add address=10.0.2.3/24 interface=*4 network=10.0.2.0
add address=10.255.255.2 interface=loopback network=10.255.255.2
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=backbone disabled=no interfaces=ether1
add area=backbone disabled=no interfaces=ether1 type=ptp
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.ru.pool.ntp.org
