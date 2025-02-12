#!/bin/bash

    # сделать архив с нуля
    # tar -cvf archive-asus-zenbook-17.tar -C ./input .

echo -e "\n\t>> Переместить файлы из каталога /input в архив TAR\n"

# Получить список файлов и отсортировать их по алфавиту
# files=$(find "$full_path_to_input_folder" -maxdepth 1 -type f \( -name "*.ogg" -o -name "*.vtt" \) | sort)

# Найти и отсортировать файлы, затем обработать их построчно
find "$full_path_to_input_folder" -maxdepth 1 -type f \( -name "*.ogg" -o -name "*.vtt" \) | sort | while read -r file; do
    if [[ -f "$file" ]]; then

        # Добавить файл в архив
        tar -rvf "$archive_filename" -C "$full_path_to_input_folder" "$(basename "$file")" && \

        # Удалить файл с диска после добавления в архив
        rm "$file"
    fi
done

echo -e "\nПереместил <<\n"
