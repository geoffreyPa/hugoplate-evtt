# 🚵‍♂️ Système de Planning VTT - Guide d'utilisation

## 📋 Vue d'ensemble

Ce système de planning interactif permet d'afficher et de gérer les sessions VTT de votre école. Il utilise **FullCalendar** pour l'interface et **Supabase** pour les données.

## 🏗️ Architecture

### Fichiers principaux :
- **Layout** : `themes/hugoplate/layouts/planning/list.html`
- **JavaScript** : `assets/js/planning.js`
- **Contenu** : `content/english/planning/_index.md`
- **Données d'exemple** : `sample_data.sql`

## 📊 Structure de la base de données

### Tables principales :

#### `vtt_planning` (Planning principal)
- `session_date` : Date de la session
- `start_time` / `end_time` : Heures de début/fin
- `theme_id` : Référence vers `vtt_themes`
- `location_id` : Référence vers `vtt_locations`
- `comment` : Commentaires sur la session
- `is_special_session` : Session spéciale (sortie, compétition)
- `is_cancelled` : Session annulée

#### Tables de référence :
- **`vtt_locations`** : Lieux (nom, adresse, Google Maps)
- **`vtt_themes`** : Thèmes (nom, description, couleur)
- **`vtt_groups`** : Groupes participants (nom, description, couleur)
- **`monitors`** : Moniteurs (nom, spécialité, contact)

#### Tables de liaison :
- **`vtt_planning_groups`** : Association planning ↔ groupes
- **`vtt_planning_monitors`** : Association planning ↔ moniteurs

## 🎨 Fonctionnalités

### Calendrier interactif
- ✅ Vue mois, semaine, jour
- ✅ Navigation en français
- ✅ Couleurs personnalisées par thème/groupe
- ✅ Tooltips informatifs au survol
- ✅ Modales détaillées au clic

### Informations affichées
- 📅 Date et horaires
- 📍 Lieu avec lien Google Maps
- 🎯 Thème de la session
- 👥 Groupes participants
- 👨‍🏫 Moniteurs encadrants
- ⭐ Sessions spéciales
- 📝 Commentaires

## 🚀 Installation et déploiement

### 1. Configuration Supabase
1. Créez les tables avec le schéma fourni
2. Insérez les données d'exemple avec `sample_data.sql`
3. Vérifiez les permissions RLS (Row Level Security)

### 2. Configuration Hugo
1. Les fichiers sont déjà en place
2. Le serveur Hugo compile automatiquement
3. Visitez `/planning` pour voir le résultat

### 3. Personnalisation
- **Couleurs** : Modifiez les couleurs Tailwind dans `parseColor()`
- **Textes** : Adaptez le contenu dans `_index.md`
- **Styles** : Personnalisez les CSS dans le layout

## 🔧 Maintenance

### Ajouter une nouvelle session
```sql
INSERT INTO vtt_planning (session_date, start_time, end_time, theme_id, location_id, comment) 
VALUES ('2024-03-15', '14:00', '16:00', 1, 1, 'Session initiation');

-- Puis associer groupes et moniteurs
INSERT INTO vtt_planning_groups (planning_id, group_id) VALUES (DERNIERE_ID, 1);
INSERT INTO vtt_planning_monitors (planning_id, monitor_id) VALUES (DERNIERE_ID, 1);
```

### Modifier les couleurs
Dans `assets/js/planning.js`, fonction `parseColor()` :
```javascript
const colorMap = {
  'bg-red-500': '#ef4444',
  'bg-green-500': '#22c55e',
  // Ajoutez vos couleurs personnalisées
};
```

## 🐛 Dépannage

### Le calendrier ne s'affiche pas
1. Vérifiez la console browser (F12)
2. Testez la connexion Supabase
3. Vérifiez les permissions RLS

### Données manquantes
1. Vérifiez que les tables contiennent des données
2. Contrôlez les relations foreign key
3. Testez la requête SQL manuellement

### Erreurs de style
1. Vérifiez que Tailwind CSS est chargé
2. Testez la compilation Hugo
3. Inspectez les éléments DOM

## 📱 Responsive Design

Le calendrier s'adapte automatiquement :
- **Desktop** : Vue complète avec sidebar
- **Tablet** : Toolbar adaptée
- **Mobile** : Vue empilée, boutons centrés

## 🔐 Sécurité

### Recommandations :
- Utilisez les **Row Level Security** (RLS) dans Supabase
- Limitez l'accès public en lecture seule
- Protégez les clés API côté serveur pour les modifications

## 📞 Support

Pour toute question technique :
1. Consultez les logs Hugo : `hugo server -v`
2. Vérifiez la console navigateur
3. Testez les requêtes Supabase directement

## 🎯 Fonctionnalités futures

### À implémenter :
- [ ] Système de réservation en ligne
- [ ] Notifications par email
- [ ] Gestion des paiements
- [ ] Interface d'administration
- [ ] Export PDF du planning
- [ ] Synchronisation calendrier externe (Google Calendar)

---

**💡 Conseil** : Sauvegardez régulièrement votre base de données Supabase et testez les modifications sur un environnement de développement avant la production.
