# dec/15/2022 07:47:54 by RouterOS 7.6
# software id = 
#
/interface bridge
add name=loopback
/interface ovpn-client
add certificate=ovpn_1 cipher=aes256 connect-to=51.250.70.58 mac-address=\
    02:DE:E8:8E:4A:AF name=ovpn-out1 port=443 user=sasha_mikrotik
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing ospf instance
add disabled=no name=default
/routing ospf area
add disabled=no instance=default name=backbone
/ip address
add address=10.255.255.1 interface=loopback network=10.255.255.1
/ip dhcp-client
add interface=ether1
/routing ospf interface-template
add area=backbone disabled=no interfaces=ether1 type=ptp
/system ntp client
set enabled=yes
/system ntp client servers
add address=0.ru.pool.ntp.org
