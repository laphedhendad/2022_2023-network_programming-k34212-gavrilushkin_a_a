University: [ITMO University](https://itmo.ru/ru/)

Faculty: [FICT](https://fict.itmo.ru)

Course: [Network programming](https://github.com/itmo-ict-faculty/network-programming)

Year: 2022/2023

Group: K34212

Author: Gavrilushkin Alexandr Alekseevich

Lab: Lab1

Date of create: 04.09.2022

Date of finished: 

## Настройка VPN сервера

### Создаем виртуальную машину в [Яндекс.Облаке](https://cloud.yandex.ru)

1. Для создания пары SSH-ключей запускаем в терминале Windows команду:
```
ssh-keygen -t ed25519
```
2. После запуска ВМ, подключаемся к ней через ssh:
```
ssh -i <путь_до_приватного_ключа> <имя_пользователя>@<ip_облака>
```
3. Устанавливаем Python3 и Ansible:
```
sudo apt install python3-pip
sudo pip3 install ansible
ansible --version
```
### Настраиваем OpenVPN Server

1. Устанавливаем необходимые зависимости (ca-сертификаты):
```
apt install ca-certificates wget net-tools gnupg
```
2. Добавляем OpenVPN в список репозиториев, отслеживаемых apt:
```
wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
echo "deb http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list
apt update
```
3. Устанавливаем OpenVPN access server:
```
apt install openvpn-as
```
4. После установки получаем адрес сайта с WebUI, а также логин и пароль для админа:
```
(Примерный вид консоли)
Access Server Web UIs are available here:
Admin UI: https://<your-ip>:943/admin
Client UI: https://<your-ip>:943
Admin login 'openvpn', password '7gsg7qwrqw7'
```
5. На этом моменте может прийти в голову идея настроить удаленный рабочий стол и установить в облаке браузер, чтобы запустить веб-среду... Выбрасываем эту мысль из головы, в поисковую строку браузера на локальном пк вбиваем <ip_облака>:943/admin и нажимаем Enter.

6. После успешной авторизации, нас встречает интерфейс OpenVPN:
![OpenVPN UI](/lab1/Screenshot_4.png)

7. Переходим в Configuration/Advanced VPN и устанавливаем TLS Control Channel Security в позицию none, чтобы отключить проверку tls-сертификата.
8. В Configuration/Network Settings убираем протокол UDP, так как наш клиент в лице Микротика udp не поддерживает.
### Регистрация клиента
1. В User Managment/User Permissions добавляем нового пользователя.
2. В User Managment/User Profiles на панели только что созданного юзера нажимаем New Profile/Create Profile. Получаем в подарок файл с расширением .ovpn, необходимый для настройки клиента.

## Подключение CHR клиента
1. Скачиваем образ Cloud Hosted Router с [Официального сайта Mikrotik](https://mikrotik.com/download)
2. Устанавливаем его на виртуальную машину, например VirtualBox.
3. Скачиваем WinBox (интерфейс для CHR) с [того же сайта](https://mikrotik.com/download)
4. Подключаем WinBox к CHR. IP машины можно посмотреть командой ```ip address print```. Логин admin, пароль пустой.

Следующие пункты выполняются в среде WinBox.

5. Открываем окно Files и закидываем тот самый файл с расширением .ovpn
6. В окне System/Certificates импортируем сертификат (ovpn-файл)
7. В окне Interfaces создаем новый интерфейс типа OVPN Client. Вводим необходимые данные:
![Настройка клиента](/lab1/Screenshot_5.png)
8. Радуемся надписи connected в статусе.

## Реузьтат
Пингуем с сервера CHR по VPN-адресу

![Ping client](/lab1/Screenshot_6.png)
## Вывод
В процессе выполнения лабораторной работы я научился поднимать OpenVPN сервер на Ubuntu, познакомился с OS от Mikrotik. Пройдя путь боли и страданий, создал между сервером и CHR-клиентом VPN-туннель. Научился подключать к виртуальной машине удаленный рабочий стол через VNC (к ходу лабораторной работы это отношения не имеет, но навык есть навык).
