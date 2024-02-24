--TASK 1
/*Для каждого дня в таблице orders рассчитайте следующие показатели:

Выручку, полученную в этот день.
Суммарную выручку на текущий день.
Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.*/

select date,
revenue,
total_revenue,
round(100.0*(last_value(revenue) over(order by date rows between 1 preceding and current row) - first_value(revenue) over(order by date rows between 1 preceding and current row)) / (first_value(revenue) over(order by date rows between 1 preceding and current row)), 2) as revenue_change
from
(select date,
revenue,
sum(revenue) over(order by date rows between unbounded preceding and current row) as total_revenue
from (
select date,
sum(price) as revenue
from
(select order_id,
creation_time::date as date,
unnest(product_ids) as product
from orders) as tmp
inner join products on tmp.product = products.product_id
where order_id not in (select order_id from user_actions where action = 'cancel_order')
group by date ) as tmp1 ) as tmp2
order by date 


--TASK 2
/*Для каждого дня в таблицах orders и user_actions рассчитайте следующие показатели:

Выручку на пользователя (ARPU) за текущий день.
Выручку на платящего пользователя (ARPPU) за текущий день.
Выручку с заказа, или средний чек (AOV) за текущий день.*/

select
  tmp2.date,
  revenue :: decimal / users as arpu,
  revenue :: decimal / u as arppu,
  revenue :: decimal / orders as aov
from
  (
    select
      date,
      sum(price) as revenue
    from
      (
        select
          order_id,
          creation_time :: date as date,
          unnest(product_ids) as product
        from
          orders
        where
          order_id not in (
            select
              order_id
            from
              user_actions
            where
              action = 'cancel_order'
          )
      ) as tmp
      inner join products on products.product_id = tmp.product
    group by
      date
  ) as tmp1
  inner join (
    select
      time :: date as date,
      count(distinct user_id) as users
    from
      user_actions
    group by
      date
  ) as tmp2 on tmp1.date = tmp2.date
  inner join (
    select
      count(distinct user_id) as u,
      time :: date as date
    from
      user_actions
    where
      order_id not in (
        select
          order_id
        from
          user_actions
        where
          user_actions.action = 'cancel_order'
      )
    group by
      time :: date
  ) as tmp3 on tmp2.date = tmp3.date
  inner join (
    select
      time :: date as date,
      count(distinct order_id) as orders
    from
      user_actions
    where
      order_id not in (
        select
          order_id
        from
          user_actions
        where
          action = 'cancel_order'
      )
    group by
      time :: date
  ) as tmp4 on tmp3.date = tmp4.date
order by tmp2.date



--TASK 2
/*По таблицам orders и user_actions для каждого дня рассчитайте следующие показатели:

Накопленную выручку на пользователя (Running ARPU).
Накопленную выручку на платящего пользователя (Running ARPPU).
Накопленную выручку с заказа, или средний чек (Running AOV).*/

select temp1.date,
sum_revenue/sum_users as arpu,
sum_revenue/sum_u as arppu,
sum_revenue/sum_orders as aov
--select temp1.date,
--sum_revenue, sum_users, sum_u, sum_orders
from
(select date,
sum(revenue) over(order by date rows between unbounded preceding and current row) as sum_revenue
from
(select date,
sum(price) as revenue
from
(select order_id,
creation_time::date as date,
unnest(product_ids) as product
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')) as tmp
inner join products on products.product_id = tmp.product
group by date
order by date) as tmp1) as temp1
inner join 
(select date,
sum(users) over(order by date rows between unbounded preceding and current row) as sum_users
from
(   select time:: date as date, count(distinct user_id) as users
    from
    user_actions
    group by date
    order by date) as tmp2) as temp2
on temp1.date = temp2.date
inner join
(select date,
sum(u) over(order by date rows between unbounded preceding and current row) as sum_u
from
(select count(distinct user_id) as u,
time::date as date
from
user_actions
where order_id not in (select order_id
from user_actions
where user_actions.action = 'cancel_order')
group by time::date
order by date) as tmp3) as temp3
on temp2.date = temp3.date
inner join 
(select date,
sum(orders) over(order by date rows between unbounded preceding and current row) as sum_orders
from
(select time::date as date,
count(distinct order_id) as orders
from user_actions
where order_id not in (select order_id
from user_actions
where action = 'cancel_order')
group by time::date ) as tmp4) as temp4
on temp3.date = temp4.date 


--TASK 3
/*По таблицам orders и user_actions для каждого дня рассчитайте следующие показатели:

Накопленную выручку на пользователя (Running ARPU).
Накопленную выручку на платящего пользователя (Running ARPPU).
Накопленную выручку с заказа, или средний чек (Running AOV).*/

select temp1.date,
sum_revenue/sum_users as arpu,
sum_revenue/sum_u as arppu,
sum_revenue/sum_orders as aov
--select temp1.date,
--sum_revenue, sum_users, sum_u, sum_orders
from
(select date,
sum(revenue) over(order by date rows between unbounded preceding and current row) as sum_revenue
from
(select date,
sum(price) as revenue
from
(select order_id,
creation_time::date as date,
unnest(product_ids) as product
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')) as tmp
inner join products on products.product_id = tmp.product
group by date
order by date) as tmp1) as temp1
inner join 
(select date,
sum(users) over(order by date rows between unbounded preceding and current row) as sum_users
from
(   select time:: date as date, count(distinct user_id) as users
    from
    user_actions
    group by date
    order by date) as tmp2) as temp2
on temp1.date = temp2.date
inner join
(select date,
sum(u) over(order by date rows between unbounded preceding and current row) as sum_u
from
(select count(distinct user_id) as u,
time::date as date
from
user_actions
where order_id not in (select order_id
from user_actions
where user_actions.action = 'cancel_order')
group by time::date
order by date) as tmp3) as temp3
on temp2.date = temp3.date
inner join 
(select date,
sum(orders) over(order by date rows between unbounded preceding and current row) as sum_orders
from
(select time::date as date,
count(distinct order_id) as orders
from user_actions
where order_id not in (select order_id
from user_actions
where action = 'cancel_order')
group by time::date ) as tmp4) as temp4
on temp3.date = temp4.date 


--TASK 4
/*Для каждого дня недели в таблицах orders и user_actions рассчитайте следующие показатели:

Выручку на пользователя (ARPU).
Выручку на платящего пользователя (ARPPU).
Выручку на заказ (AOV).*/

select weekday,
weekday_number,
revenue::decimal/ users as arpu,
revenue::decimal/ u as arppu,
revenue::decimal/ orders as aov
from
(select to_char(tmp2.date, 'Day') as weekday, 
date_part('isodow', tmp2.date) as weekday_number,
sum(revenue) as revenue,
sum(u) as u,
sum(users) as users,
sum(orders) as orders
/*revenue::decimal/ users as arpu,
revenue::decimal/ u as arppu,
revenue::decimal/ orders as aov*/
from
(select date,
sum(price) as revenue
from
(select order_id,
creation_time::date as date,
unnest(product_ids) as product
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')) as tmp
inner join products on products.product_id = tmp.product
group by date) as tmp1
inner join 
(    select time:: date as date, count(distinct user_id) as users
    from
    user_actions
    group by date) as tmp2
on tmp1.date = tmp2.date
inner join
(select count(distinct user_id) as u,
time::date as date
from
user_actions
where order_id not in (select order_id
from user_actions
where user_actions.action = 'cancel_order')
group by time::date) as tmp3
on tmp2.date = tmp3.date
inner join 
(select time::date as date,
count(distinct order_id) as orders
from user_actions
where order_id not in (select order_id
from user_actions
where action = 'cancel_order')
group by time::date ) as tmp4
on tmp3.date = tmp4.date
where tmp2.date between '2022-08-26' and '2022-09-08'
group by weekday, weekday_number) as temp
order by weekday_number
