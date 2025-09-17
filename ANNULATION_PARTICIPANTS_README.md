# 🔄 Gestion des Annulations de Participants Individuels

## 📋 Vue d'ensemble

Le système permet maintenant l'**annulation individuelle des participants** dans une inscription, avec **traçabilité complète** et **conservation des données** pour l'organisation.

### 🎯 **Avantages de cette fonctionnalité :**

✅ **Flexibilité** : Annuler un participant sans affecter les autres  
✅ **Traçabilité** : Conservation de toutes les informations d'annulation  
✅ **Réversibilité** : Possibilité de réactiver un participant  
✅ **Calculs automatiques** : Prix ajusté selon les participants actifs  
✅ **Motifs documentés** : Raisons d'annulation conservées  

## 🗄️ **Modifications de la base de données**

### **Nouvelles colonnes dans `participants_weekend_vtt` :**

```sql
- annule               BOOLEAN DEFAULT false
- motif_annulation     TEXT
- date_annulation      TIMESTAMPTZ
```

### **Nouvelle vue mise à jour :**

`v_inscriptions_completes` inclut maintenant :
- `total_participants_inscrits` : Nombre initial de participants
- `participants_actifs` : Participants non annulés
- `participants_annules` : Participants annulés
- Statut d'annulation pour chaque participant

### **Nouvelles vues d'administration :**

- `v_statistiques_annulations` : Vue d'ensemble par inscription
- `v_participants_annules` : Tous les participants annulés

## 👥 **Interface pour les participants**

### **Fonctionnalités disponibles :**

**1. Visualisation claire :**
- Participants actifs : fond bleu, badge bleu
- Participants annulés : fond rouge, badge rouge, texte barré
- Motif d'annulation affiché si renseigné
- Date d'annulation visible

**2. Actions disponibles :**
- **Bouton ❌ Annuler** : pour les participants actifs
- **Bouton 🔄 Réactiver** : pour les participants annulés

**3. Process d'annulation :**
1. Clic sur le bouton ❌ à côté du participant
2. Modal de confirmation avec champ motif (optionnel)
3. Confirmation de l'annulation
4. Mise à jour immédiate de l'affichage

**4. Process de réactivation :**
1. Clic sur le bouton 🔄 à côté du participant annulé
2. Confirmation simple
3. Participant réactivé instantanément

### **Calculs automatiques :**

- **Prix ajusté** : Affiché selon le nombre de participants actifs
- **Prix initial** : Conservé et affiché en gris si différent
- **Statistiques** : "X actifs, Y annulés (Z total)"

## 👨‍💼 **Interface d'administration mise à jour**

### **Nouvelles statistiques :**

**Dashboard principal :**
- **Participants actifs** : Nombre réel de participants présents
- **Participants annulés** : Affiché en sous-texte
- **Revenus ajustés** : Basés sur les participants actifs
- **Revenus initiaux** : Conservés pour comparaison

**Pour chaque inscription :**
- **Affichage visuel** des participants annulés (rouge)
- **Motifs d'annulation** visibles
- **Dates d'annulation** tracées
- **Prix ajusté** calculé automatiquement

### **Nouvelles requêtes disponibles :**

```sql
-- Voir toutes les statistiques d'annulation
SELECT * FROM v_statistiques_annulations;

-- Voir tous les participants annulés
SELECT * FROM v_participants_annules;

-- Calculer le manque à gagner total
SELECT SUM(manque_a_gagner) FROM v_statistiques_annulations;
```

## 🔧 **Cas d'usage pratiques**

### **Scénario 1 : Enfant malade**
1. Parent se connecte sur `/gestion-inscription/`
2. Trouve son inscription famille
3. Clique ❌ à côté de l'enfant malade
4. Renseigne "Maladie" comme motif
5. Confirme → L'enfant est annulé, les autres restent inscrits

### **Scénario 2 : Changement de dernière minute**
1. Participant adulte a un empêchement
2. Annulation avec motif "Empêchement professionnel"
3. Le prix total s'ajuste automatiquement
4. L'organisation voit immédiatement la modification

### **Scénario 3 : Guérison de dernière minute**
1. Enfant initialement malade récupère
2. Parent clique 🔄 pour réactiver
3. Participant réintégré automatiquement
4. Prix recalculé avec le participant réactivé

### **Scénario 4 : Suivi organisationnel**
1. Organisateur consulte `admin_inscriptions.html`
2. Voit les statistiques mises à jour en temps réel
3. Peut voir tous les motifs d'annulation
4. Planifie l'événement selon l'effectif réel

## 📊 **Avantages pour l'organisation**

### **1. Gestion financière précise :**
```
Exemple famille de 4 personnes (160€ initial) :
- 1 enfant annulé → Prix ajusté: 120€
- Manque à gagner: 40€
- Visible immédiatement dans l'admin
```

### **2. Planification optimisée :**
- **Effectifs réels** pour prévoir repas, matériel, encadrement
- **Listes de présence** générées automatiquement
- **Statistiques d'abandon** pour analyses futures

### **3. Communication facilitée :**
- **Motifs d'annulation** pour comprendre les raisons
- **Historique complet** pour le suivi
- **Notifications automatiques** des changements

### **4. Flexibilité maximale :**
- **Annulations jusqu'au dernier moment**
- **Réactivations possibles** en cas de changement
- **Pas de suppression définitive** → données conservées

## 🔒 **Sécurité et permissions**

### **Côté utilisateur :**
- **Recherche par email** obligatoire (pas d'accès libre)
- **Modification** limitée à sa propre inscription
- **Traçabilité** de toutes les actions

### **Côté base de données :**
- **Soft delete** : pas de suppression définitive
- **Timestamps** sur toutes les modifications
- **Policies Supabase** sécurisées

## 📈 **Métriques et suivi**

### **Indicateurs disponibles :**

**Performance de l'événement :**
- Taux d'annulation par inscription
- Motifs d'annulation les plus fréquents
- Période de pic d'annulations
- Impact financier des annulations

**Exemples de requêtes analytics :**

```sql
-- Taux d'annulation par inscription
SELECT 
    COUNT(*) as nb_inscriptions,
    AVG(participants_annules) as moyenne_annulations,
    AVG(participants_annules::float / total_participants_inscrits * 100) as taux_annulation_pct
FROM v_statistiques_annulations;

-- Motifs d'annulation les plus fréquents
SELECT 
    motif_annulation,
    COUNT(*) as frequence
FROM v_participants_annules
GROUP BY motif_annulation
ORDER BY frequence DESC;

-- Impact financier
SELECT 
    SUM(prix_initial) as revenus_theoriques,
    SUM(prix_ajuste) as revenus_reels,
    SUM(manque_a_gagner) as perte_totale
FROM v_statistiques_annulations;
```

## 🚀 **Utilisation en production**

### **Étapes de déploiement :**

1. **Exécuter le script SQL :** `supabase_annulation_participants.sql`
2. **Vérifier les nouvelles colonnes** dans la table participants
3. **Tester l'interface** de gestion des inscriptions
4. **Vérifier l'admin** pour les nouvelles statistiques

### **Tests recommandés :**

✅ Annuler un participant et vérifier le calcul du prix  
✅ Réactiver un participant annulé  
✅ Vérifier l'affichage dans l'interface d'administration  
✅ Tester avec différents motifs d'annulation  
✅ Valider les calculs de statistiques  

## 🔮 **Évolutions futures possibles**

### **Améliorations envisageables :**

**1. Notifications automatiques :**
- Email à l'organisation lors d'annulation
- SMS de confirmation au participant
- Rappels automatiques avant l'événement

**2. Gestion des listes d'attente :**
- Proposition automatique aux participants en attente
- Redistribution des places libérées

**3. Analytics avancées :**
- Prédiction des annulations
- Segmentation par profil
- Optimisation des prix

**4. Intégration planning :**
- Mise à jour automatique des groupes
- Répartition dynamique des participants
- Ajustement de l'encadrement

---

*Cette fonctionnalité améliore considérablement la flexibilité et la précision de la gestion des inscriptions.* 🎯✨
