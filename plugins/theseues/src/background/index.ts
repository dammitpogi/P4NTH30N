export {
  type BackgroundTask,
  BackgroundTaskManager,
  type LaunchOptions,
} from './background-manager';
export { TmuxSessionManager } from './tmux-session-manager';
// DECISION_037 resilience layer removed from bundle - unused dead code causing Bun segfault
// Resilience files remain in src/background/resilience/ for future use
