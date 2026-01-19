#!/bin/bash

# = Глобальный файл с переменными =
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../variables.sh"

echo -e "\n\t[Переместить файлы txt в блокнот Whisper под страницу $zim_folder_unsorted]"

# Зайти в каталог /input
cd "$folder_input" || exit 1

# Вывод этой команды глушится.
# Проверить, есть ли в каталоге /input хотя бы один *.txt.
    # Если txt файлов нет → выдать ошибку
    # Если txt файлы есть → перенести их в каталог $zim_folder_unsorted
if ls *.txt 1> /dev/null 2>&1; then
    mkdir -p "$zim_folder_main/$zim_folder_unsorted"
    mv *.txt "$zim_folder_main/$zim_folder_unsorted/"
else
    echo -e "\nОшибка!!!\n\tВ каталоге /input нет файлов *.txt\n"
    exit 1
fi

# echo -e "\n\tDone"
