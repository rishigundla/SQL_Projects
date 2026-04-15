
--------------------------------------------DAY 1--------------------------------------------------
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

select * from icc_world_cup;

-- SOLUTION 1

WITH cte AS (
    SELECT 
        *,
        CASE 
            WHEN Team_1 = Winner THEN Team_2
            ELSE Team_1
        END AS loser 
    FROM icc_world_cup
),
cte2 AS (
    SELECT team_1, 
        COUNT(CASE WHEN team_1 = winner THEN 1 END) AS wins,
        COUNT(CASE WHEN team_1 = loser THEN 1 END) AS losses
        FROM cte
        GROUP BY team_1
    UNION ALL
    SELECT team_2, 
        COUNT(CASE WHEN team_2 = winner THEN 1 END) AS wins,
        COUNT(CASE WHEN team_2 = loser THEN 1 END) AS losses
        FROM cte
        GROUP BY team_2
)
SELECT 
    team_1 AS team,
    COUNT(*) AS total_matches,
    SUM(wins) AS total_wins,
    SUM(losses) AS total_losses
FROM cte2
GROUP BY team_1;


--------------------------------------------DAY 2--------------------------------------------------

create table emp(emp_id int,emp_name varchar(10),salary int ,manager_id int);

insert into emp values(1,'Ankit',10000,4);
insert into emp values(2,'Mohit',15000,5);
insert into emp values(3,'Vikas',10000,4);
insert into emp values(4,'Rohit',5000,2);
insert into emp values(5,'Mudit',12000,6);
insert into emp values(6,'Agam',12000,2);
insert into emp values(7,'Sanjay',9000,2);
insert into emp values(8,'Ashish',5000,2);

select * from emp;


-- SOLUTION 2


SELECT 
    e.*,
    m.emp_name AS manager_name,
    m.salary AS manager_salary
FROM emp e
JOIN emp m 
ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;





--------------------------------------------DAY 3-------------------------------------------------


create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);

insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);


select * from customer_orders;


-- SOLUTION 3

WITH cte AS (
SELECT 
    customer_id,
    MIN(order_date) AS first_order_date
FROM customer_orders
GROUP BY customer_id),
cte2 AS (
SELECT 
    *,
    CASE WHEN order_date = first_order_date THEN 'New Customer' ELSE 'Repeat Customer' END AS customer_type
FROM customer_orders co
JOIN cte
ON co.customer_id = cte.customer_id)
SELECT 
    order_date,
    COUNT(CASE WHEN customer_type = 'New Customer' THEN 1 END) AS new_customers,
    COUNT(CASE WHEN customer_type = 'Repeat Customer' THEN 1 END) AS repeat_customers
FROM cte2
GROUP BY order_date
ORDER BY order_date;


--------------------------------------------DAY 4-------------------------------------------------

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR');

select * from entries;

-- SOLUTION 4
WITH cte AS (
        SELECT 
            name,
            floor,
            COUNT(*) AS most_visited_floor,
            ROW_NUMBER() OVER (PARTITION BY name ORDER BY COUNT(*) DESC) AS rn
        FROM entries
        GROUP BY name, floor
        ORDER BY name, most_visited_floor DESC),
cte2 AS (
        SELECT 
            name,
            floor AS most_visited_floor
        FROM cte
        WHERE rn = 1),
cte3 AS (
        SELECT 
            name,
            COUNT(*) AS total_visits,
            STRING_AGG(DISTINCT resources, ',') AS resources_used
        FROM entries
        GROUP BY name
        ORDER BY name)
SELECT 
    cte2.name,
    cte3.total_visits,
    cte2.most_visited_floor,
    cte3.resources_used
FROM cte2
JOIN cte3
ON cte2.name = cte3.name
ORDER BY cte2.name;

--------------------------------------------DAY 5-------------------------------------------------

create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);

insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);

select * from emp_compensation;


-- SOLUTION 5
SELECT emp_id,
    MAX(CASE WHEN salary_component_type = 'salary' THEN val END) AS salary,
    MAX(CASE WHEN salary_component_type = 'bonus' THEN val END) AS bonus,
    MAX(CASE WHEN salary_component_type = 'hike_percent' THEN val END) AS hike_percent
FROM emp_compensation
GROUP BY emp_id;



--------------------------------------------DAY 6-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.


--------------------------------------------DAY 7-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 8-------------------------------------------------

Create table friend (pid int, fid int);
insert into friend (pid , fid ) values ('1','2');
insert into friend (pid , fid ) values ('1','3');
insert into friend (pid , fid ) values ('2','1');
insert into friend (pid , fid ) values ('2','3');
insert into friend (pid , fid ) values ('3','5');
insert into friend (pid , fid ) values ('4','2');
insert into friend (pid , fid ) values ('4','3');
insert into friend (pid , fid ) values ('4','5');

create table person (PersonID int,	Name varchar(50),	Score int);
insert into person(PersonID,Name ,Score) values('1','Alice','88');
insert into person(PersonID,Name ,Score) values('2','Bob','11');
insert into person(PersonID,Name ,Score) values('3','Devis','27');
insert into person(PersonID,Name ,Score) values('4','Tara','45');
insert into person(PersonID,Name ,Score) values('5','John','63');

select * from person;
select * from friend;

-- SOLUTION 6

WITH demo AS (
            SELECT 
                pid AS person_id,
                COUNT(fid) AS total_friends,
                SUM(p.Score) AS total_score_of_friends
            FROM friend f
            JOIN person p ON f.fid = p.PersonID
            GROUP BY pid
            ORDER BY pid)
SELECT 
    d.person_id,
    p.name AS person_name,
    d.total_friends,
    d.total_score_of_friends
FROM demo d
JOIN person p ON d.person_id = p.PersonID
WHERE d.total_score_of_friends > 100
ORDER BY d.person_id;

--------------------------------------------DAY 9-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 10-------------------------------------------------
Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));

Create table Users (users_id int, banned varchar(50), role varchar(50));

insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');


insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

SELECT * FROM trips;
SELECT * FROM users;

-- SOLUTION 10

WITH demo AS (
            SELECT 
                t.*,
                u.banned AS client_banned_status,
                u2.banned AS driver_banned_status
            FROM trips t
            JOIN users u ON t.client_id = u.users_id
            JOIN users u2 ON t.driver_id = u2.users_id
            WHERE u.banned = 'No' AND u2.banned = 'No')
SELECT 
    request_at AS ride_date,
    COUNT(CASE WHEN status IN('cancelled_by_driver', 'cancelled_by_client') THEN 1 END) AS cancelled_rides,
    COUNT(1) AS total_rides,
    ROUND( (COUNT(CASE WHEN status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1 END)::DECIMAL / COUNT(1)) * 100, 2 ) AS cancellation_percentage
FROM demo
GROUP BY request_at
ORDER BY request_at;


--------------------------------------------DAY 11-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 12-------------------------------------------------

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

select * from players;
select * from matches;


-- SOLUTION 12

WITH cte AS (
            SELECT 
                first_player AS player_id,
                first_score AS score
            FROM matches
            UNION ALL
            SELECT 
                second_player AS player_id,
                second_score AS score
            FROM matches),
players_scores AS (
            SELECT 
                player_id,
                SUM(score) AS total_score 
                FROM cte
            GROUP BY player_id
            ORDER BY player_id),
players_ranking AS (
            SELECT 
                p.group_id,
                p.player_id,
                ps.total_score,
                ROW_NUMBER() OVER (PARTITION BY p.group_id ORDER BY ps.total_score DESC) AS rank_in_group
            FROM players_scores ps
            JOIN players p ON ps.player_id = p.player_id)
SELECT 
    group_id,
    player_id AS winner_player_id,
    total_score
FROM players_ranking
WHERE rank_in_group = 1


--------------------------------------------DAY 13-------------------------------------------------


create table market_users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table market_orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table market_items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into market_users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into market_items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into market_orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);

select * from market_users;
select * from market_items; 
select * from market_orders;


-- SOLUTION 13

WITH cte AS (
            SELECT
                mu.user_id AS seller_id,
                mo.order_date,
                mi.item_brand AS sold_brand,
                mu.favorite_brand AS seller_favorite_brand,
                ROW_NUMBER() OVER (PARTITION BY mo.seller_id ORDER BY mo.order_date) AS order_sequence
            FROM market_users mu
            LEFT JOIN market_orders mo ON mu.user_id = mo.seller_id
            LEFT JOIN market_items mi ON mo.item_id = mi.item_id
            ORDER BY mu.user_id, mo.order_id)
SELECT 
    seller_id,
    CASE 
        WHEN sold_brand IS NULL THEN 'No'
        WHEN sold_brand = seller_favorite_brand THEN 'Yes'
        ELSE 'No'
    END AS sold_favorite_brand_in_second_order
FROM cte
WHERE order_sequence = 2 OR (order_sequence = 1 AND sold_brand IS NULL);



--------------------------------------------DAY 14-------------------------------------------------

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);

SELECT * FROM spending;

-- SOLUTION 14

WITH cte AS (
    SELECT
        user_id,
        spend_date,
        ARRAY_AGG(platform) AS platforms_used,
        SUM(amount) AS total_amount_spent
    FROM spending
    GROUP BY user_id, spend_date
)
SELECT 
    spend_date,
    CASE 
        WHEN 'mobile' = ANY(platforms_used) AND 'desktop' = ANY(platforms_used) THEN 'Both'
        WHEN 'mobile' = ANY(platforms_used) THEN 'Mobile Only'
        WHEN 'desktop' = ANY(platforms_used) THEN 'Desktop Only'
        ELSE 'None' 
    END AS platform_usage,
    SUM(total_amount_spent) AS total_amount_spent,
    COUNT(*) AS user_count
FROM cte
GROUP BY spend_date, platform_usage
ORDER BY spend_date, platform_usage;


--------------------------------------------DAY 15-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 16-------------------------------------------------

create table amazon_users
(
user_id integer,
name varchar(20),
join_date date
);
insert into amazon_users
values (1, 'Jon', CAST('2020-02-14' AS date)), 
(2, 'Jane', CAST('2020-02-14' AS date)), 
(3, 'Jill', CAST('2020-02-15' AS date)), 
(4, 'Josh', CAST('2020-02-15' AS date)), 
(5, 'Jean', CAST('2020-02-16' AS date)), 
(6, 'Justin', CAST('2020-02-17' AS date)),
(7, 'Jeremy', CAST('2020-02-18' AS date));

create table amazon_events
(
user_id integer,
type varchar(10),
access_date date
);

insert into amazon_events values
(1, 'Pay', CAST('2020-03-01' AS date)), 
(2, 'Music', CAST('2020-03-02' AS date)), 
(2, 'P', CAST('2020-03-12' AS date)),
(3, 'Music', CAST('2020-03-15' AS date)), 
(4, 'Music', CAST('2020-03-15' AS date)), 
(1, 'P', CAST('2020-03-16' AS date)), 
(3, 'P', CAST('2020-03-22' AS date));

SELECT * FROM amazon_users;
SELECT * FROM amazon_events;


-- SOLUTION 16
WITH cte1 AS (
            SELECT 
                au.user_id AS music_user_id,
                au.join_date,
                ae.type AS music_event_type,
                ae.access_date
            FROM amazon_users au
            LEFT JOIN amazon_events ae 
                ON au.user_id = ae.user_id
            WHERE ae."type" = 'Music'
            ORDER BY au.user_id, ae.access_date),
cte2 AS (
        SELECT 
            au.user_id AS p_user_id,
            au.join_date,
            ae.type AS p_event_type,
            ae.access_date
        FROM amazon_users au
        LEFT JOIN amazon_events ae 
            ON au.user_id = ae.user_id
        WHERE ae."type" = 'P'
        ORDER BY au.user_id, ae.access_date),
cte3 AS (
        SELECT
            *,
            cte2.access_date - cte1.join_date AS days_between_p_and_join
        FROM cte1
        LEFT JOIN cte2 
            ON cte1.music_user_id = cte2.p_user_id)
SELECT 
    COUNT(DISTINCT music_user_id) AS total_music_users,
    COUNT(DISTINCT CASE WHEN days_between_p_and_join < 30 THEN p_user_id END) AS total_p_users,
    ROUND( (COUNT(DISTINCT CASE WHEN days_between_p_and_join < 30 THEN p_user_id END)::DECIMAL / COUNT(DISTINCT music_user_id)) * 100, 2 ) AS conversion_rate
FROM cte3;



--------------------------------------------DAY 17-------------------------------------------------
create table orders
(
order_id int,
customer_id int,
product_id int
);

insert into orders VALUES 
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


SELECT * FROM orders;
SELECT * FROM products;


-- SOLUTION 17

WITH cte1 AS (
            SELECT 
                o1.product_id AS p1,
                o2.product_id AS p2,
                COUNT(*) AS frequency
            FROM orders o1
            JOIN orders o2
                ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
            GROUP BY o1.product_id, o2.product_id
            ORDER BY frequency DESC)
SELECT 
    CONCAT_WS(' ', p1.name, '&', p2.name) AS product_pair,
    cte1.frequency
FROM cte1
JOIN products p1 ON cte1.p1 = p1.id
JOIN products p2 ON cte1.p2 = p2.id;


--------------------------------------------DAY 18-------------------------------------------------


create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150);

SELECT * FROM transactions;


-- SOLUTION 18

WITH demo AS (
            SELECT 
                *,
                LAG(order_date) OVER (PARTITION BY cust_id ORDER BY order_date) AS previous_order_date
            FROM transactions)
,demo2 AS (
            SELECT 
                *,
                EXTRACT(MONTH FROM order_date) AS order_month,
                CASE WHEN EXTRACT(MONTH FROM order_date) - EXTRACT(MONTH FROM previous_order_date) <= 1 THEN 'Yes' ELSE 'No' END AS is_returning_customer
            FROM demo)
SELECT 
    order_month,
    COUNT(CASE WHEN is_returning_customer = 'Yes' THEN 1 END) AS returning_customers,
    COUNT(CASE WHEN is_returning_customer = 'No' THEN 1 END) AS new_customers,
    COUNT(*) AS total_customers

FROM demo2
GROUP BY order_month;


--------------------------------------------DAY 19-------------------------------------------------



-- SOLUTION 19

WITH demo1 AS (
                SELECT
                        *,
                        LEAD(order_date) OVER (PARTITION BY cust_id ORDER BY order_date) AS next_order_date
                FROM transactions),
                demo2 AS (
                SELECT 
                        *,
                        EXTRACT(MONTH FROM order_date) AS order_month,
                        CASE WHEN EXTRACT(MONTH FROM next_order_date) - EXTRACT(MONTH FROM order_date) <= 1 THEN 'No' ELSE 'Yes' END AS is_churned 
                FROM demo1)
SELECT 
    order_month,
    COUNT(CASE WHEN is_churned = 'Yes' THEN 1 END) AS churned_customers
FROM demo2
GROUP BY order_month;



--------------------------------------------DAY 20-------------------------------------------------

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

SELECT * FROM UserActivity;

-- SOLUTION 20

WITH demo AS (
            SELECT 
                *,
                COUNT(activity) OVER (PARTITION BY username) AS activity_count,
                RANK() OVER (PARTITION BY username ORDER BY startDate) AS activity_rank
            FROM useractivity)
SELECT 
    *
FROM demo
WHERE activity_count = 1 OR activity_rank = 2;



--------------------------------------------DAY 21-------------------------------------------------
create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4);

SELECT * FROM billings;
SELECT * FROM HoursWorked;



-- SOLUTION 21


WITH cte1 AS (
            SELECT 
                *, 
                LEAD(bill_date-1,1,'9999-12-31') OVER (PARTITION BY emp_name ORDER BY bill_date) AS next_bill_date
            FROM billings)
SELECT 
    c.emp_name,
    SUM(hw.bill_hrs * c.bill_rate) AS total_billing_amount
FROM cte1 c
JOIN hoursworked hw ON c.emp_name = hw.emp_name
WHERE hw.work_date BETWEEN c.bill_date AND c.next_bill_date
GROUP BY c.emp_name;


--------------------------------------------DAY 22-------------------------------------------------

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');


-- SOLUTION 22

SELECT * FROM activity;

-- Calculate the total number of active users for each day day.
SELECT 
    event_date,
    COUNT(DISTINCT user_id) AS total_active_users
FROM activity
GROUP BY event_date
ORDER BY event_date;


-- Calculate the total number of active users each week.
SELECT 
    DATE_TRUNC('week', event_date)::DATE AS week_start,
    COUNT(DISTINCT user_id) AS total_active_users
FROM activity
GROUP BY DATE_TRUNC('week', event_date)
ORDER BY week_start;



-- Calculate total users who made a purchase on the same day as installation.
WITH cte AS (
SELECT 
    *,
    LEAD(event_date) OVER (PARTITION BY user_id ORDER BY event_date) AS app_purchase_date
FROM activity)
SELECT 
    event_date,
    COUNT(DISTINCT CASE WHEN event_date = app_purchase_date THEN user_id END) AS users_who_made_purchase_on_same_day_as_installation
FROM cte
GROUP BY event_date
ORDER BY event_date;



-- Calculate the purchase rate for each country.
WITH cte AS (
            SELECT 
                CASE WHEN country = 'India' THEN 'India'
                    WHEN country = 'USA' THEN 'USA'
                    ELSE 'Other Countries' END AS country_group,
                COUNT(DISTINCT CASE WHEN event_name = 'app-purchase' THEN user_id END) AS total_purchase_users,
                (SELECT COUNT(DISTINCT CASE WHEN event_name = 'app-purchase' THEN user_id END) FROM activity) AS total_active_users
            FROM activity
            GROUP BY country_group)
SELECT 
    country_group,
    ROUND( (total_purchase_users::DECIMAL / total_active_users) * 100, 2) AS purchase_rate
FROM cte;



-- Calculate the total number of users who made a purchase one day after installation.
WITH cte AS (
SELECT 
    *,
    LEAD(event_date) OVER (PARTITION BY user_id ORDER BY event_date) AS app_purchase_date
FROM activity)
SELECT 
    event_date,
    COUNT(DISTINCT CASE WHEN (app_purchase_date - event_date) = 1 THEN user_id END) AS users_who_made_purchase_one_day_after_installation
FROM cte
GROUP BY event_date;


--------------------------------------------DAY 23-------------------------------------------------

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');


SELECT * FROM bms;

-- SOLUTION 23

-- Using Lead and lag
WITH cte AS (
            SELECT
                *,
                lag(is_empty, 1) OVER (ORDER BY seat_no) AS prev_1,
                lag(is_empty, 2) OVER (ORDER BY seat_no) AS prev_2,
                lead(is_empty, 1) OVER (ORDER BY seat_no) AS next_1,
                lead(is_empty, 2) OVER (ORDER BY seat_no) AS next_2
            FROM bms)
SELECT * FROM cte
WHERE (is_empty = 'Y' AND prev_1 = 'Y' AND prev_2 = 'Y') 
   OR (is_empty = 'Y' AND next_1 = 'Y' AND next_2 = 'Y')
   OR (is_empty = 'Y' AND prev_1 = 'Y' AND next_1 = 'Y');



-- Using window functions with conditional aggregation
WITH cte AS (
            SELECT
                *,
                SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER BY seat_no ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS empty_seats_before,
                SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS empty_seats_around,
                SUM(CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER BY seat_no ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS empty_seats_after
            FROM bms)
SELECT * FROM cte
WHERE is_empty = 'Y' AND (empty_seats_before = 3 OR empty_seats_around = 3 OR empty_seats_after = 3);




--------------------------------------------DAY 24-------------------------------------------------

CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

SELECT * FROM stores;


-- SOLUTION 24

-- Using string manipulation to identify missing quarter
WITH cte AS (
            SELECT 
                store,
                SUM(RIGHT(QUARTER, 1)::INTEGER) AS quarter_number_sum,
                (1+2+3+4) AS total_quarters_sum
            FROM stores
            GROUP BY store)
SELECT 
    store,
    CONCAT('Q', total_quarters_sum - quarter_number_sum) AS missing_quarter
FROM cte;


-- Recursive CTE solution
WITH RECURSIVE recursive_cte AS (
        SELECT DISTINCT store, 1 AS quarter_number FROM stores
        UNION ALL
        SELECT store, quarter_number + 1 AS quarter_number FROM recursive_cte
        WHERE quarter_number < 4
),
cte AS (
        SELECT 
            store,
            CONCAT('Q', quarter_number) AS quarter_new
        FROM recursive_cte
        ORDER BY store, quarter_number)
SELECT 
    c.store,
    c.quarter_new AS missing_quarter
FROM cte c
LEFT JOIN stores s
    ON c.store = s.store AND c.quarter_new = s.quarter
WHERE s.store IS NULL
ORDER BY c.store, c.quarter_new;


--------------------------------------------DAY 25-------------------------------------------------


create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

SELECT * FROM exams;


-- SOLUTION 25

WITH cte AS (
            SELECT 
                student_id,
                MIN(CASE WHEN subject = 'Chemistry' THEN marks END) AS chemistry_marks,
                MIN(CASE WHEN subject = 'Physics' THEN marks END) AS physics_marks
            FROM exams
            GROUP BY student_id
            ORDER BY student_id)
SELECT 
    *
FROM cte
WHERE chemistry_marks = physics_marks;


--------------------------------------------DAY 26-------------------------------------------------


create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);


SELECT * FROM covid;



-- SOLUTION 26

WITH cte AS (
        SELECT 
            *,
            LEAD(cases,1) OVER (PARTITION BY city ORDER BY days) AS next_day_cases
        FROM covid),
cte2 AS (
        SELECT 
            *,
            CASE WHEN next_day_cases > cases THEN 1 END AS trend
        FROM cte
        WHERE next_day_cases IS NOT NULL),
cte3 AS (
        SELECT 
            city,
            COUNT(*) AS total_days,
            SUM(trend) AS increasing_trend_days
        FROM cte2
        GROUP BY city)
SELECT 
    city
FROM cte3
WHERE total_days = increasing_trend_days;


--------------------------------------------DAY 27-------------------------------------------------


create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');



-- SOLUTION 27

SELECT * FROM company_users;

WITH cte AS (
            SELECT 
                company_id,
                user_id,
                STRING_AGG(DISTINCT language, ', ') AS languages_known
            FROM company_users cu
            WHERE language IN ('English', 'German')
            GROUP BY company_id, user_id
            ORDER BY company_id, user_id)
SELECT 
    company_id,
    COUNT(CASE WHEN languages_known = 'English, German' THEN user_id END) AS user_ids_who_know_both_languages
FROM cte
GROUP BY company_id
HAVING COUNT(CASE WHEN languages_known = 'English, German' THEN user_id END) >= 2;


--------------------------------------------DAY 28-------------------------------------------------


create table meesho_products
(
product_id varchar(20) ,
cost int
);
insert into meesho_products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id varchar(20),
budget int
);

insert into customer_budget values ('C1',400),('C2',800),('C3',1500);



-- SOLUTION 28

SELECT * FROM meesho_products;
SELECT * FROM customer_budget;

WITH cum_cost AS (
                SELECT 
                    *,
                    SUM(cost) OVER (ORDER BY cost) AS cumulative_cost
                FROM meesho_products
                ),
budget_products AS (
                SELECT * FROM customer_budget cb
                JOIN cum_cost cc ON cb.budget >= cc.cumulative_cost
                ORDER BY cb.customer_id, cc.cumulative_cost
                )
SELECT 
    customer_id,
    MIN(budget) AS budget,
    COUNT(product_id) AS total_products_within_budget,
    STRING_AGG(product_id, ', ') AS products_within_budget
FROM budget_products
GROUP BY customer_id;



--------------------------------------------DAY 29-------------------------------------------------


CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);



-- SOLUTION 29

SELECT * FROM subscriber;


SELECT 
    CONCAT_WS('-', LEAST(sender, receiver), GREATEST(sender, receiver)) AS user_pair,
    SUM(sms_no) AS total_sms_exchanged
FROM subscriber
GROUP BY user_pair;


--------------------------------------------DAY 30-------------------------------------------------


CREATE TABLE students (
 studentid varchar(20), 
 studentname varchar(20),
 subject varchar(20),
 marks int,
 testid int,
 testdate date
);
insert into students values ('ID2','Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values ('ID3','Arnold','Subject1',95,1,'2022-01-02');
insert into students values ('ID4','Krish Star','Subject1',61,1,'2022-01-02');
insert into students values ('ID5','John Mike','Subject1',91,1,'2022-01-02');
insert into students values ('ID4','Krish Star','Subject2',71,1,'2022-01-02');
insert into students values ('ID3','Arnold','Subject2',32,1,'2022-01-02');
insert into students values ('ID5','John Mike','Subject2',61,2,'2022-11-02');
insert into students values ('ID1','John Deo','Subject2',60,1,'2022-01-02');
insert into students values ('ID2','Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values ('ID2','Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values ('ID5','John Mike','Subject3',98,2,'2022-11-02');



SELECT  * FROM students;

-- SOLUTION 30

-- Calculate the average marks for each subject and then find all students who scored above the average in their respective subjects.
WITH subject_averages AS (
            SELECT 
                subject,
                AVG(marks) AS average_marks
            FROM students
            GROUP BY subject)
SELECT 
    *
FROM students s
JOIN subject_averages sa ON s.subject = sa.subject
WHERE s.marks > sa.average_marks


-- Calculate the percentage of students who scored above 90 in each subject.

SELECT 
    subject,
    COUNT(DISTINCT CASE WHEN marks > 90 THEN studentid END) AS total_students_above_90,
    COUNT(DISTINCT studentid) AS total_students,
    ROUND( (COUNT(DISTINCT CASE WHEN marks > 90 THEN studentid END)::DECIMAL / COUNT(DISTINCT studentid)) * 100, 2 ) AS percentage_students_above_90
FROM students
GROUP BY subject;


-- Find the second highest and second lowest marks for each subject.

WITH cte AS (
            SELECT 
                subject, 
                marks,
                ROW_NUMBER() OVER (PARTITION BY subject ORDER BY marks DESC) AS desc_rank,
                ROW_NUMBER() OVER (PARTITION BY subject ORDER BY marks ASC) AS asc_rank 
            FROM students
            ORDER BY subject, marks DESC)
SELECT 
    subject,
    MIN(CASE WHEN desc_rank = 2 THEN marks END) AS second_highest_marks,
    MIN(CASE WHEN asc_rank = 2 THEN marks END) AS second_lowest_marks
FROM cte
GROUP BY subject;


-- Identify the performance trend of each student across their tests (Improved, Declined, Same, No Previous Test).
WITH cte AS (
            SELECT 
                studentid,
                testdate,
                subject,
                marks,
                LAG(marks) OVER (PARTITION BY studentid ORDER BY testdate, subject) AS previous_marks
            FROM students
            ORDER BY studentid, testdate, subject)
SELECT 
    *,
    CASE 
        WHEN previous_marks IS NULL THEN 'No Previous Test'
        WHEN marks > previous_marks THEN 'Improved'
        WHEN marks < previous_marks THEN 'Declined'
        ELSE 'Same' 
    END AS performance_trend
FROM cte;




--------------------------------------------DAY 31-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 32-------------------------------------------------


create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');


SELECT * FROM event_status;


-- SOLUTION 32
WITH cte AS (
            SELECT 
                *,
                LAG(status,1, status) OVER (ORDER BY event_time) AS previous_status
            FROM event_status),
cte2 AS (
            SELECT 
                *,
                (SUM(CASE WHEN status = 'on' AND previous_status = 'off' THEN 1 ELSE 0 END) OVER (ORDER BY event_time)) + 1 AS groups
            FROM cte)
SELECT 
    MIN(event_time) AS on_time,
    MAX(event_time) AS off_time,
    SUM(CASE WHEN status = 'on' THEN 1 END) AS on_count
FROM cte2
GROUP BY groups
ORDER BY on_time;


--------------------------------------------DAY 33-------------------------------------------------

create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

SELECT * FROM players_location;

-- SOLUTION 33
WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (PARTITION BY city ORDER BY name) AS group_number
            FROM players_location)
SELECT
    MIN(CASE WHEN city = 'Bangalore' THEN name END) AS Bangalore,
    MIN(CASE WHEN city = 'Delhi' THEN name END) AS Delhi,
    MIN(CASE WHEN city = 'Mumbai' THEN name END) AS Mumbai
FROM cte
GROUP BY group_number
ORDER BY group_number;


--------------------------------------------DAY 34-------------------------------------------------


create table employee
(
emp_id int,
company varchar(10),
salary int
);

insert into employee values (1,'A',2341);
insert into employee values (2,'A',341);
insert into employee values (3,'A',15);
insert into employee values (4,'A',15314);
insert into employee values (5,'A',451);
insert into employee values (6,'A',513);
insert into employee values (7,'B',15);
insert into employee values (8,'B',13);
insert into employee values (9,'B',1154);
insert into employee values (10,'B',1345);
insert into employee values (11,'B',1221);
insert into employee values (12,'B',234);
insert into employee values (13,'C',2345);
insert into employee values (14,'C',2645);
insert into employee values (15,'C',2645);
insert into employee values (16,'C',2652);
insert into employee values (17,'C',65);



-- SOLUTION 34


-- Calulate Median Salary for each company without any built-in median function
WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (PARTITION BY company ORDER BY salary) AS row_num_asc,
                ROW_NUMBER() OVER (PARTITION BY company ORDER BY salary DESC) AS row_num_desc
            FROM employee)
SELECT 
    company,
    AVG(salary) AS median_salary
FROM cte
WHERE ABS(row_num_asc - row_num_desc) <= 1
GROUP BY company;


--------------------------------------------DAY 35-------------------------------------------------


CREATE TABLE emp_salary (
    emp_id INT,
    emp_name VARCHAR(50),
    salary INT,
    manager_id INT,
    emp_age INT,
    dep_id INT,
    dep_name VARCHAR(20),
    gender VARCHAR(10)
);

INSERT INTO emp_salary VALUES
(1,'Ankit',14300,4,39,100,'Analytics','Female'),
(2,'Mohit',14000,5,48,200,'IT','Male'),
(3,'Vikas',12100,4,37,100,'Analytics','Female'),
(4,'Rohit',7260,2,16,100,'Analytics','Female'),
(5,'Mudit',15000,6,55,200,'IT','Male'),
(6,'Agam',15600,2,14,200,'IT','Male'),
(7,'Sanjay',12000,2,13,200,'IT','Male'),
(8,'Ashish',7200,2,12,200,'IT','Male'),
(9,'Mukesh',7000,6,51,300,'HR','Male'),
(10,'Rakesh',8000,6,50,300,'HR','Male'),
(11,'Akhil',4000,1,31,500,'Ops','Male');



-- SOLUTION 35

SELECT * FROM emp_salary;


WITH cte AS (
            SELECT 
                emp_id,
                emp_name,
                salary,
                dep_id,
                dep_name,
                ROW_NUMBER() OVER (PARTITION BY dep_id ORDER BY salary DESC) AS salary_rank_in_department,
                COUNT(*) OVER (PARTITION BY dep_id) AS total_employees_in_department
            FROM emp_salary),
cte2 AS (
            SELECT 
                *,
                CASE WHEN total_employees_in_department >= 3 AND salary_rank_in_department = 3 THEN 'Third Highest Salary'
                    WHEN total_employees_in_department < 3 AND salary_rank_in_department = total_employees_in_department THEN 'Lowest Salary'
                    ELSE 'Other Salary' END AS salary_category
            FROM cte)
SELECT 
    emp_id,
    emp_name,
    salary,
    dep_id,
    dep_name
FROM cte2
WHERE salary_category IN ('Third Highest Salary', 'Lowest Salary');



--------------------------------------------DAY 36-------------------------------------------------


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


-- SOLUTION 36

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (ORDER BY visit_date) AS rnk,
                id - ( ROW_NUMBER() OVER (ORDER BY visit_date) ) AS grp
            FROM stadium
            WHERE no_of_people >= 100),
cte2 AS (
            SELECT 
                grp,
                COUNT(*) AS grp_count
            FROM cte
            GROUP BY grp
            HAVING COUNT(*) >= 3)
SELECT 
    id,
    visit_date,
    no_of_people
FROM cte c
JOIN cte2 c2
    ON c.grp = c2.grp;



--------------------------------------------DAY 37-------------------------------------------------


create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);


SELECT * FROM business_city;


-- SOLUTION 37

WITH cte AS (
            SELECT 
                DATE_PART('YEAR', business_date) AS business_year,
                city_id
            FROM business_city 
            ORDER BY business_date)
SELECT 
    c1.business_year,
    COUNT(*) AS new_city_count
FROM cte c1
LEFT JOIN cte c2
    ON c1.business_year > c2.business_year AND c1.city_id = c2.city_id
WHERE c2.city_id IS NULL
GROUP BY c1.business_year
ORDER BY c1.business_year;



--------------------------------------------DAY 38-------------------------------------------------


create table movie(
seat varchar(50),occupancy int
);
insert into movie values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);



-- SOLUTION 38


-- Solution for finding 4 consecutive seats in each seat row
WITH cte AS (
            SELECT 
                LEFT(seat,1) AS seat_row,
                SUBSTRING(seat,2,2)::INTEGER AS seat_no,
                occupancy
            FROM movie),
cte2 AS (
        SELECT 
            *,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN 3 PRECEDING AND CURRENT ROW ) AS prev_4,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING ) AS prev_next_2,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING ) AS next_4
        FROM cte)
SELECT 
    seat_row,
    seat_no,
    occupancy
FROM cte2
WHERE occupancy = 0 AND (prev_4 = 4 OR prev_next_2 = 4 OR next_4 = 4);


-- Solution for finding 3 consecutive seats in each seat row
WITH cte AS (
            SELECT 
                LEFT(seat,1) AS seat_row,
                SUBSTRING(seat,2,2)::INTEGER AS seat_no,
                occupancy
            FROM movie),
cte2 AS (
        SELECT 
            *,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS prev_3,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) AS prev_next_1,
            SUM(CASE WHEN occupancy = 0 THEN 1 ELSE 0 END) OVER ( PARTITION BY seat_row ORDER BY seat_no ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) AS next_3
        FROM cte)
SELECT 
    seat_row,
    seat_no,
    occupancy
FROM cte2
WHERE occupancy = 0 AND (prev_3 = 3 OR prev_next_1 = 3 OR next_3 = 3);



--------------------------------------------DAY 39-------------------------------------------------



create table call_details  (
call_type varchar(10),
call_number varchar(12),
call_duration int
);

insert into call_details
values ('OUT','181868',13),('OUT','2159010',8)
,('OUT','2159010',178),('SMS','4153810',1),('OUT','2159010',152),('OUT','9140152',18),('SMS','4162672',1)
,('SMS','9168204',1),('OUT','9168204',576),('INC','2159010',5),('INC','2159010',4),('SMS','2159010',1)
,('SMS','4535614',1),('OUT','181868',20),('INC','181868',54),('INC','218748',20),('INC','2159010',9)
,('INC','197432',66),('SMS','2159010',1),('SMS','4535614',1);


-- SOLUTION 39

WITH cte AS (
            SELECT 
                call_number,
                STRING_AGG(DISTINCT call_type, ', ') AS call_types
            FROM call_details
            GROUP BY call_number
            ORDER BY call_number)
SELECT 
    call_number
FROM cte
WHERE call_types ILIKE '%OUT%' AND call_types ILIKE '%INC%';




WITH cte AS (
            SELECT 
                call_number,
                call_type,
                call_duration
            FROM call_details
            WHERE call_type IN ('OUT', 'INC')
            ORDER BY call_number, call_type),
cte2 AS (
            SELECT 
                call_number,
                COUNT(DISTINCT call_type) AS call_type_count
            FROM cte
            GROUP BY call_number),
cte3 AS (
            SELECT 
                cte.call_number,
                SUM(CASE WHEN call_type = 'OUT' THEN call_duration END) AS total_outgoing_duration,
                SUM(CASE WHEN call_type = 'INC' THEN call_duration END) AS total_incoming_duration
            FROM cte
            JOIN cte2 ON cte.call_number = cte2.call_number
            WHERE call_type_count = 2
            GROUP BY cte.call_number
            ORDER BY cte.call_number)
SELECT 
    call_number
FROM cte3
WHERE total_outgoing_duration > total_incoming_duration;




--------------------------------------------DAY 40-------------------------------------------------



create table brands 
(
category varchar(20),
brand_name varchar(20)
);
insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');


-- SOLUTION 40

WITH cte AS (
                SELECT 
                *,
                ROW_NUMBER() OVER (ORDER BY NULL) AS row_num
            FROM brands),
cte2 AS (
            SELECT 
                *,
                LEAD(row_num,1,999) OVER (ORDER BY NULL) AS next_row_num
            FROM cte
            WHERE category IS NOT NULL)
SELECT 
    cte2.category,
    cte.brand_name
FROM cte
JOIN cte2 
    ON cte.row_num >= cte2.row_num AND cte.row_num <= cte2.next_row_num-1;




--------------------------------------------DAY 41-------------------------------------------------



create table sch_students
(
student_id int,
student_name varchar(20)
);
insert into sch_students values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table sch_exams
(
exam_id int,
student_id int,
score int);

insert into sch_exams values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

SELECT * FROM sch_students;
SELECT * FROM sch_exams;


-- SOLUTION 41
WITH cte AS (
            SELECT 
            exam_id,
            MIN(score) AS lowest_score,
            MAX(score) AS highest_score
            FROM sch_exams
            GROUP BY exam_id)
SELECT 
    se.student_id,
    MAX(CASE score = lowest_score OR score = highest_score WHEN TRUE THEN 1 ELSE 0 END) AS flag
FROM sch_exams se
JOIN cte c
    ON c.exam_id = se.exam_id
GROUP BY se.student_id
HAVING MAX(CASE score = lowest_score OR score = highest_score WHEN TRUE THEN 1 ELSE 0 END) = 0;



--------------------------------------------DAY 42-------------------------------------------------


create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled timestamp
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');



SELECT * FROM phonelog;


-- SOLUTION 42

WITH cte AS (
            SELECT 
                *,
                MIN(Datecalled) OVER (PARTITION BY datecalled::date ORDER BY datecalled) AS first_call_time_of_day,
                MAX(Datecalled) OVER (PARTITION BY datecalled::date ORDER BY datecalled DESC) AS last_call_time_of_day
            FROM phonelog),
cte2 AS (
            SELECT 
                callerid,
                datecalled::date AS call_date,
                MIN(CASE WHEN first_call_time_of_day = Datecalled THEN recipientid END) AS is_first_recipient,
                MIN(CASE WHEN last_call_time_of_day = Datecalled THEN recipientid END) AS is_last_recipient
            FROM cte
            GROUP BY callerid, call_date
            ORDER BY callerid, call_date)
SELECT 
    callerid,
    call_date,
    is_first_recipient AS recipientid
FROM cte2
WHERE is_first_recipient = is_last_recipient;




--------------------------------------------DAY 43-------------------------------------------------


create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);

-- SOLUTION 43

WITH total_salary AS (
            SELECT 
                *,
                SUM(salary) OVER (PARTITION BY experience ORDER BY salary) AS cumulative_salary
            FROM candidates),
senior_candidates AS (
            SELECT * FROM total_salary
            WHERE experience = 'Senior' AND cumulative_salary <= 70000),
junior_candidates AS (
            SELECT * FROM total_salary
            WHERE experience = 'Junior' AND cumulative_salary < 70000 - (SELECT SUM(salary) FROM senior_candidates))
SELECT * FROM senior_candidates
UNION ALL
SELECT * FROM junior_candidates;



--------------------------------------------DAY 44-------------------------------------------------


create table emp_mgr(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp_mgr
values (1, 'Ankit', 100,10000, 4, 39);
insert into emp_mgr
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp_mgr
values (3, 'Vikas', 100, 12000,4,37);
insert into emp_mgr
values (4, 'Rohit', 100, 14000, 2, 16);
insert into emp_mgr
values (5, 'Mudit', 200, 20000, 6,55);
insert into emp_mgr
values (6, 'Agam', 200, 12000,2, 14);
insert into emp_mgr
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp_mgr
values (8, 'Ashish', 200,5000,2,12);
insert into emp_mgr  
values (9, 'Mukesh',300,6000,6,51);
insert into emp_mgr
values (10, 'Rakesh',500,7000,6,50);


SELECT 
    e.emp_id,
    e.emp_name,
    m.emp_name AS manager_name,
    sm.emp_name AS senior_manager_name
FROM emp_mgr e
JOIN emp_mgr m
    ON e.manager_id = m.emp_id
JOIN emp_mgr sm
    ON m.manager_id = sm.emp_id;



--------------------------------------------DAY 45-------------------------------------------------


-- Skipped as it is a theoretical question and does not require SQL code.

--------------------------------------------DAY 46-------------------------------------------------

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');



-- SOLUTION 46

WITH cte AS (
            SELECT 
                *,
                LEAD(start_loc) OVER (PARTITION BY id ORDER BY start_time) AS next_start_loc
            FROM drivers
)
SELECT 
    id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN end_loc = next_start_loc THEN 1 ELSE 0 END) AS profit_trip
FROM cte
GROUP BY id;



--------------------------------------------DAY 47-------------------------------------------------


create table purchase_history
(userid int
,productid int
,purchasedate date
);
insert into purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012');


-- SOLUTION 47
SELECT 
    userid,
    COUNT(DISTINCT purchasedate) AS purchase_days,
    COUNT(productid) AS total_products_purchased,
    COUNT(DISTINCT productid) AS unique_products_purchased
FROM purchase_history
GROUP BY userid
HAVING COUNT(DISTINCT purchasedate) > 1 AND (COUNT(productid) = COUNT(DISTINCT productid));


--------------------------------------------DAY 48-------------------------------------------------


CREATE TABLE marketing_campaign
(
 user_id int NULL,
 created_at date NULL,
 product_id int NULL,
 quantity int NULL,
 price int NULL
);
insert into marketing_campaign values 
(10,'2019-01-01',101,3,55),
(10,'2019-01-02',119,5,29),
(10,'2019-03-31',111,2,149),
(11,'2019-01-02',105,3,234),
(11,'2019-03-31',120,3,99),
(12,'2019-01-02',112,2,200),
(12,'2019-03-31',110,2,299),
(13,'2019-01-05',113,1,67),
(13,'2019-03-31',118,3,35),
(14,'2019-01-06',109,5,199),
(14,'2019-01-06',107,2,27),
(14,'2019-03-31',112,3,200),
(15,'2019-01-08',105,4,234),
(15,'2019-01-09',110,4,299),
(15,'2019-03-31',116,2,499),
(16,'2019-01-10',113,2,67),
(16,'2019-03-31',107,4,27),
(17,'2019-01-11',116,2,499),
(17,'2019-03-31',104,1,154),
(18,'2019-01-12',114,2,248),
(18,'2019-01-12',113,4,67),
(19,'2019-01-12',114,3,248),
(20,'2019-01-15',117,2,999),
(21,'2019-01-16',105,3,234),
(21,'2019-01-17',114,4,248),
(22,'2019-01-18',113,3,67),
(22,'2019-01-19',118,4,35),
(23,'2019-01-20',119,3,29),
(24,'2019-01-21',114,2,248),
(25,'2019-01-22',114,2,248),
(25,'2019-01-22',115,2,72),
(25,'2019-01-24',114,5,248),
(25,'2019-01-27',115,1,72),
(26,'2019-01-25',115,1,72),
(27,'2019-01-26',104,3,154),
(28,'2019-01-27',101,4,55),
(29,'2019-01-27',111,3,149),
(30,'2019-01-29',111,1,149),
(31,'2019-01-30',104,3,154),
(32,'2019-01-31',117,1,999),
(33,'2019-01-31',117,2,999),
(34,'2019-01-31',110,3,299),
(35,'2019-02-03',117,2,999),
(36,'2019-02-04',102,4,82),
(37,'2019-02-05',102,2,82),
(38,'2019-02-06',113,2,67),
(39,'2019-02-07',120,5,99),
(40,'2019-02-08',115,2,72),
(41,'2019-02-08',114,1,248),
(42,'2019-02-10',105,5,234),
(43,'2019-02-11',102,1,82),
(43,'2019-03-05',104,3,154),
(44,'2019-02-12',105,3,234),
(44,'2019-03-05',102,4,82),
(45,'2019-02-13',119,5,29),
(45,'2019-03-05',105,3,234),
(46,'2019-02-14',102,4,82),
(46,'2019-02-14',102,5,29),
(46,'2019-03-09',102,2,35),
(46,'2019-03-10',103,1,199),
(46,'2019-03-11',103,1,199),
(47,'2019-02-14',110,2,299),
(47,'2019-03-11',105,5,234),
(48,'2019-02-14',115,4,72),
(48,'2019-03-12',105,3,234),
(49,'2019-02-18',106,2,123),
(49,'2019-02-18',114,1,248),
(49,'2019-02-18',112,4,200),
(49,'2019-02-18',116,1,499),
(50,'2019-02-20',118,4,35),
(50,'2019-02-21',118,4,29),
(50,'2019-03-13',118,5,299),
(50,'2019-03-14',118,2,199),
(51,'2019-02-21',120,2,99),
(51,'2019-03-13',108,4,120),
(52,'2019-02-23',117,2,999),
(52,'2019-03-18',112,5,200),
(53,'2019-02-24',120,4,99),
(53,'2019-03-19',105,5,234),
(54,'2019-02-25',119,4,29),
(54,'2019-03-20',110,1,299),
(55,'2019-02-26',117,2,999),
(55,'2019-03-20',117,5,999),
(56,'2019-02-27',115,2,72),
(56,'2019-03-20',116,2,499),
(57,'2019-02-28',105,4,234),
(57,'2019-02-28',106,1,123),
(57,'2019-03-20',108,1,120),
(57,'2019-03-20',103,1,79),
(58,'2019-02-28',104,1,154),
(58,'2019-03-01',101,3,55),
(58,'2019-03-02',119,2,29),
(58,'2019-03-25',102,2,82),
(59,'2019-03-04',117,4,999),
(60,'2019-03-05',114,3,248),
(61,'2019-03-26',120,2,99),
(62,'2019-03-27',106,1,123),
(63,'2019-03-27',120,5,99),
(64,'2019-03-27',105,3,234),
(65,'2019-03-27',103,4,79),
(66,'2019-03-31',107,2,27),
(67,'2019-03-31',102,5,82);


SELECT * FROM marketing_campaign;


-- SOLUTION 48

WITH marketing_data AS (
            SELECT
                *,
                RANK() OVER (PARTITION BY user_id ORDER BY created_at) AS purchase_rank
            FROM marketing_campaign
            )
,all_day_purchase AS (
            SELECT 
                user_id,
                COUNT(DISTINCT product_id) AS all_day_unique_products_purchased,
                COUNT(product_id) AS all_day_total_products_purchased
            FROM marketing_data
            GROUP BY user_id
            HAVING COUNT(DISTINCT product_id) = COUNT(product_id)
            )
,first_day_purchase AS (
            SELECT 
                user_id,
                COUNT(DISTINCT product_id) AS first_day_unique_products_purchased,
                COUNT(product_id) AS first_day_total_products_purchased
            FROM marketing_data
            WHERE purchase_rank = 1
            GROUP BY user_id
            HAVING COUNT(DISTINCT product_id) = COUNT(product_id)
            )
,remaining_day_purchase AS (
            SELECT 
                user_id,
                COUNT(DISTINCT product_id) AS remaining_day_unique_products_purchased,
                COUNT(product_id) AS remaining_day_total_products_purchased
            FROM marketing_data
            WHERE purchase_rank <> 1
            GROUP BY user_id
            HAVING COUNT(DISTINCT product_id) = COUNT(product_id)
            )
SELECT 
    adp.user_id,
    adp.all_day_unique_products_purchased,
    fdp.first_day_unique_products_purchased,
    rdp.remaining_day_unique_products_purchased
FROM all_day_purchase adp
LEFT JOIN first_day_purchase fdp ON adp.user_id = fdp.user_id
LEFT JOIN remaining_day_purchase rdp ON adp.user_id = rdp.user_id
WHERE adp.all_day_unique_products_purchased = (fdp.first_day_unique_products_purchased + rdp.remaining_day_unique_products_purchased)
ORDER BY adp.user_id;




--------------------------------------------DAY 49-------------------------------------------------


Create Table trade(
trade_id varchar(20),
trade_timestamp time,
trade_stock varchar(20),
quantity int,
price int
)

Insert into trade Values
('TRADE1','10:01:05','ITJunction4All',100,20)
,('TRADE2','10:01:06','ITJunction4All',20,15)
,('TRADE3','10:01:08','ITJunction4All',150,30)
,('TRADE4','10:01:09','ITJunction4All',300,32)
,('TRADE5','10:10:00','ITJunction4All',-100,19)
,('TRADE6','10:10:01','ITJunction4All',-300,19);


SELECT * FROM trade;

-- SOLUTION 49

WITH cte AS (
            SELECT 
                ft.trade_id AS first_trade_id,
                st.trade_id AS second_trade_id,
                ft.trade_timestamp AS first_trade_timestamp,
                st.trade_timestamp AS second_trade_timestamp,
                ft.price AS first_trade_price,
                st.price AS second_trade_price,
                EXTRACT(EPOCH FROM (st.trade_timestamp - ft.trade_timestamp))::int AS time_diff_in_seconds,
                ROUND( (ABS((st.price - ft.price)::NUMERIC/ft.price) * 100) , 2 ) AS price_diff
            FROM trade ft
            CROSS JOIN trade st
            WHERE ft.trade_id <> st.trade_id AND ft.trade_timestamp < st.trade_timestamp
            ORDER BY ft.trade_id)
SELECT 
        first_trade_id,
        second_trade_id,
        first_trade_price,
        second_trade_price,
        price_diff
FROM cte
WHERE time_diff_in_seconds BETWEEN 0 AND 10 AND price_diff >= 10;




--------------------------------------------DAY 50-------------------------------------------------




CREATE TABLE booking_table(
   Booking_id       VARCHAR(3) NOT NULL 
  ,Booking_date     date NOT NULL
  ,User_id          VARCHAR(2) NOT NULL
  ,Line_of_business VARCHAR(6) NOT NULL
);
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;
CREATE TABLE user_table(
   User_id VARCHAR(3) NOT NULL
  ,Segment VARCHAR(2) NOT NULL
);
INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');



-- SOLUTION 50

SELECT * FROM booking_table;
SELECT * FROM user_table;



-- Total users by segment and users who booked flight in April 2022 in each segment

SELECT 
    u.segment,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN b.line_of_business = 'Flight' AND (b.booking_date >= '2022-04-01' AND b.booking_date < '2022-05-01') THEN u.user_id END) AS users_booked_flight_in_april
FROM booking_table b
JOIN user_table u
    ON b.user_id = u.user_id
GROUP BY u.segment;


-- Identify users who's first booking was a Hotel Booking

WITH cte AS (
            SELECT 
                *,
                RANK() OVER (PARTITION BY user_id ORDER BY booking_date) AS booking_rank
            FROM booking_table)
SELECT 
    user_id
FROM cte
WHERE booking_rank = 1 AND line_of_business = 'Hotel';


-- Find the days between the first and the last booking for each user

WITH cte AS (
            SELECT 
                *,
                FIRST_VALUE(booking_date) OVER (PARTITION BY user_id ORDER BY booking_date) AS first_booking_date,
                LAST_VALUE(booking_date) OVER (PARTITION BY user_id ORDER BY booking_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_booking_date
            FROM booking_table)
SELECT 
    user_id,
    first_booking_date,
    last_booking_date,
    (last_booking_date - first_booking_date) AS days_between_first_and_last_booking
FROM cte
GROUP BY user_id, first_booking_date, last_booking_date;


SELECT 
    user_id,
    MIN(booking_date) AS first_booking_date,
    MAX(booking_date) AS last_booking_date,
    MAX(booking_date) - MIN(booking_date) AS days_between_first_and_last_booking
FROM booking_table
GROUP BY user_id;



-- No. of Flight and Hotel bookings in each segment

SELECT 
    u.segment,
    COUNT( DISTINCT CASE WHEN line_of_business = 'Flight' THEN booking_id END) AS flight_bookings,
    COUNT( DISTINCT CASE WHEN line_of_business = 'Hotel' THEN booking_id END) AS hotel_bookings
FROM booking_table b
JOIN user_table u
    ON b.user_id = u.user_id
GROUP BY u.segment;


--------------------------------------------DAY 51-------------------------------------------------


create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');


-- SOLUTION 51

WITH RECURSIVE cte AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY hall_id, start_date) AS rn
    FROM hall_events
),
r_cte AS (
    SELECT 
        hall_id,
        start_date,
        end_date,
        rn,
        1 as flag
    FROM cte
    WHERE rn = 1

    UNION ALL

    SELECT
        c.hall_id,
        c.start_date,
        c.end_date,
        c.rn,
        ( CASE WHEN c.hall_id = r.hall_id AND  ( (c.start_date BETWEEN r.start_date AND r.end_date) OR (r.start_date BETWEEN c.start_date AND c.end_date) ) THEN 0 ELSE 1 END ) + flag as flag
    FROM r_cte r
    JOIN cte c
        ON r.rn + 1 = c.rn
)
SELECT 
    hall_id,
    MIN(start_date) AS start_date,
    MAX(end_date) AS end_date
FROM r_cte
GROUP BY hall_id, flag;



--------------------------------------------DAY 52-------------------------------------------------


create table emp_salary_new(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp_salary_new values
(1, 'Ankit', 100,10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 10000,4,37),
(4, 'Rohit', 100, 5000, 2, 16),
(5, 'Mudit', 200, 12000, 6,55),
(6, 'Agam', 200, 12000,2, 14),
(7, 'Sanjay', 200, 9000, 2,13),
(8, 'Ashish', 200,5000,2,12),
(9, 'Mukesh',300,6000,6,51),
(10, 'Rakesh',300,7000,6,50);


-- SOLUTION 52
WITH cte AS (
            SELECT 
                department_id,
                ROUND(AVG(salary),1) AS dept_average_salary,
                COUNT(*) AS total_employees,
                SUM(salary) AS dept_total_salary
            FROM emp_salary_new
            GROUP BY department_id
            ORDER BY department_id DESC),
cte2 AS (
            SELECT 
                c1.department_id,
                c1.dept_average_salary,
                c2.total_employees,
                c2.dept_total_salary
            FROM cte c1
            JOIN cte c2
                ON c1.department_id <> c2.department_id
            ORDER BY c1.department_id),
cte3 AS (
            SELECT 
                department_id,
                dept_average_salary,
                SUM(total_employees),
                SUM(dept_total_salary),
                ROUND( SUM(dept_total_salary) / SUM(total_employees), 1 ) AS overall_average_salary
            FROM cte2
            GROUP BY department_id, dept_average_salary
            ORDER BY department_id)
SELECT 
    department_id
FROM cte3
WHERE dept_average_salary < overall_average_salary;



--------------------------------------------DAY 53-------------------------------------------------



CREATE TABLE employee_checkin_details (
    employeeid INT,
    entry_details VARCHAR(50),
    timestamp_details TIMESTAMP
);

-- Insert Data into employee_checkin_details
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.340'),
(1000, 'login', '2023-06-16 02:00:15.340'),
(1000, 'login', '2023-06-16 03:00:15.340'),
(1000, 'logout', '2023-06-16 12:00:15.340'),
(1001, 'login', '2023-06-16 01:00:15.340'),
(1001, 'login', '2023-06-16 02:00:15.340'),
(1001, 'login', '2023-06-16 03:00:15.340'),
(1001, 'logout', '2023-06-16 12:00:15.340');
CREATE TABLE employee_details (
    employeeid INT,
    phone_number INT, -- Or BIGINT if phone numbers can be larger
    isdefault VARCHAR(512)
);

-- Insert Data into employee_details
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES
(1001, 9999, 'FALSE'),
(1001, 1111,'FALSE'),
(1001, 2222, 'TRUE'),
(1003, 3333, 'FALSE');


-- SOLUTION 53
WITH cte AS (SELECT * FROM employee_details WHERE isdefault = 'TRUE')
SELECT 
    ec.employeeid,
    phone_number AS employee_default_phone_number,
    COUNT(ec.employeeid) AS total_entry,
    COUNT(CASE WHEN entry_details = 'login' THEN ec.employeeid END) AS total_login,
    COUNT(CASE WHEN entry_details = 'logout' THEN ec.employeeid END) AS total_logout,
    MAX(CASE WHEN entry_details = 'login' THEN timestamp_details END) AS last_login_time,
    MAX(CASE WHEN entry_details = 'logout' THEN timestamp_details END) AS last_logout_time
FROM employee_checkin_details ec
LEFT JOIN cte c
    ON ec.employeeid = c.employeeid
GROUP BY ec.employeeid, phone_number
ORDER BY ec.employeeid;





--------------------------------------------DAY 54-------------------------------------------------

-- Same as Day 43

--------------------------------------------DAY 55-------------------------------------------------

create table namaste_orders
(
order_id int,
city varchar(10),
sales int
)

create table namaste_returns
(
order_id int,
return_reason varchar(20)
)

insert into namaste_orders
values(1, 'Mysore' , 100),(2, 'Mysore' , 200),(3, 'Bangalore' , 250),(4, 'Bangalore' , 150)
,(5, 'Mumbai' , 300),(6, 'Mumbai' , 500),(7, 'Mumbai' , 800)
;
insert into namaste_returns values
(3,'wrong item'),(6,'bad quality'),(7,'wrong item');


-- SOLUTION 55


SELECT * FROM namaste_orders;
SELECT * FROM namaste_returns;

WITH cte AS (
            SELECT 
                *,
                CASE WHEN r.order_id IS NULL THEN 0 ELSE 1 END AS return_order_flag
            FROM namaste_orders o
            LEFT JOIN namaste_returns r
                ON o.order_id = r.order_id)
SELECT 
    city
FROM cte
GROUP BY city
HAVING MAX(return_order_flag) = 0;



--------------------------------------------DAY 56-------------------------------------------------

-- NA


--------------------------------------------DAY 57-------------------------------------------------

CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(512),
    destination VARCHAR(512)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');



-- SOLUTION 57
WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (PARTITION BY distance ORDER BY source, destination) AS rn
            FROM city_distance)
SELECT * FROM cte
WHERE rn = 1


--------------------------------------------DAY 58-------------------------------------------------



create table customers_names  (customer_name varchar(30));
insert into customers_names values ('Ankit Bansal'), ('Vishal Pratap Singh'), ('Michael');


-- SOLUTION 58

WITH cte AS (
            SELECT 
                customer_name,
                LENGTH(customer_name) - LENGTH(REPLACE(customer_name, ' ', '')) AS number_of_spaces,
                NULLIF(POSITION(' ' IN customer_name), 0) AS first_space_position,
                NULLIF(POSITION(' ' IN SUBSTRING(customer_name FROM POSITION(' ' IN customer_name) + 1)), 0) + POSITION(' ' IN customer_name) AS second_space_position
            from customers_names)
SELECT
    customer_name,
    CASE 
        WHEN  number_of_spaces = 0 THEN customer_name
        WHEN  number_of_spaces = 1 THEN SUBSTRING(customer_name FROM 1 FOR first_space_position - 1)
        WHEN  number_of_spaces >= 2 THEN SUBSTRING(customer_name FROM 1 FOR first_space_position - 1)
    END AS first_name,
    CASE
        WHEN  number_of_spaces = 0 THEN NULL
        WHEN  number_of_spaces = 1 THEN NULL
        WHEN  number_of_spaces >= 2 THEN SUBSTRING(customer_name FROM first_space_position + 1 FOR second_space_position - first_space_position - 1)
    END AS middle_name,
    CASE 
        WHEN  number_of_spaces = 0 THEN NULL
        WHEN  number_of_spaces = 1 THEN SUBSTRING(customer_name FROM first_space_position + 1)
        WHEN  number_of_spaces >= 2 THEN SUBSTRING(customer_name FROM second_space_position + 1)
    END AS last_name
FROM cte;




--------------------------------------------DAY 59-------------------------------------------------



CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);

-- Insert the data
INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');


SELECT * FROM user_interactions;

-- SOLUTION 59

SELECT 
    game_id,
    CASE 
        WHEN COUNT(interaction_type)=0 THEN 'No Social Interaction'
        WHEN COUNT( DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 1 THEN 'One Sided Interaction'
        WHEN COUNT( DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2 
            AND COUNT( DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) = 0 THEN 'Two Sided Interaction without custom typed message'
        WHEN COUNT( DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 2 
            AND COUNT( DISTINCT CASE WHEN interaction_type = 'custom_typed' THEN user_id END) >= 1 THEN 'Two Sided Interaction with at least one custom typed message'
    END AS interaction_type
FROM user_interactions
GROUP BY game_id;



--------------------------------------------DAY 60-------------------------------------------------


CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

delete from stock;
INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
    (1, 1, 60, '2022-01-01'),
    (1, 1, 40, '2022-01-02'),
    (1, 1, 35, '2022-01-03'),
    (1, 1, 45, '2022-01-04'),
    (1, 1, 51, '2022-01-06'),
    (1, 1, 55, '2022-01-09'),
    (1, 1, 25, '2022-01-10'),
    (1, 1, 48, '2022-01-11'),
    (1, 1, 45, '2022-01-15'),
    (1, 1, 38, '2022-01-16'),
    (1, 2, 45, '2022-01-08'),
    (1, 2, 40, '2022-01-09'),
    (2, 1, 45, '2022-01-06'),
    (2, 1, 55, '2022-01-07'),
    (2, 2, 45, '2022-01-08'),
    (2, 2, 48, '2022-01-09'),
    (2, 2, 35, '2022-01-10'),
    (2, 2, 52, '2022-01-15'),
    (2, 2, 23, '2022-01-16');


-- SOLUTION 60

WITH cte AS (
            SELECT 
                supplier_id,
                product_id,
                record_date,
                LAG(record_date, 1, record_date) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS previous_record_date
            FROM stock
            WHERE stock_quantity < 50),
cte1 AS (
            SELECT 
                *,
                (record_date - previous_record_date) AS days_difference,
                CASE WHEN (record_date - previous_record_date) <= 1 THEN 0 ELSE 1 END AS group_flag
            FROM cte),
cte2 AS (
            SELECT 
                *,
                SUM(group_flag) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS group_number
            FROM cte1)
SELECT 
    supplier_id,
    product_id,
    COUNT(*) AS no_of_days_below_50,
    MIN(record_date) AS start_date
FROM cte2
GROUP BY supplier_id, product_id, group_number
HAVING COUNT(*) >= 2
ORDER BY supplier_id, product_id, start_date;



--------------------------------------------DAY 61-------------------------------------------------



CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 15),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);

WITH cte AS (
            SELECT 
                submission_date,
                hacker_id,
                COUNT(*) AS no_of_submissions,
                DENSE_RANK() OVER (ORDER BY submission_date) AS day_number
            FROM Submissions
            GROUP BY submission_date, hacker_id),
cte1 AS (
            SELECT 
                *,
                COUNT(*) OVER(PARTITION BY hacker_id ORDER BY submission_date) AS consecutive_days_with_submission
            FROM cte),
cte2 AS (
            SELECT
                *,
                CASE WHEN day_number = consecutive_days_with_submission THEN 1 ELSE 0 END AS unique_flag
            FROM cte1),
cte3 AS (
            SELECT 
                *,
                SUM(unique_flag) OVER (PARTITION BY submission_date) AS unique_submission_streak,
                ROW_NUMBER() OVER (PARTITION BY submission_date ORDER BY no_of_submissions) AS submission_rank
            FROM cte2)
SELECT
    submission_date,
    hacker_id,
    unique_submission_streak
FROM cte3
WHERE submission_rank = 1
ORDER BY submission_date, hacker_id;


--------------------------------------------DAY 62-------------------------------------------------


-- Create the 'king' table
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(50),
    house VARCHAR(50)
);

-- Create the 'battle' table
CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(100),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(50),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);

delete from king;
INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

delete from battle;
-- Insert data into the 'battle' table
INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
--for each region find house which has won maximum no of battles. display region, house and no of wins
select * from battle;
select * from king;


-- SOLUTION 62

WITH cte AS (
            SELECT 
                b.battle_number,
                b.name AS battle_name,
                ak.king AS attacker_king,
                ak.house AS attacker_house,
                dk.king AS defender_king,
                dk.house AS defender_house,
                CASE WHEN b.attacker_outcome = 1 THEN ak.house ELSE dk.house END AS winning_house,
                b.region
            FROM battle b
            JOIN king ak
                ON b.attacker_king = ak.k_no
            JOIN king dk
                ON b.defender_king = dk.k_no),
SELECT 
    region,
    winning_house,
    COUNT(*) AS no_of_wins,
    RANK() OVER (PARTITION BY region ORDER BY COUNT(*) DESC) AS win_rank
FROM cte
GROUP BY region, winning_house;



--------------------------------------------DAY 63-------------------------------------------------


CREATE TABLE cinema (
    seat_id INT PRIMARY KEY,
    free int
);
delete from cinema;
INSERT INTO cinema (seat_id, free) VALUES (1, 1);
INSERT INTO cinema (seat_id, free) VALUES (2, 0);
INSERT INTO cinema (seat_id, free) VALUES (3, 1);
INSERT INTO cinema (seat_id, free) VALUES (4, 1);
INSERT INTO cinema (seat_id, free) VALUES (5, 1);
INSERT INTO cinema (seat_id, free) VALUES (6, 0);
INSERT INTO cinema (seat_id, free) VALUES (7, 1);
INSERT INTO cinema (seat_id, free) VALUES (8, 1);
INSERT INTO cinema (seat_id, free) VALUES (9, 0);
INSERT INTO cinema (seat_id, free) VALUES (10, 1);
INSERT INTO cinema (seat_id, free) VALUES (11, 0);
INSERT INTO cinema (seat_id, free) VALUES (12, 1);
INSERT INTO cinema (seat_id, free) VALUES (13, 0);
INSERT INTO cinema (seat_id, free) VALUES (14, 1);
INSERT INTO cinema (seat_id, free) VALUES (15, 1);
INSERT INTO cinema (seat_id, free) VALUES (16, 0);
INSERT INTO cinema (seat_id, free) VALUES (17, 1);
INSERT INTO cinema (seat_id, free) VALUES (18, 1);
INSERT INTO cinema (seat_id, free) VALUES (19, 1);
INSERT INTO cinema (seat_id, free) VALUES (20, 1);


-- SOLUTION 63


WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (ORDER BY seat_id) AS row_number
            FROM cinema
            WHERE free = 1),
cte1 AS (
            SELECT 
                *,
                (seat_id - row_number) AS group_id,
                COUNT(*) OVER (PARTITION BY (seat_id - row_number)) AS consecutive_free_seats
            FROM cte)
SELECT 
    seat_id
FROM cte1
WHERE consecutive_free_seats >= 2




--------------------------------------------DAY 64-------------------------------------------------


CREATE TABLE friends (
    user_id INT,
    friend_id INT
);

-- Insert data into friends table
INSERT INTO friends VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

-- Create likes table
CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

-- Insert data into likes table
INSERT INTO likes VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');


SELECT * FROM friends;
SELECT * FROM likes;


-- SOLUTION 64


WITH cte AS (
                SELECT 
                    f.user_id,
                    ul.page_id AS user_liked_page,
                    f.friend_id,
                    fl.page_id AS friend_liked_page
                FROM friends f
                JOIN likes ul
                    ON f.user_id = ul.user_id
                JOIN likes fl
                    ON f.friend_id = fl.user_id AND ul.page_id <> fl.page_id)
, unique_user_page AS (
                    SELECT DISTINCT
                        user_id,
                        user_liked_page
                    FROM cte)
, unique_friend_page AS (
                    SELECT DISTINCT
                        user_id,
                        friend_liked_page
                    FROM cte)
SELECT 
    f.user_id,
    f.friend_liked_page
FROM unique_user_page u
FULL JOIN unique_friend_page f
    ON u.user_id = f.user_id AND u.user_liked_page = f.friend_liked_page
WHERE u.user_id IS NULL
ORDER BY f.user_id, f.friend_liked_page;





--------------------------------------------DAY 65-------------------------------------------------





CREATE TABLE subscription_history (
    customer_id INT,
    marketplace VARCHAR(10),
    event_date DATE,
    event CHAR(1),
    subscription_period INT
);

INSERT INTO subscription_history VALUES (1, 'India', '2020-01-05', 'S', 6);
INSERT INTO subscription_history VALUES (1, 'India', '2020-12-05', 'R', 1);
INSERT INTO subscription_history VALUES (1, 'India', '2021-02-05', 'C', null);
INSERT INTO subscription_history VALUES (2, 'India', '2020-02-15', 'S', 12);
INSERT INTO subscription_history VALUES (2, 'India', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (3, 'USA', '2019-12-01', 'S', 12);
INSERT INTO subscription_history VALUES (3, 'USA', '2020-12-01', 'R', 12);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-01-10', 'S', 6);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-09-10', 'R', 3);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-12-25', 'C', null);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-06-20', 'S', 12);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (6, 'UK', '2020-07-05', 'S', 6);
INSERT INTO subscription_history VALUES (6, 'UK', '2021-03-05', 'R', 6);
INSERT INTO subscription_history VALUES (7, 'Canada', '2020-08-15', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-09-10', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-12-10', 'C', null);
INSERT INTO subscription_history VALUES (9, 'Canada', '2020-11-10', 'S', 1);


-- SOLUTION 65

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (PARTITION BY customer_id, marketplace ORDER BY event_date DESC) AS rn
            FROM subscription_history WHERE event_date <= '2020-12-31'),
cte1 AS (
            SELECT 
                *,
                CASE 
                    WHEN event = 'C' THEN 1
                    WHEN event IN ('S', 'R') AND (event_date + INTERVAL '1 month' * subscription_period) <= '2020-12-31' THEN 1  
                    ELSE  0
                END AS cancelation_flag
            FROM cte
            WHERE rn = 1)
SELECT 
    customer_id,
    marketplace,
    event_date,
    event,
    subscription_period
FROM cte1
WHERE cancelation_flag = 0


--------------------------------------------DAY 66-------------------------------------------------


create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5);

SELECT * FROM numbers;

-- SOLUTION 66

WITH RECURSIVE cte AS (
    SELECT 
    n,
    1 as counter
    FROM numbers

    UNION ALL

    SELECT 
    n,
    counter + 1 AS counter
    FROM cte
    WHERE counter+1 <= n
)
SELECT * FROM cte
ORDER BY n;



SELECT * 
FROM numbers n1
CROSS JOIN numbers n2
WHERE n1.n >= n2.n
ORDER BY n1.n, n2.n;


--------------------------------------------DAY 67-------------------------------------------------



create table polls
(
user_id varchar(4),
poll_id varchar(3),
poll_option_id varchar(3),
amount int,
created_date date
);
-- Insert sample data into the investments table
INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

create table poll_answers
(
poll_id varchar(3),
correct_option_id varchar(3)
);

-- Insert sample data into the poll_answers table
INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),('p2', 'A');


-- SOLUTION 67

SELECT * FROM polls;
SELECT * FROM poll_answers;


WITH winners_cte AS (
                    SELECT 
                        p.poll_id,
                        p.user_id,
                        p.amount,
                        SUM(amount) OVER (PARTITION BY p.poll_id) AS total_amount_invested_in_poll
                    FROM polls p
                    JOIN poll_answers pa
                        ON p.poll_id = pa.poll_id
                    WHERE p.poll_option_id = pa.correct_option_id),
losers_cte AS (
                    SELECT 
                        p.poll_id,
                        SUM(amount) AS total_amount_invested_in_poll
                    FROM polls p
                    JOIN poll_answers pa
                            ON p.poll_id = pa.poll_id
                    WHERE p.poll_option_id <> pa.correct_option_id
                    GROUP BY p.poll_id)
SELECT 
    w.poll_id,
    w.user_id,
    ROUND( (w.amount / w.total_amount_invested_in_poll::decimal) * l.total_amount_invested_in_poll, 2) AS winning_amount
FROM winners_cte w
JOIN losers_cte l
    ON w.poll_id = l.poll_id;



--------------------------------------------DAY 68-------------------------------------------------


create table events 
(userid int , 
event_type varchar(20),
event_time timestamp);

insert into events VALUES (1, 'click', '2023-09-10 09:00:00');
insert into events VALUES (1, 'click', '2023-09-10 10:00:00');
insert into events VALUES (1, 'scroll', '2023-09-10 10:20:00');
insert into events VALUES (1, 'click', '2023-09-10 10:50:00');
insert into events VALUES (1, 'scroll', '2023-09-10 11:40:00');
insert into events VALUES (1, 'click', '2023-09-10 12:40:00');
insert into events VALUES (1, 'scroll', '2023-09-10 12:50:00');
insert into events VALUES (2, 'click', '2023-09-10 09:00:00');
insert into events VALUES (2, 'scroll', '2023-09-10 09:20:00');
insert into events VALUES (2, 'click', '2023-09-10 10:30:00');


-- SOLUTION 68


SELECT * FROM events;

WITH cte AS (
                SELECT 
                    *,
                    LAG(event_time,1,event_time) OVER (PARTITION BY userid ORDER BY event_time) AS previous_event_time
                FROM events)
, cte1 AS (                
            SELECT 
                *,
                ROUND(EXTRACT(EPOCH FROM (event_time - previous_event_time)) / 60, 0) AS minutes_difference
            FROM cte)
, cte2 AS (
            SELECT 
                *,
                CASE WHEN minutes_difference <= 30 THEN 0 ELSE 1 END AS sesion_flag
            FROM cte1)
, cte3 AS (
            SELECT
                *,
                SUM(sesion_flag) OVER(PARTITION BY userid ORDER BY event_time)+1 AS session_id
            FROM cte2)
SELECT 
    userid,
    session_id,
    MIN(event_time) AS session_start,
    MAX(event_time) AS session_end,
    ROUND(EXTRACT(EPOCH FROM (MAX(event_time) - MIN(event_time))) / 60, 0) AS session_duration,
    COUNT(session_id) AS event_count 
FROM cte3
GROUP BY userid, session_id
ORDER BY userid, session_id;




--------------------------------------------DAY 69-------------------------------------------------




create table assessments
(
id int,
experience int,
sql int,
algo int,
bug_fixing int
);
delete from assessments;
insert into assessments values 
(1,3,100,null,50),
(2,5,null,100,100),
(3,1,100,100,100),
(4,5,100,50,null),
(5,5,100,100,100);

delete from assessments
insert into assessments values 
(1,2,null,null,null),
(2,20,null,null,20),
(3,7,100,null,100),
(4,3,100,50,null),
(5,2,40,100,100);


-- SOLUTIOn 69

SELECT 
    experience,
    COUNT(DISTINCT id) AS total_students,
    COUNT( DISTINCT
    CASE 
        WHEN ( COALESCE(sql,100) + COALESCE(algo,100) + COALESCE(bug_fixing,100) )= 300
    THEN id
    END) AS max_score_students
FROM assessments
GROUP BY experience
ORDER BY experience;




--------------------------------------------DAY 70-------------------------------------------------


CREATE TABLE google_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date TIMESTAMP
);

delete from google_transactions;
INSERT INTO google_transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO google_transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO google_transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO google_transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO google_transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO google_transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO google_transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO google_transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO google_transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO google_transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO google_transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO google_transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO google_transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO google_transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO google_transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO google_transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO google_transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO google_transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');


SELECT * FROM google_transactions;

-- SOLUTION 70

WITH cte AS (
            SELECT 
                *,
                LEAD(customer_id) OVER (PARTITION BY tran_date ORDER BY transaction_id, tran_date) AS buyer_id
            FROM google_transactions)
, buyer_seller_cte AS (
                    SELECT
                        customer_id AS seller_id,
                        buyer_id,
                        COUNT(*) AS no_of_transactions
                    FROM cte
                    WHERE buyer_id IS NOT NULL
                    GROUP BY customer_id, buyer_id
                    ORDER BY COUNT(*) DESC)
, fraud_cte AS (
                    SELECT seller_id AS fraud_id FROM buyer_seller_cte
                    INTERSECT
                    SELECT buyer_id AS fraud_id FROM buyer_seller_cte)
SELECT * 
FROM buyer_seller_cte
WHERE seller_id NOT IN (select fraud_id FROM fraud_cte) 
    AND buyer_id NOT IN (select fraud_id FROM fraud_cte);





--------------------------------------------DAY 71-------------------------------------------------




CREATE TABLE noon_orders (
    Order_id VARCHAR(20),
    Customer_code VARCHAR(20),
    Placed_at TIMESTAMP,
    Restaurant_id VARCHAR(10),
    Cuisine VARCHAR(20),
    Order_status VARCHAR(20),
    Promo_code_Name VARCHAR(20)
);

-- Insert data with multiple restaurants per cuisine
INSERT INTO noon_orders VALUES ('OF1900191801','UFDDN1991918XUY1','2025-01-01 15:30:20','KMKMH6787','Lebanese','Delivered','Tasty50');
INSERT INTO noon_orders VALUES ('OF1900191802','UFDDN1991918XUY1','2025-01-02 12:15:45','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191803','UFDDN1991918XUY1','2025-01-10 18:45:30','PIZZA123','Italian','Cancelled','HUNGRY20');
INSERT INTO noon_orders VALUES ('OF1900191804','UFDDN1991918XUY1','2025-01-15 19:20:15','ITALIAN2','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191805','UFDDN1991918XUY1','2025-01-20 11:30:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191806','ABC1234567890XYZ','2025-01-01 08:45:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191807','ABC1234567890XYZ','2025-01-05 13:20:00','TACO789','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191808','DEF9876543210XYZ','2025-01-02 09:15:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191809','GHI5678901234XYZ','2025-01-03 14:30:00','SUSHI456','Japanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191810','JKL3456789012XYZ','2025-01-04 12:00:00','JAPANESE2','Japanese','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191811','MNO7890123456XYZ','2025-01-05 19:45:00','KMKMH6787','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191812','PQR1234567890ABC','2025-01-06 11:30:00','LEBANESE2','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191813','STU9876543210ABC','2025-01-07 13:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191814','VWX5678901234ABC','2025-01-08 18:00:00','ITALIAN2','Italian','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191815','YZA3456789012ABC','2025-01-09 12:45:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191816','BCD7890123456ABC','2025-01-10 20:15:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191817','EFG1234567890DEF','2025-01-11 09:30:00','TACO789','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191818','HIJ9876543210DEF','2025-01-12 14:45:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191819','KLM5678901234DEF','2025-01-13 17:30:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191820','NOP3456789012DEF','2025-01-14 12:15:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191821','QRS7890123456DEF','2025-01-15 19:00:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191822','TUV1234567890GHI','2025-01-16 10:45:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191823','WXY9876543210GHI','2025-01-17 15:30:00','PIZZA123','Italian','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191824','ZAB5678901234GHI','2025-01-18 18:15:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191825','CDE3456789012GHI','2025-01-19 11:00:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191826','FGH7890123456GHI','2025-01-20 20:45:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191827','IJK1234567890JKL','2025-01-21 09:15:00','TACO789','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191828','LMN9876543210JKL','2025-01-22 14:30:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191829','OPQ5678901234JKL','2025-01-23 17:45:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191830','RST3456789012JKL','2025-01-24 12:30:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191831','UVW7890123456JKL','2025-01-25 19:15:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191832','XYZ1234567890MNO','2025-01-26 10:00:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191833','ABC9876543210MNO','2025-01-27 15:15:00','PIZZA123','Italian','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191834','DEF5678901234MNO','2025-01-28 18:30:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191835','GHI3456789012MNO','2025-01-29 11:45:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191836','JKL7890123456MNO','2025-01-30 20:00:00','AMERICAN2','American','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191837','MNO1234567890PQR','2025-01-31 09:45:00','TACO789','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191838','PQR9876543210PQR','2025-01-31 14:00:00','MEXICAN2','Mexican','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191839','STU5678901234PQR','2025-01-31 17:15:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191840','VWX3456789012PQR','2025-01-31 12:00:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191841','JAN_ONLY_ORDER1','2025-01-15 13:30:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191842','JAN_ONLY_ORDER2','2025-01-20 18:45:00','LEBANESE2','Lebanese','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191843','NO_ORDER_LAST7_1','2025-02-01 12:15:00','PIZZA123','Italian','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191844','NO_ORDER_LAST7_2','2025-02-05 19:30:00','ITALIAN2','Italian','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191845','THIRD_ORDER_CUST1','2025-01-05 11:45:00','BURGER99','American','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191846','THIRD_ORDER_CUST1','2025-01-10 14:15:00','AMERICAN2','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191847','THIRD_ORDER_CUST1','2025-01-15 17:45:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191848','THIRD_ORDER_CUST2','2025-01-10 10:30:00','TACO789','Mexican','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191849','THIRD_ORDER_CUST2','2025-01-15 13:45:00','MEXICAN2','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191850','THIRD_ORDER_CUST2','2025-01-20 16:30:00','TACO789','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191851','MULTI_CUISINE_CUST','2025-01-05 12:00:00','KMKMH6787','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191852','MULTI_CUISINE_CUST','2025-01-10 15:30:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191853','MULTI_CUISINE_CUST','2025-01-15 18:45:00','PIZZA123','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191854','MULTI_CUISINE_CUST','2025-01-20 11:15:00','ITALIAN2','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191855','MULTI_CUISINE_CUST','2025-01-25 14:45:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191856','SINGLE_ORDER_JAN','2025-01-10 19:00:00','AMERICAN2','American','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191857','NO_ORDER_RECENT','2025-02-10 12:30:00','TACO789','Mexican','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191858','NO_ORDER_RECENT','2025-02-15 18:00:00','MEXICAN2','Mexican','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191859','PROMO_FIRST_ONLY','2025-02-01 11:45:00','SUSHI456','Japanese','Delivered','WELCOME50');
INSERT INTO noon_orders VALUES ('OF1900191860','PROMO_FIRST_ONLY','2025-02-05 14:15:00','JAPANESE2','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191861','PROMO_FIRST_ONLY','2025-02-10 17:30:00','SUSHI456','Japanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191862','LAST_ORDER_7DAYS','2025-03-20 10:00:00','KMKMH6787','Lebanese','Delivered','FIRSTORDER');
INSERT INTO noon_orders VALUES ('OF1900191863','LAST_ORDER_7DAYS','2025-03-25 13:15:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191864','LAST_ORDER_7DAYS','2025-03-31 16:30:00','KMKMH6787','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191865','ABC9876543210MNO','2025-02-27 15:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191866','CDE3456789012GHI','2025-03-27 15:15:00','PIZZA123','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191867','ABC9876543210MNO','2025-03-15 15:15:00','LEBANESE2','Lebanese','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191868','ZZZ9876543210MNO','2025-03-20 15:15:00','LEBANESE2','Lebanese','Delivered','NEWUSER');
INSERT INTO noon_orders VALUES ('OF1900191869','UFDDN1991918XUY1','2025-03-28 11:30:00','BURGER99','American','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191870','MULTI_CUISINE_CUST','2025-03-31 14:45:00','PIZZA123','Italian','Delivered',null);
INSERT INTO noon_orders VALUES ('OF1900191871','DEF9876543210XYZ','2025-03-02 09:15:00','KMKMH6787','Lebanese','Delivered','TASTY50');
INSERT INTO noon_orders VALUES ('OF1900191872','UVW7890123456JKL','2025-02-25 19:15:00','KMKMH6787','Lebanese','Delivered','TASTY25');
INSERT INTO noon_orders VALUES ('OF1900191873','UVW7890123456JKL','2025-03-25 19:15:00','PIZZA123','Italian','Delivered','TASTY50');


SELECT * FROM noon_orders;



-- SOLUTION 71


-- Find top restaurant by cuisine type
WITH cte AS (
                SELECT 
                    cuisine,
                    restaurant_id,
                    COUNT(DISTINCT order_id) AS total_orders 
                FROM noon_orders
                GROUP BY cuisine, restaurant_id)
, cte2 AS (
            SELECT 
                *,
                RANK() OVER(PARTITION BY cuisine ORDER BY total_orders DESC)
            FROM cte)
SELECT 
    cuisine,
    restaurant_id,
    total_orders
FROM cte2
WHERE rank = 1;



-- Find daily new customer count
WITH cte AS (
            SELECT 
                *,
                RANK() OVER(PARTITION BY customer_code ORDER BY placed_at) AS rnk
            FROM noon_orders)
SELECT 
    placed_at::DATE,
    COUNT(customer_code) AS new_customers
FROM cte 
WHERE rnk=1
GROUP BY placed_at::DATE
ORDER BY placed_at::DATE;



-- Customers how were acquired in Jan 2025 and only placed one order in Jan 2025 and did not place any other orders
WITH jan_orders AS (
                    SELECT 
                        customer_code,
                        COUNT(DISTINCT order_id) AS total_order_jan
                    FROM noon_orders
                    WHERE placed_at::DATE >= '2025-01-01' AND placed_at::DATE <= '2025-01-31'
                    GROUP BY customer_code
                    HAVING COUNT(DISTINCT order_id) = 1)
, rest_orders AS (                    
                    SELECT 
                        customer_code,
                        COUNT(DISTINCT order_id) AS total_order_rest
                    FROM noon_orders
                    WHERE placed_at::DATE > '2025-01-31'
                    GROUP BY customer_code)
SELECT 
    j.customer_code
FROM jan_orders j
LEFT JOIN rest_orders r
    ON j.customer_code = r.customer_code
WHERE r.customer_code IS NULL;




-- Customers with diference between fisrt and latest order is within days and their fisrt order on promo code

WITH cte AS (
                SELECT 
                    customer_code,
                    MIN(placed_at) AS first_order,
                    MAX(placed_at) AS latest_order
                FROM noon_orders
                GROUP BY customer_code)
, cte2 AS (
                SELECT 
                    c.*,
                    o.promo_code_name AS first_order_promo_code
                FROM cte c
                JOIN noon_orders o
                    ON c.customer_code = o.customer_code AND c.first_order = o.placed_at)
SELECT * 
FROM cte2
WHERE latest_order - first_order <= INTERVAL '7 days' AND first_order_promo_code IS NOT NULL;



-- Growth team is planning to create a trigger that will target customers after their every third order with a personalized communication and they have asked you to create a query for this.

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER(PARTITION BY customer_code ORDER BY placed_at) AS rnk
            FROM noon_orders)
SELECT 
    *
FROM cte
WHERE rnk % 3 = 0;



-- Customers who placed more then one orders and all their orders are on promo code
SELECT 
    customer_code,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT promo_code_name) AS promo_code_used
FROM noon_orders
GROUP BY customer_code
HAVING COUNT(DISTINCT order_id) > 1 AND COUNT(DISTINCT order_id) = COUNT(DISTINCT promo_code_name);



-- Percentage of customer acquired organically (without promo code)

WITH cte AS (
            SELECT 
                *,
                RANK() OVER(PARTITION BY customer_code ORDER BY placed_at) AS rnk
            FROM noon_orders
            WHERE placed_at::DATE >= '2025-01-01' AND placed_at::DATE <= '2025-01-31')
, cte2 AS (
            SELECT 
                COUNT(DISTINCT CASE WHEN promo_code_name IS NULL THEN customer_code END) AS organic_customers,
                COUNT(DISTINCT CASE WHEN promo_code_name IS NOT NULL THEN customer_code END) AS promo_code_customers,
                COUNT(DISTINCT customer_code) AS total_customers
            FROM cte 
            WHERE rnk = 1)
SELECT 
    *,
    ROUND( (organic_customers::DECIMAL / total_customers) * 100, 1) AS pct_organic,
    ROUND( (promo_code_customers::DECIMAL / total_customers) * 100, 1) AS pct_promo_code
FROM cte2;





--------------------------------------------DAY 72-------------------------------------------------



CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time TIMESTAMP,
    end_time TIMESTAMP
);

delete from airports;
INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

delete from flights;
INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');


SELECT * FROM airports;
SELECT * FROM flights;

-- SOLUTION 72

WITH cte AS (
            SELECT 
                f.flight_id,
                f.start_port,
                sa.city_name AS start_city,
                f.end_port,
                ea.city_name AS end_city,
                f.start_time,
                f.end_time
            FROM flights f
            LEFT JOIN airports sa
                ON f.start_port = sa.port_code
            LEFT JOIN airports ea
                ON f.end_port = ea.port_code)
SELECT 
    s.start_city AS start_city,
    e.start_city AS middle_city,
    COALESCE(e.end_city,s.end_city) AS end_city,
    CONCAT_WS('-',s.flight_id,e.flight_id) AS flight,
    ROUND(EXTRACT(EPOCH FROM (COALESCE(e.end_time,s.end_time) - s.start_time)) / 60, 0) AS flight_duration
FROM cte s
LEFT JOIN cte e
    ON s.end_city = e.start_city AND s.end_time <= e.start_time
WHERE e.end_city = 'Tokyo' OR (s.start_city = 'New York' AND s.end_city = 'Tokyo');




--------------------------------------------DAY 73-------------------------------------------------




CREATE TABLE swimming (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

delete from swimming;

INSERT INTO swimming VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO swimming VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO swimming VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO swimming VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO swimming VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO swimming VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO swimming VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO swimming VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO swimming VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO swimming VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO swimming VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO swimming VALUES (12,'500m',2016,'Thomas','Steven','Catherine');


SELECT * FROM swimming;

-- SOLUTION 73

WITH silve_bronze AS (
                        SELECT DISTINCT TRIM(LOWER(silver)) AS winners FROM swimming
                        UNION ALL
                        SELECT DISTINCT TRIM(LOWER(bronze)) AS winners FROM swimming)
, gold AS (
            SELECT
                id,
                TRIM(LOWER(gold)) AS gold_winners
            FROM swimming
            WHERE TRIM(LOWER(gold)) NOT IN (SELECT winners FROM silve_bronze) )
SELECT 
    gold_winners,
    COUNT(*) AS no_of_gold
FROM gold
GROUP BY gold_winners;


--------------------------------------------DAY 74-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.


--------------------------------------------DAY 75-------------------------------------------------



create table hospital ( emp_id int
, action varchar(10)
, time TIMESTAMP);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');


-- SOLUTION 75

WITH cte AS (
            SELECT
                *,
                RANK() OVER(PARTITION BY emp_id ORDER BY time DESC) AS rnk
            FROM hospital)
SELECT 
    emp_id
FROM cte
WHERE rnk = 1 AND action = 'in';





--------------------------------------------DAY 76-------------------------------------------------


create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;

-- SOLUTION 76
WITH cte AS (
            SELECT 
                user_id,
                date_searched,
                UNNEST(STRING_TO_ARRAY(filter_room_types, ',')) AS room_type
            FROM airbnb_searches)
SELECT 
    room_type,
    COUNT(*) AS search_count
FROM cte
GROUP BY room_type;



--------------------------------------------DAY 77-------------------------------------------------


CREATE TABLE emp_salary_1
(
    emp_id INTEGER NOT NULL,
    name VARCHAR(20) NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary_1
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', 11),
(102, 'rohan', '4000', 12),
(103, 'mohan', '5000', 13),
(104, 'cat', '3000', 11),
(105, 'suresh', '4000', 12),
(109, 'mahesh', '7000', 12),
(108, 'kamal', '8000', 11);


-- SOLUTION 77

SELECT e1.*
FROM emp_salary_1 e1
JOIN emp_salary_1 e2
    ON e1.dept_id = e2.dept_id AND e1.salary = e2.salary AND e1.emp_id <> e2.emp_id;




--------------------------------------------DAY 78-------------------------------------------------


create table lt_employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from lt_employee;
insert into lt_employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);

-- SOLUTION 78

SELECT DISTINCT
    dep_id,
    FIRST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC) AS emp_name_max_salary,
    LAST_VALUE(emp_name) OVER(PARTITION BY dep_id ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS emp_name_min_salary
FROM lt_employee;




--------------------------------------------DAY 79-------------------------------------------------


create table call_start_logs
(
phone_number varchar(10),
start_time TIMESTAMP
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00');

create table call_end_logs
(
phone_number varchar(10),
end_time TIMESTAMP
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;


WITH cte_start AS (
                    SELECT *, ROW_NUMBER() OVER() AS id FROM call_start_logs)
, cte_end AS (
                    SELECT *, ROW_NUMBER() OVER() AS id FROM call_end_logs)
SELECT 
    cs.phone_number,
    cs.start_time,
    ce.end_time,
    ROUND(EXTRACT(EPOCH FROM (ce.end_time - cs.start_time)) / 60, 0) AS minutes_duration
FROM cte_start cs
JOIN cte_end ce
    ON cs.id = ce.id;


--------------------------------------------DAY 80-------------------------------------------------

-- Skipped as it is a theoretical question and does not require SQL code.


--------------------------------------------DAY 81-------------------------------------------------

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

-- SOLUTION 81

WITH team AS (
                SELECT 
                    teamid,
                    COUNT(DISTINCT CASE WHEN criteria1 = 'Y' AND criteria2 = 'Y' THEN memberid END) AS total_members
                FROM ameriprise_llc
                GROUP BY teamid)
, qualifies AS (
                SELECT 
                    *,
                    CASE WHEN criteria1 = 'Y' AND criteria2 = 'Y' THEN 'Y' ELSE 'N' END AS qualifies
                FROM ameriprise_llc)
SELECT 
    q.teamid,
    q.memberid,
    q.criteria1,
    q.criteria2
FROM qualifies q
JOIN team t
    ON q.teamid = t.teamid
WHERE qualifies = 'Y' AND total_members >= 2;


-- ALTERNATIVE SOLUTION 81

WITH cte AS (
            SELECT 
                *,
                CASE WHEN criteria1 = 'Y' AND criteria2 = 'Y' THEN 'Y' ELSE 'N' END AS qualifies,
                SUM(CASE WHEN criteria1 = 'Y' AND criteria2 = 'Y' THEN 1 ELSE 0 END) OVER (PARTITION BY teamid) AS eligible_members
            FROM ameriprise_llc)
SELECT 
    teamid,
    memberid,
    criteria1,
    criteria2
FROM cte
WHERE qualifies = 'Y' AND eligible_members >= 2;



--------------------------------------------DAY 82-------------------------------------------------



create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);



-- SOLUTION 82

WITH adult AS (SELECT *, ROW_NUMBER() OVER(ORDER BY age DESC) AS id FROM family WHERE type = 'Adult'),
child AS (SELECT *, ROW_NUMBER() OVER(ORDER BY age) AS id FROM family WHERE type = 'Child')
SELECT 
    a.person,
    c.person
FROM adult a
LEFT JOIN child c
    ON a.id = c.id;





--------------------------------------------DAY 83-------------------------------------------------


create table company_revenue 
(
company varchar(100),
year int,
revenue int
)

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);



-- SOLUTION 83

WITH cte AS (
            SELECT 
                *,
                LAG(revenue,1,0) OVER(PARTITION BY company ORDER BY year) AS prev_year_revenue
            FROM company_revenue)
, cte1 AS (
            SELECT 
                *,
                CASE WHEN (revenue - prev_year_revenue) >= 0 THEN 1 ELSE 0 END AS revenue_inc_flag
            FROM cte)
SELECT 
    company,
    COUNT(*) AS cnt_years,
    SUM(revenue_inc_flag) AS cnt_flag
FROM cte1
GROUP BY company
HAVING COUNT(*) = SUM(revenue_inc_flag);




--------------------------------------------DAY 84-------------------------------------------------


create table people
(id int primary key not null,
 name varchar(20),
 gender char(2));

create table relations
(
    c_id int,
    p_id int,
    FOREIGN KEY (c_id) REFERENCES people(id),
    foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
    (107,'Days','F'),
    (145,'Hawbaker','M'),
    (155,'Hansel','F'),
    (202,'Blackston','M'),
    (227,'Criss','F'),
    (278,'Keffer','M'),
    (305,'Canty','M'),
    (329,'Mozingo','M'),
    (425,'Nolf','M'),
    (534,'Waugh','M'),
    (586,'Tong','M'),
    (618,'Dimartino','M'),
    (747,'Beane','M'),
    (878,'Chatmon','F'),
    (904,'Hansard','F');

insert into relations(c_id, p_id)
values
    (145, 202),
    (145, 107),
    (278,305),
    (278,155),
    (329, 425),
    (329,227),
    (534,586),
    (534,878),
    (618,747),
    (618,904);


SELECT * FROM people;

SELECT * FROM relations;


-- SOLUTION 84

WITH cte AS (
            SELECT 
                c.name AS child_name,
                p.name AS parent_name,
                p.gender AS parent_gender
            FROM relations r
            JOIN people c
                ON r.c_id = c.id
            JOIN people p
                ON r.p_id = p.id)
SELECT
    child_name,
    MIN(CASE WHEN parent_gender = 'M' THEN parent_name END) AS father_name,
    MIN(CASE WHEN parent_gender = 'F' THEN parent_name END) AS mother_name
FROM cte
GROUP BY child_name;


--------------------------------------------DAY 85-------------------------------------------------



create table icc_world_cup_new
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup_new values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup_new values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup_new values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup_new values(4,'SA','SL','SA');
INSERT INTO icc_world_cup_new values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup_new values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup_new values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup_new values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup_new values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup_new values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup_new values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup_new values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup_new values(12,'SA','IND','IND');



-- SOLUTION 85


WITH all_matches AS (
                    SELECT 
                        team_1,
                        COUNT(*) AS cnt_matches,
                        SUM(CASE WHEN team_1=winner THEN 1 ELSE 0 END) AS win_flag 
                    FROM icc_world_cup_new
                    GROUP BY team_1
                    UNION ALL
                    SELECT 
                        team_2,
                        COUNT(*) AS cnt_matches,
                        SUM(CASE WHEN team_2=winner THEN 1 ELSE 0 END) AS win_flag 
                    FROM icc_world_cup_new
                    GROUP BY team_2)
SELECT 
    team_1 AS teams,
    SUM(cnt_matches) AS matches_played,
    SUM(win_flag) AS total_wins,
    (SUM(cnt_matches) - SUM(win_flag)) AS total_loss,
    (SUM(win_flag) * 2) AS total_points
FROM all_matches
GROUP BY team_1
ORDER BY SUM(win_flag) DESC;



--------------------------------------------DAY 86-------------------------------------------------


create table source(id int, name varchar(5))

create table target(id int, name varchar(5))

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D')

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');


SELECT * FROM source;

SELECT * FROM target;


-- SOLUTION 86

WITH cte AS (
                SELECT 
                    s.id AS source_id,
                    s.name AS source_name,
                    t.id AS target_id,
                    t.name AS target_name,
                    CASE 
                        WHEN s.id IS NOT NULL AND t.id IS NULL THEN 'New in source'
                        WHEN s.id IS NULL AND t.id IS NOT NULL THEN 'New in target'
                        WHEN s.id = t.id AND s.name <> t.name THEN 'Mismatch'
                        ELSE NULL
                    END AS comment
                FROM source s
                FULL JOIN target t
                    ON s.id = t.id)
SELECT 
    COALESCE(source_id, target_id),
    comment
FROM cte
WHERE comment IS NOT NULL;



--------------------------------------------DAY 87-------------------------------------------------



-- Skipped as it is a theoretical question and does not require SQL code.



--------------------------------------------DAY 88-------------------------------------------------


CREATE TABLE FAMILIES (
    ID VARCHAR(50),
    NAME VARCHAR(50),
    FAMILY_SIZE INT
);

-- Insert data into FAMILIES table
INSERT INTO FAMILIES (ID, NAME, FAMILY_SIZE)
VALUES 
    ('c00dac11bde74750b4d207b9c182a85f', 'Alex Thomas', 9),
    ('eb6f2d3426694667ae3e79d6274114a4', 'Chris Gray', 2),
  ('3f7b5b8e835d4e1c8b3e12e964a741f3', 'Emily Johnson', 4),
    ('9a345b079d9f4d3cafb2d4c11d20f8ce', 'Michael Brown', 6),
    ('e0a5f57516024de2a231d09de2cbe9d1', 'Jessica Wilson', 3);

-- Create COUNTRIES table
CREATE TABLE COUNTRIES (
    ID VARCHAR(50),
    NAME VARCHAR(50),
    MIN_SIZE INT,
 MAX_SIZE INT
);

INSERT INTO COUNTRIES (ID, NAME, MIN_SIZE,MAX_SIZE)
VALUES 
    ('023fd23615bd4ff4b2ae0a13ed7efec9', 'Bolivia', 2 , 4),
    ('be247f73de0f4b2d810367cb26941fb9', 'Cook Islands', 4,8),
    ('3e85ab80a6f84ef3b9068b21dbcc54b3', 'Brazil', 4,7),
    ('e571e164152c4f7c8413e2734f67b146', 'Australia', 5,9),
    ('f35a7bb7d44342f7a8a42a53115294a8', 'Canada', 3,5),
    ('a1b5a4b5fc5f46f891d9040566a78f27', 'Japan', 10,12);


-- SOLUTION 88

SELECT * FROM families;

SELECT * FROM countries;

SELECT 
    f.name,
    COUNT(*) AS countries_eligible
FROM families f
CROSS JOIN countries c
WHERE f.family_size >= c.min_size AND f.family_size <= max_size
GROUP BY f.name
ORDER BY COUNT(*) DESC;



--------------------------------------------DAY 89-------------------------------------------------


CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);


INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
    ('DEF456', 'BOM', 'DEL', 'O', 150),
    ('GHI789', 'DEL', 'BOM', 'R', 50),
    ('JKL012', 'BOM', 'DEL', 'R', 75),
    ('MNO345', 'DEL', 'NYC', 'O', 200),
    ('PQR678', 'NYC', 'DEL', 'O', 180),
    ('STU901', 'NYC', 'DEL', 'R', 60),
    ('ABC123', 'DEL', 'BOM', 'O', 100),
    ('VWX234', 'DEL', 'NYC', 'R', 90);



-- SOLUTION 89

WITH cte AS (
                SELECT 
                    origin, destination, oneway_round, ticket_count
                FROM tickets
                UNION ALL
                SELECT
                    destination, origin, oneway_round, ticket_count
                FROM tickets
                WHERE oneway_round = 'R')
SELECT 
    origin,
    destination,
    SUM(ticket_count) AS total_tickets
FROM cte
GROUP BY origin, destination
ORDER BY SUM(ticket_count) DESC;



--------------------------------------------DAY 90-------------------------------------------------



-- Skipped as it is a theoretical question and does not require SQL code.



--------------------------------------------DAY 91------------------------------------------------

CREATE TABLE city_population (
    state VARCHAR(50),
    city VARCHAR(50),
    population INT
);

-- Insert the data
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'ambala', 100);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'panipat', 200);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'gurgaon', 300);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'amritsar', 150);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'ludhiana', 400);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'jalandhar', 250);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'mumbai', 1000);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'pune', 600);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'nagpur', 300);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'bangalore', 900);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mysore', 400);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mangalore', 200);

-- SOLUTION 91

SELECT DISTINCT
    state,
    FIRST_VALUE(city) OVER(PARTITION BY state ORDER BY population DESC) AS min_pop,
    LAST_VALUE(city) OVER(PARTITION BY state ORDER BY population DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_pop
FROM city_population;



--------------------------------------------DAY 92------------------------------------------------



CREATE TABLE seats (
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats VALUES 
(1, 'Amit'),
(2, 'Deepa'),
(3, 'Rohit'),
(4, 'Anjali'),
(5, 'Neha'),
(6, 'Sanjay'),
(7, 'Priya');


-- SOLUTION 92

SELECT 
    *,
    CASE WHEN id = (SELECT MAX(id) FROM seats) AND id % 2 = 1 THEN id -- For last id
         WHEN id % 2 = 0 THEN id-1  -- For even ids
         ELSE id+1  -- For odd ids
    END AS new_id
FROM seats;



-- ALTERNATE SOLUTION 92

SELECT 
    *,
    CASE WHEN id = (SELECT MAX(id) FROM seats) AND id % 2 = 1 THEN id -- For last id
         WHEN id % 2 = 0 THEN LAG(id) OVER(ORDER BY id) -- For even ids
         ELSE LEAD(id) OVER(ORDER BY id)  -- For odd ids
    END AS new_id
FROM seats;





--------------------------------------------DAY 93------------------------------------------------


-- Same as 13


--------------------------------------------DAY 94------------------------------------------------



create table game (

 player_id     int     ,
 device_id     int     ,
 event_date    date    ,
 games_played  int
 );

 insert into game values (1,2,'2016-03-01',5 ),(1,2,'2016-03-02',6 ),(2,3,'2017-06-25',1 )
 ,(3,1,'2016-03-02',0 ),(3,4,'2018-07-03',5 );

 select * from game;



-- SOLUTION 93



-- Write an SQL query that reports the first login date for each player

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rnk
            FROM game)
SELECT 
    player_id,
    event_date AS login_date
FROM cte 
WHERE rnk = 1;

-- Write a SQL query that reports the device that is first logged in for each player

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rnk
            FROM game)
SELECT 
    player_id,
    device_id
FROM cte 
WHERE rnk = 1;



--q3: Write an SQL query that reports for each player and date, how many games played so far by the player.
--That is, the total number of games played by the player until that date.

WITH cte AS (
            SELECT 
                *,
                SUM(games_played) OVER(PARTITION BY player_id ORDER BY event_date) AS cumulative_games_played,
                ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date DESC) AS rnk
            FROM game)
SELECT 
    player_id,
    event_date,
    cumulative_games_played
FROM cte
WHERE rnk = 1;


--q4: Write an SQL query that reports the fraction of players that logged in again
-- on the day after the day they first logged in, rounded to 2 decimal places

WITH cte AS (
            SELECT 
                *,
                ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rnk,
                LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS next_date
            FROM game)
SELECT 
    COUNT( DISTINCT CASE WHEN rnk = 1 AND (next_date - event_date) = 1 THEN player_id END ) AS logged_in_next_day,
    COUNT(DISTINCT player_id) as total_players, 
    ROUND(
        COUNT(DISTINCT CASE WHEN rnk = 1 AND (next_date - event_date) = 1 THEN player_id END)::NUMERIC 
        / COUNT(DISTINCT player_id), 
    2) AS fraction
FROM cte;




--------------------------------------------DAY 95------------------------------------------------



-- Create the table
DROP TABLE IF EXISTS linkedin_details;
CREATE TABLE linkedin_details (
    id SERIAL,
    emp_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO linkedin_details (emp_name, city) VALUES
('Sam', 'New York'),
('David', 'New York'),
('Peter', 'New York'),
('Chris', 'New York'),
('John', 'New York'),
('Steve', 'San Francisco'),
('Rachel', 'San Francisco'),
('Robert', 'Los Angeles');





-- SOLUTION 95

WITH emp AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY city ORDER BY id) AS rn
    FROM linkedin_details)
, cte1 AS (
            SELECT 
                *,
                CASE WHEN rn % 4 = 0 THEN 1 ELSE 0 END AS team_flag
            FROM emp)
, cte2 AS (
            SELECT 
                *,
                SUM(team_flag) OVER(PARTITION BY city ORDER BY id)+1 AS team_group
            FROM cte1
            )
SELECT 
    city,
    CONCAT('Team', ' ', team_group),
    STRING_AGG(emp_name, ', ' ORDER BY emp_name)
FROM cte2
GROUP BY city, team_group;




--------------------------------------------DAY 96------------------------------------------------


-- Create tables
CREATE TABLE vypar_department (
    dep_id INT,
    dep_name VARCHAR(50)
);

CREATE TABLE vypar_empdetails (
    emp_id INT,
    first_name VARCHAR(50),
    gender VARCHAR(1),
    dep_id INT
);

CREATE TABLE vypar_client (
    client_id INT,
    client_name VARCHAR(50)
);

CREATE TABLE vypar_empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert data
INSERT INTO vypar_department (dep_id, dep_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

INSERT INTO vypar_empdetails (emp_id, first_name, gender, dep_id) VALUES
(101, 'Alice', 'F', 1),
(102, 'Bob', 'M', 1),
(103, 'Charlie', 'M', 2),
(104, 'Diana', 'F', 2),
(105, 'Ethan', 'M', 3),
(106, 'Fiona', 'F', 3);

INSERT INTO vypar_client (client_id, client_name) VALUES
(1, 'Amazon'),
(2, 'Walmart'),
(3, 'Costco'),
(4, 'Target'),
(5, 'BestBuy');

INSERT INTO vypar_empsales (emp_id, client_id, sales) VALUES
(101, 1, 5000),
(101, 2, 3000),
(102, 1, 7000),
(102, 3, 2000),
(103, 2, 4000),
(103, 4, 3000),
(104, 4, 6000),
(105, 5, 8000),
(106, 3, 5000),
(106, 5, 2000);



-- SOLUTION 96


SELECT * FROM vypar_empsales;
SELECT * FROM vypar_empdetails;

WITH cte AS (
            SELECT 
                es.*,
                ed.dep_id
            FROM vypar_empsales es 
            JOIN vypar_empdetails ed
                ON ed.emp_id = es.emp_id),
cte2 AS (
            SELECT 
                *,
                RANK() OVER(PARTITION BY dep_id ORDER BY sales DESC) AS rnk
            FROM cte)
SELECT 
    d.dep_name,
    ed.first_name AS emp_name,
    cl.client_name AS client_name
FROM cte2 c
JOIN vypar_department d
    ON c.dep_id = d.dep_id
JOIN vypar_empdetails ed
    ON c.emp_id = ed.emp_id
JOIN vypar_client cl
    ON c.client_id = cl.client_id
WHERE rnk = 1;




--------------------------------------------DAY 97------------------------------------------------


CREATE TABLE football_matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);
delete from football_matches;
INSERT INTO football_matches (match_id, winning_team_id, losing_team_id, goals_won) VALUES
(1, 1001, 1007, 1),
(2, 1007, 1001, 2),
(3, 1006, 1003, 3),
(4, 1001, 1003, 1),
(5, 1007, 1001, 1),
(6, 1006, 1003, 2),
(7, 1006, 1001, 3),
(8, 1007, 1003, 5),
(9, 1001, 1003, 1),
(10, 1007, 1006, 2),
(11, 1006, 1003, 3),
(12, 1001, 1003, 4),
(13, 1001, 1006, 2),
(14, 1007, 1001, 4),
(15, 1006, 1007, 3),
(16, 1001, 1003, 3),
(17, 1001, 1007, 3),
(18, 1006, 1007, 2),
(19, 1003, 1001, 1);

insert into football_matches values
(20, 1001, 1007, 3),
(21, 1001, 1003, 3);



-- SOLUTION 97
WITH cte AS (
            SELECT winning_team_id, 1 AS points, goals_won FROM football_matches
            UNION ALL
            SELECT losing_team_id, -1 AS points, 0 AS goals_won FROM football_matches),
cte2 AS (
            SELECT 
                winning_team_id AS team_id,
                SUM(points) AS total_points,
                SUM(goals_won) AS total_goals_won
            FROM cte
            GROUP BY winning_team_id)
SELECT 
    *,
    RANK() OVER(ORDER BY total_points DESC) AS team_rank
FROM cte2;


insert into football_matches values
(20, 1001, 1007, 3),
(21, 1001, 1003, 3);



WITH cte AS (
            SELECT winning_team_id, 1 AS points, goals_won FROM football_matches
            UNION ALL
            SELECT losing_team_id, -1 AS points, 0 AS goals_won FROM football_matches),
cte2 AS (
            SELECT 
                winning_team_id AS team_id,
                SUM(points) AS total_points,
                SUM(goals_won) AS total_goals_won
            FROM cte
            GROUP BY winning_team_id)
SELECT 
    *,
    RANK() OVER(ORDER BY total_points DESC, total_goals_won DESC) AS team_rank
FROM cte2;





--------------------------------------------DAY 98------------------------------------------------

-- Same as 50

--------------------------------------------DAY 99------------------------------------------------

CREATE TABLE subscribers (
  customer_id INT,
  subscription_date DATE,
  plan_value INT
);

INSERT INTO subscribers VALUES
(1, '2023-03-02', 799),
(1, '2023-04-01', 599),
(1, '2023-05-01', 499),
(2, '2023-04-02', 799),
(2, '2023-07-01', 599),
(2, '2023-09-01', 499),
(3, '2023-01-01', 499),
(3, '2023-04-01', 599),
(3, '2023-07-02', 799),
(4, '2023-04-01', 499),
(4, '2023-09-01', 599),
(4, '2023-10-02', 499),
(4, '2023-11-02', 799),
(5, '2023-10-02', 799),
(5, '2023-11-02', 799),
(6, '2023-03-01', 499);



-- SOLUTION 99

WITH cte AS (
            SELECT 
                *,
                LAG(plan_value,1,plan_value) OVER (PARTITION BY customer_id ORDER BY subscription_date) AS prev_plan_value
            FROM subscribers),
cte2 AS (
            SELECT
                *,
                CASE WHEN plan_value > prev_plan_value THEN 1 ELSE 0 END AS has_upgraded,
                CASE WHEN plan_value < prev_plan_value THEN 1 ELSE 0 END AS has_dowgraded
            FROM cte)
SELECT 
    customer_id,
    CASE WHEN MAX(has_upgraded) = 1 THEN 'Yes' ELSE 'No' END AS has_upgraded,
    CASE WHEN MAX(has_dowgraded) = 1 THEN 'Yes' ELSE 'No' END AS has_dowgraded
FROM cte2
GROUP BY customer_id;