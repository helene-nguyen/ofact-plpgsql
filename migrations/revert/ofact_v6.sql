-- Revert ofact_sqitch:ofact_v6 from pg

BEGIN;

DROP FUNCTION IF EXISTS 
    sales_by_date(date1 DATE, date2 DATE);

COMMIT;
