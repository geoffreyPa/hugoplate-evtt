# 🔗 Intégration Webhook - Formulaire d'Inscription

## 📋 Fonctionnalité

L'envoi du formulaire d'inscription Week-end VTT envoie maintenant les données **simultanément** vers :

1. **Supabase** (base de données principale)
2. **Webhook externe** (https://automate.naturavelo.net/webhook/inscri-week-evtt)

## 🚀 Fonctionnement

### **Processus d'envoi :**

1. **Validation** des données du formulaire
2. **Insertion** dans Supabase (inscription + participants)
3. **Envoi webhook** (en parallèle, non-bloquant)
4. **Affichage** du message de succès

### **Stratégie non-bloquante :**

✅ **Si Supabase échoue** → Arrêt complet, erreur affichée  
✅ **Si webhook échoue** → Inscription Supabase conservée, warning en console  
✅ **Pas d'impact** sur l'expérience utilisateur si webhook en panne  

## 📊 Données envoyées au webhook

### **Format : GET avec paramètres URL**

```
GET https://automate.naturavelo.net/webhook/inscri-week-evtt?[PARAMETRES]
```

### **Paramètres inclus :**

| Paramètre | Type | Description | Exemple |
|-----------|------|-------------|---------|
| `inscription_id` | Number | ID unique Supabase | `123` |
| `nom` | String | Nom contact principal | `DUPONT` |
| `prenom` | String | Prénom contact principal | `Jean` |
| `email` | String | Email contact | `jean.dupont@email.com` |
| `telephone` | String | Téléphone contact | `0612345678` |
| `nombre_personnes` | Number | Nombre total participants | `3` |
| `prix_total` | Number | Prix total en euros | `120` |
| `evenement` | String | Nom de l'événement | `Week-end VTT - 20-21 septembre 2025` |
| `date_inscription` | String | Date inscription (ISO) | `2025-01-15T10:30:00.000Z` |
| `statut` | String | Statut inscription | `en_attente` |
| `participants` | String | JSON des participants | `[{"nom":"DUPONT","prenom":"Jean",...}]` |

### **Structure des participants (JSON) :**

```json
[
  {
    "nom": "DUPONT",
    "prenom": "Jean", 
    "date_naissance": "1985-03-15",
    "ordre_participant": 1
  },
  {
    "nom": "DUPONT",
    "prenom": "Marie",
    "date_naissance": "1987-07-22", 
    "ordre_participant": 2
  }
]
```

## 🔧 Configuration technique

### **URL webhook :**
```javascript
const webhookUrl = 'https://automate.naturavelo.net/webhook/inscri-week-evtt';
```

### **Fonction d'envoi :**
```javascript
async function sendToWebhook(inscriptionData, participantsData, inscriptionId) {
  // Construction des paramètres URL
  // Envoi GET non-bloquant  
  // Gestion d'erreur silencieuse
}
```

### **Point d'intégration :**
```javascript
// Après insertion Supabase réussie
await sendToWebhook(inscriptionData, participantsData, inscriptionId);
```

## 🛡️ Gestion d'erreur

### **Logs console :**

**Succès :**
```
console.log('Webhook envoyé avec succès');
```

**Erreur non-bloquante :**
```
console.warn('Erreur lors de l\'envoi vers le webhook (non-bloquant):', error);
```

### **Stratégie de robustesse :**

✅ **Try/catch** autour de l'envoi webhook  
✅ **Timeout implicite** via fetch()  
✅ **Pas d'impact** sur l'inscription principale  
✅ **Warning console** pour debug  

## 🧪 Test de l'intégration

### **Pour vérifier le bon fonctionnement :**

1. **Remplir** le formulaire d'inscription
2. **Soumettre** l'inscription  
3. **Vérifier** console navigateur :
   - ✅ `"Webhook envoyé avec succès"` 
   - ❌ `"Erreur lors de l'envoi vers le webhook"` (si problème)
4. **Vérifier** côté webhook si données reçues

### **URL de test d'exemple :**

```
https://automate.naturavelo.net/webhook/inscri-week-evtt?inscription_id=123&nom=DUPONT&prenom=Jean&email=jean.dupont@email.com&telephone=0612345678&nombre_personnes=2&prix_total=80&evenement=Week-end%20VTT%20-%2020-21%20septembre%202025&date_inscription=2025-01-15T10:30:00.000Z&statut=en_attente&participants=%5B%7B%22nom%22%3A%22DUPONT%22%2C%22prenom%22%3A%22Jean%22%2C%22date_naissance%22%3A%221985-03-15%22%2C%22ordre_participant%22%3A1%7D%2C%7B%22nom%22%3A%22DUPONT%22%2C%22prenom%22%3A%22Marie%22%2C%22date_naissance%22%3A%221987-07-22%22%2C%22ordre_participant%22%3A2%7D%5D
```

## 📈 Avantages

### **1. Intégration transparente :**
✅ **Aucun changement** pour l'utilisateur  
✅ **Double sauvegarde** des données  
✅ **Automatisation** possible côté webhook  

### **2. Fiabilité :**
✅ **Priorité à Supabase** (base principale)  
✅ **Webhook non-bloquant** (pas d'interruption)  
✅ **Retry possible** côté serveur webhook  

### **3. Flexibilité :**
✅ **Données complètes** envoyées  
✅ **Format standardisé** (paramètres GET)  
✅ **Facilité d'intégration** côté récepteur  

## 🔄 Maintenance

### **Pour modifier l'URL webhook :**

Éditer dans `/themes/hugoplate/layouts/week/list.html` :
```javascript
const webhookUrl = 'NOUVELLE_URL_WEBHOOK';
```

### **Pour ajouter des paramètres :**

Modifier la fonction `sendToWebhook()` :
```javascript
params.append('nouveau_parametre', valeur);
```

### **Pour changer la méthode (GET → POST) :**

Modifier la fonction `sendToWebhook()` :
```javascript
const response = await fetch(webhookUrl, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ /* données */ })
});
```

---

*L'intégration webhook est maintenant active et fonctionnelle sur le formulaire d'inscription Week-end VTT.* 🚀✨
