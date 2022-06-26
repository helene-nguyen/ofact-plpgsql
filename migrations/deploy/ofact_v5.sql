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

COMMIT;
