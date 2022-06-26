-- Deploy ofact_sqitch:ofact_v6 to pg

BEGIN;

CREATE TYPE sales AS(
    date TIMESTAMPTZ, 
    nb_invoices BIGINT, 
    total NUMERIC
);
CREATE
OR REPLACE FUNCTION sales_by_date(date1 DATE, date2 DATE) 
RETURNS SETOF sales AS $$

BEGIN

RETURN QUERY 
    (SELECT 
    "date_generated", 
    count(invoice_recap."Invoice_Ref") AS nb_invoices, 
    COALESCE(sum(invoice_recap."Total invoice"), 0) AS total 
    FROM generate_series(date1::date, date2::date, '1 day')AS "date_generated"
    FULL JOIN invoice_recap ON ("date_generated" = DATE(invoice_recap."Date issue"))
    GROUP BY "date_generated"
    ORDER BY "date_generated");

END

$$ LANGUAGE plpgsql VOLATILE;

-- Test range of date:
-- SELECT * FROM sales_by_date('2022-06-15','2022-06-23');

COMMIT;
