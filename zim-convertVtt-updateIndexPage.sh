#!/bin/bash

# = Глобальный файл с переменными =
. ./scripts/variables.sh

./scripts/zim/convert-vtt-file-to-txt.sh

./scripts/zim/update-index.sh

./scripts/common/move-files-to-archive-folder.sh

echo -e "\nDone"
