#!/bin/bash

# --- 0. Стираем команду скачивания (саму себя) из истории терминала ---
history -d $(HISTTIMEFORMAT="" history | tail -n 1 | awk '{print $1}') 2>/dev/null

# --- 1. Смена имени хоста ---
echo -e "\e[1;36m=== 1. Смена имени хоста ===\e[0m"
read -e -i "hostnamectl set-hostname isp.au-team.irpo" CMD
eval "$CMD"
history -s "$CMD"  # Записываем команду в историю

# --- 2. Просмотр интерфейсов ---
echo -e "\n\e[1;36m=== 2. Просмотр сетевых интерфейсов ===\e[0m"
read -e -i "ip -c a" CMD
eval "$CMD"
history -s "$CMD"

# --- 3. Создание папки enp7s2 ---
echo -e "\n\e[1;36m=== 3. Настройка интерфейса enp7s2 ===\e[0m"
read -e -i "mkdir -p /etc/net/ifaces/enp7s2" CMD
eval "$CMD"
history -s "$CMD"

# --- 4. Создание файла options для enp7s2 ---
read -e -i "echo 'TYPE=eth' > /etc/net/ifaces/enp7s2/options && echo 'DISABLED=no' >> /etc/net/ifaces/enp7s2/options && echo 'NM_CONTROLLED=no' >> /etc/net/ifaces/enp7s2/options && echo 'BOOTPROTO=static' >> /etc/net/ifaces/enp7s2/options && echo 'CONFIG_IPv4=yes' >> /etc/net/ifaces/enp7s2/options" CMD
eval "$CMD"
history -s "$CMD"

# --- 5. Создание папки enp7s3 ---
echo -e "\n\e[1;36m=== 4. Настройка интерфейса enp7s3 ===\e[0m"
read -e -i "mkdir -p /etc/net/ifaces/enp7s3" CMD
eval "$CMD"
history -s "$CMD"

# --- 6. Копирование файла options в enp7s3 ---
read -e -i "cp /etc/net/ifaces/enp7s2/options /etc/net/ifaces/enp7s3/options" CMD
eval "$CMD"
history -s "$CMD"

# --- 7. Назначение IP-адресов ---
echo -e "\n\e[1;36m=== 5. Назначение IPv4 адресов ===\e[0m"
read -e -i "echo 172.16.1.1/28 > /etc/net/ifaces/enp7s2/ipv4address" CMD
eval "$CMD"
history -s "$CMD"

read -e -i "echo 172.16.2.1/28 > /etc/net/ifaces/enp7s3/ipv4address" CMD
eval "$CMD"
history -s "$CMD"

# --- 8. Настройка маршрутизации (sysctl) ---
echo -e "\n\e[1;36m=== 6. Включение форвардинга IPv4 ===\e[0m"
echo "Сейчас откроется редактор VIM. Поменяй net.ipv4.ip_forward = 0 на 1, сохрани (:wq)."
read -e -i "vim /etc/net/sysctl.conf" CMD
eval "$CMD"
history -s "$CMD"

# --- 9. Применение настроек сети ---
echo -e "\n\e[1;36m=== 7. Применение сетевых настроек ===\e[0m"
read -e -i "systemctl restart network && ip -c a" CMD
eval "$CMD"
history -s "$CMD"

# --- 10. Перезапуск оболочки для обновления имени ---
echo -e "\n\e[1;36m=== 8. Обновление интерфейса терминала ===\e[0m"
echo -e "\e[1;32m[+] Базовая настройка успешно завершена!\e[0m"
echo "Нажми Enter, чтобы обновить сессию:"
read -e -i "exec bash" CMD
history -s "$CMD"
history -w  # Принудительно сохраняем нашу накрученную историю на диск
eval "$CMD"
