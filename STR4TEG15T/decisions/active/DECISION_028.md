# DECISION_028: XGBoost Dynamic Wager Placement Optimization

**Decision ID**: DECISION_028
**Category**: Machine Learning
**Status**: Phase 1 Implemented (WagerOptimizer rule-based + feature logging; Phase 2 XGBoost deferred until training data)
**Priority**: Medium
**Date**: 2026-02-20
**Oracle Approval**: 90%
**Designer Approval**: Approved

---

## Executive Summary

Replace static jackpot thresholds with XGBoost-based dynamic wager placement. Model learns optimal spin timing and bet sizing from historical profitable bets, considering game patterns, time features, and jackpot history.

**Current Problem**:
- Static thresholds do not adapt to game patterns or time variations
- Manual tuning is required for each game type
- No learning from historical outcomes

**Proposed Solution**:
- XGBoost model trained on historical wins and losses
- Feature engineering: jackpot value, time features, hit frequency, patterns
- WagerOptimizer service integrated with signal generation

---

## Research Source

ArXiv 2401.06086v1 - XGBoost Learning of Dynamic Wager Placement for In-Play Sports Betting

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-028-1 | Create WagerFeatures.cs | WindFixer | Pending | 9 |
| ACT-028-2 | Build training data pipeline | WindFixer | Pending | 9 |
| ACT-028-3 | Create WagerOptimizer.cs | WindFixer | Pending | 10 |
| ACT-028-4 | Integrate with signal generation | WindFixer | Pending | 8 |
| ACT-028-5 | Implement continuous retraining | WindFixer | Pending | 7 |

---

## Files

- C0MMON/Support/WagerFeatures.cs (new)
- H0UND/Services/WagerOptimizer.cs (new)
- H0UND/ML/ (new directory for model storage)

---

## Dependencies

- **Blocks**: DECISION_029
- **Blocked By**: DECISION_027
- **Related**: DECISION_025, DECISION_029, DECISION_030

---

## Designer Strategy

### Phase 1: Feature Engineering
1. Create WagerFeatures with jackpot value, time features, hit frequency
2. Create WagerOutcome for training labels

### Phase 2: Model Training
1. Training data pipeline from MongoDB
2. XGBoost hyperparameter configuration
3. Cross-validation and model serialization

### Phase 3: WagerOptimizer Service
1. Predict method returns spin decision plus bet amount
2. UpdateModel for continuous learning
3. Integration with signal generation pipeline

### Phase 4: Continuous Learning
1. Nightly retraining job
2. A/B testing framework
3. Rollback capability

### Validation
A/B testing against static thresholds.

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 90%
- **Feasibility**: 8/10
- **Risk**: 5/10
- **Complexity**: 6/10
- **Key Findings**: Model performance depends on quality and volume of historical data. Log features first.

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: Approved
- **Key Findings**: Start logging wager features immediately to build dataset before training.

---

*Decision DECISION_028 - XGBoost Dynamic Wager - 2026-02-20*