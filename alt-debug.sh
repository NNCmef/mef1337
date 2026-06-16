#!/bin/bash

# --- 0. Смена имени хоста ---
echo -e "\e[1;36m=== 1. Смена имени хоста ===\e[0m"
read -e -i "hostnamectl set-hostname isp.au-team.irpo" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 1. Просмотр интерфейсов ---
echo -e "\n\e[1;36m=== 2. Просмотр сетевых интерфейсов ===\e[0m"
read -e -i "ip -c a" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 2. Создание папки enp7s2 ---
echo -e "\n\e[1;36m=== 3. Настройка интерфейса enp7s2 ===\e[0m"
read -e -i "mkdir -p /etc/net/ifaces/enp7s2" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 3. Создание файла options для enp7s2 ---
read -e -i "echo 'TYPE=eth' > /etc/net/ifaces/enp7s2/options && echo 'DISABLED=no' >> /etc/net/ifaces/enp7s2/options && echo 'NM_CONTROLLED=no' >> /etc/net/ifaces/enp7s2/options && echo 'BOOTPROTO=static' >> /etc/net/ifaces/enp7s2/options && echo 'CONFIG_IPv4=yes' >> /etc/net/ifaces/enp7s2/options" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 4. Создание папки enp7s3 ---
echo -e "\n\e[1;36m=== 4. Настройка интерфейса enp7s3 ===\e[0m"
read -e -i "mkdir -p /etc/net/ifaces/enp7s3" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 5. Копирование файла options в enp7s3 ---
read -e -i "cp /etc/net/ifaces/enp7s2/options /etc/net/ifaces/enp7s3/options" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 6. Назначение IP-адресов ---
echo -e "\n\e[1;36m=== 5. Назначение IPv4 адресов ===\e[0m"
read -e -i "echo 172.16.1.1/28 > /etc/net/ifaces/enp7s2/ipv4address" CMD </dev/tty
eval "$CMD" </dev/tty

read -e -i "echo 172.16.2.1/28 > /etc/net/ifaces/enp7s3/ipv4address" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 7. Настройка маршрутизации (sysctl) ---
echo -e "\n\e[1;36m=== 6. Включение форвардинга IPv4 ===\e[0m"
echo "Сейчас откроется редактор VIM. Поменяй net.ipv4.ip_forward = 0 на 1, сохрани (:wq)."
read -e -i "vim /etc/net/sysctl.conf" CMD </dev/tty
# Вот здесь самая важная правка для VIM:
eval "$CMD" </dev/tty  

# --- 8. Применение настроек ---
echo -e "\n\e[1;36m=== 7. Применение сетевых настроек ===\e[0m"
read -e -i "systemctl restart network && ip -c a" CMD </dev/tty
eval "$CMD" </dev/tty

# --- 9. Перезапуск оболочки для обновления имени ---
echo -e "\n\e[1;36m=== 8. Обновление интерфейса терминала ===\e[0m"
echo -e "\e[1;32m[+] Базовая настройка успешно завершена!\e[0m"
echo "Нажми Enter, чтобы обновить имя сервера в командной строке:"
read -e -i "exec bash" CMD </dev/tty
eval "$CMD" </dev/tty
