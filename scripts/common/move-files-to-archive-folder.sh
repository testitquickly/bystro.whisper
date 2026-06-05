#!/bin/bash

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
mv "$folder_input"/* "$folder_output"

    # Проверяем результат
if [[ $? -eq 0 ]]; then
    echo "Файлы успешно перемещены."
else
    echo "Ошибка при перемещении файлов."
    exit 1
fi
