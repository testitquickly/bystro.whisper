#!/bin/bash

# = Глобальный файл с переменными =
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../variables.sh"

echo -e "\n\t[Переместить *.vtt и *.ogg из input/ в archive/]"

    # Проверяем, существуют ли каталоги
if [[ ! -d "$folder_input" ]]; then
    echo "Ошибка: Каталог $folder_input не существует."
    exit 1
fi

if [[ ! -d "$folder_output" ]]; then
    echo "Ошибка: Каталог $folder_output не существует."
    exit 1
fi

    # Перемещаем только файлы
    #mv "$folder_input"/* "$folder_output"/

    # Перемещаем всё содержимое (видимые и скрытые файлы и каталоги)
    #mv "$folder_input"/* "$folder_input"/.* "$folder_output"/ 2>/dev/null

    # Перемещаем всё содержимое (видимые файлы и каталоги)
#mv "$folder_input"/* "$folder_output/"

    # Перемещаем все файлы (без каталогов, их там быть не должно)
    # кроме *.wav и .gitkeep
find "$folder_input" -maxdepth 1 -type f ! -name '*.wav' ! -name '.gitkeep' -exec mv -t "$folder_output/" {} +

# Проверяем результат
if [[ $? -eq 0 ]]; then
    echo -e "\nDone"
else
    echo "Ошибка при перемещении файлов!"
    exit 1
fi
