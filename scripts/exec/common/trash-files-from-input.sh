#!/bin/bash

    # все переменные заданы в управляющем файле проекта

echo -e "\n\t>> Отправить все файлы из /input в корзину"

    # Удалить все файлы из каталога /input
#find "$full_path_to_input_folder/" -type f -exec rm -f {} \;

# Проверить содержимое каталога input/
if [ -d "$folder_input" ] && [ "$(ls -A "$folder_input")" ]; then
    for file in "$folder_input"/*; do
        [ -e "$file" ] || continue  # Пропуск, если нет файлов
        
        # Генерация уникального имени удаляемого файла (для учета в корзине)
        filename=$(basename "$file")
	timestamp=$(date +%Y%m%d%H%M%S)
	random=$((RANDOM % 10000))
	unique_trash_filename="${filename%.*}_${timestamp}_${random}.${filename##*.}"

        # Переместить файл в корзину
        mv "$file" "$folder_trash_files/$unique_trash_filename"

        # Создаём новый .trashinfo с метаданными удаленных файлов
cat << EOF > "$folder_trash_info/$unique_trash_filename.trashinfo"
[Trash Info]
Path=$(realpath "$file")
DeletionDate=$timestamp
EOF
    done
    echo -e "\nОтправил."
else
    echo -e "\nКаталог $folder_input пуст или не существует."
fi
