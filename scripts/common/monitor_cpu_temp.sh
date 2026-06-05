#!/bin/bash

    # должна быть установлена утилита sensor

    # Скрипт проверяет температуру CPU
    # CPU ≥ 76 °C → пауза 2 сек, замер температуры снова
    # CPU ≤ 75 °C → продолжаем выполнение Whisper
    # Никаких сообщений в консоль

SAFE_TEMP=75
SLEEP_INTERVAL=2  # seconds

    # Получаем текущую температуру самого горячего ядра по параметру Tctl из вывода "sensors"
    # Она в формате "+57.1°C", переводим его в чистое число типа "57"
CURRENT_TEMP=$(sensors | awk '/^Tctl:/ {gsub(/\+|°C/,"",$2); print int($2); exit}')

# echo "$CURRENT_TEMP"

    # Если температура выше +75 - ждем по одной паузе, пока не станет <= 75°C
    # Как только упадет до +74 — продолжить работу
while (( CURRENT_TEMP > SAFE_TEMP )); do
    sleep $SLEEP_INTERVAL
    CURRENT_TEMP=$(sensors | awk '/^Tdie/ {print $2+0; exit}')
done
