# techshop

<img width="1095" height="573" alt="image" src="https://github.com/user-attachments/assets/2d9d6014-39f3-4ef6-9c4e-4014ba72737d" />

Ovaj upit pokazuje kako povezujemo proizvode i kategorije.


	SELECT p.name, c.name AS category, p.price, p.stock
	FROM products p
	JOIN categories c ON p.category_id = c.id;

Ovaj upit pokazuje povijest kupovine prvog kupca (id=1)


	SELECT o.id, o.order_date, o.total_amount, o.status
	FROM orders o
	WHERE o.customer_id = 1;

	
Ovaj upit vraća proizvode s prosječnom ocjenom 4 ili više, koristeći agregatnu funkciju i grupiranje.

	SELECT p.name, AVG(r.rating) AS prosjecna_ocjena
	FROM reviews r
	JOIN products p ON r.product_id = p.id
	GROUP BY p.id
	HAVING prosjecna_ocjena >= 4;
		
