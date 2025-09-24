    # Sentece Transformer должен быть сперва отдельно установлен

from sentence_transformers import SentenceTransformer
from sklearn.cluster import DBSCAN
from sklearn.metrics.pairwise import cosine_distances
from collections import Counter
from razdel import sentenize # работа с кириллицей
import re # регулярные выражения
import os # прописывание относительных путей
import subprocess # для открытия файла в текстовом редакторе
import nltk

# Корень пользовательского каталога NLTK
nltk_data_root = os.path.expanduser('~/workspace/LLMs')

# Добавить путь, в котором должны находиться файлы токенайзера
nltk.data.path.append(nltk_data_root)

# Проверить наличие токенайзера и, если их нет — скачать
try:
    nltk.data.find('tokenizers/punkt')
except LookupError:
    nltk.download('punkt', download_dir=nltk_data_root)

# === НАСТРОЙКИ

# чувствительность кластеризации
    # Если предложений (кластеров) слишком много, eps можно увеличить.
    # Если кластеров мало — eps можно уменьшить, например, 0,25 или 0.22.
#eps_val = 0.34
eps_val = 0.11

    # выбрать только одну, остальные держать под комментарием
#myModel = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"    # Лёгкая модель, быстрая, средний результат
myModel = "intfloat/multilingual-e5-base"     # оптимальна для CPU
#myModel = "intfloat/multilingual-e5-large"    # Лучшая, но очень тяжёлая, сильно нагружает CPU

initialFile = "/tmp/vtt-tmp.txt"
tempFile = "/tmp/st-tmp.txt"

# === ВЫПОЛНЕНИЕ

# === 1. Загружаем модель ===
#print("\n1. Загружаем модель")

model = SentenceTransformer(myModel)

# === 2. Читаем текст ===
#print("2. Читаем текст")

with open(initialFile, "r", encoding="utf-8") as f:
    text = f.read()

# === 3. Разбиваем текст на предложения с помощью razdel ===
#print("3. Разбиваем текст на предложения")

sentences = [s.text for s in sentenize(text)]

# === 4. Векторизуем предложения ===
#print("4. Векторизуем предложения")

embeddings = model.encode(sentences)

# === 5. Кластеризация DBSCAN с косинусным расстоянием ===
#print("5. Кластеризация DBSCAN с косинусным расстоянием")

dist_matrix = cosine_distances(embeddings)
db = DBSCAN(eps=eps_val, min_samples=2, metric='precomputed')
labels = db.fit_predict(dist_matrix)

# === 6. Группируем предложения по кластерам, шум (-1) делаем отдельными абзацами ===
#print("6. Группируем предложения по кластерам, делаем отдельные абзацы")

paragraphs = {}
max_label = max(labels)
for idx, label in enumerate(labels):
    if label == -1:
        # Для шума создаём уникальный новый кластер, чтобы не объединять
        label = max_label + 1 + idx
    paragraphs.setdefault(label, []).append(sentences[idx])

# === 7. Сортируем абзацы по позиции первого предложения в тексте ===
#print("7. Сортируем абзацы по позиции первого предложения в тексте")

sentence_pos = {s: i for i, s in enumerate(sentences)}
ordered_keys = sorted(paragraphs.keys(), key=lambda k: sentence_pos[paragraphs[k][0]])
ordered_paragraphs = [paragraphs[k] for k in ordered_keys]

# === 8. Записываем результат в tempFile ===
#print("8. Записываем результат работы модели в tempFile")

with open(tempFile, "w", encoding="utf-8") as f:
    for para in ordered_paragraphs:
        clean_para = [s.replace('\n', ' ').strip() for s in para]
        f.write(" ".join(clean_para).strip() + "\n\n")

# === 9. Выполняем последнее форматирование текста после работы модели и сохраняем его обратно в initialFile
#print("9. Выполняем последнее форматирование текста после работы модели и сохраняем его обратно в initialFile")

    # Удалить пустые строки.
    # Учесть заголовки (==)
    # Склеить соседние непустые строки, вставляя между ними \n, чтобы они не сливались в одну строку.
    # Сохранить результат в файл output.txt

with open(tempFile, "r", encoding="utf-8") as f:
    lines = f.readlines()

result = []
    # конкатенация строк в абзацы
for line in lines:
    stripped = line.strip()

    # когда находим пустую строку — оставляем её в покое
    if stripped == "":
        result.append("")
        continue

    # Найдём все заголовки внутри строки и разобьём
    parts = re.split(r"(=+[^=].*?=+)", stripped)
    for part in parts:
        part = part.strip()
        if not part:
            continue
        if re.fullmatch(r"=+[^=].*?=+", part):
            result.append("")
            result.append(part)
            result.append("")
        else:
            # Текст не заголовок — добавляем как есть
            result.append(part)

with open(initialFile, "w", encoding="utf-8") as f:
    f.write("\n".join(result))

#print("\n\t== Показатели работы модели ==")
#print("model =", myModel)
#print("eps_val =", eps_val)
#print("Количество кластеров (без шума):", len(set(labels)) - (1 if -1 in labels else 0))
#print("Метки кластеров:\n", set(labels))
    #from collections import Counter
#print("Распределение по кластерам:\n", Counter(labels))
