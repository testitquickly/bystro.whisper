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

    # переделать файлы vtt в txt для Zim
./scripts/zim/convert-vtt-file-to-txt.sh

    # переместить все файлы txt под страницу index
./scripts/zim/move-txt-to-index.sh

    # пересобрать содержимое страницы index
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
