#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

source ./exec/variables.sh

# === Конвертирование в wav ===

./exec/ffmpeg/convert-sound-files-to-wav.sh

# === Транскрибирование ===

    #./exec/model/small.sh
./exec/model/medium.sh
    #./exec/model/large.sh

# === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./exec/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./exec/zim/update-index.sh

# === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
./exec/ffmpeg/convert-wav-to-ogg.sh

# === TAR ===

    # перенести в архив файлы ogg и vtt
./exec/tar/archive-files.sh

# === COMMON ===

    # очистить каталог /input
./exec/common/trash-files-from-input.sh

echo -e "\n "
