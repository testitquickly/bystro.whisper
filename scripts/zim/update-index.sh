#!/bin/bash

echo -e "\n\t>> Обновить ссылки на странице „index”"

# Проверка на наличие главной папки
if [ ! -d "$zim_main_folder" ]; then
  echo -e "\nПапка $zim_main_folder не найдена."
  exit 1
fi

# Обнуляем файл index и пишем заголовок
cat > "$zim_index_file" <<EOL
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.6
Creation-Date: $(date --iso-8601=seconds)

====== index ======

EOL

# Функция обработки верхнего уровня
process_top_level() {
  local CURRENT_FOLDER="$1"

  local ENTRIES=( "$CURRENT_FOLDER"/* )
  IFS=$'\n' sorted_entries=( $(printf "%s\n" "${ENTRIES[@]}" | sort) )

  for ENTRY in "${sorted_entries[@]}"; do
    if [ -d "$ENTRY" ]; then
      local BASENAME=$(basename "$ENTRY")
      local NOTE_FILE="$ENTRY.txt"

      if [ -f "$NOTE_FILE" ]; then
        local NOTE_NAME=$(echo "$BASENAME" | sed 's/_/ /g')
        echo -e "\n===== $NOTE_NAME =====\n" >> "$zim_index_file"
        local count=1
        process_subpages "$ENTRY" "$NOTE_NAME" 1 count
      fi
    elif [[ "$ENTRY" == *.txt ]]; then
      local FILENAME=$(basename "$ENTRY")
      local NAME_NOEXT="${FILENAME%.txt}"

      # Пропускаем index.txt
      if [ "$ENTRY" = "$zim_main_folder/index.txt" ]; then
        continue
      fi

      # Пропускаем, если есть одноимённая папка
      if [ -d "$CURRENT_FOLDER/$NAME_NOEXT" ]; then
        continue
      fi

      local NOTE_NAME=$(echo "$NAME_NOEXT" | sed 's/_/ /g')
      echo -e "\n===== $NOTE_NAME =====\n" >> "$zim_index_file"
      local count=1
      process_subpages "$CURRENT_FOLDER/$NAME_NOEXT" "$NOTE_NAME" 1 count
    fi
  done
}

# Рекурсивная функция: каждый уровень нумеруется отдельно
process_subpages() {
  local CURRENT_FOLDER="$1"
  local PARENT_PATH="$2"
  local DEPTH="$3"
  local -n count_ref=$4

  local ENTRIES=( "$CURRENT_FOLDER"/* )
    # сортировка естественным образом, 1, 2, … 9, 10, 11
  IFS=$'\n' sorted_entries=( $(printf "%s\n" "${ENTRIES[@]}" | sort -V) )

  for ENTRY in "${sorted_entries[@]}"; do
    if [[ "$ENTRY" == *.txt ]]; then
      local FILENAME=$(basename "$ENTRY")
      local NAME_NOEXT="${FILENAME%.txt}"

      if [ "$ENTRY" = "$zim_main_folder/index.txt" ]; then
        continue
      fi

      if [ -d "$CURRENT_FOLDER/$NAME_NOEXT" ]; then
        continue
      fi

      local NOTE_NAME=$(echo "$NAME_NOEXT" | sed 's/_/ /g')
      local INDENT=$(printf '\t%.0s' $(seq 1 "$DEPTH"))
      echo -e "$INDENT${count_ref}. [[$PARENT_PATH:$NOTE_NAME|$NOTE_NAME]]" >> "$zim_index_file"
      ((count_ref++))
    elif [ -d "$ENTRY" ]; then
      local BASENAME=$(basename "$ENTRY")
      local NOTE_FILE="$ENTRY.txt"

      if [ -f "$NOTE_FILE" ]; then
        local NOTE_NAME=$(echo "$BASENAME" | sed 's/_/ /g')
        local INDENT=$(printf '\t%.0s' $(seq 1 "$DEPTH"))
        echo -e "$INDENT${count_ref}. [[$PARENT_PATH:$NOTE_NAME|$NOTE_NAME]]" >> "$zim_index_file"
        ((count_ref++))

        local nested_count=1
        process_subpages "$ENTRY" "$PARENT_PATH:$NOTE_NAME" $((DEPTH + 1)) nested_count
      fi
    fi
  done
}

# Старт обхода
process_top_level "$zim_main_folder"

echo -e "\nСсылки обновлены"
