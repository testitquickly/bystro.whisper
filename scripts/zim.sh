#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

. variables.sh


    # === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
#./scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./scripts/zim/update-main-file-content.sh
