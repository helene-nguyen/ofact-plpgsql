
# Utilisation d'une view dans une fonction

```sql
BEGIN;

--* Use my created view to have expected result
CREATE VIEW invoice_recap AS
SELECT 
invoice_details."Invoice_Ref",
invoice_details."Date issue",
invoice_details."Payment date",
invoice_details."Visitor",
SUM(invoice_details."Total price per product")::numeric(10,2) AS "Total invoice"
FROM invoice_details
GROUP BY 
invoice_details."Invoice_Ref",
invoice_details."Date issue",
invoice_details."Payment date",
invoice_details."Visitor"
ORDER BY invoice_details."Invoice_Ref";

-- Search invoice recap :
--SELECT * FROM invoice_recap;

COMMIT;
```

J'ai repris ici une fonction que j'avais déjà créée 

Retour à l'accueil [HERE](../README.md)