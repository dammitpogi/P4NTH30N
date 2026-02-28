description:
  Reapply commits on top of another base tip
synopses:
  - git rebase [-i | --interactive] [<options>] [--exec <cmd>] [--onto <newbase> | --keep-base] [<upstream> [<branch>]]
  - git rebase [-i | --interactive] [<options>] [--exec <cmd>] [--onto <newbase>] --root [<branch>]
  - git rebase (--continue | --skip | --abort | --quit | --edit-todo | --show-current-patch)
options:
  --onto <newbase>: Starting point at which to create the new commits.
  --keep-base: Set the starting point at which to create the new commits to the merge base of <upstream> <branch>.
  --continue: Restart the rebasing process after having resolved a merge conflict.
  --abort: Abort the rebase operation and reset HEAD to the original branch.
  --quit: Abort the rebase operation but HEAD is not reset back to the original branch.
  --apply: Use applying strategies to rebase.
  --empty=action:
    description: How to handle commits that are not empty to start and are not clean cherry-picks of any upstream commit, but which become empty after rebasing.
    values:
      - drop: drop empty commits
      - keep: keep empty commits
      - ask: ask whether to drop empty commits
  --keep-empty: Keep commits that start empty before the rebase in the result.
  --no-keep-empty: Do not keep commits that start empty before the rebase in the result.
  --reapply-cherry-picks, --no-reapply-cherry-picks: Reapply all clean cherry-picks of any upstream commit instead of preemptively dropping them.
  --allow-empty-message: No-op, deprecated.
  --skip: Restart the rebasing process by skipping the current patch.
  --edit-todo: Edit the todo list during an interactive rebase.
  --show-current-patch: Show the current patch in an interactive rebase or when rebase is stopped because of conflicts.
  -m, --merge: Using merging strategies to rebase (default).
  -s <strategy>, --strategy=<strategy>:
    description: Use the given merge strategy, instead of the default ort. This implies --merge.
    values:
      - ort
      - recursive
      - resolve
      - octopus
      - ours
      - subtree
  -X <strategy-option>, --strategy-option=<strategy-option>: Pass the <strategy-option> through to the merge strategy. This implies --merge and, if no strategy has been specified, -s ort.
  --rerere-autoupdate, --no-rerere-autoupdate: Allow the rerere mechanism to update the index with the result of auto-conflict resolution if possible.
  -S[=<keyid>], --gpg-sign[=<keyid>]: GPG-sign commits.
  --no-gpg-sign: Countermand an earlier --gpg-sign option on the command line
  -q, --quiet: Be quiet. Implies --no-stat.
  -v, --verbose: Be verbose. Implies --stat.
  --stat: Show a diffstat of what changed upstream since the last rebase.
  -n, --no-stat: Do not show a diffstat as part of the rebase process.
  --no-verify: This option bypasses the pre-rebase hook.
  --verify: Allows the pre-rebase hook to run, which is the default. This option can be used to override --no-verify.
  -C<n>: Ensure at least <n> lines of surrounding context match before and after each change.
  -f, --no-ff, --force-rebase: Individually replay all rebased commits instead of fast-forwarding over the unchanged ones.
  --fork-point, --no-fork-point: Use reflog to find a better common ancestor between <upstream> and <branch> when calculating which commits have been introduced by <branch>.
  --ignore-whitespace: Ignore whitespace differences when trying to reconcile differences.
  --whitespace=<option>:
    description: This flag is passed to the git apply program that applies the patch. Implies --apply.
    values:
      - nowarn: Turns off the trailing whitespace warning
      - warn: Outputs warnings, but Applies the patch as-is 
      - fix: Outputs warnings and applies the patch after fixing them
      - error: Outputs warnings and refuses to apply the patch
      - error-all: Similar to error but shows all errors
  --committer-date-is-author-date: Instead of using the current time as the committer date, use the author date of the commit being rebased as the committer date. This option implies --force-rebase.
  --ignore-date, --reset-author-date: Instead of using the author date of the original commit, use the current time as the author date of the rebased commit. This option implies --force-rebase.
  --signoff: Add a Signed-off-by trailer to all the rebased commits.
  -i, --interactive: Make a list of the commits which are about to be rebased. Let the user edit that list before rebasing.
  -r: Preserve the branching structure within the commits that are to be rebased, by recreating the merge commits.
  --rebase-merges[=(rebase-cousins|no-rebase-cousins)]:
    description: Preserve the branching structure within the commits that are to be rebased, by recreating the merge commits.
    values:
      - rebase-cousins
      - no-rebase-cousins
  -x <cmd>, --exec <cmd>: Append "exec <cmd>" after each line creating a commit in the final history.
  --root: Rebase all commits reachable from <branch>, instead of limiting them with an <upstream>.
  --autosquash, --no-autosquash: When the commit log message begins with "squash! …​" or "fixup! …​" or "amend! …​", and there is already a commit in the todo list that matches the same ..., automatically modify the todo list of rebase -i, so that the commit marked for squashing comes right after the commit to be modified, and change the action of the moved commit from pick to squash or fixup or fixup -C respectively.
  --autostash, --no-autostash: Automatically create a temporary stash entry before the operation begins, and apply it after the operation ends.
  --reschedule-failed-exec, --no-reschedule-failed-exec: Automatically reschedule exec commands that failed. This only makes sense in interactive mode (or when an --exec option was provided).