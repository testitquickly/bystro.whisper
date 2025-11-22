#!/bin/bash

echo -e "\n\t>> Конвертировать файлы wav в ogg:\n"

for file in $folder_input/*.wav; do
        # Заменить расширение .wav на .ogg
    output_ogg_file="${file%.wav}.ogg"

        # Конвертация в ogg Vorbis
        # Задано: 16kHz и 64 kbps
        # на выходе будет 16kHz и ~42 kbps (Vorbis использует переменный битрейт (VBR), и он зависит от  сложности сигнала — тишина и низкая динамика → битрейт ниже, активная речь → выше)
    ffmpeg -i "$file" -c:a libvorbis -ar 16000 -b:a 64k "$output_ogg_file" > /dev/null 2>&1

    echo -e "• $(basename "$file")"
done

echo -e "\nСконвертировал"
