# Tool Output: tool_c7491f7c8001gobjTJiuvD5ahW
**Date**: 2026-02-19 06:24:09 UTC
**Size**: 1,086,937 bytes

```

C:\Users\paulc\.config\opencode\AGENTS.md:
  57: - **Oracle**: Leverages external data sources for validation and analysis
  369: # Run with coverage
  370: bun test --coverage

C:\Users\paulc\.config\opencode\agents\explorer.md:
  52: - JSON tools give you the FULL CONTEXT, not just line fragments

C:\Users\paulc\.config\opencode\agents\forgewright.md:
  61: - Implement all interface methods with in-memory storage (Lists/Dictionaries)

C:\Users\paulc\.config\opencode\agents\orchestrator.md:
  199: **Leverage Phase 0 Intelligence**: Use the Librarian's findings to focus investigation on relevant areas and avoid redundant exploration.

C:\Users\paulc\.config\opencode\agents\strategist.md:
  38: | No error handling | -12% | Fragile |
  64: - Storage IOPS: [e.g., 1000]
  313: ## RAG MCP Tools
  315: When the RAG server is active, the following tools are available for knowledge retrieval:
  321: | `rag_query` | Search RAG for relevant context | `query` (required), `topK` (default 5), `filter`, `includeMetadata` |
  322: | `rag_ingest` | Ingest content directly into RAG | `content` (required), `source` (required), `metadata` |
  323: | `rag_ingest_file` | Ingest a file from disk | `filePath` (required), `metadata` |
  324: | `rag_status` | Check RAG system health and metrics | none |
  325: | `rag_rebuild_index` | Schedule index rebuild | `fullRebuild` (default false), `sources` |
  326: | `rag_search_similar` | Find documents similar to a given doc | `documentId` (required), `topK` (default 5) |
  332: rag_query(query="What is the DPD calculation process?", topK=5)
  335: rag_query(query="signal processing", topK=3, filter={"agent": "H0UND", "type": "code"})
  338: rag_status()
  341: rag_ingest(
  342:   content="Decision RAG-001 implements vector search...",
  343:   source="T4CT1CS/decisions/RAG-001.md",
  348: rag_search_similar(documentId="doc_A1B2C3D4", topK=3)

C:\Users\paulc\.config\opencode\agents\strategist.md.bak:
  38: | No error handling | -12% | Fragile |
  64: - Storage IOPS: [e.g., 1000]

C:\Users\paulc\.config\opencode\INTELLIGENCE_BRIEF_UpdateAgentModels_Skill.md:
  61: 1. **Cost Data Storage**:

C:\Users\paulc\.config\opencode\models\ACTION_PLAN.md:
  296: **Total**: 14-22 hours of research for comprehensive coverage

C:\Users\paulc\.config\opencode\models\AGENTS.md:
  144: - Comprehensive coverage of both premium and cost-effective options
  357: **Remember**: This directory houses the OpenCode ecosystem's central model intelligence resource. Every update here impacts agent performance across the entire system. Prioritize data accuracy, document your sources, and coordinate with other agents for comprehensive coverage.

C:\Users\paulc\.config\opencode\tools\AGENTS.md:
  150: - Minimum 80% code coverage

C:\Users\paulc\.config\opencode\models\COMPLETION_STATUS.txt:
  25:    - Database expanded to 220+ models with comprehensive benchmark coverage
  39:    - Expand coverage to full 201+ model database
  58: 9. ✅ Comprehensive benchmark coverage (27 metrics across 8 categories)
  82:   ⏳ Phase 5 Extended Coverage: 44/220 complete, ~176 remaining (20%)
  87:   - Provider Family Coverage: 5/35+ families (14%)
  90:   - Critical Models Coverage: ~44% (44/100 most important models)
  106: Coverage: 172/220 models (78% of database)
  215: 2. Continue with Tier 3 extended models for full benchmark coverage
  227:   - ~176 models without full benchmark coverage (220 - 44 complete)

C:\Users\paulc\.config\opencode\tools\deployment\kubernetes\mongodb-server-deployment.yaml:
  136:           averageUtilization: 70
  142:           averageUtilization: 80

C:\Users\paulc\.config\opencode\models\COMPLETION_SUMMARY.md:
  29: - Complete 27-benchmark coverage for all Claude models
  99: - **GPT Family:** 38.57% (Below Average)
  100: - **Gemini Family:** 28.57-30% (Below Average)
  118: | Benchmark Coverage | Partial | Complete (27/27) | +100% |
  125: - **Benchmark Coverage:** 20% → 100% on completed models
  164: - **Complete Database Coverage:** All 220+ models with 27 benchmarks
  174: - ✅ **44 Models** with complete 27-benchmark coverage
  191: The systematic model-by-model completion workflow is now established, validated, and ready for scaling to complete the remaining ~176 models in the database. The comprehensive benchmark coverage, safety metrics integration, and quality assurance processes provide a solid foundation for achieving full database completion.
  193: **Next Milestone:** Complete Tier 3 extended models using the proven systematic workflow to achieve 100% database coverage.
  199: **Next Phase:** Extended Ecosystem Coverage (Tier 3)  

C:\Users\paulc\.config\opencode\tools\mongodb.md:
  208: // Average balance by game
  522:     Average: Number,
  524:     History: [{ Average, Data }],

C:\Users\paulc\.config\opencode\models\models_available.json:
  1876: [Omitted long matching line]
  2881:     "description": "DeepSeek R1 Distill Llama 70B is a distilled large language model based on [Llama-3.3-70B-Instruct](/meta-llama/llama-3.3-70b-instruct), using outputs from [DeepSeek R1](/deepseek/deepseek-r1). The model combines advanced distillation techniques to achieve high performance across multiple benchmarks, including:\n\n- AIME 2024 pass@1: 70.0\n- MATH-500 pass@1: 94.5\n- CodeForces Rating: 1633\n\nThe model leverages fine-tuning from DeepSeek R1's outputs, enabling competitive performance comparable to larger frontier models.",
  3624:     "description": "LFM2.5-1.2B-Thinking is a lightweight reasoning-focused model optimized for agentic tasks, data extraction, and RAG—while still running comfortably on edge devices. It supports long context (up to 32K tokens) and is designed to provide higher-quality “thinking” responses in a small 1.2B model.",
  4178:     "description": "MiniMax-M1 is a large-scale, open-weight reasoning model designed for extended context and high-efficiency inference. It leverages a hybrid Mixture-of-Experts (MoE) architecture paired with a custom \"lightning attention\" mechanism, allowing it to process long sequences—up to 1 million tokens—while maintaining competitive FLOP efficiency. With 456 billion total parameters and 45.9B active per token, this variant is optimized for complex, multi-step reasoning tasks.\n\nTrained via a custom reinforcement learning pipeline (CISPO), M1 excels in long-context understanding, software engineering, agentic tool use, and mathematical reasoning. Benchmarks show strong performance across FullStackBench, SWE-bench, MATH, GPQA, and TAU-Bench, often outperforming other open models like DeepSeek R1 and Qwen3-235B.",
  6075: [Omitted long matching line]
  7055:     "description": "GPT-5.1 is the latest frontier-grade model in the GPT-5 series, offering stronger general-purpose reasoning, improved instruction adherence, and a more natural conversational style compared to GPT-5. It uses adaptive reasoning to allocate computation dynamically, responding quickly to simple queries while spending more depth on complex tasks. The model produces clearer, more grounded explanations with reduced jargon, making it easier to follow even on technical or multi-step problems.\n\nBuilt for broad task coverage, GPT-5.1 delivers consistent gains across math, coding, and structured analysis workloads, with more coherent long-form answers and improved tool-use reliability. It also features refined conversational alignment, enabling warmer, more intuitive responses without compromising precision. GPT-5.1 serves as the primary full-capability successor to GPT-5",
  7382:     "description": "GPT-5.2 is the latest frontier-grade model in the GPT-5 series, offering stronger agentic and long context perfomance compared to GPT-5.1. It uses adaptive reasoning to allocate computation dynamically, responding quickly to simple queries while spending more depth on complex tasks.\n\nBuilt for broad task coverage, GPT-5.2 delivers consistent gains across math, coding, sciende, and tool calling workloads, with more coherent long-form answers and improved tool-use reliability.",
  9733:     "description": "Qwen3-Max is an updated release built on the Qwen3 series, offering major improvements in reasoning, instruction following, multilingual support, and long-tail knowledge coverage compared to the January 2025 version. It delivers higher accuracy in math, coding, logic, and science tasks, follows complex instructions in Chinese and English more reliably, reduces hallucinations, and produces higher-quality responses for open-ended Q&A, writing, and conversation. The model supports over 100 languages with stronger translation and commonsense reasoning, and is optimized for retrieval-augmented generation (RAG) and tool calling, though it does not include a dedicated “thinking” mode.",
  9801: [Omitted long matching line]
  9867: [Omitted long matching line]
  9933:     "description": "Qwen3-Next-80B-A3B-Thinking is a reasoning-first chat model in the Qwen3-Next line that outputs structured “thinking” traces by default. It’s designed for hard multi-step problems; math proofs, code synthesis/debugging, logic, and agentic planning, and reports strong results across knowledge, reasoning, coding, alignment, and multilingual evaluations. Compared with prior Qwen3 variants, it emphasizes stability under long chains of thought and efficient scaling during inference, and it is tuned to follow complex instructions while reducing repetitive or off-task behavior.\n\nThe model is suitable for agent frameworks and tool use (function calling), retrieval-heavy workflows, and standardized benchmarking where step-by-step solutions are required. It supports long, detailed completions and leverages throughput-oriented techniques (e.g., multi-token prediction) for faster generation. Note that it operates in thinking-only mode.",
  11180:     "description": "GLM-4.5 is our latest flagship foundation model, purpose-built for agent-based applications. It leverages a Mixture-of-Experts (MoE) architecture and supports a context length of up to 128k tokens. GLM-4.5 delivers significantly enhanced capabilities in reasoning, code generation, and agent alignment. It supports a hybrid inference mode with two options, a \"thinking mode\" designed for complex reasoning and tool use, and a \"non-thinking mode\" optimized for instant responses. Users can control the reasoning behaviour with the `reasoning` `enabled` boolean. [Learn more in our docs](https://openrouter.ai/docs/use-cases/reasoning-tokens#enable-reasoning-with-default-config)",
  14173:     "description": "Qwen3-Max is an updated release built on the Qwen3 series, offering major improvements in reasoning, instruction following, multilingual support, and long-tail knowledge coverage compared to the January 2025 version. It delivers higher accuracy in math, coding, logic, and science tasks, follows complex instructions in Chinese and English more reliably, reduces hallucinations, and produces higher-quality responses for open-ended Q&A, writing, and conversation. The model supports over 100 languages with stronger translation and commonsense reasoning, and is optimized for retrieval-augmented generation (RAG) and tool calling, though it does not include a dedicated “thinking” mode.",
  14235: [Omitted long matching line]

C:\Users\paulc\.config\opencode\tools\PLATFORM_INDEX.md:
  331: # Test with coverage
  332: npm run test:coverage

C:\Users\paulc\.config\opencode\tools\notes\mongodb\CRUD_OPERATIONS.md:
  242: // Average balance by game

C:\Users\paulc\.config\opencode\tools\README.md:
  194: # With coverage
  195: npm run test:coverage

C:\Users\paulc\.config\opencode\tools\notes\mongodb\ENTITY_SCHEMAS.md:
  324:     "Average": 2.5,
  336:         "Average": 2.3,

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\hle\README.md:
  9: Humanity's Last Exam (HLE) is a multi-modal benchmark at the frontier of human knowledge, designed to be the final closed-ended academic benchmark of its kind with broad subject coverage. Humanity's Last Exam consists of 2,500 questions across dozens of subjects, including mathematics, humanities, and the natural sciences. HLE is developed globally by subject-matter experts and consists of multiple-choice and short-answer questions suitable for automated grading.

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\scicode\tests\test_data\first_problem.jsonl:
  1: [Omitted long matching line]

C:\Users\paulc\.config\opencode\models\VERIFICATION_REPORT_20260212.md:
  198: ### ✅ GOOD COVERAGE:

C:\Users\paulc\.config\opencode\models\RESEARCH_SESSION_SUMMARY_20260212.md:
  91: - **Strategic models**: Coverage of most important/cited models complete

C:\Users\paulc\.config\opencode\models\RESEARCH_GUIDE.md:
  18: - **All 27 Benchmarks**: Ensure complete coverage across 8 categories
  30: **Total Results:** 44+ models with complete 27-benchmark coverage
  400: **Solution**: Take average or use most recent/reputable source

C:\Users\paulc\.config\opencode\models\QUICK_REFERENCE_GUIDE.md:
  200: - **Average MMLU Score**: ~88%

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\terminal-bench\uv.lock:
  354: name = "coverage"
  357: sdist = { url = "https://files.pythonhosted.org/packages/d6/4e/08b493f1f1d8a5182df0044acc970799b58a8d289608e0d891a03e9d269a/coverage-7.10.4.tar.gz", hash = "sha256:25f5130af6c8e7297fd14634955ba9e1697f47143f289e2a23284177c0061d27", size = 823798, upload-time = "2025-08-17T00:26:43.314Z" }
  359:     { url = "https://files.pythonhosted.org/packages/9e/4a/781c9e4dd57cabda2a28e2ce5b00b6be416015265851060945a5ed4bd85e/coverage-7.10.4-cp312-cp312-macosx_10_13_x86_64.whl", hash = "sha256:a1f0264abcabd4853d4cb9b3d164adbf1565da7dab1da1669e93f3ea60162d79", size = 216706, upload-time = "2025-08-17T00:24:51.528Z" },
  360:     { url = "https://files.pythonhosted.org/packages/6a/8c/51255202ca03d2e7b664770289f80db6f47b05138e06cce112b3957d5dfd/coverage-7.10.4-cp312-cp312-macosx_11_0_arm64.whl", hash = "sha256:536cbe6b118a4df231b11af3e0f974a72a095182ff8ec5f4868c931e8043ef3e", size = 216939, upload-time = "2025-08-17T00:24:53.171Z" },
  361:     { url = "https://files.pythonhosted.org/packages/06/7f/df11131483698660f94d3c847dc76461369782d7a7644fcd72ac90da8fd0/coverage-7.10.4-cp312-cp312-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:9a4c0d84134797b7bf3f080599d0cd501471f6c98b715405166860d79cfaa97e", size = 248429, upload-time = "2025-08-17T00:24:54.934Z" },
  362:     { url = "https://files.pythonhosted.org/packages/eb/fa/13ac5eda7300e160bf98f082e75f5c5b4189bf3a883dd1ee42dbedfdc617/coverage-7.10.4-cp312-cp312-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:7c155fc0f9cee8c9803ea0ad153ab6a3b956baa5d4cd993405dc0b45b2a0b9e0", size = 251178, upload-time = "2025-08-17T00:24:56.353Z" },
  363:     { url = "https://files.pythonhosted.org/packages/9a/bc/f63b56a58ad0bec68a840e7be6b7ed9d6f6288d790760647bb88f5fea41e/coverage-7.10.4-cp312-cp312-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:0a5f2ab6e451d4b07855d8bcf063adf11e199bff421a4ba57f5bb95b7444ca62", size = 252313, upload-time = "2025-08-17T00:24:57.692Z" },
  364:     { url = "https://files.pythonhosted.org/packages/2b/b6/79338f1ea27b01266f845afb4485976211264ab92407d1c307babe3592a7/coverage-7.10.4-cp312-cp312-musllinux_1_2_aarch64.whl", hash = "sha256:685b67d99b945b0c221be0780c336b303a7753b3e0ec0d618c795aada25d5e7a", size = 250230, upload-time = "2025-08-17T00:24:59.293Z" },
  365:     { url = "https://files.pythonhosted.org/packages/bc/93/3b24f1da3e0286a4dc5832427e1d448d5296f8287464b1ff4a222abeeeb5/coverage-7.10.4-cp312-cp312-musllinux_1_2_i686.whl", hash = "sha256:0c079027e50c2ae44da51c2e294596cbc9dbb58f7ca45b30651c7e411060fc23", size = 248351, upload-time = "2025-08-17T00:25:00.676Z" },
  366:     { url = "https://files.pythonhosted.org/packages/de/5f/d59412f869e49dcc5b89398ef3146c8bfaec870b179cc344d27932e0554b/coverage-7.10.4-cp312-cp312-musllinux_1_2_x86_64.whl", hash = "sha256:3749aa72b93ce516f77cf5034d8e3c0dfd45c6e8a163a602ede2dc5f9a0bb927", size = 249788, upload-time = "2025-08-17T00:25:02.354Z" },
  367:     { url = "https://files.pythonhosted.org/packages/cc/52/04a3b733f40a0cc7c4a5b9b010844111dbf906df3e868b13e1ce7b39ac31/coverage-7.10.4-cp312-cp312-win32.whl", hash = "sha256:fecb97b3a52fa9bcd5a7375e72fae209088faf671d39fae67261f37772d5559a", size = 219131, upload-time = "2025-08-17T00:25:03.79Z" },
  368:     { url = "https://files.pythonhosted.org/packages/83/dd/12909fc0b83888197b3ec43a4ac7753589591c08d00d9deda4158df2734e/coverage-7.10.4-cp312-cp312-win_amd64.whl", hash = "sha256:26de58f355626628a21fe6a70e1e1fad95702dafebfb0685280962ae1449f17b", size = 219939, upload-time = "2025-08-17T00:25:05.494Z" },
  369:     { url = "https://files.pythonhosted.org/packages/83/c7/058bb3220fdd6821bada9685eadac2940429ab3c97025ce53549ff423cc1/coverage-7.10.4-cp312-cp312-win_arm64.whl", hash = "sha256:67e8885408f8325198862bc487038a4980c9277d753cb8812510927f2176437a", size = 218572, upload-time = "2025-08-17T00:25:06.897Z" },
  370:     { url = "https://files.pythonhosted.org/packages/46/b0/4a3662de81f2ed792a4e425d59c4ae50d8dd1d844de252838c200beed65a/coverage-7.10.4-cp313-cp313-macosx_10_13_x86_64.whl", hash = "sha256:2b8e1d2015d5dfdbf964ecef12944c0c8c55b885bb5c0467ae8ef55e0e151233", size = 216735, upload-time = "2025-08-17T00:25:08.617Z" },
  371:     { url = "https://files.pythonhosted.org/packages/c5/e8/e2dcffea01921bfffc6170fb4406cffb763a3b43a047bbd7923566708193/coverage-7.10.4-cp313-cp313-macosx_11_0_arm64.whl", hash = "sha256:25735c299439018d66eb2dccf54f625aceb78645687a05f9f848f6e6c751e169", size = 216982, upload-time = "2025-08-17T00:25:10.384Z" },
  372:     { url = "https://files.pythonhosted.org/packages/9d/59/cc89bb6ac869704d2781c2f5f7957d07097c77da0e8fdd4fd50dbf2ac9c0/coverage-7.10.4-cp313-cp313-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:715c06cb5eceac4d9b7cdf783ce04aa495f6aff657543fea75c30215b28ddb74", size = 247981, upload-time = "2025-08-17T00:25:11.854Z" },
  373:     { url = "https://files.pythonhosted.org/packages/aa/23/3da089aa177ceaf0d3f96754ebc1318597822e6387560914cc480086e730/coverage-7.10.4-cp313-cp313-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:e017ac69fac9aacd7df6dc464c05833e834dc5b00c914d7af9a5249fcccf07ef", size = 250584, upload-time = "2025-08-17T00:25:13.483Z" },
  374:     { url = "https://files.pythonhosted.org/packages/ad/82/e8693c368535b4e5fad05252a366a1794d481c79ae0333ed943472fd778d/coverage-7.10.4-cp313-cp313-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:bad180cc40b3fccb0f0e8c702d781492654ac2580d468e3ffc8065e38c6c2408", size = 251856, upload-time = "2025-08-17T00:25:15.27Z" },
  375:     { url = "https://files.pythonhosted.org/packages/56/19/8b9cb13292e602fa4135b10a26ac4ce169a7fc7c285ff08bedd42ff6acca/coverage-7.10.4-cp313-cp313-musllinux_1_2_aarch64.whl", hash = "sha256:becbdcd14f685fada010a5f792bf0895675ecf7481304fe159f0cd3f289550bd", size = 250015, upload-time = "2025-08-17T00:25:16.759Z" },
  376:     { url = "https://files.pythonhosted.org/packages/10/e7/e5903990ce089527cf1c4f88b702985bd65c61ac245923f1ff1257dbcc02/coverage-7.10.4-cp313-cp313-musllinux_1_2_i686.whl", hash = "sha256:0b485ca21e16a76f68060911f97ebbe3e0d891da1dbbce6af7ca1ab3f98b9097", size = 247908, upload-time = "2025-08-17T00:25:18.232Z" },
  377:     { url = "https://files.pythonhosted.org/packages/dd/c9/7d464f116df1df7fe340669af1ddbe1a371fc60f3082ff3dc837c4f1f2ab/coverage-7.10.4-cp313-cp313-musllinux_1_2_x86_64.whl", hash = "sha256:6c1d098ccfe8e1e0a1ed9a0249138899948afd2978cbf48eb1cc3fcd38469690", size = 249525, upload-time = "2025-08-17T00:25:20.141Z" },
  378:     { url = "https://files.pythonhosted.org/packages/ce/42/722e0cdbf6c19e7235c2020837d4e00f3b07820fd012201a983238cc3a30/coverage-7.10.4-cp313-cp313-win32.whl", hash = "sha256:8630f8af2ca84b5c367c3df907b1706621abe06d6929f5045fd628968d421e6e", size = 219173, upload-time = "2025-08-17T00:25:21.56Z" },
  379:     { url = "https://files.pythonhosted.org/packages/97/7e/aa70366f8275955cd51fa1ed52a521c7fcebcc0fc279f53c8c1ee6006dfe/coverage-7.10.4-cp313-cp313-win_amd64.whl", hash = "sha256:f68835d31c421736be367d32f179e14ca932978293fe1b4c7a6a49b555dff5b2", size = 219969, upload-time = "2025-08-17T00:25:23.501Z" },
  380:     { url = "https://files.pythonhosted.org/packages/ac/96/c39d92d5aad8fec28d4606556bfc92b6fee0ab51e4a548d9b49fb15a777c/coverage-7.10.4-cp313-cp313-win_arm64.whl", hash = "sha256:6eaa61ff6724ca7ebc5326d1fae062d85e19b38dd922d50903702e6078370ae7", size = 218601, upload-time = "2025-08-17T00:25:25.295Z" },
  381:     { url = "https://files.pythonhosted.org/packages/79/13/34d549a6177bd80fa5db758cb6fd3057b7ad9296d8707d4ab7f480b0135f/coverage-7.10.4-cp313-cp313t-macosx_10_13_x86_64.whl", hash = "sha256:702978108876bfb3d997604930b05fe769462cc3000150b0e607b7b444f2fd84", size = 217445, upload-time = "2025-08-17T00:25:27.129Z" },
  382:     { url = "https://files.pythonhosted.org/packages/6a/c0/433da866359bf39bf595f46d134ff2d6b4293aeea7f3328b6898733b0633/coverage-7.10.4-cp313-cp313t-macosx_11_0_arm64.whl", hash = "sha256:e8f978e8c5521d9c8f2086ac60d931d583fab0a16f382f6eb89453fe998e2484", size = 217676, upload-time = "2025-08-17T00:25:28.641Z" },
  383:     { url = "https://files.pythonhosted.org/packages/7e/d7/2b99aa8737f7801fd95222c79a4ebc8c5dd4460d4bed7ef26b17a60c8d74/coverage-7.10.4-cp313-cp313t-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:df0ac2ccfd19351411c45e43ab60932b74472e4648b0a9edf6a3b58846e246a9", size = 259002, upload-time = "2025-08-17T00:25:30.065Z" },
  384:     { url = "https://files.pythonhosted.org/packages/08/cf/86432b69d57debaef5abf19aae661ba8f4fcd2882fa762e14added4bd334/coverage-7.10.4-cp313-cp313t-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:73a0d1aaaa3796179f336448e1576a3de6fc95ff4f07c2d7251d4caf5d18cf8d", size = 261178, upload-time = "2025-08-17T00:25:31.517Z" },
  385:     { url = "https://files.pythonhosted.org/packages/23/78/85176593f4aa6e869cbed7a8098da3448a50e3fac5cb2ecba57729a5220d/coverage-7.10.4-cp313-cp313t-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:873da6d0ed6b3ffc0bc01f2c7e3ad7e2023751c0d8d86c26fe7322c314b031dc", size = 263402, upload-time = "2025-08-17T00:25:33.339Z" },
  386:     { url = "https://files.pythonhosted.org/packages/88/1d/57a27b6789b79abcac0cc5805b31320d7a97fa20f728a6a7c562db9a3733/coverage-7.10.4-cp313-cp313t-musllinux_1_2_aarch64.whl", hash = "sha256:c6446c75b0e7dda5daa876a1c87b480b2b52affb972fedd6c22edf1aaf2e00ec", size = 260957, upload-time = "2025-08-17T00:25:34.795Z" },
  387:     { url = "https://files.pythonhosted.org/packages/fa/e5/3e5ddfd42835c6def6cd5b2bdb3348da2e34c08d9c1211e91a49e9fd709d/coverage-7.10.4-cp313-cp313t-musllinux_1_2_i686.whl", hash = "sha256:6e73933e296634e520390c44758d553d3b573b321608118363e52113790633b9", size = 258718, upload-time = "2025-08-17T00:25:36.259Z" },
  388:     { url = "https://files.pythonhosted.org/packages/1a/0b/d364f0f7ef111615dc4e05a6ed02cac7b6f2ac169884aa57faeae9eb5fa0/coverage-7.10.4-cp313-cp313t-musllinux_1_2_x86_64.whl", hash = "sha256:52073d4b08d2cb571234c8a71eb32af3c6923149cf644a51d5957ac128cf6aa4", size = 259848, upload-time = "2025-08-17T00:25:37.754Z" },
  389:     { url = "https://files.pythonhosted.org/packages/10/c6/bbea60a3b309621162e53faf7fac740daaf083048ea22077418e1ecaba3f/coverage-7.10.4-cp313-cp313t-win32.whl", hash = "sha256:e24afb178f21f9ceb1aefbc73eb524769aa9b504a42b26857243f881af56880c", size = 219833, upload-time = "2025-08-17T00:25:39.252Z" },
  390:     { url = "https://files.pythonhosted.org/packages/44/a5/f9f080d49cfb117ddffe672f21eab41bd23a46179a907820743afac7c021/coverage-7.10.4-cp313-cp313t-win_amd64.whl", hash = "sha256:be04507ff1ad206f4be3d156a674e3fb84bbb751ea1b23b142979ac9eebaa15f", size = 220897, upload-time = "2025-08-17T00:25:40.772Z" },
  391:     { url = "https://files.pythonhosted.org/packages/46/89/49a3fc784fa73d707f603e586d84a18c2e7796707044e9d73d13260930b7/coverage-7.10.4-cp313-cp313t-win_arm64.whl", hash = "sha256:f3e3ff3f69d02b5dad67a6eac68cc9c71ae343b6328aae96e914f9f2f23a22e2", size = 219160, upload-time = "2025-08-17T00:25:42.229Z" },
  392:     { url = "https://files.pythonhosted.org/packages/b5/22/525f84b4cbcff66024d29f6909d7ecde97223f998116d3677cfba0d115b5/coverage-7.10.4-cp314-cp314-macosx_10_13_x86_64.whl", hash = "sha256:a59fe0af7dd7211ba595cf7e2867458381f7e5d7b4cffe46274e0b2f5b9f4eb4", size = 216717, upload-time = "2025-08-17T00:25:43.875Z" },
  393:     { url = "https://files.pythonhosted.org/packages/a6/58/213577f77efe44333a416d4bcb251471e7f64b19b5886bb515561b5ce389/coverage-7.10.4-cp314-cp314-macosx_11_0_arm64.whl", hash = "sha256:3a6c35c5b70f569ee38dc3350cd14fdd0347a8b389a18bb37538cc43e6f730e6", size = 216994, upload-time = "2025-08-17T00:25:45.405Z" },
  394:     { url = "https://files.pythonhosted.org/packages/17/85/34ac02d0985a09472f41b609a1d7babc32df87c726c7612dc93d30679b5a/coverage-7.10.4-cp314-cp314-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:acb7baf49f513554c4af6ef8e2bd6e8ac74e6ea0c7386df8b3eb586d82ccccc4", size = 248038, upload-time = "2025-08-17T00:25:46.981Z" },
  395:     { url = "https://files.pythonhosted.org/packages/47/4f/2140305ec93642fdaf988f139813629cbb6d8efa661b30a04b6f7c67c31e/coverage-7.10.4-cp314-cp314-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:a89afecec1ed12ac13ed203238b560cbfad3522bae37d91c102e690b8b1dc46c", size = 250575, upload-time = "2025-08-17T00:25:48.613Z" },
  396:     { url = "https://files.pythonhosted.org/packages/f2/b5/41b5784180b82a083c76aeba8f2c72ea1cb789e5382157b7dc852832aea2/coverage-7.10.4-cp314-cp314-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:480442727f464407d8ade6e677b7f21f3b96a9838ab541b9a28ce9e44123c14e", size = 251927, upload-time = "2025-08-17T00:25:50.881Z" },
  397:     { url = "https://files.pythonhosted.org/packages/78/ca/c1dd063e50b71f5aea2ebb27a1c404e7b5ecf5714c8b5301f20e4e8831ac/coverage-7.10.4-cp314-cp314-musllinux_1_2_aarch64.whl", hash = "sha256:a89bf193707f4a17f1ed461504031074d87f035153239f16ce86dfb8f8c7ac76", size = 249930, upload-time = "2025-08-17T00:25:52.422Z" },
  398:     { url = "https://files.pythonhosted.org/packages/8d/66/d8907408612ffee100d731798e6090aedb3ba766ecf929df296c1a7ee4fb/coverage-7.10.4-cp314-cp314-musllinux_1_2_i686.whl", hash = "sha256:3ddd912c2fc440f0fb3229e764feec85669d5d80a988ff1b336a27d73f63c818", size = 247862, upload-time = "2025-08-17T00:25:54.316Z" },
  399:     { url = "https://files.pythonhosted.org/packages/29/db/53cd8ec8b1c9c52d8e22a25434785bfc2d1e70c0cfb4d278a1326c87f741/coverage-7.10.4-cp314-cp314-musllinux_1_2_x86_64.whl", hash = "sha256:8a538944ee3a42265e61c7298aeba9ea43f31c01271cf028f437a7b4075592cf", size = 249360, upload-time = "2025-08-17T00:25:55.833Z" },
  400:     { url = "https://files.pythonhosted.org/packages/4f/75/5ec0a28ae4a0804124ea5a5becd2b0fa3adf30967ac656711fb5cdf67c60/coverage-7.10.4-cp314-cp314-win32.whl", hash = "sha256:fd2e6002be1c62476eb862b8514b1ba7e7684c50165f2a8d389e77da6c9a2ebd", size = 219449, upload-time = "2025-08-17T00:25:57.984Z" },
  401:     { url = "https://files.pythonhosted.org/packages/9d/ab/66e2ee085ec60672bf5250f11101ad8143b81f24989e8c0e575d16bb1e53/coverage-7.10.4-cp314-cp314-win_amd64.whl", hash = "sha256:ec113277f2b5cf188d95fb66a65c7431f2b9192ee7e6ec9b72b30bbfb53c244a", size = 220246, upload-time = "2025-08-17T00:25:59.868Z" },
  402:     { url = "https://files.pythonhosted.org/packages/37/3b/00b448d385f149143190846217797d730b973c3c0ec2045a7e0f5db3a7d0/coverage-7.10.4-cp314-cp314-win_arm64.whl", hash = "sha256:9744954bfd387796c6a091b50d55ca7cac3d08767795b5eec69ad0f7dbf12d38", size = 218825, upload-time = "2025-08-17T00:26:01.44Z" },
  403:     { url = "https://files.pythonhosted.org/packages/ee/2e/55e20d3d1ce00b513efb6fd35f13899e1c6d4f76c6cbcc9851c7227cd469/coverage-7.10.4-cp314-cp314t-macosx_10_13_x86_64.whl", hash = "sha256:5af4829904dda6aabb54a23879f0f4412094ba9ef153aaa464e3c1b1c9bc98e6", size = 217462, upload-time = "2025-08-17T00:26:03.014Z" },
  404:     { url = "https://files.pythonhosted.org/packages/47/b3/aab1260df5876f5921e2c57519e73a6f6eeacc0ae451e109d44ee747563e/coverage-7.10.4-cp314-cp314t-macosx_11_0_arm64.whl", hash = "sha256:7bba5ed85e034831fac761ae506c0644d24fd5594727e174b5a73aff343a7508", size = 217675, upload-time = "2025-08-17T00:26:04.606Z" },
  405:     { url = "https://files.pythonhosted.org/packages/67/23/1cfe2aa50c7026180989f0bfc242168ac7c8399ccc66eb816b171e0ab05e/coverage-7.10.4-cp314-cp314t-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:d57d555b0719834b55ad35045de6cc80fc2b28e05adb6b03c98479f9553b387f", size = 259176, upload-time = "2025-08-17T00:26:06.159Z" },
  406:     { url = "https://files.pythonhosted.org/packages/9d/72/5882b6aeed3f9de7fc4049874fd7d24213bf1d06882f5c754c8a682606ec/coverage-7.10.4-cp314-cp314t-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:ba62c51a72048bb1ea72db265e6bd8beaabf9809cd2125bbb5306c6ce105f214", size = 261341, upload-time = "2025-08-17T00:26:08.137Z" },
  407:     { url = "https://files.pythonhosted.org/packages/1b/70/a0c76e3087596ae155f8e71a49c2c534c58b92aeacaf4d9d0cbbf2dde53b/coverage-7.10.4-cp314-cp314t-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:0acf0c62a6095f07e9db4ec365cc58c0ef5babb757e54745a1aa2ea2a2564af1", size = 263600, upload-time = "2025-08-17T00:26:11.045Z" },
  408:     { url = "https://files.pythonhosted.org/packages/cb/5f/27e4cd4505b9a3c05257fb7fc509acbc778c830c450cb4ace00bf2b7bda7/coverage-7.10.4-cp314-cp314t-musllinux_1_2_aarch64.whl", hash = "sha256:e1033bf0f763f5cf49ffe6594314b11027dcc1073ac590b415ea93463466deec", size = 261036, upload-time = "2025-08-17T00:26:12.693Z" },
  409:     { url = "https://files.pythonhosted.org/packages/02/d6/cf2ae3a7f90ab226ea765a104c4e76c5126f73c93a92eaea41e1dc6a1892/coverage-7.10.4-cp314-cp314t-musllinux_1_2_i686.whl", hash = "sha256:92c29eff894832b6a40da1789b1f252305af921750b03ee4535919db9179453d", size = 258794, upload-time = "2025-08-17T00:26:14.261Z" },
  410:     { url = "https://files.pythonhosted.org/packages/9e/b1/39f222eab0d78aa2001cdb7852aa1140bba632db23a5cfd832218b496d6c/coverage-7.10.4-cp314-cp314t-musllinux_1_2_x86_64.whl", hash = "sha256:822c4c830989c2093527e92acd97be4638a44eb042b1bdc0e7a278d84a070bd3", size = 259946, upload-time = "2025-08-17T00:26:15.899Z" },
  411:     { url = "https://files.pythonhosted.org/packages/74/b2/49d82acefe2fe7c777436a3097f928c7242a842538b190f66aac01f29321/coverage-7.10.4-cp314-cp314t-win32.whl", hash = "sha256:e694d855dac2e7cf194ba33653e4ba7aad7267a802a7b3fc4347d0517d5d65cd", size = 220226, upload-time = "2025-08-17T00:26:17.566Z" },
  412:     { url = "https://files.pythonhosted.org/packages/06/b0/afb942b6b2fc30bdbc7b05b087beae11c2b0daaa08e160586cf012b6ad70/coverage-7.10.4-cp314-cp314t-win_amd64.whl", hash = "sha256:efcc54b38ef7d5bfa98050f220b415bc5bb3d432bd6350a861cf6da0ede2cdcd", size = 221346, upload-time = "2025-08-17T00:26:19.311Z" },
  413:     { url = "https://files.pythonhosted.org/packages/d8/66/e0531c9d1525cb6eac5b5733c76f27f3053ee92665f83f8899516fea6e76/coverage-7.10.4-cp314-cp314t-win_arm64.whl", hash = "sha256:6f3a3496c0fa26bfac4ebc458747b778cff201c8ae94fa05e1391bab0dbc473c", size = 219368, upload-time = "2025-08-17T00:26:21.011Z" },
  414:     { url = "https://files.pythonhosted.org/packages/bb/78/983efd23200921d9edb6bd40512e1aa04af553d7d5a171e50f9b2b45d109/coverage-7.10.4-py3-none-any.whl", hash = "sha256:065d75447228d05121e5c938ca8f0e91eed60a1eb2d1258d42d5084fecfc3302", size = 208365, upload-time = "2025-08-17T00:26:41.479Z" },
  1788:     { name = "coverage" },
  2293: name = "storage3"
  2301: sdist = { url = "https://files.pythonhosted.org/packages/b9/e2/280fe75f65e7a3ca680b7843acfc572a63aa41230e3d3c54c66568809c85/storage3-0.12.1.tar.gz", hash = "sha256:32ea8f5eb2f7185c2114a4f6ae66d577722e32503f0a30b56e7ed5c7f13e6b48", size = 10198, upload-time = "2025-08-05T18:09:11.989Z" }
  2303:     { url = "https://files.pythonhosted.org/packages/7f/3b/c5f8709fc5349928e591fee47592eeff78d29a7d75b097f96a4e01de028d/storage3-0.12.1-py3-none-any.whl", hash = "sha256:9da77fd4f406b019fdcba201e9916aefbf615ef87f551253ce427d8136459a34", size = 18420, upload-time = "2025-08-05T18:09:10.365Z" },
  2352:     { name = "storage3" },

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\hle\citation.txt:
  3: [Omitted long matching line]

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\livecodebench\poetry.lock:
  187: test = ["anyio[trio]", "coverage[toml] (>=7)", "exceptiongroup (>=1.2.0)", "hypothesis (>=4.0)", "psutil (>=5.9)", "pytest (>=7.0)", "pytest-mock (>=3.6.1)", "trustme", "uvloop (>=0.17)"]
  223: cov = ["attrs[tests]", "coverage[toml] (>=5.3)"]
  481: test = ["coverage (>=4.2)", "pytest (>=3.0.3)", "pytest-cov (>=2.4.0)"]
  739: testing = ["covdefaults (>=2.3)", "coverage (>=7.3.2)", "diff-cover (>=8.0.1)", "pytest (>=7.4.3)", "pytest-cov (>=4.1)", "pytest-mock (>=3.12)", "pytest-timeout (>=2.2)"]
  1922: test = ["codecov (>=2.0.5)", "coverage (>=4.2)", "flake8 (>=3.0.4)", "pytest (>=4.5.0)", "pytest-cov (>=2.7.1)", "pytest-runner (>=5.1)", "pytest-virtualenv (>=1.7.0)", "virtualenv (>=15.0.3)"]
  2343: test = ["accelerate", "beartype (<0.16.0)", "coverage[toml] (>=5.1)", "datasets", "diff-cover", "huggingface-hub", "llama-cpp-python (>=0.2.42)", "pre-commit", "pytest", "pytest-benchmark", "pytest-cov", "pytest-mock", "responses", "transformers"]

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\scicode\README.md:
  27: [Omitted long matching line]

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\task_guide.md:
  333:   - `weight_by_size: bool = True` whether to perform micro- averaging (`True`) or macro- (`False`) averaging of subtasks' accuracy scores when reporting the group's metric. MMLU, for example, averages over per-document accuracies (the *micro average*), resulting in the same accuracy as if one simply concatenated all 57 subjects into a single dataset and evaluated accuracy on that dataset.

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\new_task_guide.md:
  368: While `tag` values are helpful when you want to be able to quickly and conveniently run a set of related tasks via `--tasks my_tag_name`, often, we wish to implement more complex logic. For example, the MMLU benchmark contains 57 *subtasks* that must all be *averaged* together in order to report a final 'MMLU score'.
  399:     weight_by_size: true # defaults to `true`. Set this to `false` to do a "macro" average (taking each subtask's average accuracy, and summing those accuracies and dividing by 3)--by default we do a "micro" average (retain all subtasks' per-document accuracies, and take the mean over all documents' accuracies to get our aggregate mean).
  404: Similar to our `metric_list` for listing out the metrics we want to calculate for a given task, we use an `aggregate_metric_list` field to specify which metric name to aggregate across subtasks, what aggregation function to use, and whether we should micro- or macro- average these metrics. See [./task_guide.md](./task_guide.md) for a full list of related sub-keys.
  406: **[!Tip]: currently, we predominantly only support the aggregation of group metrics that use `mean` (either micro- or macro- averaged) over their subtasks. If you require even more complex aggregation rules, you may want to perform aggregation offline.**

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\vendor\lm-evaluation-harness\docs\CONTRIBUTING.md:
  58: - Provide a short paragraph's worth of description. What is the feature you are requesting? What is its motivation, and an example use case of it? How does this differ from what is currently supported?
  82: - **Improving documentation** - Improvements to the documentation, or noting pain points / gaps in documentation, are helpful in order for us to improve the user experience of the library and clarity + coverage of documentation.

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\tau2-bench\web\leaderboard\SUBMISSION_GUIDE.md:
  148: To enable fair comparisons between models with different pricing structures, we encourage submitting cost information:
  150: 1. **Calculate average cost per trajectory** for each domain by dividing total cost by number of trajectories run

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\evaluation\__init__.py:
  22: from evaluation import rag
  35:     "rag": rag.RagEvaluation(
  44:     "multi_value_rag": rag.MultiValueRagEvaluation(

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\loft\evaluation\rag.py:
  16: """Evaluation functions for RAG. EM/F1 are from SQuAD and slightly modified."""
  34: def compute_coverage(gold_answers: list[str], pred_answers: list[str]) -> float:
  35:   """Calculates coverage of gold_answers in pred_answers."""
  57: class MultiValueRagEvaluation(evaluation.LOFTEvalution):
  58:   """Evaluation for RAG model outputs for single-turn Set based datasets."""
  71:     """Evaluates a RAG prediction."""
  89:     instance_metrics['coverage'] = compute_coverage(gold_answers, pred_answers)
  99: class RagEvaluation(evaluation.LOFTEvalution):
  100:   """Evaluation for multi-turn RAG model outputs."""
  110:     """Evaluates a RAG prediction."""

C:\Users\paulc\.config\opencode\skills\update-agent-models\benchmarks\ifbench\ifbench-platform\vendor\IFBench\uv.lock:
  72: name = "coverage"
  75: sdist = { url = "https://files.pythonhosted.org/packages/b6/45/2c665ca77ec32ad67e25c77daf1cee28ee4558f3bc571cdbaf88a00b9f23/coverage-7.13.0.tar.gz", hash = "sha256:a394aa27f2d7ff9bc04cf703817773a59ad6dfbd577032e690f961d2460ee936", size = 820905, upload-time = "2025-12-08T13:14:38.055Z" }
  77:     { url = "https://files.pythonhosted.org/packages/db/08/bdd7ccca14096f7eb01412b87ac11e5d16e4cb54b6e328afc9dee8bdaec1/coverage-7.13.0-cp310-cp310-macosx_10_9_x86_64.whl", hash = "sha256:02d9fb9eccd48f6843c98a37bd6817462f130b86da8660461e8f5e54d4c06070", size = 217979, upload-time = "2025-12-08T13:12:14.505Z" },
  78:     { url = "https://files.pythonhosted.org/packages/fa/f0/d1302e3416298a28b5663ae1117546a745d9d19fde7e28402b2c5c3e2109/coverage-7.13.0-cp310-cp310-macosx_11_0_arm64.whl", hash = "sha256:367449cf07d33dc216c083f2036bb7d976c6e4903ab31be400ad74ad9f85ce98", size = 218496, upload-time = "2025-12-08T13:12:16.237Z" },
  79:     { url = "https://files.pythonhosted.org/packages/07/26/d36c354c8b2a320819afcea6bffe72839efd004b98d1d166b90801d49d57/coverage-7.13.0-cp310-cp310-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:cdb3c9f8fef0a954c632f64328a3935988d33a6604ce4bf67ec3e39670f12ae5", size = 245237, upload-time = "2025-12-08T13:12:17.858Z" },
  80:     { url = "https://files.pythonhosted.org/packages/91/52/be5e85631e0eec547873d8b08dd67a5f6b111ecfe89a86e40b89b0c1c61c/coverage-7.13.0-cp310-cp310-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:d10fd186aac2316f9bbb46ef91977f9d394ded67050ad6d84d94ed6ea2e8e54e", size = 247061, upload-time = "2025-12-08T13:12:19.132Z" },
  81:     { url = "https://files.pythonhosted.org/packages/0f/45/a5e8fa0caf05fbd8fa0402470377bff09cc1f026d21c05c71e01295e55ab/coverage-7.13.0-cp310-cp310-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:7f88ae3e69df2ab62fb0bc5219a597cb890ba5c438190ffa87490b315190bb33", size = 248928, upload-time = "2025-12-08T13:12:20.702Z" },
  82:     { url = "https://files.pythonhosted.org/packages/f5/42/ffb5069b6fd1b95fae482e02f3fecf380d437dd5a39bae09f16d2e2e7e01/coverage-7.13.0-cp310-cp310-manylinux_2_31_riscv64.manylinux_2_39_riscv64.whl", hash = "sha256:c4be718e51e86f553bcf515305a158a1cd180d23b72f07ae76d6017c3cc5d791", size = 245931, upload-time = "2025-12-08T13:12:22.243Z" },
  83:     { url = "https://files.pythonhosted.org/packages/95/6e/73e809b882c2858f13e55c0c36e94e09ce07e6165d5644588f9517efe333/coverage-7.13.0-cp310-cp310-musllinux_1_2_aarch64.whl", hash = "sha256:a00d3a393207ae12f7c49bb1c113190883b500f48979abb118d8b72b8c95c032", size = 246968, upload-time = "2025-12-08T13:12:23.52Z" },
  84:     { url = "https://files.pythonhosted.org/packages/87/08/64ebd9e64b6adb8b4a4662133d706fbaccecab972e0b3ccc23f64e2678ad/coverage-7.13.0-cp310-cp310-musllinux_1_2_i686.whl", hash = "sha256:3a7b1cd820e1b6116f92c6128f1188e7afe421c7e1b35fa9836b11444e53ebd9", size = 244972, upload-time = "2025-12-08T13:12:24.781Z" },
  85:     { url = "https://files.pythonhosted.org/packages/12/97/f4d27c6fe0cb375a5eced4aabcaef22de74766fb80a3d5d2015139e54b22/coverage-7.13.0-cp310-cp310-musllinux_1_2_riscv64.whl", hash = "sha256:37eee4e552a65866f15dedd917d5e5f3d59805994260720821e2c1b51ac3248f", size = 245241, upload-time = "2025-12-08T13:12:28.041Z" },
  86:     { url = "https://files.pythonhosted.org/packages/0c/94/42f8ae7f633bf4c118bf1038d80472f9dade88961a466f290b81250f7ab7/coverage-7.13.0-cp310-cp310-musllinux_1_2_x86_64.whl", hash = "sha256:62d7c4f13102148c78d7353c6052af6d899a7f6df66a32bddcc0c0eb7c5326f8", size = 245847, upload-time = "2025-12-08T13:12:29.337Z" },
  87:     { url = "https://files.pythonhosted.org/packages/a8/2f/6369ca22b6b6d933f4f4d27765d313d8914cc4cce84f82a16436b1a233db/coverage-7.13.0-cp310-cp310-win32.whl", hash = "sha256:24e4e56304fdb56f96f80eabf840eab043b3afea9348b88be680ec5986780a0f", size = 220573, upload-time = "2025-12-08T13:12:30.905Z" },
  88:     { url = "https://files.pythonhosted.org/packages/f1/dc/a6a741e519acceaeccc70a7f4cfe5d030efc4b222595f0677e101af6f1f3/coverage-7.13.0-cp310-cp310-win_amd64.whl", hash = "sha256:74c136e4093627cf04b26a35dab8cbfc9b37c647f0502fc313376e11726ba303", size = 221509, upload-time = "2025-12-08T13:12:32.09Z" },
  89:     { url = "https://files.pythonhosted.org/packages/f1/dc/888bf90d8b1c3d0b4020a40e52b9f80957d75785931ec66c7dfaccc11c7d/coverage-7.13.0-cp311-cp311-macosx_10_9_x86_64.whl", hash = "sha256:0dfa3855031070058add1a59fdfda0192fd3e8f97e7c81de0596c145dea51820", size = 218104, upload-time = "2025-12-08T13:12:33.333Z" },
  90:     { url = "https://files.pythonhosted.org/packages/8d/ea/069d51372ad9c380214e86717e40d1a743713a2af191cfba30a0911b0a4a/coverage-7.13.0-cp311-cp311-macosx_11_0_arm64.whl", hash = "sha256:4fdb6f54f38e334db97f72fa0c701e66d8479af0bc3f9bfb5b90f1c30f54500f", size = 218606, upload-time = "2025-12-08T13:12:34.498Z" },
  91:     { url = "https://files.pythonhosted.org/packages/68/09/77b1c3a66c2aa91141b6c4471af98e5b1ed9b9e6d17255da5eb7992299e3/coverage-7.13.0-cp311-cp311-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:7e442c013447d1d8d195be62852270b78b6e255b79b8675bad8479641e21fd96", size = 248999, upload-time = "2025-12-08T13:12:36.02Z" },
  92:     { url = "https://files.pythonhosted.org/packages/0a/32/2e2f96e9d5691eaf1181d9040f850b8b7ce165ea10810fd8e2afa534cef7/coverage-7.13.0-cp311-cp311-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:1ed5630d946859de835a85e9a43b721123a8a44ec26e2830b296d478c7fd4259", size = 250925, upload-time = "2025-12-08T13:12:37.221Z" },
  93:     { url = "https://files.pythonhosted.org/packages/7b/45/b88ddac1d7978859b9a39a8a50ab323186148f1d64bc068f86fc77706321/coverage-7.13.0-cp311-cp311-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:7f15a931a668e58087bc39d05d2b4bf4b14ff2875b49c994bbdb1c2217a8daeb", size = 253032, upload-time = "2025-12-08T13:12:38.763Z" },
  94:     { url = "https://files.pythonhosted.org/packages/71/cb/e15513f94c69d4820a34b6bf3d2b1f9f8755fa6021be97c7065442d7d653/coverage-7.13.0-cp311-cp311-manylinux_2_31_riscv64.manylinux_2_39_riscv64.whl", hash = "sha256:30a3a201a127ea57f7e14ba43c93c9c4be8b7d17a26e03bb49e6966d019eede9", size = 249134, upload-time = "2025-12-08T13:12:40.382Z" },
  95:     { url = "https://files.pythonhosted.org/packages/09/61/d960ff7dc9e902af3310ce632a875aaa7860f36d2bc8fc8b37ee7c1b82a5/coverage-7.13.0-cp311-cp311-musllinux_1_2_aarch64.whl", hash = "sha256:7a485ff48fbd231efa32d58f479befce52dcb6bfb2a88bb7bf9a0b89b1bc8030", size = 250731, upload-time = "2025-12-08T13:12:41.992Z" },
  96:     { url = "https://files.pythonhosted.org/packages/98/34/c7c72821794afc7c7c2da1db8f00c2c98353078aa7fb6b5ff36aac834b52/coverage-7.13.0-cp311-cp311-musllinux_1_2_i686.whl", hash = "sha256:22486cdafba4f9e471c816a2a5745337742a617fef68e890d8baf9f3036d7833", size = 248795, upload-time = "2025-12-08T13:12:43.331Z" },
  97:     { url = "https://files.pythonhosted.org/packages/0a/5b/e0f07107987a43b2def9aa041c614ddb38064cbf294a71ef8c67d43a0cdd/coverage-7.13.0-cp311-cp311-musllinux_1_2_riscv64.whl", hash = "sha256:263c3dbccc78e2e331e59e90115941b5f53e85cfcc6b3b2fbff1fd4e3d2c6ea8", size = 248514, upload-time = "2025-12-08T13:12:44.546Z" },
  98:     { url = "https://files.pythonhosted.org/packages/71/c2/c949c5d3b5e9fc6dd79e1b73cdb86a59ef14f3709b1d72bf7668ae12e000/coverage-7.13.0-cp311-cp311-musllinux_1_2_x86_64.whl", hash = "sha256:e5330fa0cc1f5c3c4c3bb8e101b742025933e7848989370a1d4c8c5e401ea753", size = 249424, upload-time = "2025-12-08T13:12:45.759Z" },
  99:     { url = "https://files.pythonhosted.org/packages/11/f1/bbc009abd6537cec0dffb2cc08c17a7f03de74c970e6302db4342a6e05af/coverage-7.13.0-cp311-cp311-win32.whl", hash = "sha256:0f4872f5d6c54419c94c25dd6ae1d015deeb337d06e448cd890a1e89a8ee7f3b", size = 220597, upload-time = "2025-12-08T13:12:47.378Z" },
  100:     { url = "https://files.pythonhosted.org/packages/c4/f6/d9977f2fb51c10fbaed0718ce3d0a8541185290b981f73b1d27276c12d91/coverage-7.13.0-cp311-cp311-win_amd64.whl", hash = "sha256:51a202e0f80f241ccb68e3e26e19ab5b3bf0f813314f2c967642f13ebcf1ddfe", size = 221536, upload-time = "2025-12-08T13:12:48.7Z" },
  101:     { url = "https://files.pythonhosted.org/packages/be/ad/3fcf43fd96fb43e337a3073dea63ff148dcc5c41ba7a14d4c7d34efb2216/coverage-7.13.0-cp311-cp311-win_arm64.whl", hash = "sha256:d2a9d7f1c11487b1c69367ab3ac2d81b9b3721f097aa409a3191c3e90f8f3dd7", size = 220206, upload-time = "2025-12-08T13:12:50.365Z" },
  102:     { url = "https://files.pythonhosted.org/packages/9b/f1/2619559f17f31ba00fc40908efd1fbf1d0a5536eb75dc8341e7d660a08de/coverage-7.13.0-cp312-cp312-macosx_10_13_x86_64.whl", hash = "sha256:0b3d67d31383c4c68e19a88e28fc4c2e29517580f1b0ebec4a069d502ce1e0bf", size = 218274, upload-time = "2025-12-08T13:12:52.095Z" },
  103:     { url = "https://files.pythonhosted.org/packages/2b/11/30d71ae5d6e949ff93b2a79a2c1b4822e00423116c5c6edfaeef37301396/coverage-7.13.0-cp312-cp312-macosx_11_0_arm64.whl", hash = "sha256:581f086833d24a22c89ae0fe2142cfaa1c92c930adf637ddf122d55083fb5a0f", size = 218638, upload-time = "2025-12-08T13:12:53.418Z" },
  104:     { url = "https://files.pythonhosted.org/packages/79/c2/fce80fc6ded8d77e53207489d6065d0fed75db8951457f9213776615e0f5/coverage-7.13.0-cp312-cp312-manylinux1_i686.manylinux_2_28_i686.manylinux_2_5_i686.whl", hash = "sha256:0a3a30f0e257df382f5f9534d4ce3d4cf06eafaf5192beb1a7bd066cb10e78fb", size = 250129, upload-time = "2025-12-08T13:12:54.744Z" },
  105:     { url = "https://files.pythonhosted.org/packages/5b/b6/51b5d1eb6fcbb9a1d5d6984e26cbe09018475c2922d554fd724dd0f056ee/coverage-7.13.0-cp312-cp312-manylinux1_x86_64.manylinux_2_28_x86_64.manylinux_2_5_x86_64.whl", hash = "sha256:583221913fbc8f53b88c42e8dbb8fca1d0f2e597cb190ce45916662b8b9d9621", size = 252885, upload-time = "2025-12-08T13:12:56.401Z" },
  106:     { url = "https://files.pythonhosted.org/packages/0d/f8/972a5affea41de798691ab15d023d3530f9f56a72e12e243f35031846ff7/coverage-7.13.0-cp312-cp312-manylinux2014_aarch64.manylinux_2_17_aarch64.manylinux_2_28_aarch64.whl", hash = "sha256:5f5d9bd30756fff3e7216491a0d6d520c448d5124d3d8e8f56446d6412499e74", size = 253974, upload-time = "2025-12-08T13:12:57.718Z" },
  107:     { url = "https://files.pythonhosted.org/packages/8a/56/116513aee860b2c7968aa3506b0f59b22a959261d1dbf3aea7b4450a7520/coverage-7.13.0-cp312-cp312-manylinux_2_31_riscv64.manylinux_2_39_riscv64.whl", hash = "sha256:a23e5a1f8b982d56fa64f8e442e037f6ce29322f1f9e6c2344cd9e9f4407ee57", size = 250538, upload-time = "2025-12-08T13:12:59.254Z" },
  108:     { url = "https://files.pythonhosted.org/packages/d6/75/074476d64248fbadf16dfafbf93fdcede389ec821f74ca858d7c87d2a98c/coverage-7.13.0-cp312-cp312-musllinux_1_2_aarch64.whl", hash = "sha256:9b01c22bc74a7fb44066aaf765224c0d933ddf1f5047d6cdfe4795504a4493f8", size = 251912, upload-time = "2025-12-08T13:13:00.604Z" },
  109:     { url = "https://files.pythonhosted.org/packages/f2/d2/aa4f8acd1f7c06024705c12609d8698c51b27e4d635d717cd1934c9668e2/coverage-7.13.0-cp312-cp312-musllinux_1_2_i686.whl", hash = "sha256:898cce66d0836973f48dda4e3514d863d70142bdf6dfab932b9b6a90ea5b222d", size = 250054, upload-time = "2025-12-08T13:13:01.892Z" },
  110:     { url = "https://files.pythonhosted.org/packages/19/98/8df9e1af6a493b03694a1e8070e024e7d2cdc77adedc225a35e616d505de/coverage-7.13.0-cp312-cp312-musllinux_1_2_riscv64.whl", hash = "sha256:3ab483ea0e251b5790c2aac03acde31bff0c736bf8a86829b89382b407cd1c3b", size = 249619, upload-time = "2025-12-08T13:13:03.236Z" },
  111:     { url = "https://files.pythonhosted.org/packages/d8/71/f8679231f3353018ca66ef647fa6fe7b77e6bff7845be54ab84f86233363/coverage-7.13.0-cp312-cp312-musllinux_1_2_x86_64.whl", hash = "sha256:1d84e91521c5e4cb6602fe11ece3e1de03b2760e14ae4fcf1a4b56fa3c801fcd", size = 251496, upload-time = "2025-12-08T13:13:04.511Z" },
  112:     { url = "https://files.p

... (truncated)
```
