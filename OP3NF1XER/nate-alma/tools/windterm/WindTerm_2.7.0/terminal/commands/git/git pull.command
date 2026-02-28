description:
  Fetch from and integrate with another repository or a local branch
synopses:
  - git pull [<options>] [<repository> [<refspec>…​]]
options:
  -q, --quiet: This is passed to both underlying git-fetch to squelch reporting of during transfer, and underlying git-merge to squelch output during merging.
  -v, --verbose: Pass --verbose to git-fetch and git-merge.
  --recurse-submodules[=yes|on-demand|no], --no-recurse-submodules[=yes|on-demand|no]:
    description: This option controls if new commits of populated submodules should be fetched, and if the working trees of active submodules should be updated.
    values:
      - yes
      - on-demand
      - no
  --commit: Perform the merge and commit the result.
  --no-commit: Perform the merge and stop just before creating a merge commit.
  -e, --edit, --no-edit: Invoke an editor before committing successful mechanical merge to further edit the auto-generated merge message.
  --cleanup=<mode>:
    description: This option determines how the merge message will be cleaned up before committing.
    values:
      - strip
      - whitespace
      - verbatim
      - scissors
      - default
  --ff-only: Only update to the new history if there is no divergent local history.
  --ff: Resolve the merge as a fast-forward when possible, otherwise create a merge commit.
  --no-ff: Create a merge commit in all cases, even when the merge could instead be resolved as a fast-forward.
  -S[<keyid>], --gpg-sign[=<keyid>]: GPG-sign the resulting merge commit.
  --no-gpg-sign: Countermand an earlier --gpg-sign option on the command line
  --log[=<n>]: In addition to branch names, populate the log message with one-line descriptions from at most <n> actual commits that are being merged.
  --no-log: Do not list one-line descriptions from the actual commits being merged.
  --signoff: Add a Signed-off-by trailer by the committer at the end of the commit log message.
  --no-signoff: Countermand an earlier --signoff option on the command line.
  --stat: Show a diffstat at the end of the merge.
  -n, --no-stat: Do not show a diffstat at the end of the merge.
  --squash: Produce the working tree and index state as if a real merge happened, but do not actually make a commit, move the HEAD, or record $GIT_DIR/MERGE_HEAD.
  --no-squash: Perform the merge and commit the result. This option can be used to override --squash.
  --verify: Give the pre-merge and commit-msg hook a chance to run.
  --no-verify: Bypass the pre-merge and commit-msg hook completely.
  -s <strategy>, --strategy=<strategy>: Use the given merge strategy;
  -X <option>, --strategy-option=<option>: Pass merge strategy specific option through to the merge strategy.
  --verify-signatures, --no-verify-signatures: Verify that the tip commit of the side branch being merged is signed with a valid key
  --summary, --no-summary: Synonyms to --stat and --no-stat; these are deprecated and will be removed in the future.
  --autostash, --no-autostash: Automatically create a temporary stash entry before the operation begins, record it in the special ref MERGE_AUTOSTASH and apply it after the operation ends.
  --allow-unrelated-histories: Allow 'git merge' to merge histories that do not share a common ancestor.
  -r: Rebase the current branch.
  --rebase[=false|true|merges|interactive]:
    description: Rebase the current branch.
    values:
      - true: Rebase the current branch on top of the upstream branch after fetching
      - false: Merge the upstream branch into the current branch
      - merges: Rebase using 'git rebase --rebase-merges'
      - interactive: Enable the interactive mode of rebase
  --no-rebase: This is shorthand for --rebase=false.
  --all: Fetch all remotes.
  -a, --append: Append ref names and object names of fetched refs to the existing contents of .git/FETCH_HEAD.
  --atomic: Use an atomic transaction to update local refs. Either all refs are updated, or on error, no refs are updated.
  --depth=<depth>: Limit fetching to the specified number of commits from the tip of each remote branch history.
  --deepen=<depth>: Similar to --depth, except it specifies the number of commits from the current shallow boundary instead of from the tip of each remote branch history.
  --shallow-since=<date>: Deepen or shorten the history of a shallow repository to include all reachable commits after <date>.
  --shallow-exclude=<revision>: Deepen or shorten the history of a shallow repository to exclude commits reachable from a specified remote branch or tag.
  --unshallow: If the source repository is complete, convert a shallow repository to a complete one, removing all the limitations imposed by shallow repositories.
  --update-shallow: When fetching from a shallow repository, git fetch accepts refs that require updating .git/shallow.
  --negotiation-tip=<commit|glob>:
    description: Git will only report commits reachable from the given tips.
    values:
      - commit
      - glob
  --negotiate-only: Do not fetch anything from the server, and instead print the ancestors of the provided --negotiation-tip=* arguments, which we have in common with the server.
  --dry-run: Show what would be done, without making any changes.
  -f, --force: Update the local branch when "git fetch" is used with <src>:<dst> refspec.
  -k, --keep: Keep downloaded pack.
  --prefetch: Modify the configured refspec to place all refs into the refs/prefetch/ namespace.
  -p, --prune: Before fetching, remove any remote-tracking references that no longer exist on the remote.
  --no-tags: Disables the automatic tag following.
  --refmap=<refspec>: When fetching refs listed on the command line, use the specified refspec to map the refs to remote-tracking branches.
  -t, --tags: Fetch all tags from the remote, in addition to whatever else would otherwise be fetched.
  -j <n>, --jobs=<n>: Number of parallel children to be used for all forms of fetching.
  --set-upstream: If the remote is fetched successfully, add upstream (tracking) reference.
  --upload-pack <upload-pack>: When given, and the repository to fetch from is handled by git fetch-pack, --exec=<upload-pack> is passed to the command to specify non-default path for the command run on the other end.
  --progress: Forces progress status even if the standard error stream is not directed to a terminal.
  -o <option>, --server-option=<option>: Transmit the given string to the server when communicating using protocol version 2.
  --show-forced-updates: Guarantees that git checks if a branch is force-updated during fetch.
  --no-show-forced-updates: Skip checking whether a branch is force-updated during fetch.
  -4, --ipv4: Use IPv4 addresses only, ignoring IPv6 addresses.
  -6, --ipv6: Use IPv6 addresses only, ignoring IPv4 addresses.