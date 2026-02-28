#!/usr/bin/env python3
"""
Generate HTML pages for the Alma Teachings textbook
"""

import json
import re
from pathlib import Path

# Paths
SITE_DIR = Path("C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/alma-teachings/site")
CHAPTERS_DIR = SITE_DIR / "chapters"
GUIDES_DIR = SITE_DIR / "guides"

# Load content index
with open(SITE_DIR / "content-index.json", "r", encoding="utf-8") as f:
    content_data = json.load(f)

CHAPTERS = {
    "foundations": {"title": "I. Foundations", "icon": "📖"},
    "principles": {"title": "II. Trading Principles", "icon": "⚖️"},
    "mechanics": {"title": "III. Market Mechanics", "icon": "⚙️"},
    "macro": {"title": "IV. Macro Analysis", "icon": "🌍"},
    "technical": {"title": "V. Technical Analysis", "icon": "📊"},
    "assets": {"title": "VI. Asset Classes", "icon": "💎"},
    "archive": {"title": "VII. Analysis Archive", "icon": "📚"},
}


def load_chapter_guide_html(chapter_key: str) -> str:
    """Load human-first chapter guide HTML fragment if present."""
    guide_path = GUIDES_DIR / f"{chapter_key}.html"
    if not guide_path.exists():
        return ""
    return guide_path.read_text(encoding="utf-8")


def markdown_to_html(content: str) -> str:
    """Convert markdown content to HTML"""
    # Remove the header metadata section
    content = re.sub(
        r"^# .+?\n\n\u003e .+?\n\n\*\*Date:\*\* .+?\n\*\*Source:\*\* .+?\n\n---\n\n",
        "",
        content,
        flags=re.DOTALL,
    )

    # Remove the comments section at the end
    content = re.sub(r"\n---\n\n## Captured Comments.*?$", "", content, flags=re.DOTALL)

    # Convert headers
    content = re.sub(r"^### (.+)$", r"<h3>\1</h3>", content, flags=re.MULTILINE)
    content = re.sub(r"^## (.+)$", r"<h2>\1</h2>", content, flags=re.MULTILINE)
    content = re.sub(r"^# (.+)$", r"<h1>\1</h1>", content, flags=re.MULTILINE)

    # Convert bold and italic
    content = re.sub(r"\*\*\*(.+?)\*\*\*", r"<strong><em>\1</em></strong>", content)
    content = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", content)
    content = re.sub(r"\*(.+?)\*", r"<em>\1</em>", content)

    # Convert links
    content = re.sub(
        r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2" target="_blank">\1</a>', content
    )

    # Convert paragraphs (simple approach)
    paragraphs = content.split("\n\n")
    html_paragraphs = []
    for p in paragraphs:
        p = p.strip()
        if p and not p.startswith("<"):
            p = f"<p>{p}</p>"
        html_paragraphs.append(p)
    content = "\n\n".join(html_paragraphs)

    # Clean up empty paragraphs
    content = re.sub(r"<p>\s*</p>", "", content)

    return content


def get_sidebar_html(current_chapter: str = "", current_lesson: str = "") -> str:
    """Generate sidebar navigation HTML"""
    html = """
    <aside class="sidebar">
      <div class="sidebar-header">
        <div class="sidebar-title">Course Progress</div>
        <div class="sidebar-subtitle">7 Chapters</div>
        <div class="sidebar-progress">
          <div class="progress-label">
            <span>Overall Progress</span>
            <span id="progress-percent">0%</span>
          </div>
          <div class="progress-bar">
            <div class="progress-fill" id="progress-fill" style="width: 0%"></div>
          </div>
        </div>
      </div>
      
      <nav class="nav-tree">"""

    for chapter_key, chapter in CHAPTERS.items():
        is_active = chapter_key == current_chapter
        expanded = "expanded" if is_active else ""
        active_class = "active" if is_active else ""

        html += f'''
        <div class="nav-section {expanded}" data-section="{chapter_key}">
          <div class="nav-section-header {active_class}">
            <span class="nav-section-icon">{chapter["icon"]}</span>
            <span class="nav-section-title">{chapter["title"]}</span>
            <span class="nav-section-toggle">▶</span>
          </div>
          <div class="nav-section-content">'''

        # Add chapter overview link
        overview_active = (
            "active" if current_lesson == f"{chapter_key}-overview" else ""
        )
        html += f'''
            <a href="./chapter-{chapter_key}.html" class="nav-lesson {overview_active}" data-lesson="{chapter_key}-overview">
              <span class="nav-lesson-number">Overview</span>
              <span class="nav-lesson-title">Chapter Introduction</span>
              <span class="nav-lesson-status"></span>
            </a>'''

        # Lesson pages are intentionally disabled for now.

        html += """
          </div>
        </div>"""

    html += """
      </nav>
    </aside>"""

    return html


def get_header_html() -> str:
    """Generate header HTML"""
    return """
  <header class="header">
    <div class="header-brand">
      <div class="header-logo">DB</div>
      <div>
        <div class="header-title">Doctrine Bible</div>
        <div class="header-subtitle">Trading Curriculum</div>
      </div>
    </div>
    <nav class="header-nav">
      <div class="header-search">
        <span class="header-search-icon">🔍</span>
        <input type="text" id="search-input" placeholder="Search topics... (Ctrl+K)">
        <div class="search-results" id="search-results"></div>
      </div>
      <a href="../index.html" class="nav-btn">📚 Home</a>
      <button class="menu-toggle" onclick="document.querySelector('.sidebar').classList.toggle('open')">☰</button>
    </nav>
  </header>"""


def generate_chapter_overview(chapter_key: str, chapter_data: dict):
    """Generate chapter overview page"""
    chapter_info = CHAPTERS[chapter_key]

    guide_html = load_chapter_guide_html(chapter_key)

    keywords = chapter_data.get("info", {}).get("keywords", [])
    keywords_count = len(keywords) if isinstance(keywords, list) else 0

    chapter_keys = list(CHAPTERS.keys())
    idx = chapter_keys.index(chapter_key)
    prev_key = chapter_keys[idx - 1] if idx > 0 else None
    next_key = chapter_keys[idx + 1] if idx < len(chapter_keys) - 1 else None

    html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{chapter_info["title"]} - Doctrine Bible</title>
  <link rel="stylesheet" href="../css/styles.css">
  <link rel="stylesheet" href="../css/alma-chat.css">
</head>
<body data-chapter="{chapter_key}" data-lesson-id="{chapter_key}-overview">
{get_header_html()}

  <div class="app-container">
{get_sidebar_html(chapter_key, f"{chapter_key}-overview")}

    <main class="main-content">
      <div class="content-wrapper">
        <div class="breadcrumbs">
          <a href="../index.html">Home</a>
          <span class="breadcrumbs-separator">→</span>
          <span class="breadcrumbs-current">{chapter_info["title"]}</span>
        </div>

        <div class="page-header">
          <div class="page-category">{chapter_info["icon"]} Chapter Overview</div>
          <h1 class="page-title">{chapter_info["title"]}</h1>
          <p class="page-subtitle">{chapter_data["info"]["description"]}</p>
          <div class="page-meta">
            <div class="page-meta-item">🏷️ Key Themes: {keywords_count}</div>
          </div>
        </div>

        <div class="content-body">
          <h2>Chapter Guide</h2>
          <p>This chapter guide is written to teach the concepts from basics.</p>

          <div class="chapter-guide">
            {guide_html if guide_html else '<div class="info-box info-box-warning"><div class="info-box-title">Missing Guide</div><p>No chapter guide was found for this chapter yet.</p></div>'}
          </div>

        </div>

        <div class="chapter-nav">
          <a href="{"../index.html" if not prev_key else f"./chapter-{prev_key}.html"}" class="chapter-nav-btn prev">
            <div>
              <div class="chapter-nav-label">← Previous</div>
              <div class="chapter-nav-title">{"Home" if not prev_key else CHAPTERS[prev_key]["title"]}</div>
            </div>
          </a>
          
          <a href="{f"./chapter-{next_key}.html" if next_key else "../index.html"}" class="chapter-nav-btn next">
            <div>
              <div class="chapter-nav-label">Next →</div>
              <div class="chapter-nav-title">{CHAPTERS[next_key]["title"] if next_key else "Home"}</div>
            </div>
          </a>
        </div>
      </div>
    </main>
  </div>

  <script src="../js/app.js"></script>
  <script src="../config/alma-config.js"></script>
  <script src="../js/health-monitor.js"></script>
  <script src="../js/alma-chat.js"></script>
  <script src="../js/ask-alma-buttons.js"></script>
</body>
</html>'''

    output_path = CHAPTERS_DIR / f"chapter-{chapter_key}.html"
    output_path.write_text(html, encoding="utf-8")
    print(f"Generated: {output_path}")


def main():
    """Generate all pages"""
    # Ensure chapters directory exists
    CHAPTERS_DIR.mkdir(exist_ok=True)

    # Generate chapter overview pages
    for chapter_key, chapter_data in content_data["chapters"].items():
        generate_chapter_overview(chapter_key, chapter_data)

    print(f"\nOK: Generated {len(CHAPTERS)} chapter overview pages")


if __name__ == "__main__":
    main()
