-- Deploy ofact_sqitch:ofact_v8 to pg
BEGIN;

-- Source help :https://stackoverflow.com/questions/20272650/how-to-loop-over-json-arrays-in-postgresql-9-3
CREATE
OR REPLACE FUNCTION add_invoice(JSON) 
RETURNS TABLE (inserted_invoice INT) AS $$

DECLARE
_elem JSON;
_array JSON := ($1 ->> 'products');

BEGIN

PERFORM (SELECT insert_invoice."inserted_id" FROM insert_invoice($1));

FOR _elem IN SELECT * FROM json_array_elements(_array)
LOOP
 
  -- As logger to check value
--     RAISE NOTICE 'Output from space %', _elem ->> 'id';
--     RAISE NOTICE 'Output from space %', _elem ->> 'quantity';
--     RAISE NOTICE 'Output from space %', (json(_array));
--     RAISE NOTICE 'Output from space %', (SELECT invoice.id
--      FROM invoice WHERE invoice.visitor_id = ($1 ->> 'visitor_id')::INT
--      ORDER BY invoice.id DESC LIMIT 1) ;
--     RAISE NOTICE 'Output from space %', (SELECT json_build_object
--                                          ('quantity',((_elem ->> 'quantity')::INT), 
--                                           'invoice_id',(SELECT invoice.id FROM invoice 
--                                                         WHERE invoice.visitor_id = ($1 ->> 'visitor_id')::INT
--                                                         ORDER BY invoice.id DESC LIMIT 1),
--                                          'product_id', ((_elem ->> 'id')::INT)));

    -- Source https://stackoverflow.com/questions/1953326/how-to-call-a-function-postgresql
    -- If you want to discard the result of SELECT, use PERFORM
    PERFORM (SELECT insert_invoice_line.inserted_invoice 
             FROM insert_invoice_line(
                (SELECT json_build_object
                        ('quantity',((_elem ->> 'quantity')::INT), 
                        'invoice_id',(SELECT invoice.id FROM invoice 
                                    ORDER BY invoice.id DESC LIMIT 1),
                        'product_id', ((_elem ->> 'id')::INT)))));
    -- Source build object
    -- https://www.postgresql.org/docs/9.6/functions-json.html  

  END LOOP;

    
    RETURN QUERY ((SELECT invoice.id FROM invoice ORDER BY invoice.id DESC LIMIT 1));
     
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