--zadanie 1
USE lab1

with temp_table as (
SELECT od.order_id, sum(p.price) price_sum, o.date
	FROM [lab1].[dbo].[order_details] od
	join pizzas p on p.pizza_id=od.pizza_id
	join orders o on o.order_id=od.order_id
	where o.date='2015-02-18'
	group by od.order_id, o.date
)

	SELECT avg(price_sum) avg, date
	FROM temp_table
	GROUP BY date

--zadanie 2
--Pizzeria planuje wdro¿enie programu lojalnoœciowego dla klientów którzy nigdy nie zamówili 
--pizzy z ananasem w Marcu 2015. Proszê o stworzenie tabeli z id takich zamówieñ. (przydatna 
--funkcja string_agg)

with temp_table as (
SELECT od.order_id,o.date, string_agg(pd.ingredients,',') ingredients
	FROM [lab1].[dbo].[order_details] od
	join pizzas p on p.pizza_id=od.pizza_id
	join orders o on o.order_id=od.order_id
	join pizza_types pd on p.pizza_type_id=pd.pizza_type_id
	group by od.order_id, o.date
)

SELECT order_id FROM temp_table
WHERE (date like '2015-03-%' AND ingredients not like '%Pineapple%')

--zadanie 3
--Pizzeria planuje nagrodziæ klientów o najwy¿szych zamówieniach bonami kwotowymi. Proszê 
--przygotowaæ tabelê z id 10 najwiêkszych zamówieñ dla lutego wraz z ich kwot¹ przy u¿yciu 
--funkcji rank () over.

SELECT TOP 10 od.order_id, o.date, sum(p.price) total_price
FROM order_details od
join pizzas p on p.pizza_id=od.pizza_id
join orders o on o.order_id=od.order_id
where o.date like '%-02-%'
group by od.order_id, o.date
order by total_price desc



-- with rank() over
with temp_table as(
SELECT od.order_id, o.date, sum(p.price) as total_price , rank () over (order by sum(p.price) desc) as ranking
FROM order_details od
join pizzas p on p.pizza_id=od.pizza_id
join orders o on o.order_id=od.order_id
where o.date like '%-02-%'
group by od.order_id, o.date
)

select * from temp_table 
where ranking <=10



--zadanie 4
--stworzyæ tabelê która poka¿e kwotê ka¿dego zamówienia w jednej kolumnie wraz z id 
--zamówienia w drugiej, oraz œredniej kwocie zamówienia dla ka¿dego miesi¹ca

with temp_table as (
SELECT od.order_id, sum(p.price) as order_amount ,o.date, MONTH(o.date) month
FROM order_details od
join pizzas p on p.pizza_id=od.pizza_id
join orders o on o.order_id=od.order_id
group by od.order_id,o.date
),

average_per_month as (
SELECT avg(order_amount) as average_order_amount, month
FROM temp_table
GROUP BY month
)


SELECT order_id,order_amount, apm.average_order_amount,date
FROM temp_table 
JOIN average_per_month apm ON apm.month=temp_table.month


--zadanie 5
--tabela z list¹ pokazuj¹c¹ liczbê zamówieñ dla danej pe³nej godziny w 
--dniu 1 Stycznia 2015 tak jak poni¿ej (zaokr¹glenie do pe³nych godzin w dó³ tj. 11:59 -> 11)

with temp_table as (
SELECT od.order_id, o.date, o.time
FROM order_details od
join orders o on o.order_id=od.order_id 
WHERE date like '2015-01-01'
GROUP BY od.order_id,o.date,o.time
)

SELECT COUNT(order_id) order_count, date, DATEPART(hh, time) as hour
FROM temp_table
GROUP BY date,DATEPART(hh, time)
ORDER BY hour


--zadanie 6
--tabela z popularnoœci¹ danych rodzajów pizzy w miesi¹cu Styczniu 2015. Ma 
--ona pokazywaæ iloœæ sprzedanych rodzajów pizz bez rozró¿nienia na jej rozmiary. Tabela ma 
--zawieraæ nazwê ka¿dej pizzy oraz jej kategoriê.

with temp_table as(
select od.quantity ,pt.pizza_type_id,pt.name,pt.category,o.date
from order_details od
join pizzas p on p.pizza_id=od.pizza_id
join pizza_types pt on pt.pizza_type_id=p.pizza_type_id
join orders o on o.order_id=od.order_id
WHERE o.date like '%2015-01-%'
)

SELECT sum(quantity) as number_of_sold,name,category
FROM temp_table
GROUP BY name,category



--zadanie 7
--tabelê która obrazuje popularnoœæ ka¿dego rozmiaru pizzy w miesi¹cu 
--Lutym oraz Marcu 2015
CREATE VIEW temp_table AS
SELECT p.size,MONTH(date) as month
FROM  order_details od
JOIN pizzas p on p.pizza_id=od.pizza_id
JOIN pizza_types pt on pt.pizza_type_id =p.pizza_type_id
JOIN orders o on o.order_id=od.order_id
WHERE o.date like '%2015-02-%' or o.date like '%2015-03-%'


SELECT size, count(size) count
FROM temp_table
GROUP BY size

SELECT size, count(size) count, month
FROM temp_table
GROUP BY size,month
ORDER BY size 


