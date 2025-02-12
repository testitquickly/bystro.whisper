    # === Транскрибирование ===

    # Путь к виртуальному окружению
export VENV_PATH='/home/astenix/workspace/Whisper/Whisper_env/bin/activate'
    # Каталог с файлами (без завершающего слэша)
export INPUT_FOLDER='/home/astenix/workspace/bystro.whisper/input'
export whisper_language='Russian'
export whisper_output_format='vtt'
    # set 'cpu' by default; set 'cuda' for dedicated videocard
export whisper_device='cpu'
    # set 'false' for CPU;
    # set 'true' for cuda
    # кавычки не нужны, это булево значение
export whisper_fp16='False'
export whisper_threads='3'
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OMP_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1

    # === Zim ===

export zim_main_folder="/home/astenix/Dropbox/Notebooks/Whisper/"
export zim_main_file="/home/astenix/Dropbox/Notebooks/Whisper/main.txt"
``
    # === TAR ===

    # имя файла с архивом tar
export archive_filename='/home/astenix/workspace/bystro.whisper/archive-asus-zenbook-17.tar'
