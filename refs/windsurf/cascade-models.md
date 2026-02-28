> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Cascade Models

> Available AI models in Cascade including SWE-1.5, SWE-1, Claude, GPT, and bring-your-own-key (BYOK) options with credit costs.

export const ModelsTable = () => {
  const [activeTab, setActiveTab] = useState('recommended');
  const [showScrollHint, setShowScrollHint] = useState(true);
  const tableContainerRef = useRef(null);
  const windsurfIcon = {
    light: "https://exafunction.github.io/public/icons/docs/Windsurf-black-symbol.png",
    dark: "https://exafunction.github.io/public/icons/docs/Windsurf-white-symbol.png"
  };
  const openaiIcon = {
    light: "https://exafunction.github.io/public/icons/docs/OpenAI-black-monoblossom.png",
    dark: "https://exafunction.github.io/public/icons/docs/OpenAI-white-monoblossom.png"
  };
  const claudeIcon = {
    light: "https://exafunction.github.io/public/icons/docs/claude-logo-clay.png",
    dark: "https://exafunction.github.io/public/icons/docs/claude-logo-clay.png"
  };
  const deepseekIcon = {
    light: "https://exafunction.github.io/public/icons/docs/deepseek-logo.png",
    dark: "https://exafunction.github.io/public/icons/docs/deepseek-logo.png"
  };
  const geminiIcon = {
    light: "https://exafunction.github.io/public/icons/docs/gemini-models-icon.png",
    dark: "https://exafunction.github.io/public/icons/docs/gemini-models-icon.png"
  };
  const grokIcon = {
    light: "https://exafunction.github.io/public/icons/docs/Grok_Logomark_Dark.png",
    dark: "https://exafunction.github.io/public/icons/docs/Grok_Logomark_Light.png"
  };
  const qwenIcon = {
    light: "https://exafunction.github.io/public/icons/docs/qwen-logo.png",
    dark: "https://exafunction.github.io/public/icons/docs/qwen-logo.png"
  };
  const kimiIcon = {
    light: "https://exafunction.github.io/public/icons/docs/kimi-k2-icon.png",
    dark: "https://exafunction.github.io/public/icons/docs/kimi-k2-icon.png"
  };
  const minimaxIcon = {
    light: "https://exafunction.github.io/public/icons/docs/minimax-icon.png",
    dark: "https://exafunction.github.io/public/icons/docs/minimax-icon.png"
  };
  const zhipuIcon = {
    light: "https://exafunction.github.io/public/icons/docs/zai_light.png",
    dark: "https://exafunction.github.io/public/icons/docs/zai_dark.png"
  };
  const byokOnly = <a href="/windsurf/models#bring-your-own-key-byok" className="text-gray-700 dark:text-white font-normal">BYOK</a>;
  const apiPricingOnly = <a href="/windsurf/models#api-pricing" className="text-gray-700 dark:text-white font-normal">API Pricing</a>;
  const empty = "";
  const byokApiPricing = <>{byokOnly}<br />/<br />{apiPricingOnly}</>;
  const checkmark = <>
      <img className="block dark:hidden" src={"https://exafunction.github.io/public/icons/docs/checkmark-black.png"} alt="Available" style={{
    width: '16px',
    height: '16px',
    margin: '0 auto',
    pointerEvents: 'none'
  }} />
      <img className="hidden dark:block" src={"https://exafunction.github.io/public/icons/docs/checkmark-white.png"} alt="Available" style={{
    width: '16px',
    height: '16px',
    margin: '0 auto',
    pointerEvents: 'none'
  }} />
    </>;
  const allModels = [{
    name: "SWE-1.5",
    icon: windsurfIcon,
    credits: "0",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "windsurf",
    recommended: true
  }, {
    name: "SWE-1.5 Fast",
    icon: windsurfIcon,
    credits: "0.5",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "windsurf"
  }, {
    name: "SWE-1",
    icon: windsurfIcon,
    credits: "0",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "windsurf"
  }, {
    name: "Claude Opus 4.6",
    icon: claudeIcon,
    credits: "6",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic",
    recommended: true
  }, {
    name: "Claude Opus 4.6 (Thinking)",
    icon: claudeIcon,
    credits: "8",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.6 1M",
    icon: claudeIcon,
    credits: "10",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.6 Thinking 1M",
    icon: claudeIcon,
    credits: "12",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.6 Fast",
    icon: claudeIcon,
    credits: "24",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.6 Fast Thinking",
    icon: claudeIcon,
    credits: "30",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4.6",
    icon: claudeIcon,
    credits: "4",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic",
    recommended: true
  }, {
    name: "Claude Sonnet 4.6 (Thinking)",
    icon: claudeIcon,
    credits: "12",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4.6 1M",
    icon: claudeIcon,
    credits: "6",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4.6 Thinking 1M",
    icon: claudeIcon,
    credits: "16",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.5",
    icon: claudeIcon,
    credits: "4",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: "6",
    trial: checkmark,
    provider: "anthropic",
    recommended: true
  }, {
    name: "Claude Opus 4.5 (Thinking)",
    icon: claudeIcon,
    credits: "5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: "8",
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4.5",
    icon: claudeIcon,
    credits: "2",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: "3",
    trial: checkmark,
    provider: "anthropic",
    recommended: true
  }, {
    name: "Claude Sonnet 4.5 (Thinking)",
    icon: claudeIcon,
    credits: "3",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: "4",
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4.5 1M",
    icon: claudeIcon,
    credits: "10",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Haiku 4.5",
    icon: claudeIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.1",
    icon: claudeIcon,
    credits: "20",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Opus 4.1 (Thinking)",
    icon: claudeIcon,
    credits: "20",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4",
    icon: claudeIcon,
    credits: "2",
    hasGift: true,
    free: byokOnly,
    pro: checkmark,
    teams: checkmark,
    enterprise: "3",
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude Sonnet 4 (Thinking)",
    icon: claudeIcon,
    credits: "3",
    hasGift: true,
    free: byokOnly,
    pro: checkmark,
    teams: checkmark,
    enterprise: "4",
    trial: checkmark,
    provider: "anthropic"
  }, {
    name: "Claude 4 Opus",
    icon: claudeIcon,
    credits: byokOnly,
    free: byokOnly,
    pro: byokOnly,
    teams: empty,
    enterprise: empty,
    trial: byokOnly,
    provider: "anthropic"
  }, {
    name: "Claude 4 Opus (Thinking)",
    icon: claudeIcon,
    credits: byokOnly,
    free: byokOnly,
    pro: byokOnly,
    teams: empty,
    enterprise: empty,
    trial: byokOnly,
    provider: "anthropic"
  }, {
    name: "Claude 3.7 Sonnet",
    icon: claudeIcon,
    credits: "2",
    free: byokOnly,
    pro: checkmark,
    teams: checkmark,
    enterprise: "1x",
    trial: byokOnly,
    provider: "anthropic"
  }, {
    name: "Claude 3.7 Sonnet (Thinking)",
    icon: claudeIcon,
    credits: "3",
    free: byokOnly,
    pro: checkmark,
    teams: checkmark,
    enterprise: "1.25",
    trial: byokOnly,
    provider: "anthropic"
  }, {
    name: "Claude 3.5 Sonnet",
    icon: claudeIcon,
    credits: "2",
    free: byokOnly,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: byokOnly,
    provider: "anthropic"
  }, {
    name: "GPT-5.2 (No Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Low Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Medium Reasoning)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (High Reasoning)",
    icon: openaiIcon,
    credits: "3",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Extra High Reasoning)",
    icon: openaiIcon,
    credits: "8",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (No Reasoning Fast)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Low Reasoning Fast)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Medium Reasoning Fast)",
    icon: openaiIcon,
    credits: "4",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (High Reasoning Fast)",
    icon: openaiIcon,
    credits: "6",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2 (Extra High Reasoning Fast)",
    icon: openaiIcon,
    credits: "16",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (Low Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (Medium Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (High Reasoning)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (Extra High Reasoning)",
    icon: openaiIcon,
    credits: "3",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (Low Reasoning Fast)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai",
    recommended: true
  }, {
    name: "GPT-5.2-Codex (Medium Reasoning Fast)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (High Reasoning Fast)",
    icon: openaiIcon,
    credits: "4",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.2-Codex (Extra High Reasoning Fast)",
    icon: openaiIcon,
    credits: "6",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Low Reasoning)",
    icon: openaiIcon,
    credits: "1.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Medium Reasoning)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai",
    recommended: true
  }, {
    name: "GPT-5.3-Codex (High Reasoning)",
    icon: openaiIcon,
    credits: "2.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Extra High Reasoning)",
    icon: openaiIcon,
    credits: "3",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Low Reasoning Fast)",
    icon: openaiIcon,
    credits: "3",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: "3",
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Medium Reasoning Fast)",
    icon: openaiIcon,
    credits: "4",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: "4",
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (High Reasoning Fast)",
    icon: openaiIcon,
    credits: "5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: "5",
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex (Extra High Reasoning Fast)",
    icon: openaiIcon,
    credits: "6",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: "6",
    provider: "openai"
  }, {
    name: "GPT-5.3-Codex-Spark",
    icon: openaiIcon,
    credits: "—",
    free: empty,
    pro: empty,
    teams: empty,
    enterprise: empty,
    trial: empty,
    provider: "openai",
    arenaOnly: true
  }, {
    name: "GPT-5.1 (No Reasoning)",
    icon: openaiIcon,
    credits: "0.5",
    hasGift: false,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (Low Reasoning)",
    icon: openaiIcon,
    credits: "0.5",
    hasGift: false,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (Medium Reasoning)",
    icon: openaiIcon,
    credits: "1",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (High Reasoning)",
    icon: openaiIcon,
    credits: "2",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (No Reasoning Fast)",
    icon: openaiIcon,
    credits: "1",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (Low Reasoning Fast)",
    icon: openaiIcon,
    credits: "1",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (Medium Reasoning Fast)",
    icon: openaiIcon,
    credits: "2",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1 (High Reasoning Fast)",
    icon: openaiIcon,
    credits: "4",
    hasGift: false,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Max (Low Reasoning)",
    icon: openaiIcon,
    credits: "0",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Max (Medium Reasoning)",
    icon: openaiIcon,
    credits: "0.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Max (High Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex",
    icon: openaiIcon,
    credits: "0",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Low",
    icon: openaiIcon,
    credits: "0",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Mini",
    icon: openaiIcon,
    credits: "0",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5.1-Codex Mini Low",
    icon: openaiIcon,
    credits: "0",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5 (Low Reasoning)",
    icon: openaiIcon,
    credits: "0.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5 (Medium Reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5 (High Reasoning)",
    icon: openaiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-5-Codex",
    icon: openaiIcon,
    credits: "0.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "o3",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "o3 (high reasoning)",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "gpt-oss 120B (Medium)",
    icon: openaiIcon,
    credits: "0.25",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-4o",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "GPT-4.1",
    icon: openaiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "openai"
  }, {
    name: "Gemini 3.1 Pro Low",
    icon: geminiIcon,
    credits: "0.5",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3.1 Pro High",
    icon: geminiIcon,
    credits: "1",
    hasGift: true,
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Pro Low",
    icon: geminiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Pro High",
    icon: geminiIcon,
    credits: "2",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Flash Minimal",
    icon: geminiIcon,
    credits: "0.75",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Flash Low",
    icon: geminiIcon,
    credits: "1",
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Flash Medium",
    icon: geminiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 3 Flash High",
    icon: geminiIcon,
    credits: "1.75",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "Gemini 2.5 Pro",
    icon: geminiIcon,
    credits: "1",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "google"
  }, {
    name: "xAI Grok Code Fast",
    icon: grokIcon,
    credits: "0",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "xai"
  }, {
    name: "Minimax M2.1",
    icon: minimaxIcon,
    credits: "0.5",
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: empty,
    trial: checkmark,
    provider: "opensource"
  }, {
    name: "Kimi K2",
    icon: kimiIcon,
    credits: "0.5",
    free: empty,
    pro: checkmark,
    teams: checkmark,
    enterprise: empty,
    trial: checkmark,
    provider: "opensource"
  }, {
    name: "Kimi K2.5",
    icon: kimiIcon,
    credits: "0",
    hasGift: true,
    free: "0.5",
    pro: checkmark,
    teams: checkmark,
    enterprise: "1.0",
    trial: checkmark,
    provider: "opensource"
  }, {
    name: "GLM-5",
    icon: zhipuIcon,
    credits: "0.75",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "opensource"
  }, {
    name: "Minimax M2.5",
    icon: minimaxIcon,
    credits: "0.25",
    hasGift: true,
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: checkmark,
    trial: checkmark,
    provider: "opensource"
  }, {
    name: "GLM 4.7",
    icon: zhipuIcon,
    credits: "0.25",
    free: checkmark,
    pro: checkmark,
    teams: checkmark,
    enterprise: empty,
    trial: checkmark,
    provider: "opensource"
  }];
  const tabs = [{
    id: 'recommended',
    label: 'Recommended'
  }, {
    id: 'windsurf',
    label: 'Windsurf'
  }, {
    id: 'anthropic',
    label: 'Anthropic'
  }, {
    id: 'openai',
    label: 'OpenAI'
  }, {
    id: 'google',
    label: 'Google'
  }, {
    id: 'xai',
    label: 'xAI'
  }, {
    id: 'opensource',
    label: 'Open Source'
  }];
  const getFilteredModels = () => {
    if (activeTab === 'recommended') {
      return allModels.filter(m => m.recommended);
    }
    return allModels.filter(m => m.provider === activeTab);
  };
  const models = getFilteredModels();
  useEffect(() => {
    const container = tableContainerRef.current;
    if (!container) return;
    const handleScroll = () => {
      if (container.scrollLeft > 10) {
        setShowScrollHint(false);
      }
    };
    container.addEventListener('scroll', handleScroll);
    return () => container.removeEventListener('scroll', handleScroll);
  }, []);
  return <>
      <style>{`
        .gift-tooltip-container:hover .gift-tooltip {
          opacity: 1 !important;
          visibility: visible !important;
        }
        .models-tab-button {
          padding: 8px 16px;
          font-size: 14px;
          font-weight: 500;
          border: none;
          background: transparent;
          cursor: pointer;
          border-bottom: 2px solid transparent;
          transition: all 0.2s ease;
          white-space: nowrap;
        }
        .models-tab-button:hover {
          background: rgba(0, 0, 0, 0.05);
        }
        .models-tab-button.active {
          border-bottom-color: #34E8BB;
        }
        .dark .models-tab-button:hover {
          background: rgba(255, 255, 255, 0.05);
        }
        #table-container {
          overflow-x: auto !important;
          overflow-y: visible !important;
          max-height: none !important;
          height: auto !important;
          -webkit-overflow-scrolling: touch !important;
        }
        #models-table {
          overflow: visible !important;
          max-height: none !important;
          height: auto !important;
        }
        @media (max-width: 768px) {
          #models-table {
            min-width: 700px !important;
          }
        }
        @keyframes scrollHintPulse {
          0%, 100% { opacity: 0.7; transform: translateX(0); }
          50% { opacity: 1; transform: translateX(4px); }
        }
        .scroll-hint-arrow {
          animation: scrollHintPulse 1.5s ease-in-out infinite;
        }
      `}</style>

      {}
      <div style={{
    display: 'flex',
    overflowX: 'auto',
    borderBottom: '1px solid',
    marginBottom: '0',
    gap: '4px'
  }} className="border-black/10 dark:border-white/10">
        {tabs.map(tab => <button key={tab.id} onClick={() => setActiveTab(tab.id)} className={`models-tab-button text-gray-700 dark:text-white ${activeTab === tab.id ? 'active' : ''}`}>
            {tab.label}
          </button>)}
      </div>

      {}
      <div style={{
    position: 'relative'
  }}>
        {}
        <div style={{
    position: 'absolute',
    top: 0,
    right: 0,
    bottom: 0,
    width: '40px',
    background: 'linear-gradient(to right, transparent, rgba(0,0,0,0.08))',
    pointerEvents: 'none',
    zIndex: 10,
    borderTopRightRadius: '8px',
    borderBottomRightRadius: '8px',
    opacity: showScrollHint ? 1 : 0,
    transition: 'opacity 0.3s ease',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
  }} className="dark:[background:linear-gradient(to_right,transparent,rgba(0,0,0,0.3))]">
          <span className="scroll-hint-arrow text-gray-400 dark:text-gray-500" style={{
    fontSize: '18px',
    marginRight: '-4px'
  }}>→</span>
        </div>

        <div id="table-container" ref={tableContainerRef} style={{
    width: '100%',
    borderRadius: '8px',
    overflowX: 'auto',
    overflowY: 'visible',
    maxHeight: 'none',
    height: 'auto'
  }} className="light:bg-white dark:bg-zinc-900 border border-black/10 dark:border-white/10">
        <table id="models-table" style={{
    width: '100%',
    borderCollapse: 'collapse',
    fontSize: '14px',
    tableLayout: 'auto',
    margin: '0',
    padding: '0',
    height: 'auto',
    maxHeight: 'none'
  }}>
          <thead style={{
    margin: '0',
    padding: '0'
  }}>
            <tr className="border-b border-black/10 dark:!border-white/10">
              <th style={{
    padding: '16px 16px',
    textAlign: 'left',
    fontWeight: '500',
    minWidth: '200px'
  }} className="text-gray-700 dark:text-white">Model</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '80px'
  }} className="text-gray-700 dark:text-white">Credits</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '60px'
  }} className="text-gray-700 dark:text-white">Free</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '60px'
  }} className="text-gray-700 dark:text-white">Pro</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '80px'
  }} className="text-gray-700 dark:text-white">Teams</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '120px'
  }} className="text-gray-700 dark:text-white">Enterprise</th>
              <th style={{
    padding: '16px 8px',
    textAlign: 'center',
    fontWeight: '500',
    minWidth: '60px'
  }} className="text-gray-700 dark:text-white">Trial</th>
            </tr>
          </thead>
          <tbody style={{
    margin: '0',
    padding: '0'
  }}>
            {models.map((model, index) => <tr key={model.name} className={`${index === models.length - 1 ? '' : 'border-b border-black/10 dark:!border-white/10'}`}>
                <td style={{
    padding: '8px',
    fontWeight: '500',
    verticalAlign: 'middle'
  }}>
                  <div style={{
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    whiteSpace: 'nowrap'
  }}>
                    <span style={{
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '20px',
    height: '20px',
    flexShrink: 0
  }}>
                      <img className="block dark:hidden" src={model.icon.light} alt={`${model.name} icon`} style={{
    width: '20px',
    height: '20px',
    objectFit: 'contain',
    pointerEvents: 'none',
    userSelect: 'none'
  }} />
                      <img className="hidden dark:block" src={model.icon.dark} alt={`${model.name} icon`} style={{
    width: '20px',
    height: '20px',
    objectFit: 'contain',
    pointerEvents: 'none',
    userSelect: 'none'
  }} />
                    </span>
                    <span className="text-gray-700 dark:text-white">{model.name}</span>
                  </div>
                </td>
                <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>
                  <div style={{
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '4px'
  }}>
                    <span className="text-gray-700 dark:text-white">{model.credits}</span>
                    {model.hasGift && <div className="gift-tooltip-container" style={{
    position: 'relative',
    display: 'inline-flex'
  }}>
                        <span style={{
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '16px',
    height: '16px'
  }}>
                          <img className="block dark:hidden" src="https://exafunction.github.io/public/icons/docs/gift-black.png" alt="Gift icon" style={{
    width: '16px',
    height: '16px',
    objectFit: 'contain',
    pointerEvents: 'none',
    userSelect: 'none'
  }} />
                          <img className="hidden dark:block" src="https://exafunction.github.io/public/icons/docs/gift-white.png" alt="Gift icon" style={{
    width: '16px',
    height: '16px',
    objectFit: 'contain',
    pointerEvents: 'none',
    userSelect: 'none'
  }} />
                        </span>
                        <div className="gift-tooltip" style={{
    position: 'absolute',
    bottom: '100%',
    left: '50%',
    transform: 'translateX(-50%)',
    marginBottom: '8px',
    padding: '8px 12px',
    backgroundColor: '#333',
    color: 'white',
    borderRadius: '6px',
    fontSize: '12px',
    whiteSpace: 'nowrap',
    opacity: '0',
    visibility: 'hidden',
    transition: 'opacity 0.2s, visibility 0.2s',
    zIndex: '1000',
    pointerEvents: 'none'
  }}>
                          Promo pricing only available for a limited time
                          <div style={{
    position: 'absolute',
    top: '100%',
    left: '50%',
    transform: 'translateX(-50%)',
    width: '0',
    height: '0',
    borderLeft: '5px solid transparent',
    borderRight: '5px solid transparent',
    borderTop: '5px solid #333'
  }}></div>
                        </div>
                      </div>}
                  </div>
                </td>
                {model.arenaOnly ? <td colSpan={5} style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle',
    fontStyle: 'italic'
  }} className="text-gray-500 dark:text-gray-400">
                    <a href="/windsurf/cascade/arena" className="text-gray-700 dark:text-white font-normal">Arena Mode only (Fast & Hybrid)</a>
                  </td> : <>
                    <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>{model.free}</td>
                    <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>{model.pro}</td>
                    <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>{model.teams}</td>
                    <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>{model.enterprise}</td>
                    <td style={{
    padding: '10px',
    textAlign: 'center',
    verticalAlign: 'middle'
  }}>{model.trial}</td>
                  </>}
              </tr>)}
          </tbody>
        </table>
        </div>
      </div>
    </>;
};

In Cascade, you can easily switch between different models of your choosing.

Depending on the model you select, each of your input prompts will consume a different number of [prompt credits](/windsurf/cascade/usage).

Under the text input box, you will see a model selection dropdown menu containing the following models:

<ModelsTable />

# SWE-1.5, swe-grep, SWE-1

Our SWE model family of in-house frontier models are built specifically for software engineering tasks.

Our latest frontier model, SWE-1.5, achieves near-SOTA performance in a fraction of the time.

Our in house models include:

* `SWE-1.5`: Our best agentic coding model we've released so far. Near Claude 4.5-level performance, at 13x the speed. Read our [research announcement](https://cognition.ai/blog/swe-1-5).
* `SWE-1`: Our first agentic coding model. Achieved Claude 3.5-level performance at a fraction of the cost.
* `SWE-1-mini`: Powers passive suggestions in Windsurf Tab, optimized for real-time latency.
* `swe-grep`: Powers context retrieval and [Fast Context](context-awareness/fast-context)

# Bring your own key (BYOK)

<Warning>This is only available to free and paid individual users.</Warning>

For certain models, we allow users to bring their own API keys. In the model dropdown menu, individual users will see models labled with `BYOK`.

To input your API key, navigate to [this page](https://windsurf.com/subscription/provider-api-keys) in the subscription settings and add your key.

If you have not configured your API key, it will return an error if you try to use the BYOK model.

Currently, we only support BYOK for these models:

* `Claude 4 Sonnet`
* `Claude 4 Sonnet (Thinking)`
* `Claude 4 Opus`
* `Claude 4 Opus (Thinking)`
