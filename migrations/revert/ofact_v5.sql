-- Revert ofact_sqitch:ofact_v5 from pg

BEGIN;

DROP VIEW IF EXISTS invoice_recap;

COMMIT;
