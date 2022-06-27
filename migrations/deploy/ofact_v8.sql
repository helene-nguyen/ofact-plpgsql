-- Deploy ofact_sqitch:ofact_v8 to pg
BEGIN;

-- Source help :https://stackoverflow.com/questions/20272650/how-to-loop-over-json-arrays-in-postgresql-9-3
CREATE
OR REPLACE FUNCTION add_invoice2(JSON) 
RETURNS TABLE (inserted_invoice INT) AS $$

DECLARE
_elem JSON;
_array JSON := ($1 ->> 'products');
_last_invoice_id INT := (SELECT I.id FROM invoice AS I ORDER BY I.id DESC LIMIT 1);

BEGIN

PERFORM (SELECT insert_invoice."inserted_id" FROM insert_invoice($1));

FOR _elem IN SELECT * FROM json_array_elements(_array)
LOOP
    -- Source https://stackoverflow.com/questions/1953326/how-to-call-a-function-postgresql
    -- If you want to discard the result of SELECT, use PERFORM
    PERFORM (SELECT IL.inserted_invoice 
             FROM insert_invoice_line(
    -- Source build object
    -- https://www.postgresql.org/docs/9.6/functions-json.html  
                (SELECT json_build_object
                        ('quantity',((_elem ->> 'quantity')::INT), 
                        'invoice_id',(_last_invoice_id),
                        'product_id', ((_elem ->> 'id')::INT)))) AS IL);
END LOOP;
  
    RETURN QUERY (SELECT invoice.id FROM invoice ORDER BY invoice.id DESC LIMIT 1);
END

$$ LANGUAGE plpgsql VOLATILE;


-- SELECT * FROM add_invoice(
-- '{
--     "visitor_id": 3,
--     "products": [
--         {
--             "id": 8,
--             "quantity": 10
--         },
--         {
--             "id": 5,
--             "quantity": 5
--         }
--     ]
-- }
-- '
-- )

COMMIT;