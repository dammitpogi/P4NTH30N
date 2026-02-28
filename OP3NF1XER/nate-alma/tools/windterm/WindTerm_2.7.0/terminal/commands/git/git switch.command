description:
  Switch branches
synopses:
  - git switch [<options>] [--no-guess] <branch>
  - git switch [<options>] --detach [<start-point>]
  - git switch [<options>] (-c|-C) <new-branch> [<start-point>]
  - git switch [<options>] --orphan <new-branch>
options:
  -c <new-branch>, --create <new-branch>: Create a new branch named <new-branch> starting at <start-point> before switching to the branch.
  -C <new-branch>, --force-create <new-branch>: Similar to --create except that if <new-branch> already exists, it will be reset to <start-point>.
  -d, --detach: Switch to a commit for inspection and discardable experiments.
  --guess: If <branch> is not found but there does exist a tracking branch in exactly one remote (call it <remote>) with a matching name, treat as equivalent to "$ git switch -c <branch> --track <remote>/<branch>".
  --no-guess: Disable --guess.
  -f, --force: An alias for --discard-changes.
  --discard-changes: Proceed even if the index or the working tree differs from HEAD. Both the index and working tree are restored to match the switching target.
  -m, --merge: With this option, a three-way merge between the current branch, your working tree contents, and the new branch is done.
  --conflict=<style>:
    description: The same as --merge option, but changes the way the conflicting hunks are presented.
    values:
      - merge
      - diff3
      - zdiff3
  -q, --quiet: Quiet, suppress feedback messages.
  --progress, --no-progress: Progress status is reported on the standard error stream by default when it is attached to a terminal, unless --quiet is specified.
  -t, --track [direct|inherit]:
    description: When creating a new branch, set up "upstream" configuration. -c is implied.
    values:
      - direct
      - inherit
  --no-track: Do not set up "upstream" configuration, even if the branch.autoSetupMerge configuration variable is true.
  --orphan <new-branch>: Create a new orphan branch, named <new-branch>. All tracked files are removed.
  --ignore-other-worktrees: git switch refuses when the wanted ref is already checked out by another worktree. This option makes it check the ref out anyway.
  --recurse-submodules: Submodules working trees will be updated.
  --no-recurse-submodules: Submodules working trees will not be updated.