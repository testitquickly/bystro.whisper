#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

source variables.sh

    # === Транскрибирование ===

#./model/small.sh
./model/medium.sh
#./model/large.sh


    # === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./zim/update-main-file-content.sh


    # === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
./ffmpeg/convert-wav-to-ogg.sh


    # === TAR ===

    # перенести в архив файлы ogg и vtt
./tar/archive-files.sh
    # очистить каталог /input
#./tar/delete-unnecessary-files.sh
