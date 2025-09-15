# Configuration Supabase pour les inscriptions Week-end VTT

## 🚀 Étapes de configuration

### 1. Créer la table dans Supabase

1. Connectez-vous à votre dashboard Supabase : https://app.supabase.com
2. Sélectionnez votre projet : `jiforbxelcpihbphrtzx`
3. Allez dans **SQL Editor**
4. Copiez et exécutez le contenu du fichier `supabase_table_creation.sql`

### 2. Structure de la table créée

La table `inscriptions_weekend_vtt` contient :

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | BIGSERIAL | Identifiant unique (auto-incrémenté) |
| `nom` | VARCHAR(100) | Nom de famille |
| `prenom` | VARCHAR(100) | Prénom |
| `email` | VARCHAR(255) | Adresse email |
| `telephone` | VARCHAR(20) | Numéro de téléphone |
| `nombre_personnes` | INTEGER | Nombre de personnes (1-10) |
| `prix_total` | DECIMAL(10,2) | Prix total calculé |
| `evenement` | VARCHAR(255) | Nom de l'événement |
| `date_inscription` | TIMESTAMPTZ | Date d'inscription |
| `statut` | VARCHAR(50) | Statut (en_attente, confirmee, annulee) |
| `notes` | TEXT | Notes additionnelles (optionnel) |

### 3. Sécurité configurée

✅ **Row Level Security (RLS)** activé
✅ **Insertion anonyme** autorisée pour le formulaire public
✅ **Lecture/modification** autorisée pour les utilisateurs authentifiés
✅ **Index** créés pour les performances

### 4. Fonctionnalités ajoutées

- ⏰ **Timestamp automatique** : `updated_at` mis à jour automatiquement
- 📊 **Vue statistiques** : `stats_inscriptions` pour un aperçu rapide
- 🔍 **Index optimisés** pour les recherches rapides

## 📊 Vue d'ensemble des données

Pour voir les statistiques, utilisez la vue :

```sql
SELECT * FROM stats_inscriptions;
```

Résultat exemple :
- Total inscriptions : 15
- Total personnes : 32
- Chiffre d'affaires : 1,280€
- En attente : 12
- Confirmées : 3
- Annulées : 0

## 🔍 Requêtes utiles

### Voir toutes les inscriptions récentes
```sql
SELECT * FROM inscriptions_weekend_vtt 
ORDER BY date_inscription DESC;
```

### Chercher par email
```sql
SELECT * FROM inscriptions_weekend_vtt 
WHERE email = 'exemple@email.com';
```

### Confirmer une inscription
```sql
UPDATE inscriptions_weekend_vtt 
SET statut = 'confirmee', notes = 'Inscription confirmée par téléphone'
WHERE id = 1;
```

### Calculer le total des revenus
```sql
SELECT SUM(prix_total) as total_revenus 
FROM inscriptions_weekend_vtt 
WHERE statut = 'confirmee';
```

## 🎯 Intégration avec le formulaire

Le formulaire sur votre site web :
1. ✅ Se connecte automatiquement à Supabase
2. ✅ Valide les données côté client
3. ✅ Envoie les données de manière sécurisée
4. ✅ Affiche des messages de confirmation/erreur
5. ✅ Calcule automatiquement le prix total

## 🛡️ Sécurité

- **Clé publique** utilisée côté client (pas de risque)
- **RLS activé** pour protéger les données
- **Validation** des données avant insertion
- **Logs** automatiques de toutes les actions

## 📱 Interface d'administration

Vous pouvez gérer les inscriptions directement depuis :
1. **Dashboard Supabase** : Table Editor
2. **SQL Editor** : Requêtes personnalisées
3. **API** : Intégration avec vos outils existants

Votre système d'inscription est maintenant opérationnel ! 🎉
