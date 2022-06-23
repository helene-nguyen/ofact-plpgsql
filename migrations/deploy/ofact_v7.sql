-- Deploy ofact_sqitch:ofact_v7 to pg

BEGIN;

CREATE
OR REPLACE FUNCTION packed_invoice(invoice_id INT) 
RETURNS TABLE (
    visitor TEXT, 
    city TEXT, 
    invoice_ref INT,
    date_issue TIMESTAMPTZ,
    date_payment TIMESTAMPTZ, lines JSON, 
    total DOUBLE PRECISION) AS $$

BEGIN

RETURN QUERY

(SELECT
    invoice_details."Visitor",
    invoice_details."City",
    invoice_details."Invoice_Ref",
    invoice_details."Date issue",
    invoice_details."Payment date",
    JSON_AGG( json_build_object(
       'Quantity',invoice_details."Quantity",
        'Description',invoice_details."Description",
        'Price',invoice_details."Price",
        'VAT',invoice_details."VAT",
        'Total',invoice_details."Total price per product")) AS lines,
    SUM(invoice_details."Total price per product") AS "Total"
FROM invoice_details
WHERE invoice_details."Invoice_Ref" = invoice_id
GROUP BY 
    invoice_details."Visitor",
    invoice_details."City", 
    invoice_details."Invoice_Ref",
    invoice_details."Date issue",
    invoice_details."Payment date");

END

$$ LANGUAGE plpgsql VOLATILE;

-- Test packed invoice:
--SELECT * FROM packed_invoice(1);

COMMIT;
