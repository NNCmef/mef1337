#!/bin/bash

# Читаем нажатие клавиш напрямую с клавиатуры (tty), подставляем нужную команду
read -e -i "hostnamectl set-hostname isp.au-team.irpo" COMMAND_TO_RUN </dev/tty

# Выполняем то, что утвердил пользователь
eval "$COMMAND_TO_RUN"
