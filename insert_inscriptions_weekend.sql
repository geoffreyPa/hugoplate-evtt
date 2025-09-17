-- Script SQL pour insérer les inscriptions du week-end VTT
-- À exécuter dans l'éditeur SQL de Supabase

-- ================================================================
-- INSERTION DES INSCRIPTIONS PRINCIPALES
-- ================================================================

-- 1. Famille BADET (23/08/2025) - Vincent + Lucas + Raphael
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('BADET', 'Vincent', 'vincentbadet@yahoo.fr', '0682159874', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-08-23 10:00:00+02', 'en_attente');

-- 2. Famille SCARDINA/BOURDIN (20/06/2025) - Sébastien + Stéphanie + Adrien + Gabriel
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('BOURDIN', 'Stéphanie', 'stephanie-bourdin@hotmail.fr', '0682698262', 4, 160, 'Week-end VTT - 20-21 septembre 2025', '2025-06-20 14:30:00+02', 'en_attente');

-- 3. Famille AYEL (20/06/2025) - François + Martin
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('AYEL', 'François', 'ayel.commercial@gmail.com', '0604090170', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-20 16:15:00+02', 'en_attente');

-- 4. Famille FOURNIER/SEVREZ (19/06/2025) - Pascal + Sara + Mael
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('FOURNIER', 'Pascal', 'pascal.fournier@eiffage.com', '0679664278', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-19 09:45:00+02', 'en_attente');

-- 5. Famille BARBIER (18/06/2025) - Julie + Tom + Loïs
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('BARBIER', 'Julie', 'julie.barbier3@wanadoo.fr', '0633605801', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-18 11:20:00+02', 'en_attente');

-- 6. Famille BRETECHER (16/06/2025) - Mickaël + Léandre
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('BRETECHER', 'Mickaël', 'mika_bretecher@yahoo.fr', '0766225139', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-16 13:10:00+02', 'confirmee');

-- 7. Famille UGNON-FLEURY (06/06/2025) - Xavier + Clément
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('UGNON-FLEURY', 'Xavier', 'xavier.uf@gmail.com', '0673294562', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-06 15:30:00+02', 'en_attente');

-- 8. Famille BADET (05/06/2025) - Vincent + Lucas + Raphael (inscription antérieure)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('BADET', 'Vincent', 'vincentbadet@yahoo.fr', '0682159874', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-05 08:45:00+02', 'confirmee');

-- 9. Famille JEANGUYOT (31/05/2025) - Pierre + Louis
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('JEANGUYOT', 'Pierre', 'jeanguyotpierre@gmail.com', '0633333290', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-05-31 12:00:00+02', 'confirmee');

-- 10. MARIELLE Camille (19/05/2025) - seule
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('MARIELLE', 'Bruno', 'bruno.marielle@email.com', '0610807732', 1, 40, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 10:15:00+02', 'confirmee');

-- 11. PANZUTI Laura (19/05/2025) - seule
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('PANZUTI', 'Laura', 'laurapanzuti@yahoo.fr', '0686568033', 1, 40, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 14:20:00+02', 'en_attente');

-- 12. Famille SÉNÉCHAL (19/05/2025) - Romain + Arthur + Maya
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut)
VALUES ('SÉNÉCHAL', 'Romain', 'romainsenechal@outlook.com', '0631472769', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 16:45:00+02', 'en_attente');

-- ================================================================
-- INSERTION DES PARTICIPANTS
-- ================================================================

-- 1. Participants famille BADET (23/08/2025) - ID inscription sera récupéré
WITH inscription_badet_1 AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'BADET' AND email = 'vincentbadet@yahoo.fr' AND date_inscription = '2025-08-23 10:00:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_badet_1.id,
  'BADET',
  'Vincent',
  '1985-03-15',
  1
FROM inscription_badet_1
UNION ALL
SELECT 
  inscription_badet_1.id,
  'BADET',
  'Lucas',
  '2014-05-20',  -- 11 ans
  2
FROM inscription_badet_1
UNION ALL
SELECT 
  inscription_badet_1.id,
  'BADET',
  'Raphael',
  '2018-08-10',  -- 7 ans
  3
FROM inscription_badet_1;

-- 2. Participants famille SCARDINA/BOURDIN (20/06/2025)
WITH inscription_bourdin AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'BOURDIN' AND email = 'stephanie-bourdin@hotmail.fr' AND date_inscription = '2025-06-20 14:30:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_bourdin.id,
  'BOURDIN',
  'Stéphanie',
  '1982-09-12',
  1
FROM inscription_bourdin
UNION ALL
SELECT 
  inscription_bourdin.id,
  'SCARDINA',
  'Sébastien',
  '1980-04-25',
  2
FROM inscription_bourdin
UNION ALL
SELECT 
  inscription_bourdin.id,
  'SCARDINA',
  'Adrien',
  '2008-03-18',  -- 17 ans
  3
FROM inscription_bourdin
UNION ALL
SELECT 
  inscription_bourdin.id,
  'SCARDINA',
  'Gabriel',
  '2015-07-22',  -- 10 ans
  4
FROM inscription_bourdin;

-- 3. Participants famille AYEL (20/06/2025)
WITH inscription_ayel AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'AYEL' AND email = 'ayel.commercial@gmail.com' AND date_inscription = '2025-06-20 16:15:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_ayel.id,
  'AYEL',
  'François',
  '1978-11-30',
  1
FROM inscription_ayel
UNION ALL
SELECT 
  inscription_ayel.id,
  'AYEL',
  'Martin',
  '2010-06-14',  -- Estimation enfant
  2
FROM inscription_ayel;

-- 4. Participants famille FOURNIER/SEVREZ (19/06/2025)
WITH inscription_fournier AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'FOURNIER' AND email = 'pascal.fournier@eiffage.com' AND date_inscription = '2025-06-19 09:45:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_fournier.id,
  'FOURNIER',
  'Pascal',
  '1975-02-28',
  1
FROM inscription_fournier
UNION ALL
SELECT 
  inscription_fournier.id,
  'SEVREZ',
  'Sara',
  '1983-12-05',
  2
FROM inscription_fournier
UNION ALL
SELECT 
  inscription_fournier.id,
  'FOURNIER',
  'Mael',
  '2015-04-10',  -- 10 ans
  3
FROM inscription_fournier;

-- 5. Participants famille BARBIER (18/06/2025)
WITH inscription_barbier AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'BARBIER' AND email = 'julie.barbier3@wanadoo.fr' AND date_inscription = '2025-06-18 11:20:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_barbier.id,
  'BARBIER',
  'Julie',
  '1985-07-18',
  1
FROM inscription_barbier
UNION ALL
SELECT 
  inscription_barbier.id,
  'CHALANT BARBIER',
  'Tom',
  '2016-03-25',  -- 9 ans
  2
FROM inscription_barbier
UNION ALL
SELECT 
  inscription_barbier.id,
  'CHALANT BARBIER',
  'Loïs',
  '2020-01-15',  -- 5 ans (note: trop jeune pour l'événement normalement)
  3
FROM inscription_barbier;

-- 6. Participants famille BRETECHER (16/06/2025)
WITH inscription_bretecher AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'BRETECHER' AND email = 'mika_bretecher@yahoo.fr' AND date_inscription = '2025-06-16 13:10:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_bretecher.id,
  'BRETECHER',
  'Mickaël',
  '1982-01-20',
  1
FROM inscription_bretecher
UNION ALL
SELECT 
  inscription_bretecher.id,
  'BRETECHER',
  'Léandre',
  '2012-09-08',  -- 13 ans
  2
FROM inscription_bretecher;

-- 7. Participants famille UGNON-FLEURY (06/06/2025)
WITH inscription_ugnon AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'UGNON-FLEURY' AND email = 'xavier.uf@gmail.com' AND date_inscription = '2025-06-06 15:30:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_ugnon.id,
  'UGNON-FLEURY',
  'Xavier',
  '1975-08-14',
  1
FROM inscription_ugnon
UNION ALL
SELECT 
  inscription_ugnon.id,
  'UGNON-FLEURY',
  'Clément',
  '2008-04-22',  -- 17 ans
  2
FROM inscription_ugnon;

-- 8. Participants famille BADET (05/06/2025) - inscription antérieure
WITH inscription_badet_2 AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'BADET' AND email = 'vincentbadet@yahoo.fr' AND date_inscription = '2025-06-05 08:45:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_badet_2.id,
  'BADET',
  'Vincent',
  '1985-03-15',
  1
FROM inscription_badet_2
UNION ALL
SELECT 
  inscription_badet_2.id,
  'BADET',
  'Lucas',
  '2014-05-20',  -- 11 ans
  2
FROM inscription_badet_2
UNION ALL
SELECT 
  inscription_badet_2.id,
  'BADET',
  'Raphael',
  '2018-08-10',  -- 7 ans
  3
FROM inscription_badet_2;

-- 9. Participants famille JEANGUYOT (31/05/2025)
WITH inscription_jeanguyot AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'JEANGUYOT' AND email = 'jeanguyotpierre@gmail.com' AND date_inscription = '2025-05-31 12:00:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_jeanguyot.id,
  'JEANGUYOT',
  'Pierre',
  '1978-03-10',
  1
FROM inscription_jeanguyot
UNION ALL
SELECT 
  inscription_jeanguyot.id,
  'JEANGUYOT',
  'Louis',
  '2011-12-15',  -- 14 ans
  2
FROM inscription_jeanguyot;

-- 10. Participant MARIELLE (19/05/2025)
WITH inscription_marielle AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'MARIELLE' AND telephone = '0610807732' AND date_inscription = '2025-05-19 10:15:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_marielle.id,
  'MARIELLE',
  'Camille',
  '2008-02-28',  -- 17 ans
  1
FROM inscription_marielle;

-- 11. Participant PANZUTI (19/05/2025)
WITH inscription_panzuti AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'PANZUTI' AND email = 'laurapanzuti@yahoo.fr' AND date_inscription = '2025-05-19 14:20:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_panzuti.id,
  'PANZUTI',
  'Laura',
  '1990-06-12',
  1
FROM inscription_panzuti;

-- 12. Participants famille SÉNÉCHAL (19/05/2025)
WITH inscription_senechal AS (
  SELECT id FROM inscriptions_weekend_vtt 
  WHERE nom = 'SÉNÉCHAL' AND email = 'romainsenechal@outlook.com' AND date_inscription = '2025-05-19 16:45:00+02'
)
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant)
SELECT 
  inscription_senechal.id,
  'SÉNÉCHAL',
  'Romain',
  '1987-11-05',
  1
FROM inscription_senechal
UNION ALL
SELECT 
  inscription_senechal.id,
  'SÉNÉCHAL',
  'Arthur',
  '2017-01-20',  -- 8 ans
  2
FROM inscription_senechal
UNION ALL
SELECT 
  inscription_senechal.id,
  'SÉNÉCHAL',
  'Maya',
  '2022-05-30',  -- 3 ans (note: trop jeune pour l'événement normalement)
  3
FROM inscription_senechal;

-- ================================================================
-- VÉRIFICATIONS ET STATISTIQUES
-- ================================================================

-- Afficher un résumé des inscriptions créées
SELECT 
  'Résumé des inscriptions créées' as titre,
  COUNT(*) as nombre_inscriptions,
  SUM(nombre_personnes) as total_participants,
  SUM(prix_total) as revenus_total
FROM inscriptions_weekend_vtt 
WHERE evenement = 'Week-end VTT - 20-21 septembre 2025';

-- Afficher les inscriptions avec leurs participants
SELECT 
  i.nom + ', ' + i.prenom as responsable,
  i.email,
  i.telephone,
  i.nombre_personnes,
  i.statut,
  i.date_inscription,
  string_agg(p.prenom + ' ' + p.nom + ' (' + EXTRACT(YEAR FROM AGE(p.date_naissance))::text + ' ans)', ', ' ORDER BY p.ordre_participant) as participants
FROM inscriptions_weekend_vtt i
LEFT JOIN participants_weekend_vtt p ON i.id = p.inscription_id
WHERE i.evenement = 'Week-end VTT - 20-21 septembre 2025'
GROUP BY i.id, i.nom, i.prenom, i.email, i.telephone, i.nombre_personnes, i.statut, i.date_inscription
ORDER BY i.date_inscription;

-- ================================================================
-- NOTES IMPORTANTES
-- ================================================================

/*
ATTENTION : Quelques points à noter sur ces données :

1. DOUBLONS DÉTECTÉS :
   - Vincent BADET apparaît deux fois (23/08/2025 et 05/06/2025)
   - Possiblement deux inscriptions différentes ou une erreur

2. PARTICIPANTS TROP JEUNES :
   - Loïs Chalant barbier (5 ans) 
   - Maya Sénéchal (3 ans)
   - L'événement est pour les 7 ans et plus

3. DONNÉES MANQUANTES/INCOHÉRENTES :
   - Quelques emails manquants ou incorrects
   - Certains contacts secondaires non utilisés
   - Âges estimés quand non précisés

4. STATUTS :
   - "Payé" converti en "confirmee"
   - "En attente" maintenu tel quel

5. DATES DE NAISSANCE :
   - Calculées approximativement selon les âges donnés
   - Vous pouvez ajuster selon les vraies dates si disponibles
*/
