#!/bin/bash

    # запустить обработку vaw-файлов через whisper — его надо сперва запустить
    # в переменной FOLDER не надо указывать закрывающий слэш

    # глобальные переменные заданы в головном файле проекта


    # создать FILES - массив всех wav-файлов в каталоге input
FILES=("$INPUT_FOLDER"/*.wav)
    # подсчитать количество вхождений в массиве FILES
TOTAL_FILES=${#FILES[@]}

  # Если в каталоге нет файлов wav — прекратить работу
if [ "$TOTAL_FILES" -eq 0 ]; then
  echo "Нет файлов .wav для обработки в $INPUT_FOLDER."
  exit 1
fi

  # Создать переменную COUNTER, которая хранит количество оставшихся файлов.
  # Сначала она равна TOTAL_FILES, и после каждого успешного перемещения файла в каталог output
  # она уменьшается на единицу
COUNTER=$TOTAL_FILES



  # Проверить, активировано ли уже виртуальное окружение
#if [ -n "$VIRTUAL_ENV" ]; then
  # Если виртуальное окружение уже активно — его надо погасить. Иначе двигаться дальше
#  deactivate
#fi

  # Активировать виртуальное окружение
source "$VENV_PATH"

  # Проверить поднялось ли виртуальное окружение
if [ -z "$VIRTUAL_ENV" ]; then
  echo -e "\n\tСтоп. Виртуальное окружение Python не активировано."
  exit 1
else
    CURRENT_TIME=$(LC_TIME=ru_RU.UTF-8 date +"%H:%M")
    echo -e "\n\t>> ($CURRENT_TIME) Транскрибировать аудиофайлы ($TOTAL_FILES) через Whisper, модель «LARGE»\n"
fi



      # запуск отдельного окна с нагрузкой на GPU
    #konsole --noclose -e nvtop 2>/dev/null &

      # запуск отдельного окна с нагрузкой на CPU
    #konsole --noclose -e htop 2>/dev/null &



    # Обработать каждый файл .wav в каталоге input
for FILE in "$INPUT_FOLDER"/*.wav; do
	# Сохранить имя файла без полного пути к нему
    FILENAME=$(basename "$FILE")
  


	# Узнать длительность файла
    DURATION=$(ffprobe -i "$FILE" -show_entries format=duration -v quiet -of csv="p=0")
        # Преобразовать длительность в целое число (отбросить дробную часть)
    DURATION=${DURATION%.*}

	# Преобразовать длительность в часы, минуты и секунды
    HOURS=$((DURATION / 3600))
    MINUTES=$(((DURATION % 3600) / 60))
    SECONDS=$((DURATION % 60))

        # Форматировать вывод
    if [ "$HOURS" -gt 0 ]; then
        FORMATTED_DURATION=$(printf "%02d hr %02d min %02d sec" $HOURS $MINUTES $SECONDS)
    elif [ "$MINUTES" -gt 0 ]; then
        FORMATTED_DURATION=$(printf "%02d min %02d sec" $MINUTES $SECONDS)
    else
        FORMATTED_DURATION=$(printf "%02d sec" $SECONDS)
    fi



    # Запуск whisper со следующими параметрами:
        # модель нейросети
        # формат текста
        # используемый язык
        # количество задействованных ядер CPU (независимо от устройства, на котором делаются расчеты)
        # вычисления в формате float16
        # каталог сохранения результатоы
        # подавить вывод всех служебных сообщений в консоли (через направление их в /dev/null)
          # >/dev/null: Направляет stdout в /dev/null.
          # 2>&1 = читается как: "Перенаправить поток 2 (stderr) туда же, куда сейчас направлен поток 1 (stdout)."
          # всё вместе = перенаправляет поток 2 (stderr) в то же место, куда уже перенаправлен поток 1 (stdout), в данном случае —  в /dev/null.
whisper "$FILE" \
    --model large \
    --output_format "$whisper_output_format" \
    --language "$whisper_language" \
    --device "$whisper_device" \
    --threads "$whisper_threads" \
    --fp16 "$whisper_fp16" \
    --output_dir "$INPUT_FOLDER" \
    > /dev/null 2>&1

EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    # подтвердить успех транскрибации
    echo -e "$(printf "%d) \"%s\" ($FORMATTED_DURATION)" $COUNTER "$FILENAME")"
  else
    echo -e "Ошибка обработки \"$FILENAME\". Код ошибки: $EXIT_CODE.\n(если '127' — whisper не запущен, не поднялся python virt env)"
  fi
  # Уменьшить счетчик количества файлов на одну единицу
  ((COUNTER--))
done



    # disengage whisper Python virtual environment
deactivate



  # снова сохранить время в переменную CURRENT_TIME
CURRENT_TIME=$(LC_TIME=ru_RU.UTF-8 date +"%H:%M")
echo -e "\nТранскрибировал ($CURRENT_TIME)"
