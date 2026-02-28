# DECISION_161 v1.1: The Volatility Code - Book Writing Plan

**Companion to**: DECISION_161_THE_VOLATILITY_CODE_BOOK_SITE_AGENT_BIBLE.md  
**Purpose**: Detailed writing instructions for fixers, with narrative arcs, source mapping, and Agent Bible integration  
**Date**: 2026-02-26  
**Status**: Draft

---

## Executive Summary

This document provides fixers with precise instructions for writing "The Volatility Code" book. Each section includes:
- **Narrative arc** (tone, theme, key moment, emotion)
- **Source mapping** (specific bible files to reference)
- **Agent Bible integration** (ontology tags, retrieval queries)
- **Writing specifications** (length, style, required subsections)

The book follows a **hero's journey structure** where the reader (Nate) transforms from seeing markets as prediction puzzles to understanding them as probabilistic, flow-driven systems.

---

## Narrative Architecture

### Overall Book Arc: "From Certainty to Probability"

```
Act I: The Illusion (Part I - Foundations)
  ↓ The reader believes markets are predictable
Act II: The Mechanism (Part II - Microstructure)  
  ↓ Discovery of hidden flows that actually drive price
Act III: The Context (Part III - Macro)
  ↓ Understanding how regime shifts override mechanics
Act IV: The Crisis (Part IV - Crisis Architecture)
  ↓ When structure breaks and asymmetry dominates
Act V: The Mind (Part V - Trader Psychology)
  ↓ Integration: probabilistic discipline as survival
```

### Part-Level Narrative Specifications

---

## PART I: FOUNDATIONS
**Narrative Position**: The Illusion - What traders believe vs. reality

### Chapter 1: Why Fundamentals Mislead

#### Section 1.1: Voting Machine vs Weighing Machine
```json
{
  "narrative": {
    "tone": "myth-busting clarity",
    "theme": "The market you imagine is not the market that exists. Short-term sentiment and long-term valuation operate on different physics.",
    "keyMoment": "When Graham's distinction snaps into focus—voting is chaos, weighing is law, and most traders confuse the two.",
    "emotion": "The disorientation of realizing your mental model was wrong, followed by the relief of a clearer framework."
  },
  "sources": {
    "primary": [
      "bible/2025-01-29-april-s-performance-review.md"
    ],
    "secondary": [
      "bible/unknown-date-theory-of-reflexivity-by-george-soros.md"
    ],
    "searchQueries": [
      "voting machine weighing machine Graham",
      "short term sentiment long term valuation",
      "market prediction vs market pricing"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-1-voting-machine",
    "ontology": {
      "TopicEnum": ["FOUNDATIONS", "VOLATILITY"],
      "StructurePatternEnum": ["VOTING_VS_WEIGHING"],
      "MechanismEnum": []
    },
    "anchorTerms": [
      {"term": "voting machine", "weight": 1.0},
      {"term": "weighing machine", "weight": 1.0},
      {"term": "Benjamin Graham", "weight": 0.9}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Open with a trader's failed prediction. Use the April review as case study. End with clear distinction framework.",
    "requiredSubsections": [
      "The Prediction Trap",
      "Graham's Two Markets",
      "When Voting Becomes Weighing (Regime Shifts)",
      "How To Apply: Check which market you're in"
    ]
  }
}
```

#### Section 1.2: Narratives as Post-Hoc Explanations
```json
{
  "narrative": {
    "tone": "skeptical revelation",
    "theme": "The financial media creates stories after the fact. Price moves first, explanations follow. Structure precedes story.",
    "keyMoment": "When the reader sees that the narrative they read this morning was written to explain moves that already happened.",
    "emotion": "Healthy skepticism toward financial media; liberation from narrative-driven trading."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-window-of-risk-disbalance-investigating-the-story-that-the-m.md"
    ],
    "secondary": [
      "bible/unknown-date-tariff-war-bipolar-world-recession-weekly-post-31th-march-4t.md"
    ],
    "searchQueries": [
      "narrative follows price",
      "post-hoc explanation market",
      "story behind volatility"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-1-narratives",
    "ontology": {
      "TopicEnum": ["FOUNDATIONS"],
      "StructurePatternEnum": ["POST_HOC_NARRATIVE"]
    },
    "anchorTerms": [
      {"term": "narrative", "weight": 0.95},
      {"term": "post-hoc", "weight": 0.9},
      {"term": "structure over story", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,800 words",
    "style": "Show a specific news headline and the price action that preceded it. Demonstrate the time lag.",
    "requiredSubsections": [
      "The Headline Paradox",
      "Volatility Creates Narratives",
      "Trading the Structure, Not the Story",
      "Common Mistake: Fading news you just read"
    ]
  }
}
```

#### Section 1.3: Markets as Valuation Mechanisms
```json
{
  "narrative": {
    "tone": "analytical foundation",
    "theme": "Markets are continuous repricing engines. They don't predict—they adapt. Understanding this changes everything.",
    "keyMoment": "When the reader grasps that markets price risk, not outcomes, and that this pricing shifts constantly.",
    "emotion": "Intellectual clarity; the satisfaction of a robust mental model replacing a fragile one."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-what-is-volatility.md"
    ],
    "secondary": [
      "bible/unknown-date-the-concept-of-risk-var-beta-sharpe-sortino-etc.md"
    ],
    "searchQueries": [
      "market valuation mechanism",
      "risk premium repricing",
      "continuous price discovery"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-1-valuation",
    "ontology": {
      "TopicEnum": ["FOUNDATIONS", "VOLATILITY"],
      "RiskEnum": ["MODEL_RISK"]
    },
    "anchorTerms": [
      {"term": "valuation", "weight": 0.9},
      {"term": "risk premium", "weight": 0.85},
      {"term": "repricing", "weight": 0.8}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Build from first principles. Start with 'What is a market?' and derive the repricing function.",
    "requiredSubsections": [
      "The Repricing Engine",
      "Risk Premium as Adaptive Signal",
      "Discount Rates and Macro Constraints",
      "How To Apply: Watch the repricing, not the prediction"
    ]
  }
}
```

#### Section 1.4: Why Volatility Cycles Require a Story
```json
{
  "narrative": {
    "tone": "synthesis and foreshadowing",
    "theme": "Volatility alone doesn't sustain. For a regime to persist, it needs a narrative anchor. This is the paradox: structure drives price, but stories drive persistence.",
    "keyMoment": "When the reader understands that the 2025 volatility cycles needed the AI bubble narrative to sustain—and why that matters for timing.",
    "emotion": "Integration of apparent contradictions; deeper understanding of market psychology."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-playing-the-ai-bubble-long-term-outlook.md"
    ],
    "secondary": [
      "bible/unknown-date-vega-and-vomma-suppressing-feedback-loop-weekly-post-09-13-j.md"
    ],
    "searchQueries": [
      "volatility regime narrative",
      "AI bubble story",
      "cycle persistence psychology"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-1-volatility-story",
    "ontology": {
      "TopicEnum": ["FOUNDATIONS", "VOLATILITY", "REGIMES"],
      "MindsetEnum": ["STRUCTURE_OVER_STORY"]
    },
    "anchorTerms": [
      {"term": "volatility cycle", "weight": 0.95},
      {"term": "regime persistence", "weight": 0.85},
      {"term": "narrative anchor", "weight": 0.8}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,500 words",
    "style": "Use AI bubble as extended case study. Show how mechanics + narrative = sustained regime.",
    "requiredSubsections": [
      "The Paradox: Structure vs Story",
      "Case Study: The AI Bubble Narrative",
      "When Narratives Break (Regime Collapse)",
      "Trading Implications: Use Structure, Respect Story"
    ]
  }
}
```

### Chapter 2: The Volatility Framework

#### Section 2.1: Volatility as Primary Driver
```json
{
  "narrative": {
    "tone": "paradigm shift",
    "theme": "Stop watching price. Start watching volatility. Price is the effect; volatility is the cause.",
    "keyMoment": "When the reader realizes they've been looking at the wrong variable their entire trading career.",
    "emotion": "The shock of a fundamental inversion—followed by the power of a more predictive framework."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-what-is-volatility.md"
    ],
    "secondary": [
      "bible/unknown-date-vol-selling-intraday-post-03-june.md"
    ],
    "searchQueries": [
      "volatility as driver",
      "implied vs realized volatility",
      "volatility precedes price"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-2-volatility-driver",
    "ontology": {
      "TopicEnum": ["VOLATILITY"],
      "MechanismEnum": ["VEGA_DYNAMICS"],
      "MindsetEnum": ["VOLATILITY_FIRST"]
    },
    "anchorTerms": [
      {"term": "volatility", "weight": 1.0},
      {"term": "implied volatility", "weight": 0.95},
      {"term": "realized volatility", "weight": 0.95}
    ]
  },
  "writingSpec": {
    "targetLength": "1,800-2,200 words",
    "style": "Open with the mathematical definition. Build to the trading implication. Use concrete examples.",
    "requiredSubsections": [
      "The Mathematical Definition",
      "Why Returns, Not Prices",
      "Implied vs Realized: The Expectation Gap",
      "Volatility as Liquidity Signal",
      "How To Apply: Volatility-first analysis"
    ]
  }
}
```

#### Section 2.2: Micro vs Macro Cycles
```json
{
  "narrative": {
    "tone": "dimensional expansion",
    "theme": "Markets operate on nested timeframes. Micro cycles are mechanical; macro cycles are structural. Confuse them and you trade the wrong game.",
    "keyMoment": "When the reader sees how OpEx flows (micro) interact with Fed regime shifts (macro)—and why timing requires both lenses.",
    "emotion": "Dimensional thinking; the ability to hold multiple timeframes simultaneously."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-opex-flows-pt-2-intraday-post-19-sept.md",
      "bible/unknown-date-opex-flows-intraday-post-17-july.md"
    ],
    "secondary": [
      "bible/unknown-date-weekly-post-18-22-aug.md"
    ],
    "searchQueries": [
      "micro cycles macro cycles",
      "OpEx flows mechanical",
      "Fed regime structural"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-2-micro-macro",
    "ontology": {
      "TopicEnum": ["MICROSTRUCTURE", "MACRO", "REGIMES"],
      "TimeframeEnum": ["INTRADAY", "DAILY", "WEEKLY", "REGIME_SCALE"]
    },
    "anchorTerms": [
      {"term": "micro cycle", "weight": 0.9},
      {"term": "macro cycle", "weight": 0.9},
      {"term": "mechanical flows", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Contrast specific examples: OpEx pinning (micro) vs Fed pivot (macro). Show interaction.",
    "requiredSubsections": [
      "The Timeframe Stack",
      "Micro: Mechanical and Predictable",
      "Macro: Structural and Adaptive",
      "When Micro Overwhelms Macro (and Vice Versa)",
      "How To Apply: Multi-timeframe analysis"
    ]
  }
}
```

#### Section 2.3: Mechanical vs Narrative Flows
```json
{
  "narrative": {
    "tone": "dualistic clarity",
    "theme": "Dealer hedging is mechanical—it follows rules. Macro narratives are psychological—they follow belief. Both move markets, but only one is predictable.",
    "keyMoment": "When the reader can distinguish a gamma flip (mechanical) from a tariff headline (narrative) in real-time.",
    "emotion": "Discrimination power; the ability to categorize market moves by their true driver."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-opex-flows-pt-2-intraday-post-19-sept.md"
    ],
    "secondary": [
      "bible/unknown-date-tariff-war-bipolar-world-recession-weekly-post-31th-march-4t.md"
    ],
    "searchQueries": [
      "dealer hedging mechanical",
      "gamma flows predictable",
      "narrative vs mechanical"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-2-mechanical-narrative",
    "ontology": {
      "TopicEnum": ["MICROSTRUCTURE", "DEALER_FLOWS"],
      "MechanismEnum": ["GAMMA", "VANNA", "DELTA_HEDGING"]
    },
    "anchorTerms": [
      {"term": "mechanical flow", "weight": 0.9},
      {"term": "dealer hedging", "weight": 0.9},
      {"term": "narrative flow", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Side-by-side comparison. Use specific examples from September OpEx and March tariffs.",
    "requiredSubsections": [
      "The Mechanics of Hedging",
      "The Psychology of Narrative",
      "Distinguishing the Two in Real-Time",
      "Trading Each Type Differently",
      "Common Mistake: Treating narrative as mechanical"
    ]
  }
}
```

#### Section 2.4: When Structural Flows Break
```json
{
  "narrative": {
    "tone": "warning and preparation",
    "theme": "Mechanical flows work until they don't. Tail events, regime shifts, and liquidity shocks can override any model. The wise trader knows the limits of their framework.",
    "keyMoment": "When the reader internalizes that no model is forever—and that recognizing model breakdown is a trading edge.",
    "emotion": "Respectful humility; the confidence to use models combined with the wisdom to abandon them when they break."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-window-of-risk-has-just-opened-weekly-post-22-26-sept.md",
      "bible/unknown-date-thin-left-tail-intraday-post-06-oct.md"
    ],
    "secondary": [
      "bible/unknown-date-the-hidden-left-tail.md"
    ],
    "searchQueries": [
      "structural flow breakdown",
      "tail risk override",
      "model breakdown signals"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-2-flows-break",
    "ontology": {
      "TopicEnum": ["TAIL_RISK", "REGIMES"],
      "RiskEnum": ["TAIL_RISK", "LEFT_TAIL", "MODEL_RISK"],
      "MechanismEnum": ["LIQUIDITY_EVAPORATION"]
    },
    "anchorTerms": [
      {"term": "flow breakdown", "weight": 0.9},
      {"term": "tail event", "weight": 0.95},
      {"term": "regime shift", "weight": 0.9}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,500 words",
    "style": "Use specific breakdown examples. Show the warning signs. Emphasize invalidation.",
    "requiredSubsections": [
      "The Limits of Mechanical Models",
      "Warning Signs: When to Suspect Breakdown",
      "Case Study: Window of Risk Override",
      "Invalidation Discipline",
      "How To Apply: Always define 'I'm wrong when...'"
    ]
  }
}
```

### Chapter 3: Liquidity Is Everything

#### Section 3.1: Spot Decay Mechanics
```json
{
  "narrative": {
    "tone": "mechanical revelation",
    "theme": "Markets can decline without crashing. Spot decay is controlled repricing—volatility suppression combined with gradual downside drift.",
    "keyMoment": "When the reader sees how the market can grind lower for months while VIX stays low—and why this is intentional.",
    "emotion": "The recognition of a hidden pattern; the ability to see through the 'calm market' illusion."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-appendix-for-today-s-intraday-post.md"
    ],
    "secondary": [
      "bible/unknown-date-liquidity-structure-let-s-put-speed-profile-into-context.md"
    ],
    "searchQueries": [
      "spot decay mechanics",
      "controlled decline",
      "volatility suppression drift"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-3-spot-decay",
    "ontology": {
      "TopicEnum": ["LIQUIDITY", "VOLATILITY"],
      "MechanismEnum": ["SPOT_DECAY", "VOL_SUPPRESSION"],
      "StructurePatternEnum": ["OSCILLATION_NEGATIVE_DRIFT"]
    },
    "anchorTerms": [
      {"term": "spot decay", "weight": 1.0},
      {"term": "controlled decline", "weight": 0.9},
      {"term": "volatility suppression", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Explain the mechanics clearly. Use the appendix post as primary example. Show how it works.",
    "requiredSubsections": [
      "What is Spot Decay?",
      "The Mechanics: How It's Managed",
      "Why Volatility Stays Low",
      "Identifying Spot Decay Regimes",
      "Trading Spot Decay (Carefully)"
    ]
  }
}
```

#### Section 3.2: Liquidity Evaporation
```json
{
  "narrative": {
    "tone": "crisis foreshadowing",
    "theme": "Liquidity is always there—until it isn't. One-sided positioning removes the bid, and markets become fragile.",
    "keyMoment": "When the reader understands that liquidity is a function of positioning balance, not market structure—and can see fragility before it breaks.",
    "emotion": "Vigilance; the ability to sense danger before it arrives."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-liquidity-structure-let-s-put-speed-profile-into-context.md"
    ],
    "secondary": [
      "bible/unknown-date-ahead-of-fomc-pt-2-heading-into-a-liquidity-crisis-intraday-.md"
    ],
    "searchQueries": [
      "liquidity evaporation",
      "one-sided positioning",
      "fragile market structure"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-3-liquidity-evap",
    "ontology": {
      "TopicEnum": ["LIQUIDITY"],
      "MechanismEnum": ["LIQUIDITY_EVAPORATION"],
      "RiskEnum": ["LIQUIDITY_RISK"]
    },
    "anchorTerms": [
      {"term": "liquidity evaporation", "weight": 1.0},
      {"term": "one-sided positioning", "weight": 0.9},
      {"term": "fragility", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,800 words",
    "style": "Build from specific examples. Show the before/during/after of liquidity crises.",
    "requiredSubsections": [
      "Liquidity as Positioning Balance",
      "Warning Signs of Evaporation",
      "Case Study: [Specific Event]",
      "Trading in Low-Liquidity Regimes",
      "Common Mistake: Assuming liquidity is constant"
    ]
  }
}
```

#### Section 3.3: Oscillation with Negative Drift
```json
{
  "narrative": {
    "tone": "pattern recognition",
    "theme": "Range-bound markets aren't neutral. They can have a directional bias hidden in the oscillation—chop that grinds lower.",
    "keyMoment": "When the reader sees the 'range' as a downward-sloping channel, not a flat band—and adjusts their trading accordingly.",
    "emotion": "Pattern clarity; the ability to see hidden structure in apparent randomness."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-appendix-for-today-s-intraday-post.md"
    ],
    "secondary": [
      "bible/unknown-date-liquidity-structure-let-s-put-speed-profile-into-context.md"
    ],
    "searchQueries": [
      "oscillation negative drift",
      "rangebound with bias",
      "chop and drift"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-3-oscillation",
    "ontology": {
      "TopicEnum": ["LIQUIDITY", "VOLATILITY"],
      "MechanismEnum": ["OSCILLATION_NEGATIVE_DRIFT"],
      "StructurePatternEnum": ["OSCILLATION_NEGATIVE_DRIFT"]
    },
    "anchorTerms": [
      {"term": "oscillation", "weight": 0.9},
      {"term": "negative drift", "weight": 0.95},
      {"term": "rangebound", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,500 words",
    "style": "Visual explanation. Use charts/figures if possible. Show the slope within the range.",
    "requiredSubsections": [
      "The Illusion of Neutrality",
      "Identifying Hidden Drift",
      "Mechanics: Why Drift Occurs",
      "Trading Oscillation with Drift",
      "Mean Reversion Traps"
    ]
  }
}
```

#### Section 3.4: Managed Markets and Crash Prevention
```json
{
  "narrative": {
    "tone": "institutional insight",
    "theme": "Modern markets have circuit breakers, vol control, and institutional intervention. Crashes are managed—but this management embeds future risk.",
    "keyMoment": "When the reader understands that 'crash prevention' doesn't mean 'risk elimination'—it means 'risk transformation and delay.'",
    "emotion": "Sophisticated understanding; seeing the full picture of modern market structure."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-appendix-for-today-s-intraday-post.md"
    ],
    "secondary": [
      "bible/unknown-date-the-bessent-put-spy-yields-correlation-hidden-qe.md"
    ],
    "searchQueries": [
      "managed markets",
      "crash prevention",
      "institutional intervention",
      "vol control"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-3-managed-markets",
    "ontology": {
      "TopicEnum": ["LIQUIDITY", "REGIMES"],
      "MechanismEnum": ["VOL_SUPPRESSION"],
      "ActorEnum": ["INSTITUTIONS", "VOL_CONTROL_FUNDS"],
      "StructurePatternEnum": ["MANAGED_MARKETS"]
    },
    "anchorTerms": [
      {"term": "managed markets", "weight": 0.9},
      {"term": "crash prevention", "weight": 0.85},
      {"term": "institutional intervention", "weight": 0.8}
    ]
  },
  "writingSpec": {
    "targetLength": "1,500-2,000 words",
    "style": "Explain modern market structure. Discuss vol control, circuit breakers, and hidden QE.",
    "requiredSubsections": [
      "The Modern Market Infrastructure",
      "Vol Control and Targeting",
      "Hidden QE and Intervention",
      "The Cost: Embedded Future Risk",
      "Trading Implications"
    ]
  }
}
```

#### Section 3.5: Kurtosis Compression
```json
{
  "narrative": {
    "tone": "statistical foresight",
    "theme": "When tails are suppressed, the distribution looks safer than it is. Kurtosis compression hides risk—it doesn't eliminate it.",
    "keyMoment": "When the reader sees low VIX not as 'low risk' but as 'compressed risk that will expand violently.'",
    "emotion": "Statistical intuition; the ability to read risk from distribution shape, not just level."
  },
  "sources": {
    "primary": [
      "bible/unknown-date-appendix-for-today-s-intraday-post.md"
    ],
    "secondary": [
      "bible/unknown-date-board-of-peace-greenland-hidden-left-tail-and-kurtosis-geopo.md"
    ],
    "searchQueries": [
      "kurtosis compression",
      "tail suppression",
      "distribution shape risk"
    ]
  },
  "agentBible": {
    "sectionId": "part-i-ch-3-kurtosis",
    "ontology": {
      "TopicEnum": ["VOLATILITY", "TAIL_RISK"],
      "MechanismEnum": ["KURTOSIS_COMPRESSION", "KURTOSIS_EXPANSION"],
      "RiskEnum": ["TAIL_RISK"]
    },
    "anchorTerms": [
      {"term": "kurtosis compression", "weight": 1.0},
      {"term": "tail suppression", "weight": 0.9},
      {"term": "distribution shape", "weight": 0.85}
    ]
  },
  "writingSpec": {
    "targetLength": "1,200-1,500 words",
    "style": "Explain kurtosis intuitively. Use visual examples. Connect to VIX and tail risk.",
    "requiredSubsections": [
      "What is Kurtosis?",
      "Compression: The Calm Before",
      "Expansion: The Storm",
      "Reading Kurtosis in Market Data",
      "Trading Compressed Regimes"
    ]
  }
}
```

---

## PART II: MICROSTRUCTURE AND DEALER FLOWS

*[Continue with Chapters 4-7 following same format...]*

---

## Fixer Writing Guidelines

### Standard Section Template

Every section MUST include:

1. **Opening Hook** (1-2 paragraphs)
   - Concrete scenario or paradox
   - Reader pain point or misconception
   - Promise of clarity

2. **Core Concepts** (60% of section)
   - 3-5 subsections with clear headings
   - Each concept explained with:
     - Definition
     - Mechanism (how it works)
     - Example from bible sources
     - Trading implication

3. **How To Apply** (15% of section)
   - Step-by-step workflow
   - Checklist format preferred
   - Concrete action items

4. **Common Mistakes** (10% of section)
   - 3-5 bullet points
   - Each with explanation of why it's wrong
   - Correction guidance

5. **Self-Check** (5% of section)
   - 3-5 questions
   - Answers should be verifiable from section content

### Citation Format

**Inline citations**:
```
As Alma noted in the April performance review [bible/2025-01-29-april-s-performance-review.md], 
the distinction between voting and weighing machines becomes critical during regime shifts.
```

**Block quotes**:
```
From the September OpEx flows analysis:

> "Passive flows can be overwritten/interfered by shadow greek generated flows..."
> — [bible/unknown-date-opex-flows-pt-2-intraday-post-19-sept.md]
```

**Agent Bible references**:
```
ALMA retrieval query for this concept: "voting machine weighing machine Graham"
```

### Style Requirements

- **Tone**: Conversational but precise. Like a mentor explaining to a serious student.
- **Voice**: Active, direct. "You will see..." not "One might observe..."
- **Jargon**: Define on first use. Keep glossary terms consistent.
- **Length**: Target ranges are firm. Edit ruthlessly to fit.
- **Transitions**: Every subsection must connect to the next with a transition sentence.

### Source Integration Rules

1. **Primary sources**: Must be cited in every section
2. **Secondary sources**: Use for depth and validation
3. **Search queries**: Document the queries used so ALMA can replicate
4. **Contradictions**: If sources disagree, note it and explain the resolution
5. **Gaps**: If no source covers a concept, mark it [AUTHOR_NEEDED] and flag for Alma review

---

## Agent Bible Integration Specifications

### Section File Schema (for Agent Bible)

```json
{
  "sectionId": "part-{I,II,III,IV,V}-ch-{N}-{section-slug}",
  "bookRef": "Part X, Chapter Y, Section Z",
  "title": "Section Title",
  "mission": "What this section teaches",
  "narrative": {
    "tone": "...",
    "theme": "...",
    "keyMoment": "...",
    "emotion": "..."
  },
  "ontology": {
    "TopicEnum": [...],
    "MechanismEnum": [...],
    "StructurePatternEnum": [...],
    "TimeframeEnum": [...],
    "RiskEnum": [...],
    "MindsetEnum": [...]
  },
  "anchorTerms": [
    {"term": "...", "weight": 0.0-1.0}
  ],
  "sources": {
    "primary": [...],
    "secondary": [...]
  },
  "retrievalQueries": [
    "natural language query for ALMA"
  ],
  "relatedSections": [
    "sectionId of related content"
  ],
  "keyTakeaways": [
    "bullet point summary"
  ]
}
```

### ALMA Query Interface

When ALMA needs to answer a question, the system should:

1. **Classify intent** using query keywords
2. **Expand query** using ontology synonyms (from weights.json)
3. **Search Agent Bible sections** by anchor terms
4. **Retrieve source passages** from bible/ files
5. **Rank results** by relevance score
6. **Return**: Answer + citations + confidence score

Example ALMA interaction:
```
Nate: "What did Alma say about gamma flips?"

ALMA: 
"Alma discusses gamma flips in multiple contexts:

1. **Mechanics** [Part II, Ch 4]: Gamma flips are levels where dealer 
   hedging behavior changes sign. When SPX crosses a gamma flip, 
   dealers switch from buying dips to selling rallies (or vice versa).
   Source: [bible/unknown-date-opex-flows-pt-2-intraday-post-19-sept.md]

2. **Trading Application** [Part II, Ch 4]: Key gamma flip points 
   at 5890 and 5856 created mechanical suppression and acceleration 
   effects during February OpEx.
   Source: [bible/unknown-date-intraday-post-28-feb.md]

3. **Misconceptions** [Part II, Ch 4]: Gamma flips are not absolute 
   support/resistance—they're transition zones where flow dynamics change.

Retrieval confidence: 95%"
```

---

## Index Fixes and Standardization

### Issues Found in Current Index

1. **Inconsistent file naming**: Mix of `2025-01-29-` dated files and `unknown-date-` files
2. **Truncated content**: Many bible files have raw Substack HTML content, not clean markdown
3. **Missing semantic tags**: Current index has basic tokens but not weighted ontology
4. **No section mapping**: No connection between bible content and Book sections

### Standardization Rules for Fixers

**Rule 1: File Naming**
- Keep existing names for reference
- Create canonical aliases in Agent Bible mapping
- Example: `bible/unknown-date-opex-flows-pt-2-intraday-post-19-sept.md` → alias `opex-flows-sept-19`

**Rule 2: Content Cleaning**
- Bible files should contain clean markdown only
- Remove Substack HTML artifacts
- Keep: Title, Date, Source URL, Body, Captured Comments
- Remove: Navigation, Share buttons, Subscription CTAs

**Rule 3: Index Updates**
- Each bible file needs entry in `index/bible-index.json` with:
  - File path
  - Title
  - Date (parsed from filename or content)
  - Source URL
  - Top terms (from tokenization)
  - Ontology tags (from manual or AI classification)
  - Related sections (array of Book section IDs)

**Rule 4: Agent Bible Generation**
- After Book section is written, generate Agent Bible entry
- Cross-reference: Bible file → Book sections that cite it
- Update bidirectional links

### Implementation Order

1. **Phase 1**: Clean bible files (remove HTML artifacts)
2. **Phase 2**: Build enhanced bible index with ontology tags
3. **Phase 3**: Write Book sections with citations
4. **Phase 4**: Generate Agent Bible from Book + bible index
5. **Phase 5**: Validate bidirectional links

---

## Next Steps

**For Strategist (Pyxis)**:
- [ ] Review and approve narrative arcs
- [ ] Consult Oracle on technical accuracy
- [ ] Consult Designer on information architecture

**For Fixers (WindFixer/OpenFixer)**:
- [ ] Start with Part I, Chapter 1, Section 1.1
- [ ] Follow writing template exactly
- [ ] Cite sources using specified format
- [ ] Generate Agent Bible entry after each section

**For Nexus**:
- [ ] Review sample section when first complete
- [ ] Validate narrative tone matches intent
- [ ] Approve or revise source mapping

---

## Appendix: Quick Reference

### Bible Search Commands

```bash
# Search by concept
python skills/doctrine-engine/scripts/search_bible.py --query "gamma flip"

# Search with ontology expansion
python skills/doctrine-engine/scripts/search_unified.py \
  --query "vanna flows" \
  --intent microstructure_intraday

# Build section sources
python skills/doctrine-engine/scripts/get_section_sources.py \
  --section part-i-ch-1-voting-machine
```

### Book Build Commands

```bash
# Validate structure
python scripts/validate_book.py

# Generate Agent Bible
python scripts/build_agent_bible.py --book Book/ --output index/agent-bible/

# Build site
python site/build.py --book Book/content/ --output site/dist/
```

---

*This document is a living specification. As fixers write sections, update the source mappings and refine the templates based on what works.*
