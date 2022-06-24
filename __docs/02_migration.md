# Création de la première migration

La première migration consiste à créer nos tables dans la base de données à partir des seules données que nous avions sur le document [là](../data/seeding_v1.sql)

Ce document nous a été fournit pour remplir la base de données et le but du jeu était de pouvoir lancer le script sans modifications sur celle-ci.

Dans la démarche, j'ai défini quelques types de contraintes pour créer des exemples dont une qui permet de contrôler en amont le code postal avec une expression régulière [Regex](https://fr.wikipedia.org/wiki/Expression_r%C3%A9guli%C3%A8re) :

```sql
------*Control postal code FR (only 5 numbers, not int)
CREATE DOMAIN fr_zip_code AS TEXT
CHECK(
   VALUE ~ '^\d{5}$'
);

```

Et quelques une pour créer un type sur les nombres 

```sql
------*Create type control positive value with float
CREATE DOMAIN POSFLOAT AS float CHECK (VALUE>0);
------*Create type control positive value
CREATE DOMAIN POSINT AS INT CHECK (VALUE>0);
```

Quelques particularités que j'ai ajouté :

- `ON DELETE CASCADE` a été ajouté sur la clé étrangère se situant sur `invoice_line` pour `invoice` car lorsqu'on supprime la facture, on va supprimer les lignes qui lui sont liées

