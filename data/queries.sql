-- Query 1: Elenca tutti i clienti
SELECT * FROM customers;

-- Query 2: Trova tutti gli ordini effettuati da un cliente specifico
SELECT * FROM orders WHERE customerNumber = 103;

-- Query 3: Elenca i prodotti disponibili in magazzino
SELECT * FROM products WHERE quantityInStock > 0;

-- Query 4: Mostra il totale degli ordini per ogni cliente
SELECT customerNumber, COUNT(*) AS totalOrders
FROM orders
GROUP BY customerNumber;

-- Query 5: Elenca i dettagli degli ordini per un determinato ordine
SELECT * FROM orderdetails WHERE orderNumber = 10100;

-- Query 6: Trova i dipendenti che lavorano nell'ufficio di San Francisco
SELECT * FROM employees
WHERE officeCode = (SELECT officeCode FROM offices WHERE city = 'San Francisco');

-- Query 7: Elenca i clienti e i loro rappresentanti di vendita
SELECT c.customerName, e.firstName, e.lastName
FROM customers c
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber;

-- Query 8: Mostra i prodotti ordinati almeno 10 volte
SELECT productCode, SUM(quantityOrdered) AS totalOrdered
FROM orderdetails
GROUP BY productCode
HAVING totalOrdered >= 10;

-- Query 9: Elenca tutti gli uffici in Europa
SELECT * FROM offices WHERE country IN ('France', 'UK', 'Spain');

-- Query 10: Trova i clienti che non hanno ancora effettuato ordini
SELECT * FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM orders);

-- Query 11: Trova i 5 clienti con il maggior numero di ordini
SELECT c.customerName, COUNT(o.orderNumber) AS numOrders
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
ORDER BY numOrders DESC
LIMIT 5;

-- Query 12: Calcola il fatturato totale per ogni prodotto
SELECT p.productName, SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productName
ORDER BY totalRevenue DESC;

-- Query 13: Elenca i clienti che hanno ordinato prodotti esauriti
SELECT DISTINCT c.customerName
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE p.quantityInStock = 0;

-- Query 14: Trova i dipendenti che non sono rappresentanti di vendita di nessun cliente
SELECT * FROM employees e
WHERE e.employeeNumber NOT IN (SELECT salesRepEmployeeNumber FROM customers WHERE salesRepEmployeeNumber IS NOT NULL);

-- Query 15: Elenca i prodotti che non sono mai stati ordinati
SELECT * FROM products
WHERE productCode NOT IN (SELECT productCode FROM orderdetails);

-- Query 16: Trova il cliente che ha speso di più in totale
SELECT c.customerName, SUM(od.quantityOrdered * od.priceEach) AS totalSpent
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
ORDER BY totalSpent DESC
LIMIT 1;

-- Query 17: Elenca per ogni città il numero di clienti
SELECT city, COUNT(*) AS numClients
FROM customers
GROUP BY city
ORDER BY numClients DESC;

-- Query 18: Trova gli ordini che contengono più di 3 prodotti diversi
SELECT orderNumber, COUNT(DISTINCT productCode) AS numProducts
FROM orderdetails
GROUP BY orderNumber
HAVING numProducts > 3;

-- Query 19: Elenca i clienti che hanno effettuato ordini in tutti gli anni presenti nel database
SELECT c.customerName
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
HAVING COUNT(DISTINCT YEAR(o.orderDate)) = (SELECT COUNT(DISTINCT YEAR(orderDate)) FROM orders);

-- Query 20: Trova i prodotti più ordinati per ogni categoria
SELECT p.productLine, p.productName, SUM(od.quantityOrdered) AS totalOrdered
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine, p.productName
HAVING totalOrdered = (
	SELECT MAX(sub.totalOrdered)
	FROM (
		SELECT p2.productLine, p2.productName, SUM(od2.quantityOrdered) AS totalOrdered
		FROM products p2
		JOIN orderdetails od2 ON p2.productCode = od2.productCode
		WHERE p2.productLine = p.productLine
		GROUP BY p2.productLine, p2.productName
	) sub
	WHERE sub.productLine = p.productLine
);
