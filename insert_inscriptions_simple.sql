-- Script SQL simplifié pour Supabase (PostgreSQL)
-- Insérer les inscriptions du week-end VTT

-- ================================================================
-- ÉTAPE 1: INSERTION DES INSCRIPTIONS PRINCIPALES
-- ================================================================

-- 1. Famille BADET (23/08/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('BADET', 'Vincent', 'vincentbadet@yahoo.fr', '0682159874', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-08-23 10:00:00+02', 'en_attente', 'Inscription avec Lucas (11 ans) et Raphael (7 ans)');

-- 2. Famille SCARDINA/BOURDIN (20/06/2025) 
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('BOURDIN', 'Stéphanie', 'stephanie-bourdin@hotmail.fr', '0682698262', 4, 160, 'Week-end VTT - 20-21 septembre 2025', '2025-06-20 14:30:00+02', 'en_attente', 'Avec Sébastien SCARDINA, Adrien (17 ans) et Gabriel (10 ans)');

-- 3. Famille AYEL (20/06/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('AYEL', 'François', 'ayel.commercial@gmail.com', '0604090170', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-20 16:15:00+02', 'en_attente', 'Avec Martin AYEL (enfant)');

-- 4. Famille FOURNIER/SEVREZ (19/06/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('FOURNIER', 'Pascal', 'pascal.fournier@eiffage.com', '0679664278', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-19 09:45:00+02', 'en_attente', 'Avec Sara SEVREZ et Mael (10 ans)');

-- 5. Famille BARBIER (18/06/2025) 
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('BARBIER', 'Julie', 'julie.barbier3@wanadoo.fr', '0633605801', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-18 11:20:00+02', 'en_attente', 'Avec Tom (9 ans) et Loïs (5 ans) - ATTENTION: Loïs trop jeune');

-- 6. Famille BRETECHER (16/06/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('BRETECHER', 'Mickaël', 'mika_bretecher@yahoo.fr', '0766225139', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-16 13:10:00+02', 'confirmee', 'Avec Léandre (13 ans) - PAYÉ');

-- 7. Famille UGNON-FLEURY (06/06/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('UGNON-FLEURY', 'Xavier', 'xavier.uf@gmail.com', '0673294562', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-06-06 15:30:00+02', 'en_attente', 'Avec Clément (17 ans)');

-- 8. Famille BADET (05/06/2025) - DOUBLON POSSIBLE
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('BADET', 'Vincent', 'vincentbadet@yahoo.fr', '0682159874', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-06-05 08:45:00+02', 'confirmee', 'DOUBLON POSSIBLE - Inscription antérieure PAYÉE');

-- 9. Famille JEANGUYOT (31/05/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('JEANGUYOT', 'Pierre', 'jeanguyotpierre@gmail.com', '0633333290', 2, 80, 'Week-end VTT - 20-21 septembre 2025', '2025-05-31 12:00:00+02', 'confirmee', 'Avec Louis (14 ans) - PAYÉ');

-- 10. MARIELLE (19/05/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('MARIELLE', 'Bruno', 'bruno.marielle@email.com', '0610807732', 1, 40, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 10:15:00+02', 'confirmee', 'Inscription pour Camille MARIELLE (17 ans) - PAYÉ');

-- 11. PANZUTI (19/05/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('PANZUTI', 'Laura', 'laurapanzuti@yahoo.fr', '0686568033', 1, 40, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 14:20:00+02', 'en_attente', 'Inscription individuelle adulte');

-- 12. Famille SÉNÉCHAL (19/05/2025)
INSERT INTO inscriptions_weekend_vtt (nom, prenom, email, telephone, nombre_personnes, prix_total, evenement, date_inscription, statut, notes)
VALUES ('SÉNÉCHAL', 'Romain', 'romainsenechal@outlook.com', '0631472769', 3, 120, 'Week-end VTT - 20-21 septembre 2025', '2025-05-19 16:45:00+02', 'en_attente', 'Avec Arthur (8 ans) et Maya (3 ans) - ATTENTION: Maya trop jeune');

-- ================================================================
-- ÉTAPE 2: RÉCUPÉRER LES IDs DES INSCRIPTIONS ET INSÉRER LES PARTICIPANTS
-- ================================================================

-- Note: Vous devrez exécuter cette partie APRÈS avoir inséré les inscriptions ci-dessus
-- Les IDs seront automatiquement attribués par Supabase

-- Pour obtenir les IDs des inscriptions, utilisez cette requête :
SELECT id, nom, prenom, email, date_inscription, notes 
FROM inscriptions_weekend_vtt 
WHERE evenement = 'Week-end VTT - 20-21 septembre 2025'
ORDER BY date_inscription;

-- ================================================================
-- ÉTAPE 3: INSERTION DES PARTICIPANTS (à adapter avec les vrais IDs)
-- ================================================================

-- EXEMPLE pour la famille BADET (première inscription) - REMPLACEZ 'ID_INSCRIPTION' par le vrai ID
-- 
-- INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
-- (ID_INSCRIPTION, 'BADET', 'Vincent', '1985-03-15', 1),
-- (ID_INSCRIPTION, 'BADET', 'Lucas', '2014-05-20', 2),
-- (ID_INSCRIPTION, 'BADET', 'Raphael', '2018-08-10', 3);

-- ================================================================
-- TEMPLATE POUR LES PARTICIPANTS (remplacez les IDs)
-- ================================================================

-- 1. Famille BADET (23/08/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_BADET_1], 'BADET', 'Vincent', '1985-03-15', 1),
([ID_BADET_1], 'BADET', 'Lucas', '2014-05-20', 2),
([ID_BADET_1], 'BADET', 'Raphael', '2018-08-10', 3);
*/

-- 2. Famille SCARDINA/BOURDIN (20/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_BOURDIN], 'BOURDIN', 'Stéphanie', '1982-09-12', 1),
([ID_BOURDIN], 'SCARDINA', 'Sébastien', '1980-04-25', 2),
([ID_BOURDIN], 'SCARDINA', 'Adrien', '2008-03-18', 3),
([ID_BOURDIN], 'SCARDINA', 'Gabriel', '2015-07-22', 4);
*/

-- 3. Famille AYEL (20/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_AYEL], 'AYEL', 'François', '1978-11-30', 1),
([ID_AYEL], 'AYEL', 'Martin', '2010-06-14', 2);
*/

-- 4. Famille FOURNIER/SEVREZ (19/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_FOURNIER], 'FOURNIER', 'Pascal', '1975-02-28', 1),
([ID_FOURNIER], 'SEVREZ', 'Sara', '1983-12-05', 2),
([ID_FOURNIER], 'FOURNIER', 'Mael', '2015-04-10', 3);
*/

-- 5. Famille BARBIER (18/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_BARBIER], 'BARBIER', 'Julie', '1985-07-18', 1),
([ID_BARBIER], 'CHALANT BARBIER', 'Tom', '2016-03-25', 2),
([ID_BARBIER], 'CHALANT BARBIER', 'Loïs', '2020-01-15', 3);
*/

-- 6. Famille BRETECHER (16/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_BRETECHER], 'BRETECHER', 'Mickaël', '1982-01-20', 1),
([ID_BRETECHER], 'BRETECHER', 'Léandre', '2012-09-08', 2);
*/

-- 7. Famille UGNON-FLEURY (06/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_UGNON], 'UGNON-FLEURY', 'Xavier', '1975-08-14', 1),
([ID_UGNON], 'UGNON-FLEURY', 'Clément', '2008-04-22', 2);
*/

-- 8. Famille BADET (05/06/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_BADET_2], 'BADET', 'Vincent', '1985-03-15', 1),
([ID_BADET_2], 'BADET', 'Lucas', '2014-05-20', 2),
([ID_BADET_2], 'BADET', 'Raphael', '2018-08-10', 3);
*/

-- 9. Famille JEANGUYOT (31/05/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_JEANGUYOT], 'JEANGUYOT', 'Pierre', '1978-03-10', 1),
([ID_JEANGUYOT], 'JEANGUYOT', 'Louis', '2011-12-15', 2);
*/

-- 10. MARIELLE (19/05/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_MARIELLE], 'MARIELLE', 'Camille', '2008-02-28', 1);
*/

-- 11. PANZUTI (19/05/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_PANZUTI], 'PANZUTI', 'Laura', '1990-06-12', 1);
*/

-- 12. Famille SÉNÉCHAL (19/05/2025) - ID à remplacer
/*
INSERT INTO participants_weekend_vtt (inscription_id, nom, prenom, date_naissance, ordre_participant) VALUES
([ID_SENECHAL], 'SÉNÉCHAL', 'Romain', '1987-11-05', 1),
([ID_SENECHAL], 'SÉNÉCHAL', 'Arthur', '2017-01-20', 2),
([ID_SENECHAL], 'SÉNÉCHAL', 'Maya', '2022-05-30', 3);
*/

-- ================================================================
-- INSTRUCTIONS D'EXÉCUTION
-- ================================================================

/*
MARCHE À SUIVRE :

1. Exécutez d'abord l'ÉTAPE 1 (inscriptions principales)
2. Exécutez la requête SELECT pour obtenir les IDs
3. Remplacez les [ID_XXX] dans les templates par les vrais IDs
4. Exécutez l'insertion des participants

POINTS D'ATTENTION :
- Vincent BADET apparaît 2 fois (possible doublon)
- Loïs (5 ans) et Maya (3 ans) sont trop jeunes
- Vérifiez les emails et téléphones
*/
