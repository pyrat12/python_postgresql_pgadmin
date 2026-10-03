
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
LEFT JOIN orders
ON customers.customerid = orders.customerid
GROUP BY customers.customerid, customers.customername
ORDER BY number_of_orders DESC;


4. What are the customers who have placed more than 3 orders?
SELECT
    CustomerID,
    COUNT(OrderID) AS OrderCount    --Zählt, wie viele OrderID-Werte es pro Gruppe gibt unn gibt dieser berechneten Spalte den Namen OrderCount
FROM orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;          --WHERE nicht erlaubt in Aggregatfunktion


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
--Genau — direkt kannst du Customers nicht mit OrderDetails joinen, weil ihnen keine gemeinsame Schlüsselspalte fehlt
--Du brauchst eine Zwischentabelle, die beide verbindet
--Schau also, welche gemeinsame ID Customers mit Orders hat und welche gemeinsame ID Orders mit OrderDetails hat. Dann brauchst du zwei INNER JOINs!
--Tabelle orders als BRÜCKE, auch wenn man sie gar nicht ausgeben will, da sie customerid und orderid enthält

SELECT
orderdetails.quantity,
orderdetails.productid
FROM customers

INNER JOIN orders
    ON customers.customerid = orders.customerid
INNER JOIN orderdetails
    ON orders.orderid = orderdetails.orderid
WHERE country = 'France'
;


7. Area there products without a category assigned?
SELECT *
FROM products
WHERE categoryid is NULL;
 index | productid | productname | supplierid | categoryid | unit | price 
-------+-----------+-------------+------------+------------+------+-------
(0 rows)


8. What are all orders and their employees?
--Du musst Informationen aus orders mit den zugehörigen Informationen aus employees verbinden

SELECT
CAST(employees.employeeid AS TEXT) || ' ' || -- employeeid in Text umwandeln und konkatenieren
employees.firstname || ' ' || -- Vorname konkatenieren
employees.lastname AS Employee, -- Nachname konkatenieren. Somit sind alle 3 employee-Spalten konkateniert zu employee (meine eigene Idee)
-- AS kommt hier direkt nach dem letzten zu aggregierenden Feld, danach das Komma
orders.orderid
FROM orders

INNER JOIN employees
    ON orders.employeeid = employees.employeeid;


9. What is the average, minimum, and maximum price of products? Round the values to 2 decimal places.
--In PostgreSQL funktioniert ROUND(..., 2) nur mit NUMERIC => CAST
SELECT
ROUND(CAST(MIN(price) AS NUMERIC), 2) AS "Minimum Price",  -- Unbedingt Doppelte Anführungszeichen verwenden!
ROUND(CAST(MAX(price) AS NUMERIC), 2) AS "Maximum Price",
ROUND(CAST(AVG(price) AS NUMERIC), 2) AS "Average Price"
FROM products
;


10. What are the products with prices between 10 and 50? Round the price to 2 decimal places and sort the result by price in descending order.
SELECT * , ROUND(price::numeric, 2)
FROM products
WHERE price >= 10 AND price <= 50
ORDER BY price DESC;

11. What are the shippers and the total number of orders shipped by each shipper, including those with no orders?
SELECT
shippers.shippername,
COUNT(orders.OrderID) AS "Total Orders"
FROM shippers

--Du willst also alle Zeilen aus shippers behalten, unabhängig davon, ob eine passende Order existiert
--Behalte ALLES von der linken Tabelle (shippers). Suche dazu passende Zeilen aus der rechten Tabelle (orders)
--Gibt es keine, bleibt der Shipper trotzdem im Ergebnis => LEFT JOIN
--D.h. mit Left Join haben wir quasi links die Tabelle shippers und fügen hinzu werte (wo vorhanden) aus der rechten Tabelle orders

LEFT JOIN orders
    ON shippers.shipperid = orders.shipperid

GROUP BY 
shippers.shipperid,
shippers.shippername;


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
