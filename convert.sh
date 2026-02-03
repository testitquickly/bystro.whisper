#!/bin/bash

# = Глобальный файл с переменными =

source ./scripts/variables.sh

# === Конвертирование в wav ===

./scripts/ffmpeg/convert-sound-files-to-wav.sh

    # короткий сигнал про завершение
$sound_all_files_are_transcribed_short

echo -e "\n "

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT