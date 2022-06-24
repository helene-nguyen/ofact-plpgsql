-- Revert ofact:2.3fn from pg

BEGIN;

-- j'ajoute une colonne qui va contenir 'vat' à ma table product
ALTER TABLE product
    ADD COLUMN price_with_taxes NUMERIC;

-- je viens insérer une valeur calculée dans cette colonne
UPDATE product SET price_with_taxes=price+price*vat;

-- je supprime la colonne TTC et je viens ajouter NOT NULL à 'vat'
ALTER TABLE product
    DROP COLUMN vat,
    ALTER COLUMN price_with_taxes SET NOT NULL;

COMMIT;
