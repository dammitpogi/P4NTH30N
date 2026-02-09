Migration plan for refactoring: Game entity removal with embedded data in QU3UE
- Deduplicate QU3UE entries by House/Name (keep earliest Updated)
- Migrate by embedding entire G4ME document into QU3UE.game
- Drop G4ME collection
- Recreate N3XT view to expose embedded game (from QU3UE)
- Sanity check with sample queries
