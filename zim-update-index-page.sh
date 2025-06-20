#!/bin/bash

    # = Глобальный файл с переменными =
. ./scripts/variables.sh

    # пересобрать содержимое страницы index
./scripts/zim/update-index.sh

echo -e "\nDone"
