# 🎯 Page de Gestion des Inscriptions

## 📋 Vue d'ensemble

La page de gestion des inscriptions permet aux participants de **consulter, modifier ou annuler** leur inscription au week-end VTT directement depuis le site web.

### 🔗 **Accès à la page :**
- **URL directe :** `/gestion-inscription/`
- **Via le menu :** "Gérer mon inscription"
- **Fichier autonome :** `gestion_inscriptions.html` (utilisable indépendamment)

## 🚀 **Fonctionnalités disponibles**

### 1. **🔍 Recherche d'inscription**
- Recherche par **email** (utilisé lors de l'inscription)
- Affichage immédiat des résultats
- Gestion des cas d'erreur (email introuvable)

### 2. **👁️ Consultation détaillée**
- **Informations du responsable :** nom, prénom, email, téléphone
- **Détails de l'inscription :** nombre de participants, prix total, date, statut
- **Liste complète des participants :** nom, prénom, date de naissance, âge
- **Statut en temps réel :** En attente, Confirmée, Annulée

### 3. **✏️ Modification de l'inscription**
- **Informations responsable :** modification de tous les champs
- **Détails des participants :** modification nom, prénom, date de naissance
- **Validation automatique :** âge minimum, champs obligatoires
- **Sauvegarde en temps réel** dans Supabase

### 4. **❌ Annulation d'inscription**
- **Process de confirmation :** prévention des erreurs
- **Motif d'annulation :** champ optionnel pour la raison
- **Notification automatique :** l'organisation est prévenue
- **Traçabilité :** historique de l'annulation conservé

### 5. **🖨️ Impression**
- **Récapitulatif d'inscription** formaté pour impression
- **Optimisation print** : masquage des éléments non nécessaires

## 🔧 **Architecture technique**

### **Frontend**
- **HTML/CSS/JavaScript** pur (pas de frameworks)
- **Tailwind CSS** pour le design responsive
- **Font Awesome** pour les icônes
- **Design adaptatif** : mobile, tablette, desktop

### **Backend**
- **Supabase** comme base de données
- **Vue `v_inscriptions_completes`** pour les données
- **Connexion temps réel** aux données

### **Sécurité**
- **Recherche par email** uniquement (pas d'accès libre aux données)
- **Validation côté client et serveur**
- **Pas de suppression définitive** (seulement changement de statut)

## 📱 **Interface utilisateur**

### **Navigation intuitive**
1. **🔍 Recherche** → Saisie de l'email
2. **📊 Résultats** → Affichage de l'inscription trouvée
3. **✏️ Modification** → Formulaire d'édition complet
4. **❌ Annulation** → Process de confirmation sécurisé

### **Design responsive**
- **Mobile** : Navigation simplifiée, formulaires optimisés
- **Tablette** : Grilles adaptatives
- **Desktop** : Interface complète avec tous les détails

### **Feedback utilisateur**
- **Messages de succès/erreur** : notifications temporaires
- **Loading states** : indicateurs de chargement
- **Validation en temps réel** : retour immédiat sur les erreurs

## 🛠️ **Utilisation pour l'organisateur**

### **Avantages**
✅ **Autonomie des participants** : moins de demandes de modification  
✅ **Données toujours à jour** : modifications directes dans Supabase  
✅ **Traçabilité complète** : historique des modifications  
✅ **Notifications d'annulation** : information immédiate des désistements  

### **Notifications automatiques**
- **Annulations** : motif et timestamp dans les notes
- **Modifications** : timestamp de mise à jour automatique
- **Statut visible** : depuis l'interface d'administration

## 🚨 **Gestion des cas particuliers**

### **Emails multiples**
- Si plusieurs inscriptions avec le même email → affichage de la plus récente
- Possibilité d'étendre pour gérer plusieurs inscriptions

### **Inscriptions annulées**
- **Consultation** : toujours possible
- **Modification** : bloquée
- **Réinscription** : possible via le formulaire principal

### **Validations**
- **Âge minimum** : 7 ans (cohérent avec le formulaire d'inscription)
- **Champs obligatoires** : nom, prénom, email, téléphone, date de naissance
- **Format des données** : validation email, téléphone, dates

## 📊 **Données synchronisées**

### **Tables concernées**
- `inscriptions_weekend_vtt` : données principales
- `participants_weekend_vtt` : détails des participants
- `v_inscriptions_completes` : vue consolidée

### **Champs modifiables**
**Responsable :**
- nom, prenom, email, telephone

**Participants :**
- nom, prenom, date_naissance

### **Champs en lecture seule**
- nombre_personnes (pas de modification du nombre)
- prix_total (recalculé automatiquement)
- date_inscription (historique)
- evenement (fixe)

## 🔄 **Workflow utilisateur**

### **Modification typique**
1. 📧 Utilisateur saisit son email
2. 🔍 Système trouve l'inscription
3. 👁️ Affichage des détails actuels
4. ✏️ Clic sur "Modifier"
5. 📝 Édition des champs souhaités
6. 💾 Sauvegarde automatique
7. ✅ Confirmation et retour aux détails

### **Annulation typique**
1. 📧 Recherche de l'inscription
2. ❌ Clic sur "Annuler mon inscription"
3. ⚠️ Lecture des avertissements
4. 📝 Saisie optionnelle du motif
5. ✔️ Confirmation de l'annulation
6. 🔔 Notification de l'organisation

## 📞 **Support utilisateur**

### **Aide intégrée**
- **Instructions claires** sur chaque page
- **Numéro de contact** : 06 82 15 98 74
- **Conseils d'utilisation** : email exact, délais, etc.

### **Messages d'erreur explicites**
- "Aucune inscription trouvée avec cet email"
- "Erreur lors de la sauvegarde. Veuillez réessayer"
- "Votre inscription a été annulée avec succès"

## 🎯 **Objectifs atteints**

✅ **Autonomie** : Les participants gèrent leurs inscriptions  
✅ **Transparence** : Accès direct aux informations  
✅ **Flexibilité** : Modifications jusqu'au 19 septembre  
✅ **Suivi** : Notifications des annulations  
✅ **Simplicité** : Interface intuitive et accessible  

## 🔮 **Évolutions possibles**

### **Fonctionnalités futures**
- **Historique des modifications** : journal des changements
- **Notifications email** : confirmation automatique des modifications
- **Réinscription directe** : après annulation
- **Upload de documents** : certificats médicaux, etc.
- **Gestion des paiements** : statut et relances

### **Améliorations techniques**
- **Authentification avancée** : code de confirmation par email
- **API notifications** : emails automatiques
- **Export personnel** : PDF de l'inscription
- **Calendrier intégré** : ajout à l'agenda personnel

---

*Cette page améliore considérablement l'expérience utilisateur et réduit la charge administrative pour l'organisation.* 🚴‍♂️✨
