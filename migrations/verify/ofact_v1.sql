-- Verify ofact_sqitch:ofact_v1 on pg

BEGIN;

--* Check if tables exist in database
SELECT "id" FROM "visitor";
SELECT "id" FROM "product";
SELECT "id" FROM "invoice";
SELECT "id" FROM "invoice_line";
ROLLBACK;
