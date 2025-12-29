# === Транскрибирование ===

    # Путь к виртуальному окружению Python с Whisper
export llms_path='/home/astenix/workspace/LLMs'
export whisper_virtual_environment_path='/home/astenix/workspace/LLMs/Whisper/whisper_env/bin/activate'
export SentenceTransformer_virtual_environment_path='/home/astenix/workspace/LLMs/SentenceTransformer/SentenceTransformer_env/bin/activate'

    # Каталог с файлами (без завершающего слэша)
export folder_input='/home/astenix/workspace/bystro.whisper/input'
export folder_output='/home/astenix/workspace/bystro.whisper/archive/'

    # Каталог корзины и её подкаталоги
export folder_trash="$HOME/.local/share/Trash"
export folder_trash_files="$folder_trash/files"
export folder_trash_info="$folder_trash/info"

    # Переменные для настройки whisper
export whisper_language='Russian'
export whisper_output_format='vtt'

    # 'cpu' для работы с процессора, 'cuda' для работы с выделенной видеокарты
export whisper_device='cpu'

    # Количество физических ядер, выделенных для Whisper
export whisper_threads='3'

    # по-умолчанию True. Установить 'False' для CPU;
    # кавычки не нужны, это boolean
    # для cuda его вообще нужно убрать из файла с моделью
export whisper_fp16=False

    # OpenBLAS — для линейной алгебры (могут использоваться при работе с тензорами в PyTorch). Важное.
export OPENBLAS_NUM_THREADS=2

    # MKL — если у тебя установлена версия PyTorch, собранная с Intel MKL, то эта библиотека тоже может влиять на производительность. Важное.
export MKL_NUM_THREADS=2

    # OpenMP (OMP) — напрямую используется PyTorch для параллельных операций. Важное.
export OMP_NUM_THREADS=2

    # NumExpr — редко задействуется в Whisper, используется со сторонними библиотеками для доп. обработки данных.
export NUMEXPR_NUM_THREADS=1

# === Zim ===

export zim_folder_main="/home/astenix/Notebooks/Whisper"
export zim_file_index="index.txt"
export zim_folder_unsorted="Unsorted"

# === FINAL SOUNDS ===

    # ssh-ключи для соединения с основным компьютером
export ssh_keys='/home/astenix/keys/ssh/astenix'

    # короткий сигнал про завершение транскрибрования каждого файла
export sound_file_is_transcribed='paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga'

    # долгий сигнал про завершение транскрибрования всех файлов
export sound_all_files_are_transcribed_long='paplay /usr/share/sounds/Oxygen-Sys-Log-In.ogg'

    # короткий сигнал про завершение транскрибрования всех файлов
export sound_all_files_are_transcribed_short='paplay /usr/share/sounds/Oxygen-Sys-Log-In-Short.ogg'
