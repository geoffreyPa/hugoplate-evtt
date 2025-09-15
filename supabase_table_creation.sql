-- Script SQL pour créer la table des inscriptions week-end VTT dans Supabase
-- À exécuter dans l'éditeur SQL de votre dashboard Supabase

-- Créer la table pour les inscriptions
CREATE TABLE IF NOT EXISTS inscriptions_weekend_vtt (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    nombre_personnes INTEGER NOT NULL CHECK (nombre_personnes >= 1 AND nombre_personnes <= 10),
    prix_total DECIMAL(10,2) NOT NULL,
    evenement VARCHAR(255) NOT NULL DEFAULT 'Week-end VTT - 20-21 septembre 2025',
    date_inscription TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    statut VARCHAR(50) NOT NULL DEFAULT 'en_attente',
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Ajouter des commentaires sur les colonnes
COMMENT ON COLUMN inscriptions_weekend_vtt.id IS 'Identifiant unique de l''inscription';
COMMENT ON COLUMN inscriptions_weekend_vtt.nom IS 'Nom de famille du participant';
COMMENT ON COLUMN inscriptions_weekend_vtt.prenom IS 'Prénom du participant';
COMMENT ON COLUMN inscriptions_weekend_vtt.email IS 'Adresse email de contact';
COMMENT ON COLUMN inscriptions_weekend_vtt.telephone IS 'Numéro de téléphone';
COMMENT ON COLUMN inscriptions_weekend_vtt.nombre_personnes IS 'Nombre de personnes inscrites (7 ans et plus)';
COMMENT ON COLUMN inscriptions_weekend_vtt.prix_total IS 'Prix total calculé (40€ x nombre_personnes)';
COMMENT ON COLUMN inscriptions_weekend_vtt.evenement IS 'Nom de l''événement';
COMMENT ON COLUMN inscriptions_weekend_vtt.date_inscription IS 'Date et heure de l''inscription';
COMMENT ON COLUMN inscriptions_weekend_vtt.statut IS 'Statut de l''inscription: en_attente, confirmee, annulee';
COMMENT ON COLUMN inscriptions_weekend_vtt.notes IS 'Notes additionnelles (optionnel)';

-- Créer un index sur l'email pour les recherches rapides
CREATE INDEX IF NOT EXISTS idx_inscriptions_email ON inscriptions_weekend_vtt(email);

-- Créer un index sur la date d'inscription
CREATE INDEX IF NOT EXISTS idx_inscriptions_date ON inscriptions_weekend_vtt(date_inscription);

-- Créer un index sur le statut
CREATE INDEX IF NOT EXISTS idx_inscriptions_statut ON inscriptions_weekend_vtt(statut);

-- Fonction pour mettre à jour automatiquement updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger pour mettre à jour automatiquement updated_at
CREATE TRIGGER update_inscriptions_weekend_vtt_updated_at 
    BEFORE UPDATE ON inscriptions_weekend_vtt 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Activer Row Level Security (RLS)
ALTER TABLE inscriptions_weekend_vtt ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre l'insertion anonyme (pour le formulaire public)
CREATE POLICY "Allow anonymous insert" ON inscriptions_weekend_vtt
    FOR INSERT 
    TO anon 
    WITH CHECK (true);

-- Politique pour permettre la lecture par les utilisateurs authentifiés
CREATE POLICY "Allow authenticated read" ON inscriptions_weekend_vtt
    FOR SELECT 
    TO authenticated 
    USING (true);

-- Politique pour permettre la mise à jour par les utilisateurs authentifiés
CREATE POLICY "Allow authenticated update" ON inscriptions_weekend_vtt
    FOR UPDATE 
    TO authenticated 
    USING (true);

-- Créer une vue pour les statistiques (optionnel)
CREATE OR REPLACE VIEW stats_inscriptions AS
SELECT 
    COUNT(*) as total_inscriptions,
    SUM(nombre_personnes) as total_personnes,
    SUM(prix_total) as chiffre_affaires_total,
    COUNT(*) FILTER (WHERE statut = 'en_attente') as en_attente,
    COUNT(*) FILTER (WHERE statut = 'confirmee') as confirmees,
    COUNT(*) FILTER (WHERE statut = 'annulee') as annulees
FROM inscriptions_weekend_vtt;

-- Donner accès à la vue aux utilisateurs authentifiés
GRANT SELECT ON stats_inscriptions TO authenticated;
