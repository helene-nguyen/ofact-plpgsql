-- Revert ofact_sqitch:ofact_v2 from pg

BEGIN;

TRUNCATE visitor,
product,
invoice,
invoice_line RESTART IDENTITY;

COMMIT;
