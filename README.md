# Описание задачи

Из-за сезонного спада выручка в аптеке начнет падать. Поэтому нужно сегментировать клиентов аптечной сети на основе их покупательского поведения для повышения лояльности, увеличения среднего чека и оптимизации маркетинговых стратегий.

## Что было сделано

Для решения этой задачи мной был проведен RFM-анализ клиентской базы аптечной сети. В этот репозиторий включил:

- [SQL-запрос рассчета основных показателей и составления групп](https://github.com/EvgenyGladyshev/RFM-analysis/blob/master/rfm_analysis.sql)
- [Скрипт подключения к БД](https://github.com/EvgenyGladyshev/RFM-analysis/blob/master/rfm_analysis.py)(SQL-запрос написан для *PostgreSQL*)
- [Визуализация основных показателей, а также таблицы RFM-анализа с помощью BI-системы Metabase](https://github.com/EvgenyGladyshev/RFM-analysis/blob/master/dashboard.md)
- [Бизнес-выводы и рекомендации](https://github.com/EvgenyGladyshev/RFM-analysis/blob/master/insights.md)



## Запуск скрипта

```sh

# Создаем виртуальное окружение
python -m venv rfm_analysis

# Активируем виртуальное окружение
./rfm_analysis/scripts/activate # source rfm_analysis/bin/activate для Linux

# Устанавливаем зависимости
pip install -r requirements.txt

# Запускаем скрипт
python rfm_analysis.py
```