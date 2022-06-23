-- Revert ofact_sqitch:ofact_v7 from pg

BEGIN;

DROP FUNCTION IF EXISTS 
    packed_invoice(invoice_id INT);

COMMIT;
