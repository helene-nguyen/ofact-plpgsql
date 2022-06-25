-- Revert ofact_sqitch:ofact_v1 from pg

BEGIN;

DROP TABLE IF EXISTS public.invoice_line;
DROP TABLE IF EXISTS public.invoice;
DROP TABLE IF EXISTS public.product;
DROP TABLE IF EXISTS public.visitor;

--* Drop types because it stays registered
DROP TYPE IF EXISTS "fr_zip_code", "posint", "posfloat", "email";
COMMIT;
