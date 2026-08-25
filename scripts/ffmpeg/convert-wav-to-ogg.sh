#!/bin/bash

echo -e "\n\t[Конвертировать файлы wav в ogg]\n"

# = Глобальный файл с переменными =
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../variables.var"

for file in $folder_input/*.wav; do

    # Пропустить файлы, которые уже помечены как [done]
    if [[ "$(basename "$file")" == "[done]"* ]]; then
        continue
    fi
        # Заменить расширение .wav на .ogg
    output_ogg_file="${file%.wav}.ogg"

        # Конвертация в ogg Vorbis в псевдостерео, чтобы монозапись не звучала только в левом ухе
        # сохранить 16kHz
        # пустить монозапись в оба канала
        # задать качество аудио для кодека Vorbis в режиме VBR (variable bitrate). У Vorbis VBR через -q:a обычно лучше распределяет биты,
        # тишину сжимает сильнее, сложные места — меньше.
        	# -q:a 0    очень низкое качество
        	# -q:a 3-4  для речи, до ~128 кбит/с
        	# -q:a 5-6  музыка, до ~192 кбит/с
        	# -q:a 8-10 почти без потерь (но большой размер, избыточно для речевых заметок)
	ffmpeg -i "$file" \
        -c:a libvorbis \
        -ar 16000 \
        -ac 2 \
        -q:a 4 \
        "$output_ogg_file" > /dev/null 2>&1

    # переименовать оригинальный wav — добавить слово ”done”
    if [ $? -eq 0 ]; then
        mv "$file" "$(dirname "$file")/[done] $(basename "$file")"
    fi

    echo -e "• $(basename "$file")"

done

echo -e "\nDone"
