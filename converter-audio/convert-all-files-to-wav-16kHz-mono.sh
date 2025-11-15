#!/bin/bash

  # Скрипт лежит в каталоге с аудиофайлами
  # Он создаёт подкаталог ready/ и складывает туда переконвертированные файлы
  # Каждый файл → wav, 16000 Hz, mono
  # При сбое скрипт сообщает об ошибке

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
READY_DIR="$SCRIPT_DIR/ready"

mkdir -p "$READY_DIR"

for file in "$SCRIPT_DIR"/*; do
    [[ -f "$file" ]] || continue
    [[ "$file" == "$SCRIPT_DIR/$(basename "$0")" ]] && continue   # пропустить файл самого скрипта

    ext="${file##*.}"
    name="${file##*/}"
    base="${name%.*}"

    echo -n "→ $name … "

    out="$READY_DIR/${base}.wav"

    if ffmpeg -i "$file" -ar 16000 -ac 1 "$out" -y > /dev/null 2>&1; then
        echo "OK"
    else
        echo "ОШИБКА!"
    fi
done

echo -e "\nГотово."
