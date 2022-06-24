-- Deploy ofact:2.3fn to pg

BEGIN;

-- j'ajoute une colonne qui va contenir 'vat' à ma table product
ALTER TABLE product
    ADD COLUMN vat NUMERIC;

-- je viens insérer une valeur calculée dans cette colonne
UPDATE product SET vat=(price_with_taxes/price - 1.0);

-- je supprime la colonne TTC et je viens ajouter NOT NULL à 'vat'
ALTER TABLE product
    DROP COLUMN price_with_taxes,
    ALTER COLUMN vat SET NOT NULL;

COMMIT;
