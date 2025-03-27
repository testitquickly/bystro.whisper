#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

    # = Глобальный файл с переменными =

source ./scripts/variables.sh

# === Конвертирование в wav ===

./scripts/ffmpeg/convert-sound-files-to-wav.sh

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
#./scripts/tar/archive-files.sh

# === COMMON ===

    # очистить каталог /input
#./scripts/common/trash-files-from-input.sh
./scripts/common/move-files-to-archive-folder.sh

# === END OF STORY ===

    # Выполнить звуковой сигнал на другом компьютере через ssh (нужен ключ)
#ssh astenix@192.168.50.17 'paplay /usr/share/sounds/freedesktop/stereo/complete.oga'
#./scripts/network/ping.sh

    # короткий сигнал про завершение транскрибрования
# paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga

    # долгий сигнал про завершение транскрибрования
$sound_all_files_are_transcribed


echo -e "\n "
