-- Script SQL pour ajouter la gestion d'annulation individuelle des participants
-- À exécuter dans l'éditeur SQL de Supabase

-- ================================================================
-- AJOUTER LES COLONNES D'ANNULATION AUX PARTICIPANTS
-- ================================================================

-- Ajouter les colonnes pour gérer l'annulation des participants
ALTER TABLE participants_weekend_vtt 
ADD COLUMN IF NOT EXISTS annule BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS motif_annulation TEXT,
ADD COLUMN IF NOT EXISTS date_annulation TIMESTAMPTZ;

-- Ajouter des commentaires sur les nouvelles colonnes
COMMENT ON COLUMN participants_weekend_vtt.annule IS 'Indique si ce participant a annulé sa participation';
COMMENT ON COLUMN participants_weekend_vtt.motif_annulation IS 'Motif de l''annulation du participant';
COMMENT ON COLUMN participants_weekend_vtt.date_annulation IS 'Date et heure de l''annulation du participant';

-- ================================================================
-- CRÉER UNE VUE MISE À JOUR AVEC LES ANNULATIONS
-- ================================================================

-- Supprimer l'ancienne vue et la recréer avec les nouvelles colonnes
DROP VIEW IF EXISTS v_inscriptions_completes;

CREATE OR REPLACE VIEW v_inscriptions_completes AS
SELECT 
    i.id as inscription_id,
    i.nom as responsable_nom,
    i.prenom as responsable_prenom,
    i.email,
    i.telephone,
    i.nombre_personnes,
    i.prix_total,
    i.evenement,
    i.date_inscription,
    i.statut,
    i.notes,
    -- Statistiques des participants
    COUNT(p.id) as total_participants_inscrits,
    COUNT(CASE WHEN p.annule = false OR p.annule IS NULL THEN 1 END) as participants_actifs,
    COUNT(CASE WHEN p.annule = true THEN 1 END) as participants_annules,
    -- Liste complète des participants avec leur statut
    json_agg(
        json_build_object(
            'id', p.id,
            'nom', p.nom,
            'prenom', p.prenom,
            'date_naissance', p.date_naissance,
            'ordre', p.ordre_participant,
            'annule', COALESCE(p.annule, false),
            'motif_annulation', p.motif_annulation,
            'date_annulation', p.date_annulation
        ) ORDER BY p.ordre_participant
    ) as participants
FROM inscriptions_weekend_vtt i
LEFT JOIN participants_weekend_vtt p ON i.id = p.inscription_id
GROUP BY i.id, i.nom, i.prenom, i.email, i.telephone, i.nombre_personnes, 
         i.prix_total, i.evenement, i.date_inscription, i.statut, i.notes
ORDER BY i.date_inscription DESC;

-- Permissions pour la nouvelle vue
GRANT SELECT ON v_inscriptions_completes TO anon;

-- ================================================================
-- FONCTIONS UTILITAIRES MISES À JOUR
-- ================================================================

-- Fonction pour calculer le prix ajusté selon les participants actifs
CREATE OR REPLACE FUNCTION calculer_prix_ajuste(p_inscription_id BIGINT, p_prix_par_personne DECIMAL DEFAULT 40)
RETURNS DECIMAL AS $$
DECLARE
    participants_actifs INTEGER;
    prix_ajuste DECIMAL;
BEGIN
    -- Compter les participants non annulés
    SELECT COUNT(*) INTO participants_actifs
    FROM participants_weekend_vtt 
    WHERE inscription_id = p_inscription_id 
    AND (annule = false OR annule IS NULL);
    
    -- Calculer le prix ajusté
    prix_ajuste := participants_actifs * p_prix_par_personne;
    
    RETURN prix_ajuste;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour obtenir la liste formatée des participants avec statut
CREATE OR REPLACE FUNCTION format_liste_participants_avec_statut(p_inscription_id BIGINT)
RETURNS TEXT AS $$
DECLARE
    participant_text TEXT := '';
    participant_record RECORD;
    age INTEGER;
BEGIN
    FOR participant_record IN 
        SELECT nom, prenom, date_naissance, ordre_participant, annule, motif_annulation
        FROM participants_weekend_vtt 
        WHERE inscription_id = p_inscription_id 
        ORDER BY ordre_participant
    LOOP
        age := calculer_age_participant(participant_record.date_naissance);
        
        participant_text := participant_text || participant_record.ordre_participant || '. ' || 
                          participant_record.prenom || ' ' || participant_record.nom || ' (' || age || ' ans)';
        
        -- Ajouter le statut d'annulation
        IF participant_record.annule = true THEN
            participant_text := participant_text || ' - ANNULÉ';
            IF participant_record.motif_annulation IS NOT NULL THEN
                participant_text := participant_text || ' (' || participant_record.motif_annulation || ')';
            END IF;
        END IF;
        
        participant_text := participant_text || E'\n';
    END LOOP;
    
    RETURN TRIM(participant_text);
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- VUES ADDITIONNELLES POUR L'ADMINISTRATION
-- ================================================================

-- Vue pour les statistiques d'annulation
CREATE OR REPLACE VIEW v_statistiques_annulations AS
SELECT 
    i.id as inscription_id,
    CONCAT(i.prenom, ' ', i.nom) as responsable,
    i.email,
    i.nombre_personnes as participants_initiaux,
    COUNT(p.id) as participants_inscrits,
    COUNT(CASE WHEN p.annule = false OR p.annule IS NULL THEN 1 END) as participants_actifs,
    COUNT(CASE WHEN p.annule = true THEN 1 END) as participants_annules,
    i.prix_total as prix_initial,
    calculer_prix_ajuste(i.id) as prix_ajuste,
    (i.prix_total - calculer_prix_ajuste(i.id)) as manque_a_gagner,
    i.statut,
    i.date_inscription
FROM inscriptions_weekend_vtt i
LEFT JOIN participants_weekend_vtt p ON i.id = p.inscription_id
WHERE i.evenement = 'Week-end VTT - 20-21 septembre 2025'
GROUP BY i.id, i.nom, i.prenom, i.email, i.nombre_personnes, i.prix_total, i.statut, i.date_inscription
ORDER BY participants_annules DESC, i.date_inscription DESC;

-- Vue pour les participants annulés seulement
CREATE OR REPLACE VIEW v_participants_annules AS
SELECT 
    p.id,
    p.nom,
    p.prenom,
    p.date_naissance,
    calculer_age_participant(p.date_naissance) as age,
    p.motif_annulation,
    p.date_annulation,
    CONCAT(i.prenom, ' ', i.nom) as responsable_inscription,
    i.email as email_responsable,
    i.telephone as telephone_responsable,
    i.id as inscription_id
FROM participants_weekend_vtt p
JOIN inscriptions_weekend_vtt i ON p.inscription_id = i.id
WHERE p.annule = true
AND i.evenement = 'Week-end VTT - 20-21 septembre 2025'
ORDER BY p.date_annulation DESC;

-- Permissions
GRANT SELECT ON v_statistiques_annulations TO anon;
GRANT SELECT ON v_participants_annules TO anon;

-- ================================================================
-- POLITIQUE DE SÉCURITÉ MISE À JOUR
-- ================================================================

-- Permettre la mise à jour des colonnes d'annulation
CREATE POLICY "Allow update participant cancellation" ON participants_weekend_vtt
    FOR UPDATE USING (true)
    WITH CHECK (true);

-- ================================================================
-- EXEMPLES D'UTILISATION
-- ================================================================

-- Annuler un participant
/*
UPDATE participants_weekend_vtt 
SET 
    annule = true,
    motif_annulation = 'Maladie',
    date_annulation = NOW(),
    updated_at = NOW()
WHERE id = [ID_DU_PARTICIPANT];
*/

-- Réactiver un participant
/*
UPDATE participants_weekend_vtt 
SET 
    annule = false,
    motif_annulation = NULL,
    date_annulation = NULL,
    updated_at = NOW()
WHERE id = [ID_DU_PARTICIPANT];
*/

-- Voir les inscriptions avec leurs statistiques d'annulation
/*
SELECT * FROM v_statistiques_annulations;
*/

-- Voir tous les participants annulés
/*
SELECT * FROM v_participants_annules;
*/

-- ================================================================
-- RAPPORT DE VÉRIFICATION
-- ================================================================

-- Afficher les nouvelles colonnes ajoutées
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    col_description(pgc.oid, pa.attnum) as column_comment
FROM information_schema.columns isc
JOIN pg_class pgc ON pgc.relname = isc.table_name
JOIN pg_attribute pa ON pa.attrelid = pgc.oid AND pa.attname = isc.column_name
WHERE table_name = 'participants_weekend_vtt'
AND column_name IN ('annule', 'motif_annulation', 'date_annulation')
ORDER BY ordinal_position;

-- Test de la vue mise à jour
SELECT 
    responsable_nom,
    responsable_prenom,
    total_participants_inscrits,
    participants_actifs,
    participants_annules
FROM v_inscriptions_completes
WHERE evenement = 'Week-end VTT - 20-21 septembre 2025'
LIMIT 5;

-- ================================================================
-- NOTES IMPORTANTES
-- ================================================================

/*
🎯 NOUVELLES FONCTIONNALITÉS :

1. ANNULATION INDIVIDUELLE :
   - Chaque participant peut être annulé individuellement
   - Motif d'annulation conservé
   - Date d'annulation tracée
   - Possibilité de réactiver un participant

2. TRAÇABILITÉ COMPLÈTE :
   - Aucune suppression de données
   - Historique des annulations
   - Calcul automatique des prix ajustés

3. VUES D'ADMINISTRATION :
   - v_statistiques_annulations : vue d'ensemble par inscription
   - v_participants_annules : tous les participants annulés
   - v_inscriptions_completes : mise à jour avec statuts

4. AVANTAGES POUR L'ORGANISATION :
   - Suivi des désistements
   - Calcul du manque à gagner
   - Possibilité de relancer des participants
   - Statistiques précises pour l'événement

5. UTILISATIONS POSSIBLES :
   - Un enfant malade → annulation individuelle
   - Changement de dernière minute → modification du groupe
   - Réactivation si guérison → restauration du participant
   - Suivi précis des revenus réels
*/
