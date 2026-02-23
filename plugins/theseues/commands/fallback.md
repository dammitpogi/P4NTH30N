---
description: Trigger model fallback for the Orchestrator
---

Trigger a model fallback for the Orchestrator agent by running the CLI fallback command.

!`bunx oh-my-opencode-theseus fallback orchestrator 2>&1`

If the fallback was successful, the next Orchestrator prompt will use the new model from the fallback chain.
