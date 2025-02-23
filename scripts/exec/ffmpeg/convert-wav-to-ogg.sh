#!/bin/bash

echo -e "\n\t>> Конвертировать все wav в ogg:\n"

for file in $INPUT_FOLDER/*.wav; do
        # Заменить расширение .wav на .ogg
    output_ogg_file="${file%.wav}.ogg"
        # Конвертация в ogg
    ffmpeg -i "$file" -c:a libvorbis "$output_ogg_file"  > /dev/null 2>&1

    echo -e "• '$file'"
done

echo -e "\nСконвертировал"