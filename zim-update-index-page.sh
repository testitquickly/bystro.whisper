#!/bin/bash

    # = Глобальный файл с переменными =
. ./scripts/variables.sh

    # пересобрать содержимое страницы Main
./scripts/zim/update-index.sh

echo -e "\nDone"
