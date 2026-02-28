description:
  Switch branches or restore working tree files
synopses:
  - git checkout [-q] [-f] [-m] [<branch>]
  - git checkout [-q] [-f] [-m] --detach [<branch>]
  - git checkout [-q] [-f] [-m] [--detach] <commit>
  - git checkout [-q] [-f] [-m] [[-b|-B|--orphan] <new_branch>] [<start_point>]
  - git checkout [-f|--ours|--theirs|-m|--conflict=<style>] [<tree-ish>] [--] <paths>…​
  - git checkout [<tree-ish>] [--] <pathspec>…​
  - git checkout (-p|--patch) [<tree-ish>] [--] [<paths>…​]
options:
  -q, --quiet: Quiet, suppress feedback messages.
  --progress, --no-progress: Enables progress reporting even if not attached to a terminal, regardless of --quiet.
  -f, --force: When switching branches, proceed even if the index or the working tree differs from HEAD, and even if there are untracked files in the way.
  --ours, --theirs: When checking out paths from the index, check out stage #2 (ours) or #3 (theirs) for unmerged paths.
  -b <new-branch>: Create a new branch named <new-branch> and start it at <start-point>.
  -B <new-branch>: Creates the branch <new-branch> and start it at <start-point>.
  -t: When creating a new branch, set up "upstream" configuration.
  --track[=(direct|inherit)] :
    description: When creating a new branch, set up "upstream" configuration.
    values:
      - direct
      - inherit
  --no-track: Do not set up "upstream" configuration, even if the branch.autoSetupMerge configuration variable is true.
  --guess: Guess the branch.
  --no-guess: Don't guess the branch.
  -l: Create the new branch's reflog.
  -d, --detach: Rather than checking out a branch to work on it, check out a commit for inspection and discardable experiments.
  --orphan <new-branch>: Create a new orphan branch, named <new-branch>, started from <start-point> and switch to it.erent from the one of <start-point>, then you should clear the index and the working tree right after creating the orphan branch by running git rm -rf . from the top level of the working tree. Afterwards you will be ready to prepare your new files, repopulating the working tree, by copying them from elsewhere, extracting a tarball, etc.
  --ignore-skip-worktree-bits: Ignores the sparse patterns and adds back any files in <paths>.
  -m, --merge: A three-way merge between the current branch, your working tree contents, and the new branch is done, and you will be on the new branch.
  --conflict=<style>:
    description: Changes the way the conflicting hunks are presented
    values:
      - '"merge"'
      - '"diff3"'
      - '"zdiff3"'
  -p, --patch: Interactively select hunks in the difference between the <tree-ish> (or the index, if unspecified) and the working tree.
  --ignore-other-worktrees: Check the ref out anyway.
  --overwrite-ignore: Silently overwrite ignored files when switching branches.
  --no-overwrite-ignore: Abort the operation when the new branch contains ignored files.
  --recurse-submodules: Update the content of all active submodules according to the commit recorded in the superproject.
  --no-recurse-submodules: Submodules working trees will not be updated.
  --overlay: Never removes files from the index or the working tree.
  --no-overlay: Files that appear in the index and working tree, but not in <tree-ish> are removed, to make them match <tree-ish> exactly.
  --pathspec-from-file=<file>: Pathspec is passed in <file> instead of commandline args.
  --pathspec-file-nul: Pathspec elements are separated with NUL character and all other characters are taken literally (including newlines and quotes).