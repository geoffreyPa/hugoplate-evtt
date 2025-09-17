# 🐛 Guide de Debug - Problème Mobile Formulaire

## 🚨 Problème Initial

**Symptôme :** Sur téléphone, le formulaire reste bloqué en "envoi en cours" et ne fonctionne pas.

## ✅ Corrections Apportées

### **1. Webhook Non-Bloquant**

**Problème :** Le webhook pouvait bloquer l'inscription si lent/inaccessible
**Solution :** Webhook vraiment asynchrone avec timeout de 8 secondes

```javascript
// AVANT (bloquant)
await sendToWebhook(...);

// APRÈS (non-bloquant)
sendToWebhook(...); // avec setTimeout interne
```

### **2. Timeout Global**

**Problème :** Pas de limite de temps pour le processus complet
**Solution :** Timeout de 30 secondes pour tout le processus

```javascript
const inscriptionTimeout = new Promise((_, reject) => {
  setTimeout(() => reject(new Error('Timeout')), 30000);
});

await Promise.race([processusInscription(), inscriptionTimeout]);
```

### **3. Logs de Debug**

**Ajout :** Logs détaillés pour diagnostiquer où ça bloque

## 🔍 Comment Diagnostiquer

### **Étape 1 : Ouvrir la Console**

**Sur Mobile (Chrome/Safari) :**
1. **Chrome :** Menu → Plus d'outils → Outils de développement → Console
2. **Safari :** Réglages → Avancé → Afficher le menu Développement → Console
3. **Firefox Mobile :** about:debugging

**Sur Desktop pour simuler mobile :**
1. **F12** → Console
2. **Ctrl+Shift+M** pour simuler mobile

### **Étape 2 : Suivre les Logs**

**Séquence normale attendue :**
```
🚀 Début de la soumission du formulaire
🔒 Bouton désactivé, traitement en cours...
👥 Nombre de personnes: X
✅ Validation réussie
💾 Début de l'insertion dans Supabase...
📝 Insertion de l'inscription principale...
✅ Inscription créée avec ID: XXX
👥 Insertion des participants...
✅ Participants insérés avec succès
📡 Envoi vers webhook...
🎉 Affichage du message de succès...
🔄 Réinitialisation du formulaire...
✅ Processus d'inscription complètement terminé
🔓 Réactivation du bouton de soumission
```

**Logs webhook (séparés) :**
```
🔄 Tentative d'envoi vers webhook...
📡 URL webhook: https://automate.naturavelo.net/webhook/...
✅ Webhook envoyé avec succès
```

### **Étape 3 : Identifier le Blocage**

**Si ça s'arrête à :**

| Log d'arrêt | Problème probable | Solution |
|-------------|-------------------|----------|
| `🚀 Début de la soumission` | JavaScript cassé | Vérifier erreurs console |
| `✅ Validation réussie` | Problème Supabase | Vérifier clés API |
| `📝 Insertion inscription` | Connexion Supabase | Problème réseau/mobile |
| `✅ Inscription créée` | Insertion participants | Erreur de données |
| `✅ Participants insérés` | Affichage message | Problème DOM |
| `⏰ Timeout` | Connexion trop lente | Réseau mobile faible |

## 🛠️ Solutions par Type d'Erreur

### **Erreur Network/Connexion**

**Symptômes :**
- `Failed to fetch`
- `NetworkError`
- `⏰ Timeout`

**Solutions :**
1. **Vérifier connexion mobile** (4G/WiFi)
2. **Réessayer** avec meilleure connexion
3. **Tester sur Desktop** pour isoler le problème

### **Erreur Supabase**

**Symptômes :**
- `❌ Erreur inscription principale`
- Codes d'erreur Supabase

**Solutions :**
1. **Vérifier clés API** Supabase
2. **Tester en mode Desktop** d'abord
3. **Contacter admin** si problème persiste

### **Erreur Validation**

**Symptômes :**
- `❌ Erreur de validation`
- S'arrête avant Supabase

**Solutions :**
1. **Vérifier tous les champs** remplis
2. **Dates de naissance** valides
3. **Nombre de participants** cohérent

### **Erreur Webhook**

**Symptômes :**
- `❌ Erreur lors de l'envoi vers le webhook`
- `⚠️ Webhook response not OK`

**Impact :** Aucun ! L'inscription est sauvée dans Supabase

## 📱 Tests Spécifiques Mobile

### **Test 1 : Connexion**
```javascript
// Dans la console mobile
fetch('https://jiforbxelcpihbphrtzx.supabase.co').then(r => console.log('Supabase OK')).catch(e => console.log('Supabase KO', e));
```

### **Test 2 : Webhook**
```javascript
// Dans la console mobile
fetch('https://automate.naturavelo.net/webhook/inscri-week-evtt?test=1').then(r => console.log('Webhook OK')).catch(e => console.log('Webhook KO', e));
```

### **Test 3 : Données**
```javascript
// Vérifier si les champs sont bien remplis
console.log('Nom:', document.getElementById('nom').value);
console.log('Participants:', document.getElementById('nombre_personnes').value);
```

## 🔧 Désactiver le Webhook Temporairement

**Si le webhook pose problème :**

1. **Ouvrir** le fichier `themes/hugoplate/layouts/week/list.html`
2. **Commenter** la ligne :
```javascript
// sendToWebhook(inscriptionData, participantsData, inscriptionId);
```
3. **Tester** sans webhook

## 📊 Monitoring Continu

### **URLs de test :**

**Webhook :**
```
https://automate.naturavelo.net/webhook/inscri-week-evtt?test=debug
```

**Supabase :**
```
https://jiforbxelcpihbphrtzx.supabase.co/rest/v1/inscriptions_weekend_vtt?select=count
```

### **Vérifications périodiques :**

1. **Formulaire fonctionne** sur Desktop ✓
2. **Formulaire fonctionne** sur Mobile ✓  
3. **Webhook répond** ✓
4. **Emails N8N** envoyés ✓
5. **Données Supabase** sauvées ✓

## 🚨 Actions d'Urgence

### **Si problème critique :**

1. **Désactiver webhook** (commenter la ligne)
2. **Tester formulaire** sans webhook
3. **Vérifier inscriptions** dans Supabase admin
4. **Contacter support** avec logs console

### **Numéros/Contacts d'urgence :**

- **Admin site :** geoffrey@naturavelo.com
- **Support technique :** [logs console + URL de test]

## ✅ Checklist de Vérification

### **Avant un événement :**

- [ ] **Test inscription Desktop** fonctionne
- [ ] **Test inscription Mobile** fonctionne  
- [ ] **Webhook répond** (logs N8N)
- [ ] **Emails automatiques** reçus
- [ ] **Interface admin** accessible
- [ ] **Sauvegarde Supabase** fonctionnelle

### **En cas de problème :**

- [ ] **Console ouverte** pour voir les logs
- [ ] **Erreur identifiée** selon les logs
- [ ] **Solution appliquée** selon le type d'erreur
- [ ] **Test validé** après correction
- [ ] **Documentation mise à jour** si nécessaire

---

*Avec ces corrections et outils de debug, le formulaire devrait fonctionner de façon fiable sur mobile !* 📱✅
