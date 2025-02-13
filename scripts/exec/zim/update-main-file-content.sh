#!/bin/bash

echo -e "\n\t>> Обновить перечень ссылок на дочерние файлы для страницы «Home»"

# Проверяем существование папки
if [ ! -d "$zim_main_folder" ]; then
  echo -e "\nПапка $zim_main_folder не найдена."
  exit 1
fi

# Удаляем содержимое MAIN_FILE и добавляем заголовок
cat > "$zim_main_file" <<EOL
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.6
Creation-Date: 2023-01-12T16:01:54+02:00

====== Home ======

EOL

# Переменная для нумерации
counter=1

# Функция для обработки файлов и генерации ссылок
process_files() {
  local CURRENT_FOLDER="$1"
  local DEPTH="$2" # Глубина вложенности (для формирования отступов)

  # Получаем список файлов и каталогов, сортируем по алфавиту
  local ENTRIES=( "$CURRENT_FOLDER"* )
  IFS=$'\n' sorted_entries=( $(printf "%s\n" "${ENTRIES[@]}" | sort) )

  for ENTRY in "${sorted_entries[@]}"; do
    if [ -d "$ENTRY" ]; then
      # Проверяем, что одноимённый файл существует
      local PARENT_NOTE="${ENTRY}.txt"
      if [ -f "$PARENT_NOTE" ] && [ "$PARENT_NOTE" != "$zim_main_folder/Home.txt" ]; then
        local NOTE_NAME=$(basename "$ENTRY" | sed 's/_/ /g')

        # Формируем отступ в зависимости от уровня вложенности
        local INDENT=$'\t'

        echo -e "$counter. $INDENT[[$NOTE_NAME|$NOTE_NAME]]" >> "$zim_main_file"
        ((counter++))

        # Рекурсивно обрабатываем дочерние заметки с символом "*"
        process_files_with_bullets "$ENTRY/" "$NOTE_NAME" $((DEPTH + 1))
      fi
    elif [[ "$ENTRY" == *.txt ]]; then
      # Обрабатываем только текстовые файлы, игнорируя каталоги
      local FILENAME=$(basename "$ENTRY")
      local BASENAME="${FILENAME%.*}"

      # Пропускаем текстовые файлы, если есть одноимённый каталог
      if [ -d "${CURRENT_FOLDER}${BASENAME}" ]; then
        continue
      fi

      local NOTE_NAME=$(echo "$BASENAME" | sed 's/_/ /g')

      # Пропускаем файл main.txt
      if [ "$CURRENT_FOLDER/$FILENAME" != "$zim_main_folder/Home.txt" ]; then
        local INDENT=$'\t'
        echo -e "$counter. $INDENT[[$NOTE_NAME|$NOTE_NAME]]" >> "$zim_main_file"
        ((counter++))
      fi
    fi
  done
}

# Функция для обработки дочерних заметок с символом "*"
process_files_with_bullets() {
  local CURRENT_FOLDER="$1"
  local PARENT_NAME="$2"
  local DEPTH="$3"

  local ENTRIES=( "$CURRENT_FOLDER"* )
  IFS=$'\n' sorted_entries=( $(printf "%s\n" "${ENTRIES[@]}" | sort) )

  for ENTRY in "${sorted_entries[@]}"; do
    if [[ "$ENTRY" == *.txt ]]; then
      local FILENAME=$(basename "$ENTRY")
      local BASENAME="${FILENAME%.*}"
      local NOTE_NAME=$(echo "$BASENAME" | sed 's/_/ /g')

      # Формируем отступ в зависимости от уровня вложенности
      local INDENT=$'\t'

      # Пропускаем файл main.txt
      if [ "$CURRENT_FOLDER/$FILENAME" != "$zim_main_folder/Home.txt" ]; then
        echo -e "$INDENT* [[$PARENT_NAME:$NOTE_NAME|$NOTE_NAME]]" >> "$zim_main_file"
      fi
    elif [ -d "$ENTRY" ]; then
      # Проверяем, что одноимённый файл существует
      local PARENT_NOTE="${ENTRY}.txt"
      if [ -f "$PARENT_NOTE" ] && [ "$PARENT_NOTE" != "$zim_main_folder/Home.txt" ]; then
        local NOTE_NAME=$(basename "$ENTRY" | sed 's/_/ /g')

        # Формируем отступ для каталога
        local INDENT=$'\t'

        echo -e "$INDENT* [[$PARENT_NAME:$NOTE_NAME|$NOTE_NAME]]" >> "$zim_main_file"

        # Рекурсивно обрабатываем дочерние заметки внутри каталога
        process_files_with_bullets "$ENTRY/" "$PARENT_NAME:$NOTE_NAME" $((DEPTH + 1))
      fi
    fi
  done
}

# Запускаем обработку файлов в папке
process_files "$zim_main_folder" 0

echo -e "\nОбновил <<\n"
