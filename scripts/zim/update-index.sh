#!/bin/bash
# -*- coding: utf-8 -*-
# Скрипт собирает файлы .txt первого уровня в index.txt.
# - Каждый обнаруженный файл становится заголовком второго уровня (===== Заголовок =====)
# - Unsorted всегда ставим первым
# - Игнорируем сам файл index.txt
# - Под каждым заголовком собираем нумерованные ссылки на файлы из каталога с таким именем
# - Списки файлов отодвинуты на один таб от левого края (для красоты)

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../variables.sh"

index_path="$zim_folder_main/$zim_file_index"

# ───────────────────────────────────────────────
# Инициализация index.txt
# ───────────────────────────────────────────────
cat > "$zim_folder_main/$zim_file_index" <<EOL
Content-Type: text/x-zim-wiki
Wiki-Format: zim 0.6
Creation-Date: $(date --iso-8601=seconds)

====== index ======

EOL

# ───────────────────────────────────────────────
# Получаем список файлов первого уровня, исключая index.txt
# ───────────────────────────────────────────────
mapfile -t files_level1 < <(find "$zim_folder_main" -maxdepth 1 -type f -name "*.txt" ! -iname "$zim_file_index" | sort)

# Разделяем список "Unsorted" от остальных
unsorted_files=()
other_files=()
for file in "${files_level1[@]}"; do
    stem=$(basename "$file" .txt)
    if [[ "$stem" == "Unsorted" ]]; then
        unsorted_files+=("$file")
    else
        other_files+=("$file")
    fi
done

files_ordered=("${unsorted_files[@]}" "${other_files[@]}")

# ───────────────────────────────────────────────
# Добавляем заголовки второго уровня и файлы из каталогов
# ───────────────────────────────────────────────
for file in "${files_ordered[@]}"; do
    stem=$(basename "$file" .txt)
    title="${stem//_/ }"
    echo "===== $title =====" >> "$zim_folder_main/$zim_file_index"
    echo "" >> "$zim_folder_main/$zim_file_index"

    folder_path="$zim_folder_main/$stem"
    if [[ -d "$folder_path" ]]; then
        mapfile -t inner_files < <(find "$folder_path" -maxdepth 1 -type f -name "*.txt" | sort)
        idx=1
        for inner_file in "${inner_files[@]}"; do
            inner_title=$(basename "$inner_file" .txt)
            inner_title="${inner_title//_/ }"
            echo -e "\t$idx. [[${title}:${inner_title}|${inner_title}]]" >> "$zim_folder_main/$zim_file_index"
            ((idx++))
        done
    fi

    echo "" >> "$zim_folder_main/$zim_file_index"
done

echo -e "\nУспешно перезаписан $zim_folder_main/$zim_file_index"
