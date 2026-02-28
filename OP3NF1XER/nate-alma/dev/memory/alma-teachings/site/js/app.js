/**
 * Doctrine Bible - Textbook Application
 * Navigation and Interactive Features
 */

// ============================================
// STATE MANAGEMENT
// ============================================

const AppState = {
  currentChapter: null,
  completedLessons: JSON.parse(localStorage.getItem('completedLessons') || '[]'),
  expandedSections: JSON.parse(localStorage.getItem('expandedSections') || '[]'),
  searchQuery: '',
  searchResults: [],
  
  init() {
    this.loadProgress();
    this.setupEventListeners();
    this.renderNavigation();
  },

  renderNavigation() {
    // Restore expanded sections from saved state
    if (!Array.isArray(this.expandedSections)) return;
    this.expandedSections.forEach((sectionId) => {
      const section = document.querySelector(`[data-section="${sectionId}"]`);
      if (section) section.classList.add('expanded');
    });
  },
  
  loadProgress() {
    const saved = localStorage.getItem('doctrineBibleProgress');
    if (saved) {
      const data = JSON.parse(saved);
      this.completedLessons = data.completedLessons || [];
      this.expandedSections = data.expandedSections || [];
    }
  },
  
  saveProgress() {
    localStorage.setItem('doctrineBibleProgress', JSON.stringify({
      completedLessons: this.completedLessons,
      expandedSections: this.expandedSections,
      lastVisited: new Date().toISOString()
    }));
  },
  
  markLessonComplete(lessonId) {
    if (!this.completedLessons.includes(lessonId)) {
      this.completedLessons.push(lessonId);
      this.saveProgress();
      this.updateProgressUI();
    }
  },
  
  toggleSection(sectionId) {
    const index = this.expandedSections.indexOf(sectionId);
    if (index > -1) {
      this.expandedSections.splice(index, 1);
    } else {
      this.expandedSections.push(sectionId);
    }
    this.saveProgress();
  }
};

// ============================================
// NAVIGATION
// ============================================

const Navigation = {
  toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    sidebar.classList.toggle('open');
  },
  
  toggleSection(sectionId) {
    const section = document.querySelector(`[data-section="${sectionId}"]`);
    if (section) {
      section.classList.toggle('expanded');
      AppState.toggleSection(sectionId);
    }
  },
  
  goToChapterKey(chapterKey) {
    if (!chapterKey) return;

    // Handles navigation from both root and /chapters pages
    const inChapters = window.location.pathname.includes('/chapters/');
    const prefix = inChapters ? './' : './chapters/';
    window.location.href = `${prefix}chapter-${chapterKey}.html`;
  },

  goToLesson(lessonId, chapterKey) {
    // Lesson pages are intentionally disabled for now.
    // We still use the search index to route the user to the right chapter.
    const inferredChapterKey = chapterKey || (lessonId ? lessonId.split('-')[0] : null);
    this.goToChapterKey(inferredChapterKey);
  },
  
  goToChapter(chapterNum) {
    window.location.href = `./chapters/chapter-${chapterNum}.html`;
  }
};

// ============================================
// SEARCH FUNCTIONALITY
// ============================================

const Search = {
  index: [],
  
  async buildIndex() {
    const candidates = [
      './search-index.json',
      '../search-index.json',
      '/search-index.json',
    ];

    for (const url of candidates) {
      try {
        const response = await fetch(url);
        if (!response.ok) continue;
        this.index = await response.json();
        return;
      } catch {
        // try next
      }
    }
  },
  
  search(query) {
    if (!query || query.length < 2) return [];
    
    const normalizedQuery = query.toLowerCase();

    return this.index
      .filter((item) => {
        const title = (item.title || '').toLowerCase();
        const excerpt = (item.excerpt || '').toLowerCase();
        const chapter = (item.chapter || item.category || '').toLowerCase();
        const filename = (item.filename || '').toLowerCase();

        return (
          title.includes(normalizedQuery) ||
          excerpt.includes(normalizedQuery) ||
          chapter.includes(normalizedQuery) ||
          filename.includes(normalizedQuery)
        );
      })
      .slice(0, 12);
  },
  
  displayResults(results) {
    const container = document.querySelector('.search-results');
    if (!container) return;
    
    if (results.length === 0) {
      container.innerHTML = '<div class="search-result-item"><div class="search-result-title">No results found</div></div>';
    } else {
      container.innerHTML = results.map(result => `
        <div class="search-result-item" onclick="Navigation.goToLesson('${result.id}', '${result.chapter_key || ''}')">
          <div class="search-result-title">${result.title}</div>
          <div class="search-result-excerpt">${result.excerpt}</div>
          <div class="search-result-category">${result.chapter || result.category || ''}</div>
        </div>
      `).join('');
    }
    
    container.classList.add('active');
  },
  
  hideResults() {
    const container = document.querySelector('.search-results');
    if (container) {
      container.classList.remove('active');
    }
  }
};

// ============================================
// PROGRESS TRACKING
// ============================================

const Progress = {
  calculateOverallProgress() {
    const totalLessons = document.querySelectorAll('.nav-lesson').length;
    const completed = AppState.completedLessons.length;
    return totalLessons > 0 ? Math.round((completed / totalLessons) * 100) : 0;
  },
  
  updateProgressUI() {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-label span:last-child');
    
    if (progressFill && progressText) {
      const percentage = this.calculateOverallProgress();
      progressFill.style.width = `${percentage}%`;
      progressText.textContent = `${percentage}%`;
    }
    
    // Update lesson status indicators
    document.querySelectorAll('.nav-lesson').forEach(lesson => {
      const lessonId = lesson.getAttribute('data-lesson');
      const statusIndicator = lesson.querySelector('.nav-lesson-status');
      
      if (statusIndicator) {
        if (AppState.completedLessons.includes(lessonId)) {
          statusIndicator.classList.add('completed');
        } else if (lessonId === AppState.currentChapter) {
          statusIndicator.classList.add('in-progress');
        }
      }
    });
  }
};

// ============================================
// EVENT LISTENERS
// ============================================

AppState.setupEventListeners = function() {
  // Mobile menu toggle
  const menuToggle = document.querySelector('.menu-toggle');
  if (menuToggle) {
    menuToggle.addEventListener('click', () => Navigation.toggleSidebar());
  }
  
  // Section toggles
  document.querySelectorAll('.nav-section-header').forEach(header => {
    header.addEventListener('click', (e) => {
      const section = e.currentTarget.closest('.nav-section');
      const sectionId = section.getAttribute('data-section');
      Navigation.toggleSection(sectionId);
    });
  });
  
  // Search functionality
  const searchInput = document.querySelector('.header-search input');
  if (searchInput) {
    let debounceTimer;
    searchInput.addEventListener('input', (e) => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        const query = e.target.value;
        if (query.length >= 2) {
          const results = Search.search(query);
          Search.displayResults(results);
        } else {
          Search.hideResults();
        }
      }, 300);
    });
    
    searchInput.addEventListener('blur', () => {
      setTimeout(() => Search.hideResults(), 200);
    });
  }
  
  // Keyboard shortcuts
  document.addEventListener('keydown', (e) => {
    // Ctrl/Cmd + K for search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
      e.preventDefault();
      const searchInput = document.querySelector('.header-search input');
      if (searchInput) searchInput.focus();
    }
    
    // Arrow keys for navigation
    if (e.key === 'ArrowLeft' && e.altKey) {
      const prevBtn = document.querySelector('.chapter-nav-btn.prev');
      if (prevBtn) prevBtn.click();
    }
    
    if (e.key === 'ArrowRight' && e.altKey) {
      const nextBtn = document.querySelector('.chapter-nav-btn.next');
      if (nextBtn) nextBtn.click();
    }
  });
  
  // Close sidebar when clicking outside on mobile
  document.addEventListener('click', (e) => {
    const sidebar = document.querySelector('.sidebar');
    const menuToggle = document.querySelector('.menu-toggle');
    
    if (window.innerWidth <= 1024 && 
        sidebar && 
        sidebar.classList.contains('open') &&
        !sidebar.contains(e.target) &&
        !menuToggle.contains(e.target)) {
      sidebar.classList.remove('open');
    }
  });
};

// ============================================
// TABLE OF CONTENTS GENERATION
// ============================================

const TOC = {
  generate() {
    const content = document.querySelector('.content-body');
    if (!content) return;
    
    const headings = content.querySelectorAll('h2, h3');
    if (headings.length === 0) return;
    
    const tocContainer = document.createElement('div');
    tocContainer.className = 'table-of-contents';
    tocContainer.innerHTML = `
      <div class="toc-title">On This Page</div>
      <ul class="toc-list">
        ${Array.from(headings).map(heading => {
          const level = heading.tagName === 'H2' ? 1 : 2;
          const id = heading.id || this.slugify(heading.textContent);
          heading.id = id;
          return `
            <li class="toc-item level-${level}">
              <a href="#${id}">${heading.textContent}</a>
            </li>
          `;
        }).join('')}
      </ul>
    `;
    
    const pageHeader = document.querySelector('.page-header');
    if (pageHeader) {
      pageHeader.after(tocContainer);
    }
    
    // Add smooth scroll behavior
    tocContainer.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const target = document.querySelector(link.getAttribute('href'));
        if (target) {
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    });
  },
  
  slugify(text) {
    return text
      .toLowerCase()
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .substring(0, 50);
  }
};

// ============================================
// INITIALIZATION
// ============================================

document.addEventListener('DOMContentLoaded', () => {
  AppState.init();
  Search.buildIndex();
  TOC.generate();
  Progress.updateProgressUI();
  
  // Prefer explicit page identity from the HTML
  const lessonId = document.body?.getAttribute('data-lesson-id');
  if (lessonId) AppState.currentChapter = lessonId;
});

// Expose to global scope for onclick handlers
window.Navigation = Navigation;
window.AppState = AppState;
window.Search = Search;
