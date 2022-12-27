University: [ITMO University](https://itmo.ru/ru/)

Faculty: [FICT](https://fict.itmo.ru)

Course: [Network programming](https://github.com/itmo-ict-faculty/network-programming)

Year: 2022/2023

Group: K34212

Author: Gavrilushkin Alexandr Alekseevich

Lab: Lab2

Date of create: 14.12.2022

Date of finished: 

## Второй роутер в сети

### Повторяем шаги с настройкой ovpn-клиента из [первой лабораторной работы](https://github.com/laphedhendad/2022_2023-network_programming-k34212-gavrilushkin_a_a/blob/main/lab1/lab1_report.md)

## Настройка роутеров с помощью Ansible

### Создание inventory-файла

1. Создаем файл hosts.ini. Указываем в нём список роутеров. Для каждого роутера указываем его IP в VPN, а также другие переменные, которые понадобятся в дальнейшем: IP для OSPF и RouterID:
```
[hosts]
mikrotik_1 ansible_ssh_host=172.27.224.2 router_ospf_ip=10.255.255.1/32 router_id=R1
mikrotik_2 ansible_ssh_host=172.27.224.6 router_ospf_ip=10.255.255.2/32 router_id=R2
```
2. Указываем в этом же файле общие переменные (тип подключения, операционную систему, логин и пароль):
```
[hosts:vars]
ansible_connection=ansible.netcommon.network_cli
ansible_network_os=community.routeros.routeros
ansible_ssh_user=admin
ansible_ssh_pass="111"
ansible_ssh_port=22
```

### Создание playbook'а

1. Создаём файл с расширением .yml. Прописываем команды для создания нового пользователя и настройки NTP:
```
- name: Setup
  hosts: hosts
  tasks:
    - name: Add user
      community.routeros.command:
        commands:
          - /user add name=user password=password group=full
          - /system ntp client set enabled=yes servers=0.ru.pool.ntp.org
```
2. Создаём в этом же файле новую таску для настройки OSPF:
```
- name: OSPF
      community.routeros.command:
        commands:
          - /routing ospf instance add name=default
          - /interface bridge add name=loopback
          - /ip address add address={{router_ospf_ip}} interface=loopback
          - /routing ospf instance set 0 router-id={{router_id}}
          - /routing ospf area add instance=default name=backbone
          - /routing ospf interface-template add area=backbone interfaces=ether1 type=ptp
```
### Результаты

1. Запускаем playbook командой:
```
ansible-playbook sashapb_1.yml -i sashahost.ini(название inventory-файла)
```
2. Дожидаемся завершения и смотрим на результаты:

![Новый пользователь](/lab2/Screenshot_1.png)

![OSPF-сосед](/lab2/Screenshot_2.png)

3. Экспортируем конфигурацию роутера командой:
```
export compact file=configuration.rsc
```
4. Конфигурация R1:

```
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
```

6. Конфигурация R2:

```
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
```

8. Диаграмма получившейся сети:
 
![Диаграмма сети](/lab2/Screenshot_3.png)

## Вывод
В процессе выполнения лабораторной работы я научился настраивать OSPF на RouterOS и автоматически настраивать несколько сетевых устройств одновременно, используя Ansible.
