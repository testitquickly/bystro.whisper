#!/bin/bash

: << 'COMMENT'
    Это блок комментариев. Можно писать что угодно здесь, и оно не будет выполнено.
COMMENT

if ! command -v sensors &> /dev/null; then
    echo -e "\n\tПроцесс остановлен: не нахожу утилиту 'sensors'\n\tsudo apt install lm-sensors"
    exit 1
fi

# остановить скрипт при любой ошибке
set -e

echo -e "\n\tМониторинг CPU: htop\n\tМониторинг GPU: nvtop"

echo -e "\n\tЕсли процесс запущен на GPU и его надо остановить:\n\t1) в основном окне CTRL+C\n\t2) во втором окне с монитором nvtop через\n\t\tF9 > Send signal: 9 SIGKILL"

# = Глобальный файл с переменными =

. ./scripts/variables.var

# === Транскрибирование ===

#./scripts/model/test.sh

# ./scripts/model/small.sh
#./scripts/model/medium.sh
./scripts/model/large.sh
#./scripts/model/turbo.sh

# === Zim ===

    # собрать новый файл для Zim на основе содержимого всех vtt-файлов
#./scripts/zim/convert-vtt-file-to-txt.sh
    # пересобрать содержимое страницы Main
#./scripts/zim/update-index.sh

# === Конвертирование файлов из wav в ogg ===

    # конвертировать все wav-файлы в ogg-файлы
./scripts/ffmpeg/convert-wav-to-ogg.sh

# === TAR ===

    # перенести в архив файлы ogg и vtt
#./scripts/tar/archive-files.sh

# === COMMON ===

    # очистить каталог /input
    # переместить оставшиеся файлы в корзину (на всякий случай)
    # при восстановлении все кириллические символы в названии будут заменены на „/?”
#./scripts/common/trash-files-from-input.sh

# === END OF STORY ===

    # Выполнить звуковой сигнал на другом компьютере через ssh (нужен ключ)
#./scripts/network/ping.sh

    # короткий сигнал про завершение транскрибрования
# paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga

    # долгий сигнал про завершение транскрибрования
$sound_all_files_are_transcribed

echo -e "\n "
