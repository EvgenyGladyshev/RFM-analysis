import configparser
import os

import psycopg2
from psycopg2 import sql

# Путь к файлам
dirname = os.path.dirname(__file__)

# Настраиваем конфиги
config = configparser.ConfigParser()
config.read(os.path.join(dirname, "config.ini"), encoding="utf-8")

# В переменные записываем данные из конфига
DATABASE = config["Database"]

conn = psycopg2.connect(
    host=DATABASE["HOST"],
    database=DATABASE["DATABASE"],
    user=DATABASE["USER"],
    password=DATABASE["PASSWORD"],
    port = DATABASE["PORT"]
)

# Создаем курсор
cursor = conn.cursor()

# Загружаем SQL из файла
with open("rfm_analysis.sql", "r", encoding='utf-8') as sql_file:
    reader = sql_file.read()
    cursor.execute(reader)
    
results = cursor.fetchall()
for row in results:
    print(row)
    
# Закрываем соединение соединение
conn.commit()
cursor.close()
conn.close()
