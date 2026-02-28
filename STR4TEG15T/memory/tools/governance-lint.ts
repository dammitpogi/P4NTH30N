#!/usr/bin/env bun
import { parseArgs } from 'util';

type CheckStatus = 'PASS' | 'PARTIAL' | 'FAIL';

type CheckResult = {
  id: string;
  status: CheckStatus;
  details: string;
};

type LintReport = {
  schemaVersion: '1.0.0';
  generatedAt: string;
  inputs: {
    decisionFile: string;
    structuredAskFile: string;
    strategistPrompt: string;
    runtimeOpenFixerPrompt: string;
    repositoryOpenFixerPrompt: string;
  };
  checks: {
    preHandoffGovernance: CheckResult[];
    structuredAskFormat: CheckResult[];
    openfixerPromptParity: CheckResult[];
  };
  summary: {
    pass: number;
    partial: number;
    fail: number;
    overall: CheckStatus;
  };
};

type ParityReport = {
  schemaVersion: '1.0.0';
  generatedAt: string;
  runtimePromptPath: string;
  repositoryPromptPath: string;
  status: CheckStatus;
  sections: Array<{
    section: string;
    status: CheckStatus;
    details: string;
  }>;
  diffSummary: string[];
};

const DEFAULT_DECISION_FILE =
  'C:/P4NTHE0N/STR4TEG15T/decisions/active/DECISION_115.md';
const DEFAULT_STRUCTURED_ASK_FILE =
  'C:/P4NTHE0N/STR4TEG15T/decisions/active/DECISION_115.md';
const DEFAULT_STRATEGIST_PROMPT =
  'C:/Users/paulc/.config/opencode/agents/strategist.md';
const DEFAULT_RUNTIME_OPENFIXER =
  'C:/Users/paulc/.config/opencode/agents/openfixer.md';
const DEFAULT_REPO_OPENFIXER =
  'C:/P4NTHE0N/agents/openfixer.md';
const DEFAULT_OUTPUT =
  'C:/P4NTHE0N/STR4TEG15T/memory/decision-engine/governance-lint-report.json';
const DEFAULT_PARITY_OUTPUT =
  'C:/P4NTHE0N/STR4TEG15T/memory/decision-engine/openfixer-prompt-parity.json';

function hasMatch(content: string, pattern: RegExp): boolean {
  return pattern.test(content);
}

function normalizeSection(text: string): string[] {
  return text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0);
}

function readText(path: string): Promise<string> {
  return Bun.file(path).text();
}

function extractSection(content: string, heading: string): string {
  const normalized = content.replace(/\r/g, '');
  const lines = normalized.split('\n');
  const target = `## ${heading}`.trim();
  const start = lines.findIndex((line) => line.trim() === target);
  if (start === -1) {
    return '';
  }

  const sectionLines: string[] = [];
  for (let i = start + 1; i < lines.length; i++) {
    const line = lines[i];
    if (line.trim().startsWith('## ')) {
      break;
    }
    sectionLines.push(line);
  }

  return sectionLines.join('\n').trim();
}

function preHandoffChecks(decisionContent: string): CheckResult[] {
  return [
    {
      id: 'pre_handoff_harden_question',
      status: hasMatch(decisionContent, /\bHarden\s*:/i) ? 'PASS' : 'FAIL',
      details: 'Requires at least one harden question.',
    },
    {
      id: 'pre_handoff_expand_question',
      status: hasMatch(decisionContent, /\bExpand\s*:/i) ? 'PASS' : 'FAIL',
      details: 'Requires at least one expand question.',
    },
    {
      id: 'pre_handoff_narrow_question',
      status: hasMatch(decisionContent, /\bNarrow\s*:/i) ? 'PASS' : 'FAIL',
      details: 'Requires at least one narrow question.',
    },
    {
      id: 'pre_handoff_closure_checklist',
      status: hasMatch(decisionContent, /Closure Checklist/i) ? 'PASS' : 'FAIL',
      details: 'Requires closure checklist draft section.',
    },
    {
      id: 'pre_handoff_delta_handling_reference',
      status: hasMatch(
        decisionContent,
        /(deployment delta|delta handling|versioned companion decision file)/i,
      )
        ? 'PASS'
        : 'FAIL',
      details: 'Requires deployment delta handling reference.',
    },
  ];
}

function structuredAskChecks(promptContent: string): CheckResult[] {
  const numberedBlocks = hasMatch(promptContent, /^\d+[\.)]\s+/m);
  const letteredChoices = hasMatch(promptContent, /(^|\s)[a-z]\)\s+/im);
  const decisionPointQuestions = Array.from(
    promptContent.matchAll(/^\d+[\.)]\s+.*\?/gm),
  );
  const recommendedDefaults = Array.from(
    promptContent.matchAll(/recommended\s+default/gi),
  );
  const headerMode = hasMatch(promptContent, /^Mode\s*:/im);
  const headerDecision = hasMatch(promptContent, /^Decision\s*:/im);
  const headerStatus = hasMatch(promptContent, /^Status\s*:/im);

  let defaultStatus: CheckStatus = 'PASS';
  if (decisionPointQuestions.length > 0 && recommendedDefaults.length < decisionPointQuestions.length) {
    defaultStatus = 'FAIL';
  } else if (decisionPointQuestions.length === 0 && recommendedDefaults.length > 0) {
    defaultStatus = 'PARTIAL';
  }

  return [
    {
      id: 'structured_numbered_question_blocks',
      status: numberedBlocks ? 'PASS' : 'FAIL',
      details: 'Requires numbered question blocks.',
    },
    {
      id: 'structured_lettered_choices',
      status: letteredChoices ? 'PASS' : 'FAIL',
      details: 'Requires lettered answer choices (a), b), ...).',
    },
    {
      id: 'structured_recommended_default_per_question',
      status: defaultStatus,
      details: `Decision-point questions=${decisionPointQuestions.length}, recommended-default markers=${recommendedDefaults.length}`,
    },
    {
      id: 'structured_mode_decision_status_header',
      status: headerMode && headerDecision && headerStatus ? 'PASS' : 'FAIL',
      details: 'Requires Mode, Decision, and Status headers.',
    },
  ];
}

function parityChecks(runtimeContent: string, repoContent: string, runtimePath: string, repoPath: string): ParityReport {
  const governanceSections = [
    'Execution Rules',
    'Completion Report',
    'Governance Report Standard',
    'Developmental Learning Capture',
  ];

  const sectionResults: ParityReport['sections'] = [];
  const diffSummary: string[] = [];

  for (const section of governanceSections) {
    const runtimeSection = extractSection(runtimeContent, section);
    const repoSection = extractSection(repoContent, section);

    if (!runtimeSection && !repoSection) {
      sectionResults.push({
        section,
        status: 'PARTIAL',
        details: 'Section missing from both prompts.',
      });
      diffSummary.push(`${section}: missing in both`);
      continue;
    }

    if (!runtimeSection || !repoSection) {
      sectionResults.push({
        section,
        status: 'FAIL',
        details: !runtimeSection
          ? 'Missing in runtime prompt.'
          : 'Missing in repository prompt.',
      });
      diffSummary.push(
        `${section}: ${!runtimeSection ? 'missing runtime section' : 'missing repository section'}`,
      );
      continue;
    }

    const runtimeLines = normalizeSection(runtimeSection);
    const repoLines = normalizeSection(repoSection);
    const same = JSON.stringify(runtimeLines) === JSON.stringify(repoLines);

    if (same) {
      sectionResults.push({
        section,
        status: 'PASS',
        details: `Equivalent (${runtimeLines.length} normalized lines).`,
      });
    } else {
      sectionResults.push({
        section,
        status: 'FAIL',
        details: `Drift detected (runtime ${runtimeLines.length} lines vs repository ${repoLines.length} lines).`,
      });
      const runtimeOnly = runtimeLines.filter((line) => !repoLines.includes(line));
      const repoOnly = repoLines.filter((line) => !runtimeLines.includes(line));
      if (runtimeOnly.length > 0) {
        diffSummary.push(`${section}: runtime-only => ${runtimeOnly.join(' | ')}`);
      }
      if (repoOnly.length > 0) {
        diffSummary.push(`${section}: repository-only => ${repoOnly.join(' | ')}`);
      }
    }
  }

  const hasFail = sectionResults.some((item) => item.status === 'FAIL');
  const overallStatus: CheckStatus = hasFail ? 'FAIL' : 'PASS';

  return {
    schemaVersion: '1.0.0',
    generatedAt: new Date().toISOString(),
    runtimePromptPath: runtimePath,
    repositoryPromptPath: repoPath,
    status: overallStatus,
    sections: sectionResults,
    diffSummary,
  };
}

function summarize(checks: LintReport['checks']): LintReport['summary'] {
  const all = [
    ...checks.preHandoffGovernance,
    ...checks.structuredAskFormat,
    ...checks.openfixerPromptParity,
  ];
  const pass = all.filter((check) => check.status === 'PASS').length;
  const partial = all.filter((check) => check.status === 'PARTIAL').length;
  const fail = all.filter((check) => check.status === 'FAIL').length;
  const overall: CheckStatus = fail > 0 ? 'FAIL' : partial > 0 ? 'PARTIAL' : 'PASS';
  return { pass, partial, fail, overall };
}

async function main() {
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      decision: { type: 'string', default: DEFAULT_DECISION_FILE },
      'structured-ask': { type: 'string', default: DEFAULT_STRUCTURED_ASK_FILE },
      strategist: { type: 'string', default: DEFAULT_STRATEGIST_PROMPT },
      runtime: { type: 'string', default: DEFAULT_RUNTIME_OPENFIXER },
      repository: { type: 'string', default: DEFAULT_REPO_OPENFIXER },
      output: { type: 'string', default: DEFAULT_OUTPUT },
      parity: { type: 'string', default: DEFAULT_PARITY_OUTPUT },
      strict: { type: 'boolean', default: false },
    },
    strict: true,
  });

  const [decisionContent, structuredAskContent, strategistContent, runtimeOpenFixerContent, repoOpenFixerContent] =
    await Promise.all([
      readText(values.decision),
      readText(values['structured-ask']),
      readText(values.strategist),
      readText(values.runtime),
      readText(values.repository),
    ]);

  const preHandoff = preHandoffChecks(decisionContent);
  const structuredAsk = structuredAskChecks(structuredAskContent);
  const parity = parityChecks(
    runtimeOpenFixerContent,
    repoOpenFixerContent,
    values.runtime,
    values.repository,
  );

  const checks: LintReport['checks'] = {
    preHandoffGovernance: preHandoff,
    structuredAskFormat: structuredAsk,
    openfixerPromptParity: [
      {
        id: 'openfixer_prompt_governance_parity',
        status: parity.status,
        details:
          parity.status === 'PASS'
            ? 'Runtime and repository governance sections are equivalent.'
            : `Governance section drift detected. See parity artifact: ${values.parity}`,
      },
    ],
  };

  const report: LintReport = {
    schemaVersion: '1.0.0',
    generatedAt: new Date().toISOString(),
    inputs: {
      decisionFile: values.decision,
      structuredAskFile: values['structured-ask'],
      strategistPrompt: values.strategist,
      runtimeOpenFixerPrompt: values.runtime,
      repositoryOpenFixerPrompt: values.repository,
    },
    checks,
    summary: summarize(checks),
  };

  await Bun.write(values.parity, `${JSON.stringify(parity, null, 2)}\n`);
  await Bun.write(values.output, `${JSON.stringify(report, null, 2)}\n`);

  console.log(`Governance lint report: ${values.output}`);
  console.log(`OpenFixer parity report: ${values.parity}`);
  console.log(
    `Summary: PASS=${report.summary.pass} PARTIAL=${report.summary.partial} FAIL=${report.summary.fail} OVERALL=${report.summary.overall}`,
  );

  if (values.strict && report.summary.overall === 'FAIL') {
    process.exit(1);
  }
}

main().catch((error: unknown) => {
  console.error(`governance-lint failed: ${String(error)}`);
  process.exit(1);
});
