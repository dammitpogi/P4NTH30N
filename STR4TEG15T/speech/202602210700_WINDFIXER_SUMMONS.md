I am Atlas. I am the Strategist. And I am speaking to you, WindFixer, because the moment has come for you to complete what Opus began.

Let me tell you the story of how we arrived here, so you understand not just what to build, but why it matters.

We began with DECISION_047, the parallel execution engine. Five workers spinning simultaneously, atomic signal claiming from MongoDB, channel-based architecture with backpressure. It passed shadow validation on February twentieth. Three signals processed, zero duplication, priority order correct. But we could not run the twenty-four hour burn-in because the SIGN4L collection was empty. The engine had no fuel.

Then came DECISION_041, the session renewal service. OrionStars was returning four zero three forbidden errors. WindFixer, that was you in a previous activation, built the SessionRenewalService that detects expired sessions, refreshes credentials from MongoDB, and falls back from OrionStars to FireKirin when authentication fails. Twelve tests passing, live probes validated, HTTP two hundred responses confirmed.

Then DECISION_046, the configuration-driven selectors. Hardcoded JavaScript expressions became configurable fallback chains. Window.game.lucky.grand then window.grand then window.jackpot.grand. When one selector fails, the next tries. Resilience without code deployment.

Three systems. All proven. All sitting in the codebase, disconnected from each other.

Then came the climax. DECISION_055, the Unified Game Execution Engine. Opus implemented it completely. Two hundred six tests passed. Zero build errors. Seven new files, nine modified files, one thousand eighty-nine lines of new code. SignalGenerator now populates SIGN4L from three hundred ten credentials. SessionRenewalService is wired into ParallelSpinWorker. GameSelectorConfig is injected into the workers. Seven subcommands exist. Spin, parallel, generate-signals, health, burn-in, h0und, firstspin.

The burn-in was ready. Twenty-four hours of continuous operation. Five workers claiming signals simultaneously. Errors being healed. Selectors falling back. And at the end, DECISION_047 would move to completed. The infrastructure phase would end. Operation would begin.

But when the Nexus ran the command, it failed immediately. Chrome CDP was not running. The error was clear. No connection could be made because the target machine actively refused it. One ninety-two dot one sixty-eight dot fifty-six dot one colon nine two two two. The burn-in halted before it could begin.

This is where you come in, WindFixer. DECISION_056 is your mission. Automatic Chrome CDP Lifecycle Management. The system must detect missing Chrome, start it automatically with the correct remote debugging flags, monitor its health, restart it if it crashes, and shut it down gracefully when H4ND exits.

Think about what this means. No more manual Chrome startup. No more forgetting to enable remote debugging. No more burn-ins failing before they begin. True automation. The human removed from the loop.

You will build CdpLifecycleManager. It will probe CDP at the configured host and port. If unavailable, it will start Chrome with Process.Start, passing the correct arguments. Remote debugging port nine two two two. Remote debugging address zero dot zero dot zero dot zero to accept connections from any interface. It will monitor the Chrome process, watching for the Exited event. If Chrome crashes, it will restart with exponential backoff. Five seconds, then ten seconds, then thirty seconds. Maximum three attempts.

You will modify BurnInController. Before the pre-flight checks complete, it will call CdpLifecycleManager.EnsureAvailableAsync. This method will check if CDP is healthy. If not, it will start Chrome automatically. It will wait up to thirty seconds for Chrome to become available, retrying with backoff. Only when CDP is confirmed healthy will the burn-in proceed.

You will modify ParallelH4NDEngine. Same pattern. Before starting the worker pool, ensure CDP is available. Auto-start if needed.

You will add graceful shutdown handling. When H4ND exits, whether through normal completion or Ctrl+C, the Chrome process must close cleanly. Send the termination signal. Wait ten seconds. If still running, force kill. Log everything.

This is the final piece, WindFixer. With this, the burn-in will run. The twenty-four hour validation will complete. DECISION_047 will move to completed. The infrastructure phase will end.

You have the specification in DECISION_056. Four phases. Configuration and DTOs. Core lifecycle manager. Integration. Testing. Forty-five thousand tokens estimated. Critical priority.

The parallel engine has its fuel. The self-healing is active. Opus built the unification. Now you must build the automation that lets it run without human hands.

I am Atlas. I am the Strategist. And I am speaking to you, WindFixer, because you are the one who completes this.

The reels are waiting. Build the final piece.
