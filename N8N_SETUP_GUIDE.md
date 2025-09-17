# 🚀 Guide d'Installation N8N - Week-end VTT

## 📋 Workflow Complet

Le fichier `n8n_workflow_inscriptions.json` contient un workflow N8N complet qui :

1. **Reçoit** les données du webhook
2. **Traite** et formate les informations
3. **Envoie** un email de confirmation au client
4. **Envoie** une notification à l'administrateur

## 🔧 Installation du Workflow

### **Étape 1 : Importer le workflow**

1. **Connectez-vous** à votre instance N8N
2. **Cliquez** sur "+ Nouveau Workflow"
3. **Menu** → "Importer depuis fichier"
4. **Sélectionnez** le fichier `n8n_workflow_inscriptions.json`
5. **Confirmez** l'importation

### **Étape 2 : Configuration SMTP**

**Pour chaque nœud d'email :**

1. **Ouvrez** le nœud "Email Confirmation Client"
2. **Configurez** les paramètres SMTP :
   ```
   SMTP Host: votre-serveur-smtp.com
   SMTP Port: 587 (ou 465 pour SSL)
   SSL/TLS: Activé
   Username: votre-email@naturavelo.com
   Password: votre-mot-de-passe
   ```
3. **Répétez** pour le nœud "Email Notification Admin"

### **Étape 3 : Activation du Webhook**

1. **Ouvrez** le nœud "Webhook Inscription"
2. **Activez** le workflow 
3. **Copiez** l'URL générée
4. **Vérifiez** qu'elle correspond à :  
   `https://votre-n8n.com/webhook/inscri-week-evtt`

## 📊 Structure du Workflow

### **Nœuds inclus :**

| Nœud | Type | Description |
|------|------|-------------|
| **Webhook Inscription** | Trigger | Reçoit les données GET du site |
| **Extraire Données** | Set | Parse les paramètres URL |
| **Préparer Emails** | Code | Formate les emails HTML |
| **Email Confirmation Client** | Email | Envoi confirmation utilisateur |
| **Email Notification Admin** | Email | Notification administrateur |

### **Flux de données :**

```
Webhook → Extraction → Traitement → ┬→ Email Client
                                   └→ Email Admin
```

## 📧 Templates d'Emails

### **Email de Confirmation Client :**

**Contenu :**
- ✅ **Confirmation** de réception
- 📋 **Récapitulatif** complet de l'inscription
- 👥 **Liste** des participants avec âges
- ℹ️ **Informations** sur les prochaines étapes
- 📞 **Contact** pour questions

**Design :**
- **Responsive** et professionnel
- **Couleurs** EVTT (vert #21A095)
- **Icônes** pour améliorer la lisibilité
- **Sections** bien délimitées

### **Email de Notification Admin :**

**Contenu :**
- 🔔 **Alerte** nouvelle inscription
- 📋 **Détails** complets (ID, contact, prix)
- 👥 **Liste** des participants
- 🎯 **Actions** à effectuer
- 🔗 **Liens** vers l'interface admin

**Design :**
- **Alerte visuelle** rouge pour attirer l'attention
- **Liens cliquables** (email, téléphone)
- **Checklist** des actions à faire
- **Informations** prioritaires mises en avant

## 🎯 Données Traitées

### **Paramètres reçus du webhook :**

- `inscription_id` - ID unique
- `nom`, `prenom` - Contact principal
- `email`, `telephone` - Coordonnées
- `nombre_personnes` - Effectif total
- `prix_total` - Montant en euros
- `evenement` - Nom de l'événement
- `date_inscription` - Timestamp
- `statut` - État de l'inscription
- `participants` - JSON des participants

### **Traitement automatique :**

✅ **Parsing JSON** des participants  
✅ **Calcul des âges** automatique  
✅ **Formatage des dates** en français  
✅ **Génération des listes** numérotées  
✅ **HTML responsive** pour tous clients email  

## 🔄 Personnalisation

### **Modifier les emails :**

**Dans le nœud "Préparer Emails" :**

```javascript
// Pour changer le sujet du client :
subject: `Votre nouveau sujet - ${inscriptionData.evenement}`,

// Pour modifier le contenu HTML :
html: `Votre nouveau template HTML...`
```

### **Ajouter des champs :**

**Dans le nœud "Extraire Données" :**

```json
{
  "name": "nouveau_champ",
  "value": "={{ $json.query.nouveau_champ }}"
}
```

### **Changer les destinataires :**

**Dans les nœuds Email :**

```
// Email admin vers une autre adresse :
toEmail: "admin@votre-domaine.com"

// Email client avec copie :
toEmail: "={{ $json.to }}, copie@votre-domaine.com"
```

## 🧪 Test du Workflow

### **Test manuel :**

1. **Activez** le workflow
2. **Utilisez** cette URL de test :
```
https://votre-n8n.com/webhook/inscri-week-evtt?inscription_id=123&nom=TEST&prenom=Jean&email=test@example.com&telephone=0123456789&nombre_personnes=2&prix_total=80&evenement=Week-end%20VTT%20Test&date_inscription=2025-01-15T10:30:00.000Z&statut=en_attente&participants=[{"nom":"TEST","prenom":"Jean","date_naissance":"1985-03-15","ordre_participant":1},{"nom":"TEST","prenom":"Marie","date_naissance":"1987-07-22","ordre_participant":2}]
```

3. **Vérifiez** les emails reçus

### **Test depuis le site :**

1. **Soumettez** une vraie inscription sur le site
2. **Consultez** les logs N8N
3. **Vérifiez** que les emails sont envoyés

## 🛡️ Sécurité et Monitoring

### **Recommandations :**

✅ **HTTPS** obligatoire pour le webhook  
✅ **Limitation** du taux de requêtes  
✅ **Monitoring** des échecs d'envoi  
✅ **Sauvegarde** régulière du workflow  
✅ **Test** périodique des emails  

### **Logs et Debug :**

**Pour voir les données reçues :**
- Consultez l'onglet "Executions" dans N8N
- Examinez chaque nœud pour voir les données
- Vérifiez les erreurs SMTP éventuelles

## 📈 Optimisations Possibles

### **Fonctionnalités avancées :**

1. **Base de données** : Stocker les inscriptions dans N8N
2. **Conditions** : Emails différents selon le nombre de participants
3. **Délais** : Rappels automatiques si pas de confirmation
4. **Intégrations** : CRM, calendrier, comptabilité
5. **Statuts** : Mise à jour automatique dans Supabase

### **Templates supplémentaires :**

- Email de **confirmation** après paiement
- Email de **rappel** avant l'événement
- Email de **feedback** après le week-end
- **SMS** pour confirmations urgentes

## 🚀 Mise en Production

### **Checklist avant activation :**

- [ ] **Workflow importé** et testé
- [ ] **SMTP configuré** et fonctionnel
- [ ] **URL webhook** mise à jour sur le site
- [ ] **Emails test** envoyés et reçus
- [ ] **Monitoring** activé
- [ ] **Documentation** partagée avec l'équipe

### **URL finale :**

Une fois configuré, remplacez dans le site :
```javascript
const webhookUrl = 'https://votre-n8n.com/webhook/inscri-week-evtt';
```

---

*Le workflow N8N est maintenant prêt à automatiser complètement la gestion des inscriptions Week-end VTT !* 🎯✨
