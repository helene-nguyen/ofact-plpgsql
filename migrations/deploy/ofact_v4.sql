-- Deploy ofact_sqitch:ofact_v4 to pg

BEGIN;

--* Function calculate tva rate
CREATE OR REPLACE 
FUNCTION tva_rate(priceHT DOUBLE PRECISION, priceTTC DOUBLE PRECISION) 
RETURNS DOUBLE PRECISION AS $$
        BEGIN
        -- La formule standard Prix TTC (en €) = Prix HT (en €) x (1 + Taux TVA (en %) )
        -- Taux TVA = ( Prix TTC / Prix HT ) - 1
        RETURN ( (priceTTC / priceHT) - 1)::numeric(10,2);
        
        END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Montant TVA (en €) = Taux TVA (en %) x Prix TTC (en €) / (1 + Taux TVA (en %) )
--* Function calculate total price TTC
CREATE OR REPLACE 
FUNCTION total_price(quantity INT, priceTTC DOUBLE PRECISION) 
RETURNS DOUBLE PRECISION AS $$
        BEGIN
                RETURN (priceTTC * quantity)::numeric(10,2);
        END;
$$ LANGUAGE plpgsql IMMUTABLE;

--* Create view of invoice details
CREATE VIEW invoice_details AS
SELECT 
    V.name AS "Visitor",
    V.city AS "City",
    I.id AS "Invoice_Ref",
    I.issued_at AS "Date issue",
    I.paid_at AS "Payment date",
    IL.quantity AS "Quantity",
    P.label AS "Description",
    P.price AS "Price",
    (SELECT tva_rate(Price,P.price_with_taxes)) AS "VAT",
    (SELECT total_price(Quantity, P.price_with_taxes)) AS "Total price per product"
FROM "visitor" AS V
JOIN "invoice" AS I
    ON I.visitor_id = V.id
JOIN "invoice_line" AS IL
    ON IL.invoice_id = I.id
JOIN "product" AS P
    ON P.id = IL.product_id;

-- Search for one visitor, try :
--SELECT * FROM invoice_details WHERE invoice_details."Visitor" = 'Numérobis';
COMMIT;
