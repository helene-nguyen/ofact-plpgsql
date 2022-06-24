
# Création de fonctions CRUD (surtout Create et Update)

Pour les opérations d'insertion et de mise à jour, on va créer des fonctions réutilisables.

Pour l'exemple sur les factures :

## INSERT function

- Créer une fonction commence par

```sql
CREATE OR REPLACE FUNCTION insert_visitor(json)
```

- On donne un nom à la fonction
- On lui définit le type de données qu'on va lui envoyer en paramètre et ici, on veut récupérer du `JSON`, on aurait pu également mettre un nom au paramètre et ici, si on ne met rien, on utilise un token `$1`

```sql
CREATE
OR REPLACE FUNCTION insert_visitor(json) 
RETURNS TABLE (inserted_id INT, name TEXT) AS $$

BEGIN

INSERT INTO
    public.visitor (
        "email",
        "password",
        "name",
        "address",
        "zip_code",
        "city"
    )
VALUES
(
        ($1 ->> 'email')::TEXT,
        ($1 ->> 'password')::TEXT,
        ($1 ->> 'name')::TEXT,
        ($1 ->> 'address')::TEXT,
        ($1 ->> 'zip_code')::POSINT,
        ($1 ->> 'city')::TEXT
);
    RETURN QUERY
        (SELECT visitor.id, visitor.name FROM visitor WHERE visitor.name = ($1 ->> 'name')::TEXT);
    END

$$ LANGUAGE plpgsql VOLATILE; --default value
```

- Ici le `RETURNS TABLE` me permet de générer une nouvelle table pour en ressortir le résultat récupéré par ma requête (requête qui renvoie donc 2 colonnes)

Voilà une idée de résultat :

![Inserted data](../images/insert.jpg)

Retour à l'accueil [HERE](../README.md)


