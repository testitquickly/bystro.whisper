#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

. ./exec/variables.sh


    # === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./exec/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./exec/zim/update-index.sh

echo "\n "