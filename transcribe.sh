#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

# = Глобальный файл с переменными =

. ./scripts/variables.sh

# === Транскрибирование ===

#./scripts/model/small.sh
#./scripts/model/medium.sh
./scripts/model/large.sh

# === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./scripts/zim/update-index.sh

# === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
./scripts/ffmpeg/convert-wav-to-ogg.sh

# === COMMON ===

    # переместить оставшиеся файлы в каталог archive/
./scripts/common/move-files-to-archive-folder.sh

# === END OF STORY ===

    # короткий сигнал про завершение транскрибрования
# paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga
$sound_all_files_are_transcribed_short

    # долгий сигнал про завершение транскрибрования
# $sound_all_files_are_transcribed_long

echo -e "\n "
