#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

source variables.sh


    # === Конвертирование ===

../scripts/ffmpeg/convert-sound-files-to-wav.sh


    # === Транскрибирование ===

#../scripts/model/small.sh
../scripts/model/medium.sh
#../scripts/model/large.sh


    # === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
../scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
../scripts/zim/update-main-file-content.sh


    # === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
../scripts/ffmpeg/convert-wav-to-ogg.sh


    # === TAR ===

    # перенести в архив файлы ogg и vtt
../scripts/tar/archive-files.sh
    # очистить каталог /input (уничтожает ВСЁ содержимое)
#../scripts/tar/delete-unnecessary-files.sh
