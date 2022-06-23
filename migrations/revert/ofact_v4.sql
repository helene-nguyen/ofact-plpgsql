-- Revert ofact_sqitch:ofact_v4 from pg

BEGIN;

DROP VIEW IF EXISTS invoice_details;

DROP FUNCTION IF EXISTS 
    tva_rate(priceHT DOUBLE PRECISION, priceTTC DOUBLE PRECISION), 
    total_price(quantity INT, priceTTC DOUBLE PRECISION);

COMMIT;
