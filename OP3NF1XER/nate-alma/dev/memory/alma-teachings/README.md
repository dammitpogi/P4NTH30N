# Doctrine Bible System

This directory is the agent-first knowledge system for Nate + Alma doctrine.

## Structure

- `bible/` - canonical ALMA bible index + derived views (Index v4 contract artifacts)
  - `_manifest/manifest.json` - machine index entrypoint used by doctrine search scripts
  - `_schemas/` - JSON schemas for index contract
  - `atoms/`, `mappings/`, `views/`, `ontology/` - Index v4 components
- `substack/` - raw source material corpus (340+ markdown articles)
- `Book/` - book delivery preparation
- `site/` - static pages prepared for Railway exposure
- `legacy/` - historical artifacts and backups

## Agent Retrieval Flow

1. Run `skills/doctrine-engine/scripts/search_bible.py` for ranked semantic results.
2. Run `skills/doctrine-engine/scripts/cite_doctrine.py` to fetch exact line-level citations.
3. Run `skills/doctrine-engine/scripts/query_decision_engine.py` for decision provenance.
4. Include citations in final response.

## Source Doctrine

- Primary corpus: `alma-teachings/substack/` (340+ markdown articles)
- Index v4 entrypoint: `alma-teachings/bible/_manifest/manifest.json`
- Legacy artifacts: `alma-teachings/legacy/index-artifacts/`
