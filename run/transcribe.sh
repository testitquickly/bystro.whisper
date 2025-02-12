#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

source "$(dirname "$0")/variables.sh"

    # === Транскрибирование ===

#./scripts/model/small.sh
./scripts/model/medium.sh
#./scripts/model/large.sh


    # === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./scripts/zim/update-main-file-content.sh


    # === TAR ===

    # конвертировать все wav-файлы в ogg-файлы
./scripts/tar/convert-wav-to-ogg.sh
    # перенести в архив файлы ogg и vtt
./scripts/tar/archive-files.sh
    # очистить каталог /input
#./scripts/tar/delete-unnecessary-files.sh
