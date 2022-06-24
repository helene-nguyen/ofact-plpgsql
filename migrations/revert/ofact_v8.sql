-- Revert ofact_sqitch:ofact_v8 from pg

BEGIN;

DROP FUNCTION IF EXISTS add_invoice(JSON);

COMMIT;
