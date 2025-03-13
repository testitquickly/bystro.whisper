#!/bin/bash

echo -e "\n\t>> Переделать файлы vtt в txt для Zim\n"

# Перейти в каталог /input
cd "$folder_input" || exit 1

# Получить текущую дату и время
current_date_and_time=$(date +"%Y-%m-%dT%H:%M:%S")

# Пройти по каждому файлу с расширением vtt
for file in *.vtt; do

    # Проверить, что файл существует
    if [[ -f "$file" ]]; then

        # убрать из названия ".vtt",
        # заменить пробелы на "_" и точки на "-" (это формат имени файла в Zim)
        # положить имя файла в переменную
        output_file_name=$(echo "${file%.vtt}" | tr ' ' '_' | tr '.' '-')

        # Обработать содержимое файла
            # Удалить из файла все строки с таймингом: начинается с цифры AND содержит символ "-->" AND завершаются цифрами
            # Удалить пустые строки по всему файлу, начиная со второй строки (первую не трогать)
            # Заменить слово "WEBVTT" на пустое место
            # Вставить в первую строку файла объявление txt-файла в формате zim 
		# AND добавить заголовок второго уровня с названием файла 
		# AND добавить имя ogg-файла (со звуком),
	    # сохранить всё в новый файл с тем же названием 
		# AND добавить ему расширение "txt"
        sed -e '/^[0-9].*-->.*[0-9]$/d' \
            -e '1!{/^\s*$/d}' \
            -e 's/WEBVTT//g' \
            -e "1s/^/Content-Type: text\/x-zim-wiki\nWiki-Format: zim 0.6\nCreation-Date: $current_date_and_time\n\n===== ${file%.vtt} =====\n\n''${file%.vtt}.ogg''\n/" \
            "$file" > "${output_file_name}.txt"

        echo "• ${output_file_name}.txt"
    fi
done

# Переместить все файлы txt из input в блокнот zim/main
if ls *.txt 1> /dev/null 2>&1; then
  mv *.txt "$zim_main_folder"
else
  echo "В каталоге /input нет файлов .txt"
fi

echo -e "\nПеределал"
