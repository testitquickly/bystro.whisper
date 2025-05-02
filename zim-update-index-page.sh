#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

. ./scripts/variables.sh

# === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
#./scripts/zim/convert-vtt-file-to-txt.sh

    # пересобрать содержимое страницы Main
./scripts/zim/update-index.sh

#./exec/common/trash-files-from-input.sh

echo -e "\n "
