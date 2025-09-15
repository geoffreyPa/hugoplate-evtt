# 🆕 Nouvelles Fonctionnalités du Planning VTT

## ✅ Vue Liste par Défaut

Le planning s'ouvre maintenant en **vue liste semaine** pour une lecture chronologique claire et intuitive.

### Vues disponibles :
- **📋 Liste Semaine** (par défaut) - Chronologique jour par jour
- **📋 Liste Mois** - Vue mensuelle en liste
- **📅 Calendrier Mois** - Vue traditionnelle en grille
- **📅 Planning Semaine** - Vue semaine avec créneaux horaires

## 🎯 Système de Filtrage par Groupes

### Fonctionnalités :
- **Boutons de filtre** générés automatiquement selon les groupes dans la base
- **Couleurs coordonnées** - chaque groupe garde sa couleur définie dans Supabase
- **Filtrage multiple** - sélectionnez plusieurs groupes simultanément
- **Compteur dynamique** - nombre de sessions affichées/total
- **Bouton "Tous"** pour réinitialiser les filtres

### Interface :
```
🎯 Filtrer par groupes
[Tous les groupes] [Débutants 8-12 ans] [Intermédiaires 10-14 ans] [Adultes confirmés]
12 sessions pour Débutants 8-12 ans (sur 24 au total)
```

## 🔧 Comment tester

### 1. Prérequis
Assurez-vous que votre base Supabase contient :
- Des sessions dans `vtt_planning`
- Des groupes liés via `vtt_planning_groups`
- Des couleurs définies dans `vtt_groups.color`

### 2. Test des filtres
1. Visitez `/planning`
2. Vérifiez que les boutons de filtre apparaissent
3. Cliquez sur un groupe spécifique
4. Observez le filtrage des événements
5. Testez la sélection multiple
6. Vérifiez le compteur de sessions

### 3. Test des vues
1. Utilisez les boutons de navigation en haut à droite
2. Basculez entre les différentes vues
3. Vérifiez que les filtres restent actifs

## 📊 Structure des Données

### Groupes VTT dans Supabase :
```sql
-- Table vtt_groups
id | name | color | description
1  | Débutants 8-12 ans | bg-green-500 | Enfants débutants
2  | Intermédiaires 10-14 ans | bg-blue-500 | Niveau intermédiaire
3  | Adultes confirmés | bg-purple-500 | Adultes expérimentés
```

### Associations :
```sql
-- Table vtt_planning_groups (liaison planning ↔ groupes)
planning_id | group_id
1          | 1
1          | 2
2          | 3
```

## 🎨 Personnalisation

### Couleurs des groupes
Les couleurs sont définies dans la base via la colonne `vtt_groups.color` :
- Format : Classes Tailwind (`bg-green-500`, `bg-blue-500`, etc.)
- Conversion automatique en hexadécimal pour l'affichage
- Calcul automatique du contraste pour le texte

### Styles CSS
Les styles des filtres sont dans le layout :
```css
.filter-btn.active {
  transform: scale(1.05);
}
```

## 🐛 Dépannage

### Les filtres n'apparaissent pas
1. Vérifiez que des groupes sont associés aux sessions
2. Contrôlez la table `vtt_planning_groups`
3. Regardez la console browser (F12)

### Les couleurs ne s'affichent pas
1. Vérifiez le format des couleurs dans `vtt_groups.color`
2. Utilisez les classes Tailwind standard
3. Exemple correct : `bg-green-500`

### Les filtres ne fonctionnent pas
1. Vérifiez que FullCalendar est chargé
2. Contrôlez les erreurs JavaScript dans la console
3. Testez la connexion Supabase avec `test_supabase.html`

## 📈 Améliorations Futures

### Possibles ajouts :
- **Sauvegarde des filtres** dans localStorage
- **Filtres par moniteur** en plus des groupes
- **Filtres par lieu ou thème**
- **Recherche textuelle** dans les événements
- **Export des sessions filtrées** en PDF/iCal

---

**🎯 Ces fonctionnalités rendent le planning plus intuitif et permettent aux utilisateurs de personnaliser l'affichage selon leurs besoins !**
