-- Script SQL pour créer la table des participants individuels pour le week-end VTT
-- À exécuter dans l'éditeur SQL de votre dashboard Supabase

-- Créer la table pour les participants individuels
CREATE TABLE IF NOT EXISTS participants_weekend_vtt (
    id BIGSERIAL PRIMARY KEY,
    inscription_id BIGINT NOT NULL REFERENCES inscriptions_weekend_vtt(id) ON DELETE CASCADE,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    ordre_participant INTEGER NOT NULL DEFAULT 1, -- Pour maintenir l'ordre de saisie
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Ajouter des commentaires sur les colonnes
COMMENT ON COLUMN participants_weekend_vtt.id IS 'Identifiant unique du participant';
COMMENT ON COLUMN participants_weekend_vtt.inscription_id IS 'Référence vers l''inscription principale';
COMMENT ON COLUMN participants_weekend_vtt.nom IS 'Nom de famille du participant';
COMMENT ON COLUMN participants_weekend_vtt.prenom IS 'Prénom du participant';
COMMENT ON COLUMN participants_weekend_vtt.date_naissance IS 'Date de naissance du participant';
COMMENT ON COLUMN participants_weekend_vtt.ordre_participant IS 'Ordre de saisie des participants (1, 2, 3...)';

-- Créer des index pour les performances
CREATE INDEX IF NOT EXISTS idx_participants_inscription_id ON participants_weekend_vtt(inscription_id);
CREATE INDEX IF NOT EXISTS idx_participants_inscription_ordre ON participants_weekend_vtt(inscription_id, ordre_participant);

-- Ajouter une contrainte pour s'assurer que l'ordre est correct
ALTER TABLE participants_weekend_vtt 
ADD CONSTRAINT check_ordre_participant 
CHECK (ordre_participant >= 1 AND ordre_participant <= 10);

-- Créer une vue pour récupérer facilement les inscriptions avec leurs participants
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
    json_agg(
        json_build_object(
            'id', p.id,
            'nom', p.nom,
            'prenom', p.prenom,
            'date_naissance', p.date_naissance,
            'ordre', p.ordre_participant
        ) ORDER BY p.ordre_participant
    ) as participants
FROM inscriptions_weekend_vtt i
LEFT JOIN participants_weekend_vtt p ON i.id = p.inscription_id
GROUP BY i.id, i.nom, i.prenom, i.email, i.telephone, i.nombre_personnes, 
         i.prix_total, i.evenement, i.date_inscription, i.statut, i.notes
ORDER BY i.date_inscription DESC;

-- Fonction pour calculer automatiquement l'âge d'un participant
CREATE OR REPLACE FUNCTION calculer_age_participant(date_naissance DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(date_naissance));
END;
$$ LANGUAGE plpgsql;

-- Fonction pour obtenir la liste formatée des participants d'une inscription
CREATE OR REPLACE FUNCTION format_liste_participants(p_inscription_id BIGINT)
RETURNS TEXT AS $$
DECLARE
    participant_text TEXT := '';
    participant_record RECORD;
    age INTEGER;
BEGIN
    FOR participant_record IN 
        SELECT nom, prenom, date_naissance, ordre_participant
        FROM participants_weekend_vtt 
        WHERE inscription_id = p_inscription_id 
        ORDER BY ordre_participant
    LOOP
        age := calculer_age_participant(participant_record.date_naissance);
        participant_text := participant_text || participant_record.ordre_participant || '. ' || 
                          participant_record.prenom || ' ' || participant_record.nom || ' (' || age || ' ans)' || E'\n';
    END LOOP;
    
    RETURN TRIM(participant_text);
END;
$$ LANGUAGE plpgsql;

-- Permissions pour les utilisateurs anonymes (lecture seulement)
GRANT SELECT ON v_inscriptions_completes TO anon;
GRANT SELECT ON participants_weekend_vtt TO anon;
GRANT INSERT ON participants_weekend_vtt TO anon;

-- Politique de sécurité : permettre l'insertion et la lecture
ALTER TABLE participants_weekend_vtt ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre l'insertion (tout le monde peut ajouter des participants)
CREATE POLICY "Allow insert participants" ON participants_weekend_vtt
    FOR INSERT WITH CHECK (true);

-- Politique pour permettre la lecture (tout le monde peut lire les participants)
CREATE POLICY "Allow read participants" ON participants_weekend_vtt
    FOR SELECT USING (true);
