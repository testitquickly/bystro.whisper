#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

# = Глобальный файл с переменными =

. ./scripts/variables.sh

# === Транскрибирование ===

#./scripts/model/small.sh
./scripts/model/medium.sh
#./scripts/model/large.sh

# === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
./scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
./scripts/zim/update-index.sh

# === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
./scripts/ffmpeg/convert-wav-to-ogg.sh

# === TAR ===

    # перенести в архив файлы ogg и vtt
./scripts/tar/archive-files.sh

# === COMMON ===

    # очистить каталог /input
    # переместить оставшиеся файлы в корзину (на всякий случай)
    # при восстановлении все кириллические символы в названии будут заменены на „/?”
./scripts/common/trash-files-from-input.sh

echo -e "\n "
