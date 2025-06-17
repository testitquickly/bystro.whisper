#!/bin/bash

    # OBSOLETE

    # сделать архив с нуля
    # tar -cvf archive-asus-zenbook-17.tar -C ./input .

echo -e "\n\t>> Переместить файлы из каталога /input в архив TAR\n"

# Получить список файлов и отсортировать их по алфавиту
# files=$(find "$full_path_to_input_folder" -maxdepth 1 -type f \( -name "*.ogg" -o -name "*.vtt" \) | sort)

# Найти и отсортировать файлы, затем обработать их построчно
find "$folder_input" -maxdepth 1 -type f \( -name "*.ogg" -o -name "*.vtt" \) | sort | while read -r file; do
    if [[ -f "$file" ]]; then

        # Добавить файл в архив
	# r — --append) — добавить файлы в конец существующего архива.
	    # Работает только с не-сжатым архивом (.tar). Если архив уже сжат (.tar.gz, .tar.bz2), этот флаг не сработает.
	# -f (--file) — указывает имя архива (переменная $archive_filename)
        tar -rf "$archive_filename" -C "$folder_input" "$(basename "$file")" && \

        # Удалить файл с диска после добавления в архив
        rm "$file"

	# Вывести сообщение о каждом файле, который был добавлен в архив
        # basename "$file" — извлекает имя файла (и его расширение) из полного пути.
	echo -e "• $(basename "$file")"
    fi
done

echo -e "\nПереместил"
