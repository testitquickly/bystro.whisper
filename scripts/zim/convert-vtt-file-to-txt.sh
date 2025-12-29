#!/bin/bash

# = Глобальный файл с переменными =
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../variables.sh"

echo -e "\n\t[Переделать файлы vtt в txt для Zim]\n"

initialFile="/tmp/vtt-tmp.txt"
zim_output_tmp="/tmp/zim-output-tmp.txt"

cd "$folder_input" || exit 1

source $SentenceTransformer_virtual_environment_path

for file in *.vtt; do
    [[ -f "$file" ]] || continue

    # Имя выходного файла без расширения
    output_file_name=$(echo "${file%.vtt}" | tr ' ' '_' | tr '.' '-')

    # Предобработка VTT -> initialFile
    sed -e '/^[0-9].*-->.*[0-9]$/d' \
        -e '1!{/^\s*$/d}' \
        -e 's/WEBVTT//g' \
        "$file" > "$initialFile"

    echo -e "SentenceTransformer => $file "
    # python3 ~/workspace/SentenceTransformer/sentence-transformer.py
    python3 ../scripts/zim/sentence-transformer.py

current_date_and_time=$(date +"%Y-%m-%dT%H:%M:%S")

    # Добавить заголовок Zim и сохранить в txt
    sed -e "1s|^|Content-Type: text/x-zim-wiki\nWiki-Format: zim 0.6\nCreation-Date: $current_date_and_time\n\n====== ${file%.vtt} ======\n\n''${output_file_name}.ogg''\n\n\n|" "$initialFile" > "${output_file_name}.txt"

done

deactivate

echo -e "\nDone"
