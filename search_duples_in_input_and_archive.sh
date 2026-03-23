#!/bin/bash

: '
Поиск совпадающих файлов между двумя каталогами по "теле" названия.

Скрипт ищет совпадения между файлами из каталога input_dir и archive_dir  на основании "тела"
файла — части имени без начальных цифр/дат/времени и расширения.

Совпадение считается, если оставшиеся строки полностью идентичны.

- Скрипт игнорирует файлы с расширением .vtt и .gitkeep
- В сравнении не учитываются дата и время из названий файлов, а также их расширения.
- В выводе результатов, буде таковые появяццо, указываются полные оригинальные имена файлов
    с расширениями.
- Результаты поиска будут отсортированы по алфавиту.
- Скрипт аккуратно работает с пробелами и спецсимволами в именах файлов.
- Используется ассоциативный массив archive_map для ускорения поиска — каждый файл input
    проверяется только один раз против карты архива.
- Сортировка идёт по полному имени файла input, включая дату и время.
- Результаты формируются блоками (Совпадение: + два файла + пустая строка).
- Результаты сохраняются в файл search_duples_results.txt в том же каталоге. Итоговый файл
    открывается в Kate и отвязывается от терминала.
'

input_dir="/home/astenix/bystro.whisper/input"
archive_dir="/home/astenix/bystro.whisper/archive"
output_file="./search_duples_results.txt"

    # Очистка файла с результатами перед началом работы
: > "$output_file"

echo -e "\nВыполняется поиск совпадений в названиях файлов.\nРезультат откроется в Kate."

    # Функция для извлечения "тела" названия (без даты/времени и расширения)
get_body() {
    local filename="$1"
    filename="${filename##*/}"                 # убираем путь
    filename="${filename%.*}"                  # убираем расширение
    echo "$filename" | sed 's/^[0-9 :.-]*//'  # убираем ведущие цифры/даты/время
}

    # Функция для безопасного ключа массива (замена всех спецсимволов на "_")
safe_key() {
    local str="$1"
    echo "$str" | tr -c '[:alnum:]' '_'
}

    # Создать карту архива для ускорения поиска
declare -A archive_map
while IFS= read -r f; do
    [[ "$f" == *.vtt || "$(basename "$f")" == ".gitkeep" ]] && continue
    body=$(get_body "$f")
    key=$(safe_key "$body")
    archive_map["$key"]+="$f"$'\n'
done < <(find "$archive_dir" -maxdepth 1 -type f)

    # Пройти по input в поисках точных совпадений
matches=()
while IFS= read -r in_file; do
    [[ "$in_file" == *.vtt || "$(basename "$in_file")" == ".gitkeep" ]] && continue
    body_in=$(get_body "$in_file")
    key_in=$(safe_key "$body_in")

    # Проверяем только файлы с таким же ключом
    if [[ -n "${archive_map[$key_in]}" ]]; then
        while IFS= read -r ar_file; do
            [[ -z "$ar_file" ]] && continue
            body_ar=$(get_body "$ar_file")
            # точное совпадение "тела" имени
            if [[ "$body_in" == "$body_ar" ]]; then
                matches+=("$in_file"$'\t'"$ar_file")
            fi
        done <<< "${archive_map[$key_in]}"
    fi
done < <(find -L "$input_dir" -maxdepth 1 -type f)

    #  Сортировка по полному имени input-файла
    # Отсортировать массив результатов по полному имени файлов,
    # убрать пустые строки
    # сохранить результат в $sorted;
mapfile -t sorted < <(printf "%s\n" "${matches[@]}" | sed '/^$/d' | sort -k1,1)
    # сохранить в $counted итоговое количество отсортированных элементов.
counted=${#sorted[@]}

    # Записать в файл уже отсортированные и подсчитанные результаты,
    # по три строки с нумерацией
: > "$output_file"

echo "Всего: $counted" >> "$output_file"
echo >> "$output_file"

counter=1
for line in "${sorted[@]}"; do
    in_file=$(cut -f1 <<<"$line")
    ar_file=$(cut -f2 <<<"$line")
    {
        echo "$counter:"
        echo "'$in_file'"
        echo "'$ar_file'"
        echo
    } >> "$output_file"
    ((counter++))
done


echo -e "\nГотово\n"

    # открыть файл с результатами в Kate и отвязать процесс от терминала
kate "$output_file" >/dev/null 2>&1 &
disown
