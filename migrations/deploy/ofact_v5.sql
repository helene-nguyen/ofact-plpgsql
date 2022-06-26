-- Deploy ofact_sqitch:ofact_v5 to pg

BEGIN;



--* Use my created view to have expected result
CREATE VIEW invoice_recap AS
SELECT 
I."Invoice_Ref",
I."Date issue",
I."Payment date",
I."Visitor",
SUM(I."Total price per product")::numeric(10,2) AS "Total invoice"
FROM invoice_details AS I
GROUP BY 
I."Invoice_Ref",
I."Date issue",
I."Payment date",
I."Visitor"
ORDER BY I."Invoice_Ref";

-- Search invoice recap :
--SELECT * FROM invoice_recap;

--* Subqueries version

-- CREATE VIEW invoice_recap2 AS
-- SELECT 
--     I.id "Invoice_Ref", 
--     I.issued_at "Date issue", 
--     I.paid_at "Payment date",
-- 	(SELECT "name" 
--      FROM "visitor" 
--      WHERE "id" = I.visitor_id) "Visitor",
-- 	(SELECT SUM((price_with_taxes) * (SELECT "quantity" FROM "invoice_line" 
--                                       WHERE "product_id" = P.id AND invoice_id = I.id))
--      FROM product AS P
--      -- Source https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-any/
--      -- The = ANY is equivalent to IN operator
--      WHERE id = ANY (SELECT product_id 
--                      FROM invoice_line
--                      WHERE invoice_id = I.id) 
-- 	)::NUMERIC(10,2) AS "Total"
-- FROM invoice AS I;

-- SELECT * FROM invoice_recap2;

COMMIT;
