-- Activity1
create database sdet4_preethy;
use  sdet4_preethy;

Describe salesman;

-- Activity2
CREATE TABLE salesman (
    salesman_id int primary key,
    name varchar(32),
    city varchar(32),
    commission int
);

desc salesman;
INSERT INTO salesman VALUES(5001, 'James Hoog', 'New York', 15);
INSERT INTO salesman VALUES
    (5002, 'Nail Knite', 'Paris', 13),
    (5005, 'Pit Alex', 'London', 11), 
    (5006, 'McLyon', 'Paris', 14), 
    (5007, 'Paul Adam', 'Rome', 13),
    (5003, 'Lauson Hen', 'San Jose', 12);
    
    select * from salesman;
    
    -- Activity3
    select salesman_id,city from salesman;
    select * from salesman where city='Rome';
    select salesman_id, commission from salesman where upper(name)='PAUL ADAM';
  
  -- Activity4
  ALTER TABLE salesman ADD grade int;
    update salesman set grade=100;
   
   -- Activity6
   create table orders(
    order_no int primary key, purchase_amount float, order_date date,
    customer_id int, salesman_id int);
    insert into orders values
(70001, 150.5, '2012-10-05', 3005, 5002), (70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001), (70004, 110.5, '2012-08-17', 3009, 5003),
(70007, 948.5, '2012-09-10', 3005, 5002), (70005, 2400.6, '2012-07-27', 3007, 5001),
(70008, 5760, '2012-08-15', 3002, 5001), (70010, 1983.43, '2012-10-10', 3004, 5006),
(70003, 2480.4, '2012-10-10', 3009, 5003), (70012, 250.45, '2012-06-27', 3008, 5002),
(70011, 75.29, '2012-08-17', 3003, 5007), (70013, 3045.6, '2012-04-25', 3002, 5001);
  
  -- Activity5
  update salesman set grade=200 where city='Rome';
  
  update salesman set grade=300 where name='James Hoog';
  
  update salesman set name='Pierre' where name='McLyon';
 
 -- Activity 6
 select * from orders;

select distinct salesman_id from orders;

select order_no,order_date from orders order by order_date;

select order_no,purchase_amount from orders order by purchase_amount desc;

select * from orders where purchase_amount < 500;

select * from orders where purchase_amount between 1000 and 2000;

-- Activity7
select sum(purchase_amount) as "TOTAL" from orders;

select avg(purchase_amount) as "AVG" from orders;

select max(purchase_amount)  from orders;

select min(purchase_amount)  from orders;

select count(distinct salesman_id) from orders;

-- Activity8
select customer_id, max(purchase_amount) AS "MAX AMOUNT" from orders ORDER BY GROUP_ID;

SELECT salesman_id, order_date, MAX(purchase_amount) AS "Max Amount" FROM orders 
WHERE order_date='2012-08-17' GROUP BY salesman_id, order_date;

SELECT customer_id, order_date, MAX(purchase_amount) AS "Max Amount" FROM orders
GROUP BY customer_id, order_date
HAVING MAX(purchase_amount) IN(2030, 3450, 5760, 6000);


-- Activity 9

create table customers (
    customer_id int primary key, customer_name varchar(32),
    city varchar(20), grade int, salesman_id int);
    
    insert into customers values 
(3002, 'Nick Rimando', 'New York', 100, 5001), (3007, 'Brad Davis', 'New York', 200, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002), (3008, 'Julian Green', 'London', 300, 5002),
(3004, 'Fabian Johnson', 'Paris', 300, 5006), (3009, 'Geoff Cameron', 'Berlin', 100, 5003),
(3003, 'Jozy Altidor', 'Moscow', 200, 5007), (3001, 'Brad Guzan', 'London', 300, 5005);

select * from customers;

select * from salesman;

select a.customer_name, a.city, a.grade, b.salesman_id, b.name as "SALESMAN_NAME"
from customers a
inner join salesman b ON a.salesman_id=b.salesman_id;

select a.customer_name, a.city, a.grade, b.salesman_id, b.name as "SALESMAN_NAME"
from customers a
left join salesman b ON a.salesman_id=b.salesman_id where a.grade<300
order by a.customer_id;

select a.customer_name, a.city, a.grade, b.salesman_id, b.name as "SALESMAN_NAME", b.commission from customers a
inner join salesman b ON a.salesman_id=b.salesman_id where b.commission>12;

select a.order_no, a.purchase_amount, b.customer_name AS "Customer Name", b.grade, c.name AS "Salesman", c.commission FROM orders a
INNER JOIN customers b ON a.customer_id=b.customer_id 
INNER JOIN salesman c ON a.salesman_id=c.salesman_id;

-- Activity10
select * from orders where salesman_id=(select distinct salesman_id from customers where customer_id=3007); 

select * from orders where salesman_id=(select  salesman_id from salesman where city='New York');

select  salesman_id from salesman where city='New York';

SELECT grade, COUNT(*) FROM customers
GROUP BY grade having grade>(SELECT AVG(grade) FROM customers WHERE city='New York'); 

SELECT order_no, purchase_amount, order_date, salesman_id FROM orders
WHERE salesman_id IN( SELECT salesman_id FROM salesman
WHERE commission=( SELECT MAX(commission) FROM salesman));

-- Activity 11
-- Write a query that produces the name and number of each salesman and each customer with more than one current order. Put the results in alphabetical order
SELECT customer_id, customer_name FROM customers a
WHERE 1<(SELECT COUNT(*) FROM orders b WHERE a.customer_id = b.customer_id)
UNION
SELECT salesman_id, name FROM salesman a
WHERE 1<(SELECT COUNT(*) FROM orders b WHERE a.salesman_id = b.salesman_id)
ORDER BY customer_name;

-- Write a query to make a report of which salesman produce the largest and smallest orders on each date.
SELECT a.salesman_id, name, order_no, 'highest on', order_date FROM salesman a, orders b
WHERE a.salesman_id=b.salesman_id
AND b.purchase_amount=(SELECT MAX(purchase_amount) FROM orders c WHERE c.order_date = b.order_date)
UNION
SELECT a.salesman_id, name, order_no, 'lowest on', order_date FROM salesman a, orders b
WHERE a.salesman_id=b.salesman_id
AND b.purchase_amount=(SELECT MIN(purchase_amount) FROM orders c WHERE c.order_date = b.order_date);