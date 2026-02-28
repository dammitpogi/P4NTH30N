Use this runbook when switching between Anthropic Opus, Sonnet, and Haiku in OpenClaw.

Tool path:
`skills/openclaw-model-switch-kit/scripts/switch_anthropic_model.py`

Step 1, pre-audit only:
`python skills/openclaw-model-switch-kit/scripts/switch_anthropic_model.py --target sonnet`

Step 2, apply plus restart:
`python skills/openclaw-model-switch-kit/scripts/switch_anthropic_model.py --target sonnet --apply --restart`

Accepted targets:
`opus`, `sonnet`, `haiku`, or explicit model id such as `anthropic/claude-sonnet-4-5-20250929`.

Required evidence in the response:
The agent must include `PRE-AUDIT`, `MUTATION REPORT`, and `POST-AUDIT` outputs. If any block is missing, model-switch completion is not valid.

Validation rule:
Do not accept a model switch claim unless config paths changed and gateway restart/status outputs are present.
