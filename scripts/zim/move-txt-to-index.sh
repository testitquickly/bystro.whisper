#!/bin/bash

echo -e "\n\t>> Переместить файлы txt в блокнот Whisper под страницу index"

cd "$folder_input" || exit 1

if ls *.txt 1> /dev/null 2>&1; then
    mkdir -p "$zim_main_folder/index"
    mv *.txt "$zim_main_folder/index/"
else
    echo "Ошибка! В каталоге /input нет файлов .txt"
fi

echo -e "\nГотово"
