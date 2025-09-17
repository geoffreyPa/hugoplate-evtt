# 🚴‍♂️ Nouvelle Fonctionnalité : Gestion Détaillée des Participants

## 📋 Vue d'ensemble

Le formulaire d'inscription pour le week-end VTT a été amélioré pour permettre la saisie détaillée de chaque participant. Au lieu de simplement indiquer le nombre de personnes, il est maintenant possible de renseigner pour chaque participant :

- **Nom de famille**
- **Prénom** 
- **Date de naissance**

Toutes ces informations sont stockées dans Supabase et peuvent être consultées via une interface d'administration dédiée.

## 🔧 Modifications Apportées

### 1. Structure de Base de Données

**Nouveau fichier :** `supabase_participants_table.sql`

- **Nouvelle table :** `participants_weekend_vtt`
  - Stocke les informations individuelles de chaque participant
  - Liée à la table `inscriptions_weekend_vtt` via `inscription_id`
  - Validation automatique de l'âge minimum (7 ans)

- **Vue créée :** `v_inscriptions_completes`
  - Combine les inscriptions avec leurs participants
  - Facilite la récupération des données complètes

- **Fonctions utilitaires :**
  - `calculer_age_participant()` : Calcule l'âge d'un participant
  - `format_liste_participants()` : Formate la liste des participants pour l'affichage

### 2. Interface Utilisateur Améliorée

**Fichier modifié :** `themes/hugoplate/layouts/week/list.html`

- **Section dynamique des participants :**
  - Apparaît automatiquement selon le nombre de personnes sélectionné
  - Interface intuitive avec numérotation des participants
  - Validation en temps réel de l'âge minimum

- **Fonctionnalités JavaScript ajoutées :**
  - `generateParticipantsFields()` : Génère les champs pour chaque participant
  - `validateParticipantsData()` : Valide les données avant envoi
  - `handleNombrePersonnesChange()` : Gère les changements du nombre de personnes

### 3. Interface d'Administration

**Nouveau fichier :** `admin_inscriptions.html`

Interface complète pour gérer les inscriptions avec :

- **Tableau de bord :**
  - Statistiques en temps réel
  - Nombre total d'inscriptions et de participants
  - Revenus prévus
  - Inscriptions en attente

- **Gestion des inscriptions :**
  - Affichage détaillé de chaque inscription
  - Liste complète des participants avec âges
  - Modification du statut des inscriptions
  - Filtrage par statut et recherche

- **Fonctions d'export :**
  - Impression de la liste complète des participants
  - Export CSV pour Excel
  - Données formatées pour impression

## 🚀 Utilisation

### Pour les Utilisateurs (Inscription)

1. **Remplir les informations du responsable :**
   - Nom, prénom, email, téléphone

2. **Indiquer le nombre de participants :**
   - Sélectionner le nombre de personnes (7 ans et plus)

3. **Renseigner chaque participant :**
   - Les champs apparaissent automatiquement
   - Saisir nom, prénom et date de naissance pour chaque participant
   - Validation automatique de l'âge minimum (7 ans)

4. **Valider l'inscription :**
   - Le système enregistre l'inscription principale et tous les participants
   - En cas d'erreur, un message d'erreur explicite s'affiche

### Pour l'Organisateur (Administration)

1. **Accéder à l'interface d'administration :**
   - Ouvrir le fichier `admin_inscriptions.html` dans un navigateur

2. **Consulter les statistiques :**
   - Vue d'ensemble des inscriptions
   - Nombre total de participants
   - Revenus prévus

3. **Gérer les inscriptions :**
   - Voir les détails de chaque inscription
   - Modifier le statut (En attente → Confirmée → Annulée)
   - Filtrer et rechercher dans les inscriptions

4. **Exporter les données :**
   - Imprimer la liste complète des participants
   - Exporter en CSV pour traitement dans Excel
   - Données formatées pour les organisateurs

## 📊 Structure des Données

### Table `inscriptions_weekend_vtt` (existante, inchangée)
- Informations du responsable de l'inscription
- Données globales (nombre de personnes, prix total, etc.)

### Table `participants_weekend_vtt` (nouvelle)
```sql
- id (clé primaire)
- inscription_id (référence vers l'inscription)
- nom (nom de famille)
- prenom (prénom)
- date_naissance (date de naissance)
- ordre_participant (ordre de saisie 1, 2, 3...)
```

### Vue `v_inscriptions_completes` (nouvelle)
Combine automatiquement les inscriptions avec leurs participants pour faciliter l'affichage.

## 🔐 Sécurité et Permissions

- **Policies Supabase configurées :**
  - Lecture publique des données (pour l'interface d'administration)
  - Insertion publique (pour les nouvelles inscriptions)
  - Pas de modification/suppression publique (sécurité)

- **Validation côté client et serveur :**
  - Vérification de l'âge minimum (7 ans)
  - Validation des champs obligatoires
  - Cohérence des données (nombre de participants = nombre de fiches)

## 📱 Responsive Design

- Interface adaptée aux mobiles et tablettes
- Formulaire optimisé pour tous les écrans
- Interface d'administration responsive

## 🎯 Avantages

1. **Pour les Participants :**
   - Saisie claire et guidée
   - Validation en temps réel
   - Interface intuitive

2. **Pour l'Organisateur :**
   - Liste complète et détaillée des participants
   - Gestion centralisée des inscriptions
   - Export facilité des données
   - Statistiques en temps réel

3. **Pour l'Organisation :**
   - Données structurées et complètes
   - Facilité de suivi et de gestion
   - Conformité avec les exigences d'encadrement
   - Traçabilité complète des inscriptions

## 🔄 Mise en Place

### Étape 1 : Base de Données
1. Exécuter le script `supabase_participants_table.sql` dans Supabase
2. Vérifier que les tables et vues sont créées

### Étape 2 : Site Web
1. Les modifications sont déjà en place dans le code
2. Redéployer le site Hugo si nécessaire

### Étape 3 : Administration
1. Ouvrir `admin_inscriptions.html` pour accéder aux données
2. Bookmark la page pour un accès facile

## 📈 Évolutions Futures Possibles

- **Notifications automatiques :** Envoi d'emails de confirmation
- **Paiement en ligne :** Intégration d'un système de paiement
- **Gestion des groupes :** Attribution automatique aux groupes par âge
- **Check-in digital :** QR codes pour l'arrivée au week-end
- **Statistiques avancées :** Analyses démographiques des participants

## 🆘 Support

En cas de problème :
1. Vérifier les logs dans la console du navigateur
2. S'assurer que Supabase est accessible
3. Vérifier que les scripts SQL ont été exécutés correctement
4. Contrôler les permissions dans Supabase

---

*Cette fonctionnalité améliore considérablement la gestion des inscriptions et facilite l'organisation du week-end VTT.* 🚴‍♂️✨
