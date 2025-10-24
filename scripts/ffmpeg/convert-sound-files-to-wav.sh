#!/bin/bash

    # все аудио (да и видео) файлы из каталога input будут сконвертированы
    # в новые файлы в формате pcm (wav), 16 кГц, моно — это требования whisper
    # оригиналы будут удалены

    # все переменные заданы в управляющем файле проекта

# = Глобальный файл с переменными =
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

source "$SCRIPT_DIR/../variables.sh"

echo "folder_input = $folder_input"

# === Конвертирование в wav ===

echo $folder_input

echo -e "\n\t>> Конвертировать новые аудиофайлы в wav"

    # Цикл по всем файлам в каталоге
for file in "$folder_input"/*; do
      # Проверить, что это файл
  if [[ -f "$file" ]]; then

	# Извлечь базовое имя файла без расширения
    base_name=$(basename "${file%.*}")

        # Конвертировать каждый файл в wav (16 кГц, моно)
	    # и оставить его в том же каталоге
	    # и не выводить информацию о конвертации
    ffmpeg -i "$file" -ar 16000 -ac 1 "$folder_input/${base_name}.wav" -y > /dev/null 2>&1

    echo -e "• '$file'"

  fi
done

echo -e "\nСконвертировал"
