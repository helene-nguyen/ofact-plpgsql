-- Deploy ofact_sqitch:ofact_v3 to pg
BEGIN;

-----------*VISITOR------------
-- json format create
-- {
--     "email":"arthur@pendragon.com",
--     "password": "alavolette",
--     "name":"Arturos",
--     "address":"42 rue de Brocéliande",
--     "zip_code":	"42000",
--     "city":"Kaamelott"
-- }
CREATE
OR REPLACE FUNCTION insert_visitor(json) 
RETURNS TABLE (inserted_id INT, name TEXT) AS $$

BEGIN
INSERT INTO
    public.visitor (
        "email",
        "password",
        "name",
        "address",
        "zip_code",
        "city"
    )
VALUES
(
        ($1 ->> 'email')::TEXT,
        ($1 ->> 'password')::TEXT,
        ($1 ->> 'name')::TEXT,
        ($1 ->> 'address')::TEXT,
        ($1 ->> 'zip_code')::POSINT,
        ($1 ->> 'city')::TEXT
);
    RETURN QUERY
        (SELECT visitor.id, visitor.name FROM visitor WHERE visitor.name = ($1 ->> 'name')::TEXT);
    END

$$ LANGUAGE plpgsql VOLATILE; --default value
-- json format update
-- {
--     "email":"arthur@pendragon.com",
--     "password": "alavolette",
--     "name":"Arturos",
--     "address":"42 rue de Brocéliande",
--     "zip_code":	"42000",
--     "city":"Kaamelott",
--     "id":"3"
-- }
CREATE
OR REPLACE FUNCTION update_visitor(json) 
RETURNS TABLE (updated_id INT) AS $$

BEGIN
UPDATE
    public.visitor
SET
    "email" = ($1 ->> 'email')::TEXT,
    "password" = ($1 ->> 'password')::TEXT,
    "name" = ($1 ->> 'name')::TEXT,
    "address" = ($1 ->> 'address')::TEXT,
    "zip_code" = ($1 ->> 'zip_code')::POSINT,
    "city" = ($1 ->> 'city')::TEXT 
WHERE
    "id" = ($1->> 'id')::INT;

RETURN QUERY(SELECT visitor.id FROM visitor WHERE visitor.id = ($1->> 'id')::INT);
END

$$ LANGUAGE plpgsql VOLATILE;


-------------*PRODUCT-------------
-- json format create 
-- {
--     "label":"test",
--     "price": "2.50",
--     "price_with_taxes":"3"
-- }
CREATE
OR REPLACE FUNCTION insert_product(json) 
RETURNS TABLE (inserted_id INT, label TEXT) AS $$

BEGIN
INSERT INTO
    public.product (
        "label",
        "price",
        "price_with_taxes"   
    )
VALUES
(
        ($1 ->> 'label')::TEXT,
        ($1 ->> 'price')::POSFLOAT,
        ($1 ->> 'price_with_taxes')::POSFLOAT
);
    RETURN QUERY(SELECT product.id, product.label FROM product WHERE product.label = ($1 ->> 'label')::TEXT);
    END

$$ LANGUAGE plpgsql VOLATILE;
-- json format update
-- {
--     "label":"test",
--     "price": "2.50",
--     "price_with_taxes":"3",
--     "id":"2"
-- }
CREATE
OR REPLACE FUNCTION update_product(json) 
RETURNS TABLE (updated_id INT) AS $$

BEGIN
UPDATE
    public.product
SET
    "label" = ($1 ->> 'label')::TEXT,
    "price" = ($1 ->> 'price')::POSFLOAT,
    "price_with_taxes" = ($1 ->> 'price_with_taxes')::POSFLOAT
WHERE
    "id" = ($1->> 'id')::INT;

RETURN QUERY (SELECT product.id FROM product WHERE product.id = ($1->> 'id')::INT);
END

$$ LANGUAGE plpgsql VOLATILE;


-------------*INVOICE-------------
-- json format create
-- {
--     "visitor_id":"4",
--     "paid_at": "2.50"
-- }
CREATE
OR REPLACE FUNCTION insert_invoice(json) 
RETURNS TABLE (inserted_id INT, visitor_id INT) AS $$

BEGIN
INSERT INTO
    public.invoice (
        "visitor_id",
        "paid_at"
    )
VALUES
(
        ($1 ->> 'visitor_id')::INT,
        ($1 ->> 'paid_at')::TIMESTAMPTZ
);
    RETURN QUERY 
    (SELECT invoice.id, invoice.visitor_id
     FROM invoice WHERE invoice.visitor_id = ($1 ->> 'visitor_id')::INT
     ORDER BY invoice.id DESC LIMIT 1);
    END;

$$ LANGUAGE plpgsql VOLATILE;

-- json format update
-- {
--     "visitor_id":"4",
--     "id":"2"
-- }
CREATE
OR REPLACE FUNCTION update_invoice(json) 
RETURNS TABLE (updated_id INT) AS $$

BEGIN
UPDATE
    invoice
SET
    "visitor_id" = ($1 ->> 'visitor_id')::INT,
    "paid_at" = COALESCE(($1 ->> 'paid_at')::TIMESTAMPTZ, paid_at)
    -- Source used : https://medium.com/developer-rants/conditional-update-in-postgresql-a27ddb5dd35
WHERE
    invoice."id" = ($1->> 'id')::INT;
    
RETURN QUERY (SELECT invoice.id FROM invoice WHERE invoice.id = ($1->> 'id')::INT);
END

-- $$ LANGUAGE plpgsql VOLATILE;

-------------*INVOICE LINE-------------
-- json format create
-- {
--     "quantity":"4",
--     "invoice_id": "2",
--     "product_id":"3"
-- }
CREATE
OR REPLACE FUNCTION insert_invoice_line(json) 
RETURNS TABLE (line_id INT,inserted_invoice INT, inserted_product INT) AS $$

BEGIN
INSERT INTO
    public.invoice_line (
        "quantity",
        "invoice_id",
        "product_id"   
    )
VALUES
(
        ($1 ->> 'quantity')::POSINT,
        ($1 ->> 'invoice_id')::INT,
        ($1 ->> 'product_id')::INT
); 
    RETURN QUERY 
    (SELECT invoice_line.id,invoice_line.invoice_id, invoice_line.product_id 
     FROM invoice_line
     ORDER BY invoice_line.id DESC LIMIT 1);
    END;

$$ LANGUAGE plpgsql VOLATILE;

-- json format update
-- {
--     "quantity":"42",
--     "invoice_id": "2",
--     "product_id":"3",
--     "id":"2"
-- }
CREATE
OR REPLACE FUNCTION update_invoice_line(json) 
RETURNS TABLE (updated_id INT) AS $$

BEGIN
UPDATE
    public.invoice_line
SET
    "quantity" = ($1 ->> 'quantity')::POSINT,
    "invoice_id" = ($1 ->> 'invoice_id')::INT,
    "product_id" = ($1 ->> 'product_id')::INT
WHERE
    "id" = ($1->> 'id')::INT;

RETURN QUERY 
    (SELECT invoice_line.id FROM invoice_line
        WHERE invoice_line.id = ($1->> 'id')::INT);
END

$$ LANGUAGE plpgsql VOLATILE;

COMMIT;