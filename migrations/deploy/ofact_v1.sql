-- Deploy ofact_sqitch:ofact_v1 to pg

BEGIN;

------*Control postal code FR (only 5 numbers, not int)
CREATE DOMAIN fr_zip_code AS TEXT
CHECK(
   VALUE ~ '^\d{5}$'
);
------*Control postal code FR (only 5 numbers, not int)
CREATE DOMAIN EMAIL AS TEXT CHECK ( value ~ '^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
------*Create type control positive value with float
CREATE DOMAIN POSFLOAT AS float CHECK (VALUE>0);
------*Create type control positive value
CREATE DOMAIN POSINT AS INT CHECK (VALUE>0);


CREATE TABLE IF NOT EXISTS "visitor" (
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "email" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "zip_code" fr_zip_code NOT NULL,
    "city" TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "product" (
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "label" TEXT NOT NULL,
    "price" POSFLOAT NOT NULL,
    "price_with_taxes" POSFLOAT NOT NULL
);
CREATE TABLE IF NOT EXISTS "invoice" (
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "visitor_id" INTEGER NOT NULL 
        REFERENCES "visitor"("id"),
    "issued_at" TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    "paid_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "invoice_line" (
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "quantity" POSINT NOT NULL,
    "invoice_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL REFERENCES "product"("id"),
-- deleting invoice will delete reference with invoice_line
    CONSTRAINT invoice_fk
        FOREIGN KEY ("invoice_id")
            REFERENCES "invoice"("id")
             ON UPDATE NO ACTION
             ON DELETE CASCADE
    -- source : https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-foreign-key/
);

CREATE INDEX "visitor_brin_idx" ON "visitor" 
USING BRIN ("email", "password", "name", "address", "zip_code", "city");
CREATE INDEX "product_brin_idx" ON "product" 
USING BRIN ("label", "price", "price_with_taxes");
CREATE INDEX "invoice_brin_idx" ON "invoice" 
USING BRIN ("visitor_id", "issued_at", "paid_at");
CREATE INDEX "invoice_line_brin_idx" ON "invoice_line" 
USING BRIN ("quantity", "invoice_id", "product_id");

COMMIT;
