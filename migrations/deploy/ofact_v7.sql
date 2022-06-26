-- Deploy ofact_sqitch:ofact_v7 to pg

BEGIN;

CREATE TYPE packed AS (
    visitor TEXT, 
    city TEXT, 
    invoice_ref INT,
    date_issue TIMESTAMPTZ,
    date_payment TIMESTAMPTZ, lines JSON, 
    total DOUBLE PRECISION
);


CREATE
OR REPLACE FUNCTION packed_invoice(invoice_id INT) 
RETURNS SETOF packed AS $$

BEGIN

RETURN QUERY
(SELECT
    ID."Visitor",
    ID."City",
    ID."Invoice_Ref",
    ID."Date issue",
    ID."Payment date",
    JSON_AGG( json_build_object(
       'Quantity',ID."Quantity",
        'Description',ID."Description",
        'Price',ID."Price",
        'VAT',ID."VAT",
        'Total',ID."Total price per product")) AS lines,
    SUM(ID."Total price per product") AS "Total"
FROM invoice_details AS ID
WHERE ID."Invoice_Ref" = invoice_id
GROUP BY 
    ID."Visitor",
    ID."City", 
    ID."Invoice_Ref",
    ID."Date issue",
    ID."Payment date");

END

$$ LANGUAGE plpgsql VOLATILE;

-- Test packed invoice:
--SELECT * FROM packed_invoice(1);

COMMIT;
