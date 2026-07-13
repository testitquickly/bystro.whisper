#!/bin/bash

# Alexei Lupan, 2026
# Email: astenix@testitquickly.com
# Hostname: uss-Asus-Zenbook-17

# Этот скрипт найдет в каталоге все файлы ogg и перекодирует их в псевдо-стерео
# с сохранением качества (оно малое, но всё-таки)

: << 'COMMENT'
…
COMMENT


for f in *.ogg; do
    ffmpeg -i "$f" -ac 2 -c:a libvorbis -q:a 4 "${f%.ogg}_stereo.ogg"
done
