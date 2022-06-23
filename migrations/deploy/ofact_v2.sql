-- Deploy ofact_sqitch:ofact_v2 to pg

BEGIN;

INSERT INTO
    "visitor"("email", "password", "name", "address", "zip_code", "city")
VALUES
    (
        'numero@bis.eg',
        '$2b$10$Btz1P5F51OMGfvuuL1wh7.kdwyEYXdzCSGpbLg1BAlx91GvwFGlXm',
        'Numérobis',
        'Dernière pyramide à gauche',
        '12345',
        'Le Caire'
    ),
    (
        'amon@bofis.eg',
        '$2b$10$XBG4JD2apNQs1S97bXlL/.7jd95ylW6h4ZFnP1dAE10RaqsaSd8De',
        'Amonbofis',
        'Première pyramide à droite',
        '54321',
        'Le Caire'
    ),
    (
        'pano@ramix.ga',
        '$2b$10$g8NKBH9OrxoUt.2jMJ.V3eyH7lN6EbVk7THcG3bAsUCtd.iKuqtnK',
        'Panoramix',
        'Grande hutte à la sortie du village',
        '98765',
        'Village des irréductibles'
    );

INSERT INTO
    "product"("label", "price", "price_with_taxes")
VALUES
    ('Lot de 20 pierres de taille', 2312, 2774.4),
    ('Esclave', 500, 527.5),
    ('Petit géranium', 43.2, 51.84),
    ('Strychnine (1L)', 32, 38.4),
    ('Arsenic (1L)', 35, 42),
    ('Bave de sangsue (20CL)', 12.5, 15),
    ('Scorpion séché', 7, 7.385),
    ('Branche de gui', 19, 22.8),
    ('Barquette de fraises', 39.5, 47.4),
    ('Cèpes (500G)', 48, 50.64);

INSERT INTO
    "invoice"("visitor_id", "issued_at", "paid_at")
VALUES
    (1, NOW(), null),
    (1, NOW() - '1 day 3 hours' :: interval, null),
    (
        2,
        NOW() - '2 days' :: interval,
        NOW() - '1 day' :: interval
    ),
    (
        3,
        NOW() - '3 days 12 hours' :: interval,
        NOW() - '1 day 6 hours' :: interval
    ),
    (3, NOW() - '2 days' :: interval, null),
    (3, NOW(), null);

INSERT INTO
    "invoice_line"("quantity", "invoice_id", "product_id")
VALUES
    (2, 1, 1),
    (5, 1, 2),
    (10, 2, 3),
    (3, 3, 4),
    (1, 3, 5),
    (5, 3, 6),
    (18, 3, 7),
    (5, 4, 9),
    (3, 5, 8),
    (2, 5, 9),
    (3, 6, 8),
    (4, 6, 10);

COMMIT;
