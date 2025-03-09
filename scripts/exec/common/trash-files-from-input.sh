#!/bin/bash

# все переменные заданы в управляющем файле проекта

echo -e "\n\t>> Отправить все файлы из /input в корзину"

# Проверить содержимое каталога input/
if [ -d "$folder_input" ] && [ "$(ls -A "$folder_input")" ]; then
    for file in "$folder_input"/*; do
        [ -e "$file" ] || continue  # Пропуск, если нет файлов

        # Переместить к корзину каждый файл
        mv "$file" "$folder_trash_files/"

        # Создать новый .trashinfo с метаданными для удаляемого файла
cat << EOF > "$folder_trash_info/$(basename "$file").trashinfo"
[Trash Info]
Path=$(realpath "$file")
DeletionDate=$timestamp
EOF
    done
    echo -e "\nОтправил."
else
    echo -e "\nКаталог $folder_input пуст или не существует."
fi
