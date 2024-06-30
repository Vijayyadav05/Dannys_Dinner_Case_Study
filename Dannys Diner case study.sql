use dannys_dinner;
select * from sales;
select * from menu;
select * from members;
# 1. What is the total amount each customer spent at the restaurant?
select customer_id,sum(price) from sales inner join menu using(product_id)
group by customer_id;
# 2. How many days has each customer visited the restaurant?
select customer_id,count(order_date) as "Customer visit" from sales group by customer_id;
select * from sales;
select * from menu;
# 3. What was the first item from the menu purchased by each customer?
with info as(
select customer_id,product_name,min(order_date) as first_item from sales inner join menu using(product_id)
group by customer_id,product_name),
rank_info as (
select customer_id,product_name,first_item, rank() over(partition by customer_id order by first_item)
 as rk from info)
select customer_id,product_name,first_item from rank_info where rk=1;
# 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select * from sales;
select product_id,product_name,no_of_purchased_item from (
select product_id,count(product_id) as no_of_purchased_item from sales group by product_id order by
 count(product_id) desc limit 1) t inner join menu m using (product_id) ;
 # 5. Which item was the most popular for each customer?
 select * from sales;
 with cust_info as (
 select customer_id,product_id,count(customer_id) as number_of_time from sales
 group by product_id,customer_id),
 rank_info as (
 select *,rank() over(partition by customer_id order by number_of_time desc) as rk from cust_info)
 select customer_id,product_id,product_name,number_of_time from rank_info inner join menu using
 (product_id) where rk=1 order by customer_id;
 # 6. Which item was purchased first by the customer after they became a member?
 select * from members;
 with cust_info as (
 select s.customer_id,m.product_name,min(s.order_date) as first_purchased from sales as s inner join members as a
 on s.customer_id = a.customer_id and s.order_date > a.join_date inner join menu as m using(product_id) group by
 s.customer_id,m.product_name order by customer_id),
 rank_info as (
 select *,rank() over(partition by customer_id order by first_purchased) as rk from cust_info)
 select customer_id,product_name,first_purchased from rank_info where rk=1;
 # 7. Which item was purchased just before the customer became a member?
 with cust_info as (
 select s.customer_id,m.product_name,max(s.order_date) as Before_member from sales as s inner
 join members as b on s.customer_id = b.customer_id and order_date < join_date inner join 
 menu as m using(product_id) group by s.customer_id,m.product_name),
 rank_info as (
 select *,rank() over (partition by customer_id order by Before_member desc) as rk from cust_info)
 select customer_id,product_name,Before_member from rank_info where rk=1;
 select * from sales;
 select* from members;
 # 8. What is the total items and amount spent for each member before they became a member?
 select * from menu;
 select * from sales;
 select s.customer_id,count(m.product_name) as 'total items',sum(m.price) as 'total Amount'from sales
 as s inner join menu as m using (product_id) inner join members as c  on
 s.customer_id = c.customer_id and order_date< join_date  group by customer_id order by s.customer_id;
 # 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
 -- how many points would each customer have?
 select s.customer_id, sum(case when m.product_name='sushi' then m.price*20 else m.price*10 end) as 'total Points'
 from sales as s inner join menu as m using (product_id) group by s.customer_id;
 # 10. In the first week after a customer joins the program (including their join date) they earn 2x points
 -- on all items, not just sushi - how many points do customer A and B have at the end of January?
 select s.customer_id, sum(CASE WHEN s.order_date between b.join_date and 
DATE_ADD(b.join_date, interval 6 day) THEN m.price * 20 WHEN m.product_name = 'sushi' 
THEN m.price * 20 ELSE m.price * 10 END) AS total_points
from sales s JOIN menu m ON s.product_id = m.product_id
JOIN members b ON s.customer_id = b.customer_id
WHERE s.order_date <= '2021-01-31' group by  s.customer_id
order by customer_id;
 
 
 
 
 
 
 







