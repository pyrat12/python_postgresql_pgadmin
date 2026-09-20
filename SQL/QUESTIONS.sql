
1. What are the details of all customers whose country is 'Spain'?
SELECT *
FROM customers
WHERE country = 'Spain';

 index | customerid |             customername             |    contactname    |        address         |   city    | postalcode | country 
-------+------------+--------------------------------------+-------------------+------------------------+-----------+------------+---------
     7 |          8 | Bólido Comidas preparadas            | Martín Sommer     | C/ Araquil, 67         | Madrid    | 28023      | Spain
    21 |         22 | FISSA Fabrica Inter. Salchichas S.A. | Diego Roel        | C/ Moralzarzal, 86     | Madrid    | 28034      | Spain
    28 |         29 | Galería del gastrónomo               | Eduardo Saavedra  | Rambla de Cataluña, 23 | Barcelona | 8022       | Spain
    29 |         30 | Godos Cocina Típica                  | José Pedro Freyre | C/ Romero, 33          | Sevilla   | 41101      | Spain
    68 |         69 | Romero y tomillo                     | Alejandra Camino  | Gran Vía, 1            | Madrid    | 28001      | Spain


2. What are the distinct cities of customers from Germany with a city containing the letter 'B'?
SELECT DISTINCT city
FROM customers
WHERE country = 'Germany'
AND city LIKE '%B%';
    city     
-------------
 Berlin
 Brandenburg


3. What are the number of orders placed by each customer? Sort the result by the number of orders in descending order.
SELECT customers.customerid,
       customers.customername,
       COUNT(orders.orderid) AS number_of_orders
FROM customers
INNER JOIN orders
ON customers.customerid = orders.customerid
GROUP BY customers.customerid, customers.customername
ORDER BY number_of_orders DESC;


4. What are the customers who have placed more than 3 orders?


5. What are the top 5 most expensive products? Round the price to 2 decimal places.
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;
 index | productid |       productname       | supplierid | categoryid |         unit         | price  
-------+-----------+-------------------------+------------+------------+----------------------+--------
    37 |        38 | Côte de Blaye           |         18 |          1 | 12 - 75 cl bottles   |  263.5
    28 |        29 | Thüringer Rostbratwurst |         12 |          6 | 50 bags x 30 sausgs. | 123.79
     8 |         9 | Mishi Kobe Niku         |          4 |          6 | 18 - 500 g pkgs.     |     97
    19 |        20 | Sir Rodneys Marmalade  |          8 |          3 | 30 gift boxes        |     81
    17 |        18 | Carnarvon Tigers        |          7 |          8 | 16 kg pkg.           |   62.5


6. What are the order details (ProductID, Quantity) for customers from France?


7. Area there products without a category assigned?
SELECT *
FROM products
WHERE categoryid is NULL;
 index | productid | productname | supplierid | categoryid | unit | price 
-------+-----------+-------------+------------+------------+------+-------
(0 rows)

8. What are all orders and their employees?


9. What is the average, minimum, and maximum price of products? Round the values to 2 decimal places.


10. What are the products with prices between 10 and 50? Round the price to 2 decimal places and sort the result by price in descending order.
SELECT * , ROUND(price::numeric, 2)
FROM products
WHERE price >= 10 AND price <= 50
ORDER BY price DESC;

11. What are the shippers and the total number of orders shipped by each shipper, including those with no orders?


12. What are the employees who have processed > 5 orders? Sort the result by the number of orders in descending order.


13. What is the total revenue for each product within each order, including the product name and ordered by order ID and total revenue in descending order?


14. What are the customers, employees, and the total number of orders placed by each customer?


15. What are the products with an average price higher than the overall average product price? 
    Round the price to 2 decimal places and sort the result by price in descending order.
SELECT *, ROUND(price::numeric, 2)
FROM products
WHERE price > (
SELECT AVG(price) FROM products)
ORDER BY price DESC;
