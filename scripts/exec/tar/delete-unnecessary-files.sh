#!/bin/bash

    # все переменные заданы в управляющем файле проекта

echo -e "\n\t>> Очистить каталог /input"

# Удалить все файлы из каталога /input
find "$full_path_to_input_folder/" -type f -exec rm -f {} \;

echo -e "\nОчистил"
