#!/bin/bash

    # = Глобальный файл с переменными =
. ./scripts/variables.var

    # пересобрать содержимое страницы index
./scripts/zim/update-index.sh

#zim /home/astenix/Notebooks/Whisper/ index &

echo -e "\nDone\n"
