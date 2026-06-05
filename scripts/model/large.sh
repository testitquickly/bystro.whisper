#!/bin/bash

    # запустить обработку wav-файлов через whisper
    # в переменной FOLDER не надо указывать закрывающий слэш
    # глобальные переменные заданы в головном файле проекта — variables.var


    # создать FILES - массив всех wav-файлов в каталоге input
FILES=("$folder_input"/*.wav)
    # подсчитать количество вхождений в массиве FILES
TOTAL_FILES=${#FILES[@]}

  # Если в каталоге нет файлов wav — прекратить работу
if [ "$TOTAL_FILES" -eq 0 ]; then
  echo "Нет файлов .wav для обработки в $folder_input."
  exit 1
fi

  # Создать переменную COUNTER, которая хранит количество оставшихся файлов.
  # Сначала она равна TOTAL_FILES, и после каждого успешного перемещения файла в каталог output
  # она уменьшается на единицу
COUNTER=$TOTAL_FILES


  # Активировать виртуальное окружение
source "$whisper_virtual_environment_path"

  # Проверить поднялось ли виртуальное окружение
if [ -z "$VIRTUAL_ENV" ]; then
  echo -e "\n\tСтоп. Виртуальное окружение Python не активировано."
  exit 1
else
    CURRENT_TIME=$(LC_TIME=ru_RU.UTF-8 date +"%H:%M")
    echo -e "\n\t>> Начинаю транскрибирование\n\n\tМодель:\tlarge-v3\n\tФайлов:\t$TOTAL_FILES\n\tВремя:\t$CURRENT_TIME\n"
fi

      # запуск отдельного окна с нагрузкой на GPU
    #konsole --noclose -e nvtop 2>/dev/null &

      # запуск отдельного окна с нагрузкой на CPU
    #konsole --noclose -e htop 2>/dev/null &


    # Обработать каждый файл .wav в каталоге input
for FILE in "$folder_input"/*.wav; do
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
        # формат чисел float16 нужене только когда всё на CPU, а для GPU этот параметр не нужен вообще
        # каталог сохранения результатов
        # подавить вывод всех служебных сообщений в консоли (через направление их в /dev/null)
          # >/dev/null: Направляет stdout в /dev/null.
          # 2>&1 = читается как: "Перенаправить поток 2 (stderr) туда же, куда сейчас направлен поток 1 (stdout)."
          # всё вместе = перенаправляет поток 2 (stderr) в то же место, куда уже перенаправлен поток 1 (stdout), в данном случае —  в /dev/null.
whisper "$FILE" \
    --model large-v3 \
    --output_format "$whisper_output_format" \
    --language "$whisper_language" \
    --device "$whisper_device" \
    --threads "$whisper_threads" \
    $fp16_statement \
    --output_dir "$folder_input" \
    > /dev/null 2>&1 &   # ← запустить процесс whisaper в фоне, чтобы "поймать" его PID

# Поймать PID запущенного процесса whisper
pid=$!

# Команда заставляет Linux распределять процесс Whisper только по логическим ядрам, которые автоматически выбрал балансировщик нагрузки на CPU
  # taskset: привязать уже запущенный процесс Whisper (мы его узнали через $pid) к выбранным через $LOGICAL_CORES логическим ядрам
  # -p  = применить к существующему процессу
  # -c  = указать список конкретных ядер
  # >/dev/null = подавить вывод команды, чтобы не мусорить в консоли
taskset -pc "$LOGICAL_CORES" "$pid" >/dev/null

# Подождать завершения обработки файла
wait "$pid"

# проверить код возврата успешного запуска процесса Whisper
EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
        # подтвердить успех транскрибации
    echo -e "$(printf "%d) %s ($FORMATTED_DURATION)" $COUNTER "$FILENAME")"
        # короткий звук
    $sound_file_is_transcribed    
  else
    echo -e "Ошибка обработки \"$FILENAME\". Код ошибки: $EXIT_CODE.\n(если '127' — whisper не запущен, не поднялся python virt env)"
  fi

  # Подождать охлаждения CPU до +75 перед обработкой следующего файла
  # Путь к файлу с мониторингом температуры указан относительно текущего каталога (large)
source "$(dirname "$0")/../common/monitor_cpu_temp.sh"

    # Уменьшить счетчик только если файлов больше одного, иначе пропустить этот шаг
if [ "$COUNTER" -gt 1 ]; then
  ((COUNTER--))
fi
done


    # disengage whisper Python virtual environment
deactivate


  # снова сохранить время в переменную CURRENT_TIME
CURRENT_TIME=$(LC_TIME=ru_RU.UTF-8 date +"%H:%M")
echo -e "\nТранскрибировал. Время:\t$CURRENT_TIME"
