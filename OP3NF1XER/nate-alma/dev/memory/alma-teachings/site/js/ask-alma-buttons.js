/**
 * "Ask Alma?" Button Integration
 * Embeds context-aware help buttons throughout lesson content
 */

document.addEventListener('DOMContentLoaded', () => {
  // Find all concept markers in lesson content
  const concepts = document.querySelectorAll('[data-concept]');

  concepts.forEach(el => {
    const concept = el.dataset.concept;
    const button = document.createElement('button');
    button.className = 'ask-alma-btn';
    button.textContent = '[Ask Alma?]';
    button.onclick = (e) => {
      e.preventDefault();
      e.stopPropagation();

      const context = {
        type: 'concept',
        source: 'doctrine-bible',
        concept: concept,
        lesson: {
          id: document.body.dataset.lessonId || null,
          title: document.title,
          chapter: document.body.dataset.chapter || null
        },
        paragraph: el.closest('p')?.textContent?.slice(0, 200) || '',
        timestamp: Date.now()
      };

      if (window.almaChat) {
        almaChat.injectContext(context);
      }
    };

    el.appendChild(button);
  });

  // Auto-detect lesson filename for context injection
  injectFilenameContext();
});

function injectFilenameContext() {
  const path = window.location.pathname;

  // Match lesson pages: lesson-{chapter}-{number}.html
  const lessonMatch = path.match(/lesson-(.+)\.html/);
  if (lessonMatch) {
    document.body.dataset.lessonId = lessonMatch[1];
  }

  // Match chapter pages: chapter-{name}.html
  const chapterMatch = path.match(/chapter-(.+)\.html/);
  if (chapterMatch) {
    document.body.dataset.chapter = chapterMatch[1];
  }

  // Auto-inject page context when chat opens without manual context
  document.addEventListener('alma-chat-open', () => {
    if (window.almaChat && !window.almaChat.context) {
      const lessonId = document.body.dataset.lessonId;
      const chapter = document.body.dataset.chapter;

      if (lessonId || chapter) {
        window.almaChat.injectContext({
          type: 'auto',
          source: 'doctrine-bible',
          lesson: {
            id: lessonId || chapter || null,
            title: document.title,
            url: window.location.href
          },
          timestamp: Date.now()
        });
      }
    }
  });
}
