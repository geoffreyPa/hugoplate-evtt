-- Exemple de données pour tester le planning VTT
-- Exécutez ce script dans votre console Supabase

-- Insérer des lieux
INSERT INTO vtt_locations (name, address, google_maps_url) VALUES
('Forêt de Fontainebleau', '77300 Fontainebleau, France', 'https://maps.google.com/?q=Forêt+de+Fontainebleau'),
('Base de loisirs de Cergy', '95000 Cergy, France', 'https://maps.google.com/?q=Base+de+loisirs+Cergy'),
('Parc de la Poudrerie', '93410 Vaujours, France', 'https://maps.google.com/?q=Parc+de+la+Poudrerie+Vaujours'),
('Bois de Vincennes', '75012 Paris, France', 'https://maps.google.com/?q=Bois+de+Vincennes+Paris');

-- Insérer des thèmes
INSERT INTO vtt_themes (name, description, color) VALUES
('Initiation VTT', 'Découverte du VTT et apprentissage des bases', 'bg-green-500'),
('Technique de pilotage', 'Perfectionnement de la technique de conduite', 'bg-blue-500'),
('Endurance', 'Développement de l''endurance et de la condition physique', 'bg-orange-500'),
('Trial et obstacles', 'Apprentissage du franchissement d''obstacles', 'bg-purple-500'),
('Sortie découverte', 'Exploration de nouveaux terrains', 'bg-yellow-500'),
('Compétition', 'Préparation et participation aux compétitions', 'bg-red-500');

-- Insérer des groupes
INSERT INTO vtt_groups (name, description, color) VALUES
('Débutants 8-12 ans', 'Enfants débutants de 8 à 12 ans', 'bg-green-500'),
('Intermédiaires 10-14 ans', 'Enfants niveau intermédiaire de 10 à 14 ans', 'bg-blue-500'),
('Avancés 12-16 ans', 'Adolescents niveau avancé de 12 à 16 ans', 'bg-orange-500'),
('Adultes débutants', 'Adultes découvrant le VTT', 'bg-teal-500'),
('Adultes confirmés', 'Adultes pratiquant régulièrement', 'bg-purple-500'),
('Compétition jeunes', 'Groupe compétition pour les jeunes', 'bg-red-500');

-- Insérer des moniteurs
INSERT INTO monitors (name, speciality, color, tel, mail) VALUES
('Jean Dupont', 'Initiation et technique', 'bg-blue-500', '06.12.34.56.78', 'jean.dupont@ecole-vtt.fr'),
('Marie Martin', 'Endurance et compétition', 'bg-green-500', '06.98.76.54.32', 'marie.martin@ecole-vtt.fr'),
('Pierre Leclerc', 'Trial et obstacles', 'bg-purple-500', '06.11.22.33.44', 'pierre.leclerc@ecole-vtt.fr'),
('Sophie Bernard', 'Groupes enfants', 'bg-pink-500', '06.55.66.77.88', 'sophie.bernard@ecole-vtt.fr'),
('Thomas Rousseau', 'Adultes et sorties', 'bg-orange-500', '06.99.88.77.66', 'thomas.rousseau@ecole-vtt.fr');

-- Insérer des sessions de planning (exemples pour la semaine prochaine)
INSERT INTO vtt_planning (session_date, start_time, end_time, theme_id, location_id, comment, is_special_session) VALUES
-- Mercredi prochain
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 3)::int, '14:00', '16:00', 1, 1, 'Session d''initiation pour les nouveaux adhérents', false),
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 3)::int, '16:30', '18:00', 2, 2, 'Perfectionnement technique avancé', false),

-- Samedi prochain
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 6)::int, '09:00', '11:30', 5, 3, 'Grande sortie découverte en forêt', true),
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 6)::int, '14:00', '16:00', 3, 1, 'Entraînement endurance', false),

-- Dimanche prochain
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 7)::int, '10:00', '12:00', 4, 4, 'Atelier trial et franchissement', false),
((CURRENT_DATE + INTERVAL '1 week')::date + (EXTRACT(DOW FROM CURRENT_DATE + INTERVAL '1 week') * -1 + 7)::int, '14:30', '17:00', 6, 2, 'Compétition régionale - inscription obligatoire', true);

-- Récupérer les IDs des sessions pour les associations
-- (Vous devrez adapter les IDs selon les données insérées)

-- Associer des groupes aux sessions
INSERT INTO vtt_planning_groups (planning_id, group_id) VALUES
-- Session 1 (initiation) - Débutants
(1, 1), (1, 4),
-- Session 2 (technique) - Intermédiaires et avancés
(2, 2), (2, 3), (2, 5),
-- Session 3 (sortie découverte) - Tous niveaux
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5),
-- Session 4 (endurance) - Confirmés
(4, 3), (4, 5),
-- Session 5 (trial) - Avancés
(5, 3), (5, 5),
-- Session 6 (compétition) - Groupe compétition
(6, 6);

-- Associer des moniteurs aux sessions
INSERT INTO vtt_planning_monitors (planning_id, monitor_id) VALUES
-- Session 1 - Jean et Sophie (initiation enfants/adultes)
(1, 1), (1, 4),
-- Session 2 - Jean et Pierre (technique avancée)
(2, 1), (2, 3),
-- Session 3 - Thomas et Marie (sortie découverte)
(3, 5), (3, 2),
-- Session 4 - Marie (endurance)
(4, 2),
-- Session 5 - Pierre (trial)
(5, 3),
-- Session 6 - Marie et Sophie (compétition)
(6, 2), (6, 4);

-- Afficher un résumé des données créées
SELECT 
  p.session_date,
  p.start_time,
  p.end_time,
  t.name as theme,
  l.name as lieu,
  p.is_special_session,
  string_agg(DISTINCT g.name, ', ') as groupes,
  string_agg(DISTINCT m.name, ', ') as moniteurs
FROM vtt_planning p
LEFT JOIN vtt_themes t ON p.theme_id = t.id
LEFT JOIN vtt_locations l ON p.location_id = l.id
LEFT JOIN vtt_planning_groups pg ON p.id = pg.planning_id
LEFT JOIN vtt_groups g ON pg.group_id = g.id
LEFT JOIN vtt_planning_monitors pm ON p.id = pm.planning_id
LEFT JOIN monitors m ON pm.monitor_id = m.id
WHERE p.session_date >= CURRENT_DATE
GROUP BY p.id, p.session_date, p.start_time, p.end_time, t.name, l.name, p.is_special_session
ORDER BY p.session_date, p.start_time;
