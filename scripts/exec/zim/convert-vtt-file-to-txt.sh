#!/bin/bash

echo -e "\n\t>> Переделать файлы в формат Zim\n"

    # перейти в каталог /input
cd "$INPUT_FOLDER" || exit 1

    # Получить текущую дату и время
current_date_and_time=$(date +"%Y-%m-%dT%H:%M:%S")

    # Пройти по каждому файлу с расширением vtt
for file in *.vtt; do

    # Проверить, что файл существует
    if [[ -f "$file" ]]; then

        # Взять имя файла в переменную, заменить пробелы на - и точки на - (это формат имени файла в Zim)
    modified_name=$(echo "$file" | tr ' ' '_' | tr '.' '-')

        # Определить имя выходного файла — с расширением txt
    output_file="${modified_name%.vtt}.txt"

        # Обработать содержимое файла
            # Удалить из файла все строки с таймингом: начинается с цифры AND содержит символ "-->" AND завершаются цифрами
            # Удалить пустые строки по всему файлу, начиная со второй строки (первую не трогать)
            # Заменить слово "WEBVTT" на пустое место
            # Вставить в первую строку файла инструкцию для файла zim AND заголовок второго уровня с названием файла,
		 # и сохранить всё в новый файл с тем же названием, но с расширением txt
    sed -e '/^[0-9].*-->.*[0-9]$/d' \
        -e '1!{/^\s*$/d}' \
        -e 's/WEBVTT//g' \
        -e "1s/^/Content-Type: text\/x-zim-wiki\nWiki-Format: zim 0.6\nCreation-Date: $current_date_and_time\n\n===== ${file%.vtt} =====\n\n''${file%.vtt}.ogg''\n/" \
        "$file" > "$output_file"

    echo "• $output_file"

    fi
done

    # переместить все файлы txt из input в блокнот zim/main
if ls *.txt 1> /dev/null 2>&1; then
  mv *.txt "$zim_main_folder"
else
  echo "Нет файлов .txt для перемещения"
fi

echo -e "\nПеределал <<"
