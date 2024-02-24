# Расчет продуктовых метрик 
В ходе этого учебного проекта выполнялся анализ данных работы интернет-магазина путем написания SQL-запросов и построения дашбордов в Redash.

## Условия задач  
1. Для каждого дня в таблице orders рассчитайте следующие показатели:

- Выручку, полученную в этот день.
- Суммарную выручку на текущий день.
- Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.

Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.

Будем считать, что оплата за заказ поступает сразу же после его оформления, т.е. случаи, когда заказ был оформлен в один день, а оплата получена на следующий, возникнуть не могут.  
Суммарная выручка на текущий день — это результат сложения выручки, полученной в текущий день, со значениями аналогичного показателя всех предыдущих дней.

2. Для каждого дня в таблицах orders и user_actions рассчитайте следующие показатели:

- Выручку на пользователя (ARPU) за текущий день.
- Выручку на платящего пользователя (ARPPU) за текущий день.
- Выручку с заказа, или средний чек (AOV) за текущий день.

Колонки с показателями назовите соответственно arpu, arppu, aov. Колонку с датами назовите date. При расчёте всех показателей округляйте значения до двух знаков после запятой.

3. По таблицам orders и user_actions для каждого дня рассчитайте следующие показатели:

- Накопленную выручку на пользователя (Running ARPU).
- Накопленную выручку на платящего пользователя (Running ARPPU).
- Накопленную выручку с заказа, или средний чек (Running AOV).

Колонки с показателями назовите соответственно running_arpu, running_arppu, running_aov. Колонку с датами назовите date. 

4. Для каждого дня недели в таблицах orders и user_actions рассчитайте следующие показатели:

- Выручку на пользователя (ARPU).
- Выручку на платящего пользователя (ARPPU).
- Выручку на заказ (AOV).

Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share. Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.

При расчётах учитывайте данные только за период с 26 августа 2022 года по 8 сентября 2022 года включительно — так, чтобы в анализ попало одинаковое количество всех дней недели (ровно по два дня).  
В результирующую таблицу включите как наименования дней недели (например, Monday), так и порядковый номер дня недели (от 1 до 7, где 1 — это Monday, 7 — это Sunday).  
Колонки с показателями назовите соответственно arpu, arppu, aov. Колонку с наименованием дня недели назовите weekday, а колонку с порядковым номером дня недели weekday_number.


*Дашборды представлены в .jpg файлах*

*В планах посчитать для этих данных retention*