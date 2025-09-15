// Configuration Supabase
const SUPABASE_URL = 'https://mrxqmhzpcrkbfgdlisah.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1yeHFtaHpwY3JrYmZnZGxpc2FoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM0NDcxMjMsImV4cCI6MjA2OTAyMzEyM30.KOYe2BK_G8kVPV1IyEcTfbGz-nOSmh3pZb8bI57ouBw';

class PlanningVTT {
  constructor() {
    this.supabase = null;
    this.calendar = null;
    this.allEvents = [];
    this.filteredEvents = [];
    this.activeFilters = new Set(['all']);
    this.availableGroups = new Set();
    this.init();
  }

  init() {
    // Initialiser Supabase
    this.supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    
    // Initialiser le calendrier immédiatement (le DOM est déjà prêt)
    this.initCalendar();
  }

  // Fonction pour charger les données du planning
  async loadPlanningData() {
    try {
      console.log('Chargement des données du planning...');
      
      // Récupérer les données de planning avec toutes les relations
      const { data: planningData, error } = await this.supabase
        .from('vtt_planning')
        .select(`
          *,
          vtt_locations:location_id(*),
          vtt_themes:theme_id(*),
          vtt_planning_groups(
            vtt_groups(*)
          ),
          vtt_planning_monitors(
            monitors(*)
          )
        `)
        .eq('is_cancelled', false)
        .order('session_date', { ascending: true });
      
      if (error) {
        throw error;
      }
      
      console.log('Données du planning récupérées:', planningData);
      
      // Transformer les données pour FullCalendar
      const events = planningData.map(item => {
        const startDateTime = new Date(`${item.session_date}T${item.start_time}`);
        const endDateTime = new Date(`${item.session_date}T${item.end_time}`);
        
        // Récupérer les groupes associés
        const groups = item.vtt_planning_groups?.map(pg => pg.vtt_groups) || [];
        const groupNames = groups.map(g => g?.name).filter(Boolean);
        
        // Récupérer les moniteurs associés
        const monitors = item.vtt_planning_monitors?.map(pm => pm.monitors) || [];
        const monitorNames = monitors.map(m => m?.name).filter(Boolean);
        
        // Déterminer la couleur basée sur le groupe principal ou le thème
        let eventColor = '#6b7280'; // gris par défaut
        let groupColor = null;
        
        // Couleurs par défaut par nom de groupe si pas de couleur dans les données
        const defaultGroupColors = {
          'Les p\'tits vélos': 'bg-green-500',
          'Samedi matin': 'bg-blue-500',
          'Samedi après-midi': 'bg-orange-500',
          'Mercredi après-midi': 'bg-purple-500',
          'Dimanche matin': 'bg-red-500',
          'Vacances': 'bg-teal-500',
          'Compétition': 'bg-pink-500'
        };
        
        if (groups.length > 0) {
          const primaryGroup = groups[0];
          groupColor = primaryGroup?.color;
          
          // Si pas de couleur définie, utiliser une couleur par défaut basée sur le nom
          if (!groupColor) {
            groupColor = defaultGroupColors[primaryGroup?.name] || 'bg-gray-500';
          }
          
          eventColor = this.parseColor(groupColor);
          console.log(`Événement "${item.vtt_themes?.name || 'Sans titre'}" - Groupe: ${primaryGroup?.name}, Couleur: ${groupColor} -> ${eventColor}`);
        } else if (item.vtt_themes?.color) {
          eventColor = this.parseColor(item.vtt_themes.color);
          console.log(`Événement "${item.vtt_themes?.name}" - Thème couleur: ${item.vtt_themes.color} -> ${eventColor}`);
        } else {
          console.log(`Événement "${item.vtt_themes?.name || 'Sans titre'}" - Couleur par défaut: ${eventColor}`);
        }
        
        return {
          id: item.id,
          title: this.generateEventTitle(item, groups, monitors),
          start: startDateTime,
          end: endDateTime,
          description: item.comment || '',
          extendedProps: {
            lieu: item.vtt_locations?.name || 'Lieu non défini',
            adresse: item.vtt_locations?.address || '',
            theme: item.vtt_themes?.name || 'Thème non défini',
            themeDescription: item.vtt_themes?.description || '',
            groupes: groupNames,
            moniteurs: monitorNames,
            googleMapsUrl: item.google_maps_url || item.vtt_locations?.google_maps_url || '',
            isSpecialSession: item.is_special_session || false,
            sessionDate: item.session_date,
            rawData: item,
            primaryGroupColor: groupColor,
            primaryGroup: groups.length > 0 ? groups[0]?.name : null
          },
          backgroundColor: eventColor,
          borderColor: eventColor,
          textColor: this.getContrastColor(eventColor),
          classNames: groups.length > 0 ? [`group-${groups[0]?.name.toLowerCase().replace(/\s+/g, '-')}`] : []
        };
      });
      
      // Stocker tous les événements et extraire les groupes
      this.allEvents = events;
      this.extractAvailableGroups(planningData);
      
      return events;
      
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error);
      throw error;
    }
  }

  // Générer le titre de l'événement enrichi
  generateEventTitle(planningItem, groups, monitors) {
    let title = '';
    
    // Heure
    const startTime = planningItem.start_time.substring(0, 5); // HH:MM
    const endTime = planningItem.end_time.substring(0, 5); // HH:MM
    title += `${startTime}-${endTime}`;
    
    // Thème ou session spéciale
    if (planningItem.is_special_session) {
      title += ' • ⭐ Session spéciale';
    } else if (planningItem.vtt_themes?.name) {
      title += ` • ${planningItem.vtt_themes.name}`;
    }
    
    // Lieu
    if (planningItem.vtt_locations?.name) {
      title += ` • 📍 ${planningItem.vtt_locations.name}`;
    }
    
    // Moniteurs
    if (monitors.length > 0) {
      const monitorNames = monitors.map(m => m.name).join(', ');
      title += ` • 👨‍🏫 ${monitorNames}`;
    }
    
    return title;
  }

  // Parser les couleurs Tailwind CSS vers hex
  parseColor(colorString) {
    if (!colorString) return '#6b7280';
    
    const colorMap = {
      'bg-red-500': '#ef4444',
      'bg-green-500': '#22c55e',
      'bg-blue-500': '#3b82f6',
      'bg-yellow-500': '#eab308',
      'bg-purple-500': '#a855f7',
      'bg-pink-500': '#ec4899',
      'bg-indigo-500': '#6366f1',
      'bg-orange-500': '#f97316',
      'bg-teal-500': '#14b8a6',
      'bg-cyan-500': '#06b6d4',
      'bg-gray-500': '#6b7280',
      'bg-lime-500': '#84cc16',
      'bg-emerald-500': '#10b981',
      'bg-sky-500': '#0ea5e9',
      'bg-violet-500': '#8b5cf6',
      'bg-rose-500': '#f43f5e',
      'bg-amber-500': '#f59e0b'
    };
    
    // Nettoyer la chaîne de couleur
    const cleanColor = colorString.trim().toLowerCase();
    
    if (colorMap[cleanColor]) {
      return colorMap[cleanColor];
    }
    
    if (cleanColor.startsWith('#')) {
      return cleanColor;
    }
    
    // Fallback par défaut
    return '#6b7280';
  }

  // Calculer la couleur de contraste pour le texte
  getContrastColor(hexColor) {
    // Convertir hex en RGB
    const r = parseInt(hexColor.slice(1, 3), 16);
    const g = parseInt(hexColor.slice(3, 5), 16);
    const b = parseInt(hexColor.slice(5, 7), 16);
    
    // Calculer la luminance
    const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    
    return luminance > 0.5 ? '#000000' : '#ffffff';
  }

  // Extraire les groupes disponibles depuis les données
  extractAvailableGroups(planningData) {
    this.availableGroups.clear();
    
    // Couleurs par défaut pour les groupes
    const defaultColors = [
      'bg-green-500',   // vert
      'bg-blue-500',    // bleu
      'bg-red-500',     // rouge
      'bg-purple-500',  // violet
      'bg-orange-500',  // orange
      'bg-teal-500',    // teal
      'bg-pink-500',    // rose
      'bg-indigo-500'   // indigo
    ];
    
    let colorIndex = 0;
    const seenGroups = new Set();
    
    planningData.forEach(item => {
      const groups = item.vtt_planning_groups?.map(pg => pg.vtt_groups) || [];
      groups.forEach(group => {
        if (group?.name && !seenGroups.has(group.name)) {
          seenGroups.add(group.name);
          
          // Couleurs par défaut par nom de groupe
          const defaultGroupColors = {
            'Les p\'tits vélos': 'bg-green-500',
            'Samedi matin': 'bg-blue-500',
            'Samedi après-midi': 'bg-orange-500',
            'Mercredi après-midi': 'bg-purple-500',
            'Dimanche matin': 'bg-red-500',
            'Vacances': 'bg-teal-500',
            'Compétition': 'bg-pink-500'
          };
          
          // Utiliser la couleur du groupe ou assigner une couleur par défaut
          let groupColor = group.color;
          if (!groupColor || groupColor === 'bg-gray-500') {
            groupColor = defaultGroupColors[group.name] || defaultColors[colorIndex % defaultColors.length];
            colorIndex++;
          }
          
          this.availableGroups.add(JSON.stringify({
            name: group.name,
            color: groupColor
          }));
          
          console.log(`Groupe trouvé: ${group.name} avec couleur: ${groupColor}`);
        }
      });
    });
    
    console.log('Groupes extraits:', Array.from(this.availableGroups).map(str => JSON.parse(str)));
  }

  // Créer les boutons de filtrage par groupes
  createGroupFilters() {
    const groupFiltersContainer = document.getElementById('group-filters');
    if (!groupFiltersContainer) return;

    // Garder le bouton "Tous"
    const allButton = document.getElementById('filter-all');
    
    // Supprimer les anciens filtres (sauf "Tous")
    const existingFilters = groupFiltersContainer.querySelectorAll('.filter-btn:not(#filter-all)');
    existingFilters.forEach(btn => btn.remove());

    // Compter les sessions par groupe
    const groupCounts = this.getGroupCounts();

    // Ajouter les filtres par groupe
    this.availableGroups.forEach(groupStr => {
      const group = JSON.parse(groupStr);
      const count = groupCounts[group.name] || 0;
      
      const button = document.createElement('button');
      button.className = 'filter-btn px-4 py-2 rounded-full text-sm font-medium border-2 transition-all duration-200 relative overflow-hidden';
      button.dataset.group = group.name;
      
      // Appliquer la couleur du groupe
      const color = this.parseColor(group.color);
      button.style.borderColor = color;
      
      // Contenu du bouton avec indicateur visuel de couleur et compteur
      button.innerHTML = `
        <span class="inline-flex items-center gap-2">
          <span class="w-3 h-3 rounded-full flex-shrink-0 ring-2 ring-white ring-opacity-50" style="background-color: ${color}"></span>
          <span class="font-medium">${group.name}</span>
          <span class="px-2 py-0.5 text-xs bg-gray-100 text-gray-600 rounded-full count-badge">${count}</span>
        </span>
      `;
      
      button.addEventListener('click', () => this.toggleFilter(group.name));
      groupFiltersContainer.appendChild(button);
    });

    // Mettre à jour le bouton "Tous" avec compteur
    if (allButton) {
      const totalCount = this.allEvents.length;
      allButton.innerHTML = `
        <span class="inline-flex items-center gap-2">
          <span class="w-3 h-3 rounded-full bg-blue-600 flex-shrink-0 ring-2 ring-white ring-opacity-50"></span>
          <span class="font-medium">Tous les groupes</span>
          <span class="px-2 py-0.5 text-xs bg-gray-100 text-gray-600 rounded-full count-badge">${totalCount}</span>
        </span>
      `;
      allButton.addEventListener('click', () => this.toggleFilter('all'));
    }

    this.updateFilterButtons();
  }

  // Compter les sessions par groupe
  getGroupCounts() {
    const counts = {};
    
    this.allEvents.forEach(event => {
      const groups = event.extendedProps.groupes || [];
      groups.forEach(groupName => {
        counts[groupName] = (counts[groupName] || 0) + 1;
      });
    });
    
    return counts;
  }

  // Basculer un filtre
  toggleFilter(filterName) {
    if (filterName === 'all') {
      this.activeFilters.clear();
      this.activeFilters.add('all');
    } else {
      this.activeFilters.delete('all');
      if (this.activeFilters.has(filterName)) {
        this.activeFilters.delete(filterName);
      } else {
        this.activeFilters.add(filterName);
      }
      
      // Si aucun filtre spécifique, revenir à "tous"
      if (this.activeFilters.size === 0) {
        this.activeFilters.add('all');
      }
    }

    this.updateFilterButtons();
    this.applyFilters();
  }

  // Mettre à jour l'apparence des boutons de filtre
  updateFilterButtons() {
    const buttons = document.querySelectorAll('.filter-btn');
    
    buttons.forEach(btn => {
      const filterName = btn.dataset.group || 'all';
      const isActive = this.activeFilters.has(filterName);
      
      if (isActive) {
        btn.classList.add('active');
        
        if (filterName === 'all') {
          // Bouton "Tous" actif - style plus marqué
          btn.style.backgroundColor = '#1d4ed8'; // blue-700
          btn.style.color = '#ffffff';
          btn.style.borderColor = '#1d4ed8';
          btn.style.borderWidth = '3px';
          btn.style.transform = 'scale(1.08) translateY(-3px)';
          btn.style.boxShadow = '0 8px 25px rgba(29, 78, 216, 0.4), 0 0 0 4px rgba(29, 78, 216, 0.1)';
          btn.style.fontWeight = '700';
        } else {
          // Boutons de groupe actifs - style plus marqué
          const group = Array.from(this.availableGroups)
            .map(str => JSON.parse(str))
            .find(g => g.name === filterName);
          if (group) {
            const color = this.parseColor(group.color);
            const shadowColor = color + '60'; // 60% opacity
            btn.style.backgroundColor = color;
            btn.style.color = this.getContrastColor(color);
            btn.style.borderColor = color;
            btn.style.borderWidth = '3px';
            btn.style.transform = 'scale(1.08) translateY(-3px)';
            btn.style.boxShadow = `0 8px 25px ${shadowColor}, 0 0 0 4px ${color}20`;
            btn.style.fontWeight = '700';
          }
        }
      } else {
        btn.classList.remove('active');
        btn.style.backgroundColor = 'rgba(255, 255, 255, 0.9)';
        btn.style.color = '#4b5563'; // gray-600
        btn.style.transform = 'scale(1) translateY(0)';
        btn.style.boxShadow = '0 2px 4px rgba(0, 0, 0, 0.1)';
        btn.style.borderWidth = '2px';
        btn.style.fontWeight = '500';
        
        // Garder la couleur de bordure mais plus subtile
        if (filterName !== 'all') {
          const group = Array.from(this.availableGroups)
            .map(str => JSON.parse(str))
            .find(g => g.name === filterName);
          if (group) {
            const color = this.parseColor(group.color);
            btn.style.borderColor = color + '80'; // 50% opacity
          }
        } else {
          btn.style.borderColor = '#d1d5db'; // gray-300
        }
      }
    });
  }

  // Appliquer les filtres aux événements
  applyFilters() {
    if (this.activeFilters.has('all')) {
      this.filteredEvents = [...this.allEvents];
    } else {
      this.filteredEvents = this.allEvents.filter(event => {
        const eventGroups = event.extendedProps.groupes || [];
        return eventGroups.some(groupName => this.activeFilters.has(groupName));
      });
    }

    // Mettre à jour le calendrier
    if (this.calendar) {
      this.calendar.removeAllEvents();
      this.calendar.addEventSource(this.filteredEvents);
    }

    this.updateEventsCount();
  }

  // Mettre à jour le compteur d'événements
  updateEventsCount() {
    const countElement = document.getElementById('events-count');
    if (!countElement) return;

    const total = this.allEvents.length;
    const filtered = this.filteredEvents.length;
    
    if (this.activeFilters.has('all')) {
      countElement.innerHTML = `
        <span class="inline-flex items-center gap-2">
          <span class="w-2 h-2 bg-green-500 rounded-full"></span>
          <span class="font-medium text-green-700">${total} sessions affichées</span>
        </span>
      `;
    } else {
      const activeFiltersArray = Array.from(this.activeFilters);
      const groupsList = activeFiltersArray.map(name => {
        const group = Array.from(this.availableGroups)
          .map(str => JSON.parse(str))
          .find(g => g.name === name);
        const color = group ? this.parseColor(group.color) : '#6b7280';
        return `<span class="inline-flex items-center gap-1">
          <span class="w-2 h-2 rounded-full" style="background-color: ${color}"></span>
          <span>${name}</span>
        </span>`;
      }).join(', ');
      
      countElement.innerHTML = `
        <span class="inline-flex items-center gap-2 flex-wrap">
          <span class="font-medium text-blue-700">${filtered} sessions pour:</span>
          ${groupsList}
          <span class="text-gray-500">(sur ${total} au total)</span>
        </span>
      `;
    }
  }

  // Initialiser le calendrier
  async initCalendar() {
    try {
      const events = await this.loadPlanningData();
      
      const calendarEl = document.getElementById('planning-calendar');
      if (!calendarEl) {
        throw new Error('Élément calendar non trouvé');
      }
      
      this.calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'listWeek',
        locale: 'fr',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'listWeek,listMonth,dayGridMonth,timeGridWeek'
        },
        buttonText: {
          today: "Aujourd'hui",
          listWeek: 'Liste semaine',
          listMonth: 'Liste mois',
          month: 'Mois',
          week: 'Semaine'
        },
        events: events,
        eventClick: (info) => this.showEventDetails(info.event),
        eventMouseEnter: (info) => this.showTooltip(info),
        eventMouseLeave: (info) => this.hideTooltip(info),
        height: 'auto',
        aspectRatio: 1.8,
        dayMaxEvents: 3,
        moreLinkText: function(num) {
          return '+ ' + num + ' autres';
        },
        eventDidMount: function(info) {
          // Ajouter des classes pour l'accessibilité
          info.el.setAttribute('role', 'button');
          info.el.setAttribute('tabindex', '0');
          info.el.setAttribute('aria-label', `Événement: ${info.event.title}`);
        }
      });
      
      this.calendar.render();
      
      // Initialiser les filtres
      this.createGroupFilters();
      this.filteredEvents = [...this.allEvents];
      this.updateEventsCount();
      
      // Masquer l'indicateur de chargement et afficher le calendrier et les filtres
      this.hideLoading();
      this.showCalendar();
      this.showFilters();
      
    } catch (error) {
      console.error('Erreur lors de l\'initialisation du calendrier:', error);
      this.hideLoading();
      this.showError('Erreur lors du chargement du planning: ' + error.message);
    }
  }

  // Gestion des tooltips
  showTooltip(info) {
    const tooltip = document.createElement('div');
    tooltip.className = 'calendar-tooltip bg-gradient-to-br from-gray-900 to-gray-800 text-white p-4 rounded-xl shadow-2xl z-50 absolute max-w-sm border border-gray-600';
    
    const event = info.event;
    const props = event.extendedProps;
    
    // Construire les groupes avec leurs couleurs
    let groupsDisplay = '';
    if (props.groupes.length > 0) {
      const groupsWithColors = props.groupes.map(groupName => {
        const group = Array.from(this.availableGroups)
          .map(str => JSON.parse(str))
          .find(g => g.name === groupName);
        const color = group ? this.parseColor(group.color) : '#6b7280';
        return `<span class="inline-flex items-center gap-1">
          <span class="w-2 h-2 rounded-full" style="background-color: ${color}"></span>
          <span>${groupName}</span>
        </span>`;
      }).join(', ');
      groupsDisplay = `<div class="flex items-center gap-1 flex-wrap">👥 ${groupsWithColors}</div>`;
    }
    
    tooltip.innerHTML = `
      <div class="space-y-2">
        <div class="font-semibold text-sm border-b border-gray-600 pb-2">
          ${props.isSpecialSession ? '⭐ ' : ''}${props.theme || 'Cours VTT'}
        </div>
        <div class="text-xs space-y-1.5">
          <div class="flex items-center gap-2">
            <span class="text-blue-300">🕐</span>
            <span>${event.start.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})} - ${event.end.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="text-green-300">📍</span>
            <span>${props.lieu}</span>
          </div>
          ${props.moniteurs.length > 0 ? `
            <div class="flex items-center gap-2">
              <span class="text-yellow-300">👨‍🏫</span>
              <span>${props.moniteurs.join(', ')}</span>
            </div>
          ` : ''}
          ${groupsDisplay}
          ${props.isSpecialSession ? `<div class="text-yellow-300 font-medium">⭐ Événement spécial</div>` : ''}
        </div>
        <div class="text-xs text-gray-400 pt-2 border-t border-gray-600">
          Cliquez pour plus de détails
        </div>
      </div>
    `;
    
    document.body.appendChild(tooltip);
    
    // Positionner le tooltip avec une marge plus importante
    const rect = info.el.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();
    
    let left = rect.left + (rect.width / 2) - (tooltipRect.width / 2);
    let top = rect.top - tooltipRect.height - 15;
    
    // Ajuster si le tooltip sort de l'écran
    if (left < 15) left = 15;
    if (left + tooltipRect.width > window.innerWidth - 15) {
      left = window.innerWidth - tooltipRect.width - 15;
    }
    if (top < 15) {
      top = rect.bottom + 15;
    }
    
    tooltip.style.left = left + 'px';
    tooltip.style.top = top + 'px';
    
    // Animation d'apparition
    tooltip.style.opacity = '0';
    tooltip.style.transform = 'scale(0.95) translateY(5px)';
    setTimeout(() => {
      tooltip.style.transition = 'all 0.2s ease-out';
      tooltip.style.opacity = '1';
      tooltip.style.transform = 'scale(1) translateY(0)';
    }, 10);
    
    info.el.tooltip = tooltip;
  }

  hideTooltip(info) {
    if (info.el.tooltip) {
      document.body.removeChild(info.el.tooltip);
      info.el.tooltip = null;
    }
  }

  // Fonction pour afficher les détails d'un événement
  showEventDetails(event) {
    const props = event.extendedProps;
    
    // Construire les groupes avec leurs couleurs
    let groupsDisplay = '';
    if (props.groupes.length > 0) {
      const groupsWithColors = props.groupes.map(groupName => {
        const group = Array.from(this.availableGroups)
          .map(str => JSON.parse(str))
          .find(g => g.name === groupName);
        const color = group ? this.parseColor(group.color) : '#6b7280';
        return `
          <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-sm font-medium" style="background-color: ${color}20; color: ${color}; border: 1px solid ${color}40;">
            <span class="w-2 h-2 rounded-full" style="background-color: ${color}"></span>
            ${groupName}
          </span>
        `;
      }).join('');
      groupsDisplay = `
        <div class="space-y-2">
          <h5 class="text-sm font-semibold text-gray-600 uppercase tracking-wide">👥 Groupes participants</h5>
          <div class="flex flex-wrap gap-2">${groupsWithColors}</div>
        </div>
      `;
    }

    // Construire les moniteurs
    let monitorsDisplay = '';
    if (props.moniteurs.length > 0) {
      const monitorsFormatted = props.moniteurs.map(monitorName => `
        <span class="inline-flex items-center gap-2 px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-sm font-medium">
          <span class="w-2 h-2 bg-blue-500 rounded-full"></span>
          ${monitorName}
        </span>
      `).join('');
      monitorsDisplay = `
        <div class="space-y-2">
          <h5 class="text-sm font-semibold text-gray-600 uppercase tracking-wide">👨‍🏫 Équipe d'encadrement</h5>
          <div class="flex flex-wrap gap-2">${monitorsFormatted}</div>
        </div>
      `;
    }
    
    const details = `
      <div class="event-details">
        <!-- En-tête avec titre et badge -->
        <div class="relative mb-8">
          <div class="absolute inset-0 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl transform -rotate-1"></div>
          <div class="relative bg-white rounded-2xl p-6 border border-gray-100 shadow-sm">
            <div class="flex justify-between items-start mb-4">
              <div>
                <h3 class="text-3xl font-bold text-gray-900 mb-2">${props.theme || 'Cours VTT'}</h3>
                <p class="text-lg text-gray-600">${event.start.toLocaleDateString('fr-FR', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</p>
              </div>
              <div class="flex flex-col items-end gap-2">
                ${props.isSpecialSession ? `
                  <span class="px-4 py-2 rounded-full text-sm font-bold bg-gradient-to-r from-yellow-400 to-orange-400 text-white shadow-lg">
                    ⭐ Session spéciale
                  </span>
                ` : ''}
                <div class="text-right">
                  <div class="text-2xl font-bold text-indigo-600">${event.start.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})} - ${event.end.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'})}</div>
                  <div class="text-sm text-gray-500">Durée: ${Math.round((event.end - event.start) / (1000 * 60 / 60))}h${Math.round(((event.end - event.start) % (1000 * 60 * 60)) / (1000 * 60)).toString().padStart(2, '0')}</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Informations principales en grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
          <!-- Colonne gauche : Infos pratiques -->
          <div class="space-y-6">
            <div class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-6 border border-green-100">
              <h4 class="text-lg font-bold text-green-800 mb-4 flex items-center gap-2">
                <span class="text-2xl">📍</span>
                Lieu de rendez-vous
              </h4>
              <div class="space-y-3">
                <div class="text-xl font-semibold text-green-900">${props.lieu}</div>
                ${props.adresse ? `
                  <div class="text-green-700">
                    <span class="text-sm font-medium">Adresse :</span><br>
                    <span class="text-base">${props.adresse}</span>
                  </div>
                ` : ''}
                ${props.googleMapsUrl ? `
                  <a href="${props.googleMapsUrl}" target="_blank" class="inline-flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-all duration-200 shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
                    <span class="text-lg">🗺️</span>
                    <span class="font-medium">Voir l'itinéraire</span>
                  </a>
                ` : ''}
              </div>
            </div>

            ${props.themeDescription ? `
              <div class="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-6 border border-blue-100">
                <h4 class="text-lg font-bold text-blue-800 mb-3 flex items-center gap-2">
                  <span class="text-2xl">🎯</span>
                  À propos de cette session
                </h4>
                <p class="text-blue-900 leading-relaxed text-base">${props.themeDescription}</p>
              </div>
            ` : ''}
          </div>

          <!-- Colonne droite : Équipe et participants -->
          <div class="space-y-6">
            ${groupsDisplay ? `
              <div class="bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-6 border border-purple-100">
                ${groupsDisplay}
              </div>
            ` : ''}

            ${monitorsDisplay ? `
              <div class="bg-gradient-to-br from-orange-50 to-amber-50 rounded-2xl p-6 border border-orange-100">
                ${monitorsDisplay}
              </div>
            ` : ''}

            <div class="bg-gradient-to-br from-gray-50 to-slate-50 rounded-2xl p-6 border border-gray-100">
              <h4 class="text-lg font-bold text-gray-800 mb-4 flex items-center gap-2">
                <span class="text-2xl">ℹ️</span>
                Informations pratiques
              </h4>
              <div class="space-y-3">
                <div class="flex justify-between items-center py-2 border-b border-gray-200">
                  <span class="text-gray-600 font-medium">Type d'activité</span>
                  <span class="text-gray-900 font-semibold">${props.theme || 'Cours VTT'}</span>
                </div>
                <div class="flex justify-between items-center py-2 border-b border-gray-200">
                  <span class="text-gray-600 font-medium">Durée de la session</span>
                  <span class="text-gray-900 font-semibold">${Math.round((event.end - event.start) / (1000 * 60 * 60 * 100)) / 100}h</span>
                </div>
                <div class="flex justify-between items-center py-2">
                  <span class="text-gray-600 font-medium">Statut</span>
                  <span class="inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-bold ${props.isSpecialSession ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}">
                    <span class="w-2 h-2 rounded-full ${props.isSpecialSession ? 'bg-yellow-500' : 'bg-green-500'}"></span>
                    ${props.isSpecialSession ? 'Événement spécial' : 'Session régulière'}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        ${event.description ? `
          <div class="mb-8">
            <div class="bg-gradient-to-br from-indigo-50 to-blue-50 rounded-2xl p-6 border border-indigo-100">
              <h4 class="text-lg font-bold text-indigo-800 mb-4 flex items-center gap-2">
                <span class="text-2xl">📝</span>
                Commentaires et notes
              </h4>
              <div class="text-indigo-900 leading-relaxed text-base bg-white rounded-lg p-4 border border-indigo-200">
                ${event.description}
              </div>
            </div>
          </div>
        ` : ''}
        
        <!-- Actions en bas -->
        <div class="flex flex-col sm:flex-row justify-between items-center gap-4 pt-6 border-t-2 border-gray-100">
          <button onclick="this.closest('.fixed').remove()" class="order-2 sm:order-1 px-6 py-3 bg-gray-500 text-white rounded-xl hover:bg-gray-600 transition-all duration-200 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5">
            ✕ Fermer
          </button>
          <div class="order-1 sm:order-2 flex flex-wrap gap-3">
            ${props.googleMapsUrl ? `
              <button onclick="window.open('${props.googleMapsUrl}', '_blank')" class="px-6 py-3 bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-xl hover:from-green-600 hover:to-emerald-600 transition-all duration-200 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5 flex items-center gap-2">
                <span class="text-lg">🚗</span>
                Itinéraire
              </button>
            ` : ''}
            <button class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-500 text-white rounded-xl hover:from-blue-600 hover:to-indigo-600 transition-all duration-200 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5 flex items-center gap-2" onclick="alert('Fonctionnalité de contact à implémenter')">
              <span class="text-lg">💬</span>
              Contacter
            </button>
            <button class="px-6 py-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-xl hover:from-purple-600 hover:to-pink-600 transition-all duration-200 font-medium shadow-md hover:shadow-lg transform hover:-translate-y-0.5 flex items-center gap-2" onclick="alert('Fonctionnalité d\\'inscription à implémenter')">
              <span class="text-lg">✏️</span>
              S'inscrire
            </button>
          </div>
        </div>
      </div>
    `;
    
    // Créer la modal agrandie
    const modal = document.createElement('div');
    modal.className = 'fixed inset-0 bg-black bg-opacity-60 flex items-center justify-center z-50 p-4 backdrop-blur-sm';
    modal.innerHTML = `
      <div class="bg-white rounded-3xl shadow-2xl max-w-6xl w-full max-h-[90vh] overflow-y-auto border border-gray-200">
        <div class="sticky top-0 bg-white rounded-t-3xl border-b border-gray-100 px-8 py-4 flex justify-between items-center">
          <div class="text-sm font-medium text-gray-500">Détails de la session</div>
          <button onclick="this.closest('.fixed').remove()" class="w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center transition-colors duration-200">
            <span class="text-gray-600 font-bold">✕</span>
          </button>
        </div>
        <div class="px-8 py-6">
          ${details}
        </div>
      </div>
    `;
    
    document.body.appendChild(modal);
    
    // Animation d'apparition
    modal.style.opacity = '0';
    modal.style.transform = 'scale(0.95)';
    setTimeout(() => {
      modal.style.transition = 'all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)';
      modal.style.opacity = '1';
      modal.style.transform = 'scale(1)';
    }, 10);
    
    // Gestion des événements
    modal.addEventListener('click', (e) => {
      if (e.target === modal) {
        this.closeModal(modal);
      }
    });
    
    modal.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.closeModal(modal);
      }
    });
    
    // Focus pour l'accessibilité
    modal.setAttribute('tabindex', '-1');
    modal.focus();
  }

  // Fermer la modal avec animation
  closeModal(modal) {
    modal.style.transition = 'all 0.2s ease-out';
    modal.style.opacity = '0';
    modal.style.transform = 'scale(0.95)';
    setTimeout(() => {
      modal.remove();
    }, 200);
  }

  // Fonctions utilitaires pour l'UI
  hideLoading() {
    const loading = document.getElementById('loading-indicator');
    if (loading) loading.style.display = 'none';
  }

  showCalendar() {
    const container = document.getElementById('calendar-container');
    if (container) container.style.display = 'block';
  }

  showFilters() {
    const container = document.getElementById('filters-container');
    if (container) container.classList.remove('hidden');
  }

  showError(message) {
    const errorEl = document.getElementById('error-message');
    const errorText = document.getElementById('error-text');
    
    if (errorEl && errorText) {
      errorText.textContent = message;
      errorEl.classList.remove('hidden');
    }
  }

  // Fonction pour rafraîchir les données
  async refreshCalendar() {
    try {
      if (this.calendar) {
        const events = await this.loadPlanningData();
        this.createGroupFilters();
        this.applyFilters();
      }
    } catch (error) {
      console.error('Erreur lors du rafraîchissement:', error);
      this.showError('Erreur lors du rafraîchissement des données');
    }
  }
}

// La classe PlanningVTT est maintenant disponible
// L'instanciation se fait depuis le layout après vérification des dépendances
