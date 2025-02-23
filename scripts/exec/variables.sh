    # === Транскрибирование ===

    # Путь к виртуальному окружению
export VENV_PATH='/home/hdd/workspace/Whisper/Whisper_env/bin/activate'

    # Каталог с файлами (без завершающего слэша)
export INPUT_FOLDER='/home/hdd/workspace/bystro.whisper/input'
export whisper_language='Russian'
export whisper_output_format='vtt'
    # set 'cpu' by default; 
    # set 'cuda' for dedicated videocard
export whisper_device='cpu'
    # по-умолчанию True. Установить 'False' для CPU;
    # кавычки не нужны, это boolean
    # для cuda его вообще нужно убрать из файла с моделью
export whisper_fp16=False
export whisper_threads='2'
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OMP_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1

    # === Zim ===

export zim_main_folder="/home/hdd/Dropbox/Notebooks/Whisper/"
export zim_main_file="/home/hdd/Dropbox/Notebooks/Whisper/Home.txt"

    # === TAR ===

    # имя файла с архивом tar
export archive_filename='/home/hdd/workspace/bystro.whisper/archive.tar'
