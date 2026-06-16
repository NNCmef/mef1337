#!/bin/bash

# Задаем цвета для красивого и понятного вывода
GREEN='\e[1;32m'
CYAN='\e[1;36m'
RED='\e[1;31m'
NC='\e[0m' # No Color

# 0. Проверка на права root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[Ошибка] Этот скрипт должен быть запущен от имени root (или через sudo).${NC}" >&2
  exit 1
fi

echo -e "${CYAN}=== 1. Настройка имени хоста ===${NC}"
TARGET_HOSTNAME="isp.au-team.irpo"

# Устанавливаем hostname
hostnamectl set-hostname "$TARGET_HOSTNAME"

# Проверяем, успешно ли применилось новое имя
if [ "$(hostname)" == "$TARGET_HOSTNAME" ]; then
    echo -e "${GREEN}[+] Имя хоста успешно изменено на: $TARGET_HOSTNAME${NC}"
else
    echo -e "${RED}[-] Ошибка: не удалось изменить имя хоста.${NC}" >&2
    exit 1
fi

echo -e "\n${CYAN}=== 2. Следующий шаг ===${NC}"
# Здесь будет следующий код
history -d $(history 1)
