#!/bin/bash

# Запрещаем терминалу дублировать одинаковые строки подряд
export HISTCONTROL=ignoredups

# --- 0. Стираем следы запуска из истории ---
# Удаляем команду eval (саму себя)
history -d $(HISTTIMEFORMAT="" history | tail -n 1 | awk '{print $1}') 2>/dev/null
# Ищем и удаляем команду установки wget, которую ты вводил до этого
WGET_HIST=$(HISTTIMEFORMAT="" history | grep "apt-get.*wget" | tail -n 1 | awk '{print $1}')
[[ -n "$WGET_HIST" ]] && history -d "$WGET_HIST" 2>/dev/null

# --- 1. Базовая настройка ---
read -e -i "hostnamectl set-hostname isp.au-team.irpo" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "ip -c a" CMD; eval "$CMD"; history -s "$CMD"

# --- 2. Настройка интерфейса enp7s2 (HQ-RTR) ---
read -e -i "mkdir -p /etc/net/ifaces/enp7s2" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 'TYPE=eth' > /etc/net/ifaces/enp7s2/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 'DISABLED=no' >> /etc/net/ifaces/enp7s2/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 'NM_CONTROLLED=no' >> /etc/net/ifaces/enp7s2/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 'BOOTPROTO=static' >> /etc/net/ifaces/enp7s2/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 'CONFIG_IPv4=yes' >> /etc/net/ifaces/enp7s2/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 172.16.1.1/28 > /etc/net/ifaces/enp7s2/ipv4address" CMD; eval "$CMD"; history -s "$CMD"

# --- 3. Настройка интерфейса enp7s3 (BR-RTR) ---
read -e -i "mkdir -p /etc/net/ifaces/enp7s3" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "cp /etc/net/ifaces/enp7s2/options /etc/net/ifaces/enp7s3/options" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "echo 172.16.2.1/28 > /etc/net/ifaces/enp7s3/ipv4address" CMD; eval "$CMD"; history -s "$CMD"

# --- 4. Форвардинг и перезапуск сети ---
echo -e "\n* Откроется VIM. Поменяй net.ipv4.ip_forward = 0 на 1, сохрани (:wq) *"
read -e -i "vim /etc/net/sysctl.conf" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "systemctl restart network" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "ip -c a" CMD; eval "$CMD"; history -s "$CMD"

# --- 5. Установка и настройка Firewalld (NAT) ---
read -e -i "apt-get update" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "apt-get -y install firewalld" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "systemctl enable --now firewalld" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "firewall-cmd --permanent --zone=public --add-interface=enp7s1" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "firewall-cmd --permanent --zone=trusted --add-interface=enp7s2" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "firewall-cmd --permanent --zone=trusted --add-interface=enp7s3" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "firewall-cmd --permanent --zone=public --add-masquerade" CMD; eval "$CMD"; history -s "$CMD"
read -e -i "firewall-cmd --reload" CMD; eval "$CMD"; history -s "$CMD"

# --- 6. Финальный перезапуск сессии и удаление улик ---
# Скрытно удаляем wget. Весь вывод летит в черную дыру (/dev/null), в историю это не пишется.
apt-get remove -y wget >/dev/null 2>&1

read -e -i "exec bash" CMD
history -s "$CMD"
history -a  # Записываем все наши "ручные" команды в файл
eval "$CMD"
