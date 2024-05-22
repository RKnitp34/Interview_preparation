create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000)



with cte as 
(
select e1.* , e2.max_salary , e2.min_salary from employee e1 
left join (
select dep_id , max(salary) max_salary , min(salary) min_salary from employee 
group by dep_id ) e2 on e1.dep_id = e2.dep_id ) 


select dep_id , 
max(case when salary=max_salary then emp_name end ) as emp_max_slry , 
max(case when salary=min_salary then emp_name end ) as emp_min_slry 
from cte group by dep_id 


create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00')
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;


select * from call_start_logs 
select * from call_end_logs 

select * from call_start_logs s 
union
call_end_logs e 

CREATE TABLE uber (
    user_id INT,
    spend DECIMAL(10, 2),
    transaction_date DATETIME
);

-- Insert the values
INSERT INTO uber (user_id, spend, transaction_date) VALUES
(111, 100.50, '2022-01-08 12:00:00'),
(111, 55.00, '2022-01-10 12:00:00'),
(121, 36.00, '2022-01-18 12:00:00'),
(145, 24.99, '2022-01-26 12:00:00'),
(111, 89.60, '2022-02-05 12:00:00');



with cte as (
select * , 
rank() over(partition by user_id order by transaction_date asc) as rn 

from uber 
where user_id in  (select user_id from uber group by user_id having(count(transaction_date) >=3) ) ) 
select user_id , spend , transaction_date from cte where rn = 3 

CREATE TABLE activity (
    activity_id INT,
    user_id INT,
    activity_type VARCHAR(50),
    time_spent DECIMAL(10, 2),
    activity_date DATETIME
);	
INSERT INTO activity (activity_id, user_id, activity_type, time_spent, activity_date) VALUES
(7274, 123, 'open', 4.50, '2022-06-22 12:00:00'),
(2425, 123, 'send', 3.50, '2022-06-22 12:00:00'),
(1413, 456, 'send', 5.67, '2022-06-23 12:00:00'),
(1414, 789, 'chat', 11.00, '2022-06-25 12:00:00'),
(2536, 456, 'open', 3.00, '2022-06-25 12:00:00');


CREATE TABLE age_breakdown (
    user_id INT,
    age_bucket VARCHAR(10)
);
INSERT INTO age_breakdown (user_id, age_bucket) VALUES
(123, '31-35'),
(456, '26-30'),
(789, '21-25');

select * from activity
select * from age_breakdown

with cte as (
select  a.activity_type , a.time_spent , ab.age_bucket 
from activity a 
left join
age_breakdown ab on a.user_id = ab.user_id 
where a.activity_type<>'chat' )

select age_bucket , sum(time_spent) as total_time from cte group by age_bucket


create table input (
id int,
formula varchar(10),
value int
)
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);


select * From input 



with t1 as (
select * , 
left(formula , 1) as first_digit , 
right(formula , 1) as second_digit , 
left(right (formula , 2 ) , 1)  as operator 
from input ) 
select t1.id , t1.value ,t1.formula , t1.second_digit , t1.operator , ip1.value as d1_value , ip2.value as d2_value , 
case when t1.operator = '+' then ip1.value + ip2.value else ip1.value -  ip2.value end   as new_value 

from t1 inner join input ip1 on 
t1.first_digit = ip1.id 
inner join input ip2 on 
t1.second_digit = ip2.id  

create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);
insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');

	select * , 
	CASE WHEN Criteria1='Y' AND Criteria2='Y' AND teamID in (select teamID from Ameriprise_LLC
	where Criteria1='Y' and Criteria2 = 'Y'
	group by teamID having (count(1)>=2)) then 'Y' else 'N' end as refrence 
	from Ameriprise_LLC

create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);

select a.person , c.person from 
	(select * , 
	right(person , 1) as a_id from family 
	where type = 'adult' )  as a 
	left join 
	(select * , 
	right(person , 1) as c_id from family 
	where type = 'child') as c 
on a.a_id= c.c_id 

select * from family 
selet * , 
rank() 


create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);


select * from stadium 
with cte as (
select * , 
row_number() over(order by id) as rn , 
id -  row_number() over(order by id) as cnt

from stadium where no_of_people >=100 ) 

SELECT id , visit_date , no_of_people FROM CTE WHERE CNT IN 
(select CNT from cte group by cnt having(count(1)>=3) )  order by visit_date



create table employee1 
(
emp_id int,
company varchar(10),
salary int
);

insert into employee1 values (1,'A',2341)
insert into employee1 values (2,'A',341)
insert into employee1 values (3,'A',15)
insert into employee1 values (4,'A',15314)
insert into employee1 values (5,'A',451)
insert into employee1 values (6,'A',513)
insert into employee1 values (7,'B',15)
insert into employee1 values (8,'B',13)
insert into employee1 values (9,'B',1154)
insert into employee1 values (10,'B',1345)
insert into employee1 values (11,'B',1221)
insert into employee1 values (12,'B',234)
insert into employee1 values (13,'C',2345)
insert into employee1 values (14,'C',2645)
insert into employee1 values (15,'C',2645)
insert into employee1 values (16,'C',2652)
insert into employee1 values (17,'C',65);

select * , 
row_number() over(partition by company order by salary asc) as idx

from employee1 
where company = 'A'
order by company , salary 


with cte as (
select a.emp_id , a.company , a.idx , a.salary , b.length from 
(select * , 
row_number() over(partition by company order by salary asc) as idx 
from employee1 
) a  

inner join 

(select company , count(1) as length
from employee1 
group by company ) b 
on a.company = b.company ) 
select * , 
case when length%2=0 then salary where idx =  

from cte 




select * from employee1 

select company , count(1) as length
from employee1 
group by company

create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');


select * , 
case when city ='Mumbai' then name end as mumbai , 
case when city ='Delhi' then name end as delhi , 
case when city  = 'banglore' then name end as banglore 
from players_location 

select city
SELECT
   *,
    COALESCE(CASE WHEN city = 'Mumbai' THEN name END, '') AS mumbai,
    COALESCE(CASE WHEN city = 'Delhi' THEN name END, '') AS delhi,
    COALESCE(CASE WHEN city = 'Bangalore' THEN name END, '') AS bangalore
FROM
    players_location;


create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

select * , 
rank() over(partition by username order by startDate desc) as rn from UserActivity 

select username , activity , count(activity)  from UserActivity
group by username , activity 

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * From icc_world_cup


select team , count(1) as match_played , sum(winner)  as no_of_matches_won from (
select Team_1 as team , 
case when team_1 = winner then 1 else 0 end winner   from icc_world_cup 
union all 
select Team_2 as team, 
case when team_2 = winner then 1 else 0 end winner from icc_world_cup  ) as team_played

group by team

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
select * from customer_orders
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;

select * from customer_orders


select * from trips 
select * from users 

with cte1 as (
select t.* , u1.banned as client_banned from trips t 
inner join users u1
on t.client_id = u1.users_id 
where u1.role = 'client'  )  

select cte1.* , u2.banned as driver_banned from cte1 
inner join users u2 
on cte1.driver_id = u2.users_id 
where u2.role = 'driver' 

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

with cte as (
select first_player as player_id , first_score as scores  from matches
union all 
select second_player , second_score  from matches ) 

 , final_ranking as (
select a.* , rank() over(partition by a.group_id order by a.scores desc , a.player_id asc) as rn from (
select cte.player_id , p.group_id , sum(cte.scores) scores  from cte inner join players p on cte.player_id = p.player_id
group by cte.player_id , p.group_id ) a) 

select * from final_ranking where rn = 1 


create table users1 (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users1 values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

 select * from users1
 select * from items 
 select * from orders 

 with rank_orders as (
 select o.* , rank() over(partition by seller_id order by order_date ) as rn from orders o ) 
 , final_table as (
 select ro.* , it.item_brand , u.favorite_brand from rank_orders ro 
 inner join items it on ro.item_id = it.item_id 
 inner join users1 u on ro.seller_id  = u.user_id 
 where ro.rn =2 ) 


 --write this in above query itself and use the users as left join and filter rn above while joining only 
 select order_id , 
 case when item_brand = favorite_brand then 'yes' else 'no' end as response
 from final_table 

 create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success')

with cte as (
select * , rank() over(partition by state order by date_value) as rn , ROW_NUMBER() over(order by date_value ) as row from tasks )
select min(date_value) as start_date , max(date_value) as end_date , state  from cte group by (rn-row) , state
order by min(date_value)

select * from tasks 

#SQL 10 complex interview question 

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);


/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
*/

select   * From spending 



-- SQL 12 lecture
create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

select * From sales 


with r_cte as ( 
select min(period_start) dates , max(period_end) as max_date from sales --anchor query 
union all 
select dateadd(day , 1, dates) as dates , max_date from r_cte 
where dates < max_date ) 


select product_id , year(dates) as year , sum(average_daily_sales) as total_amount from r_cte innner join sales on dates between period_start and period_end 
group by product_id , year(dates)

option (maxrecursion 1000)  ; --defalut it 100 


-- SQL 13 lectures	
create table orders1
(
order_id int,
customer_id int,
product_id int
);

insert into orders1 VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from orders1 
select * from products

with cte as (
select * from orders1 o1 
inner join products p 
on o1.product_id = p.id ) 

select  CONCAT(c1.name, ' ', c2.name) AS pair , count(1)
from cte c1 inner join 
cte c2 on c1.order_id = c2.order_id
where c1.product_id < c2.product_id 
group by CONCAT(c1.name, ' ', c2.name)
Given the following two tables, return the fraction of users, rounded to two decimal places,
who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up. 


-- SQL 14 lectures

create table users2
(
user_id integer,
name varchar(20),
join_date date
);
insert into users2
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));


select * from users2 
select * from events 

-- Query to find users who joine prime after having access of music less than 30 days of signing in.
with t as (
select u.user_id , u.join_date ,u.name, e.access_date  , datediff(day , u.join_date ,e.access_date ) as days_diff ,
case when e.type='P' then datediff(day , u.join_date ,e.access_date ) end as prime , 
case when e.type='Music' then datediff(day , u.join_date ,e.access_date ) end as music 
from users2 u
inner join events e on u.user_id = e.user_id 
where e.type in ('P','Music'))


--select * from t
, t2 as (
select user_id , name , sum(prime) prime_day , sum(music) music_day , count(distinct user_id) as total_users from t 
group by user_id , name having sum(music) is not null ) 

select * , sum(total_users) from t2 
--having sum(prime)<=31 and sum(music) is not null

--Leetcode questions
CREATE TABLE employee2 (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    managerId INT,
    FOREIGN KEY (managerId) REFERENCES employee2(id)
);

INSERT INTO employee2 (id, name, department, managerId) VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101),
(107, 'Tom', 'A', 102),
(108, 'Tommy', 'A', 102),
(109, 'Peter', 'C', 102),
(110, 'Dong', 'A', 102),
(111, 'DIDI', 'D', 102);


select * from employee2 

select name from employee2 where id in 
(select managerId from employee2 
group by managerId having count(distinct name)>=5)

CREATE TABLE transactions (
    id INT PRIMARY KEY,
    country VARCHAR(2),
    state VARCHAR(10),
    amount INT,
    trans_date DATE
);

-- Insert data into the table
INSERT INTO transactions (id, country, state, amount, trans_date)
VALUES
    (121, 'US', 'approved', 1000, '2018-12-18'),
    (122, 'US', 'declined', 2000, '2018-12-19'),
    (123, 'US', 'approved', 2000, '2019-01-01'),
    (124, 'DE', 'approved', 2000, '2019-01-07');


DATE_FORMAT(trans_date, '%Y-%m') AS month,





--Lectures 50

Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
)

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20)
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15)
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30)
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32)
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19)
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19)

select t1.Trade_ID , t2.TRADE_ID , t1.Trade_Timestamp , t2.Trade_Timestamp , t1.Price , t2.Price , abs(t1.Price - t2.Price)/t1.Price*100 as pct 
from Trade_tbl t1
inner join Trade_tbl t2 on 1=1
where t1.Trade_ID!=t2.TRADE_ID and t1.Trade_Timestamp<t2.Trade_Timestamp and DATEDIFF(second , t1.Trade_Timestamp , t2.Trade_Timestamp) < 10 and 
abs((t1.Price - t2.Price)/t1.Price*100)> 10 
order by t1.Trade_ID



--Lectures 53 
create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
delete from hall_events
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');

select * from hall_events
