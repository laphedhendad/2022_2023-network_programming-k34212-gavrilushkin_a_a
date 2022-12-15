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
4. [Конфигурация R1](/lab2/configuration_R1.rsc)
5. [Конфигурация R2](/lab2/configuration_R2.rsc)
6. ![Диаграмма сети](/lab2/Screenshot_3.png)
## Вывод
В процессе выполнения лабораторной работы я научился настраивать OSPF на RouterOS и автоматически настраивать несколько сетевых устройств одновременно, используя Ansible.
