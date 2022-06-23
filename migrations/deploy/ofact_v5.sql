-- Deploy ofact_sqitch:ofact_v5 to pg

BEGIN;

--* Use my created function to have expected result
CREATE VIEW invoice_recap AS
SELECT 
invoice_details."Invoice_Ref",
invoice_details."Date issue",
invoice_details."Payment date",
invoice_details."Visitor",
SUM(invoice_details."Total price")::numeric(10,2)
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
