# oFact

Auhtor : Yumicode (Helene Nguyen)
## Introduction

Ce dossier a été fait lors d'un challenge lors de notre spécialisation en data avec l'école [O'clock](https://oclock.io/formations). 

Tout le travail est fait avec le SGBD PostgreSQL avec le langage procédural géré par [PostgreSQL](https://www.postgresql.org/) PL/pgSQL qui nous permet de centraliser les traitements directement dans la base de données.

Cela permet en mettant la logique dans la base de données de faciliter la maintenance  de notre base de données.

La mise en place peut paraître longue mais le code s'éxécute directement dans le moteur de la base, cela fait gagner en performance car le langage permet d'accéder à une biblithèque spécifique et le langage est plus facile d'accès.

Pur plus de détails, vous pouvez aller voir [ici](https://public.dalibo.com/exports/formation/manuels/modules/p1/p1.handout.html)

Si vous voulez tester, cela est possible mais au préalable, il vous faudra PostgreSQL et [Sqitch](https://sqitch.org/docs/manual/sqitchtutorial/)
## Création de la base de données

Détails [ICI](./__docs/01_creation_db.md)
## Création de la première migration

Détails [ICI](./__docs/02_migration.md)
## Gérer la 3e forme normale

Détails [ICI](./__docs/03_3FN.md)
## Création de fonctions CRUD (surtout Create et Update)

Détails [ICI](./__docs/04_crud.md)
## Jouer avec les jointures

Détails [ICI](./__docs/05_jointures.md)
## Utilisation d'une view dans une view et subqueries

Détails [ICI](./__docs/06_views.md)
## Fonction avec des paramètres

Détails [ICI](./__docs/07_params.md)
## Utiliser les fonctions de création de JSON PostgreSQL

Détails [ICI](./__docs/08_json.md)

## Utiliser les fonctions avec une boucle

Détails [ICI](./__docs/09_loop.md)

## Mot de la fin

Toutes ces notions apprises nous permettent de nous projeter quant à l'utilisation des `VIEW`, `FUNCTION` et `INDEX` pour la performance des sites et ce n'est pas rien ! 

Encore un petit visuel de ce que cela peut donner lorsqu'on a créé toutes ces fonctions :

![end](./images/end.jpg)

___

Sources diverses :

[Utiliser une clé primaire dans une autre table](https://stackoverflow.com/questions/55631622/can-i-use-one-same-primary-key-in-two-different-tables)

[Clés primaires](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-primary-key/)

[Normalistations expliquées](https://www.ionos.fr/digitalguide/hebergement/aspects-techniques/normalisation-base-de-donnees/)

[Utilisation de PERFORM](https://stackoverflow.com/questions/1953326/how-to-call-a-function-postgresql)

[Utilisation de json_build_object](https://www.postgresql.org/docs/9.6/functions-json.html)