description:
  Record changes to the repository
synopses:
  - git commit [-a | --interactive | --patch] [-s] [-v] [-u<mode>] [--amend]
    [--dry-run] [(-c | -C | --squash) <commit> | --fixup [(amend|reword):]<commit>)]
    [-F <file> | -m <msg>] [--reset-author] [--allow-empty]
    [--allow-empty-message] [--no-verify] [-e] [--author=<author>]
    [--date=<date>] [--cleanup=<mode>] [--status | --no-status]
    [-i | -o] [--pathspec-from-file=<file> [--pathspec-file-nul]]
    [(--trailer <token>[(=|:)<value>])…​] [-S[<keyid>]] 
    [--] [<pathspec>…​]
options:
  -a, --all: Tell the command to automatically stage files that have been modified and deleted, but new files you have not told Git about are not affected.
  -p, --patch: Use the interactive patch selection interface to choose which changes to commit.
  -C <commit>, --reuse-message=<commit>: Take an existing commit object, and reuse the log message and the authorship information (including the timestamp) when creating the commit.
  -c <commit>, --reedit-message=<commit>: Like -C, but with -c the editor is invoked, so that the user can further edit the commit message.
  --fixup=[(amend|reword):]<commit>: Create a new commit which "fixes up" <commit> when applied with "git rebase --autosquash".
  --squash=<commit>: Construct a commit message for use with rebase --autosquash.
  --reset-author: When used with -C/-c/--amend options, or when committing after a conflicting cherry-pick, declare that the authorship of the resulting commit now belongs to the committer. This also renews the author timestamp.
  --short: When doing a dry-run, give the output in the short-format. Implies --dry-run.
  --branch: Show the branch and tracking info even in short-format.
  --porcelain: When doing a dry-run, give the output in a porcelain-ready format. Implies --dry-run.
  --long: When doing a dry-run, give the output in the long-format. Implies --dry-run.
  -z, --null: When showing short or porcelain status output, print the filename verbatim and terminate the entries with NUL, instead of LF.
  -F <file>, --file=<file>: Take the commit message from the given file. Use - to read the message from the standard input.
  --author=<author>: Override the commit author.
  --date=<date>: Override the author date used in the commit.
  -m <msg>, --message=<msg>: Use the given <msg> as the commit message.
  -t <file>, --template=<file>: When editing the commit message, start the editor with the contents in the given file.
  -s, --signoff: Add a Signed-off-by trailer by the committer at the end of the commit log message.
  --no-signoff: Countermand an earlier --signoff option on the command line.
  --trailer <token>[(=|:)<value>] : Specify a (<token>, <value>) pair that should be applied as a trailer.
  --verify: Allow the pre-commit and commit-msg hooks to run.
  -n, --no-verify: Disable the pre-commit and commit-msg hooks from running.
  --allow-empty: Allow recording a commit that has the exact same tree as its sole parent commit.
  --allow-empty-message: Allow you to create a commit with an empty commit message without using plumbing commands like git-commit-tree.
  --cleanup=<mode>:
    description: This option determines how the supplied commit message should be cleaned up before committing.
    values:
      - strip: Strip leading and trailing empty lines, trailing whitespace, commentary and collapse consecutive empty lines.
      - whitespace: Same as strip except #commentary is not removed
      - verbatim: Do not change the message at all
      - scissors: Same as whitespace except that everything from (and including) the line found below is truncated
      - default: Same as strip if the message is to be edited. Otherwise whitespace.
  -e, --edit: Use the selected commit message with launching an editor.
  --no-edit: Use the selected commit message without launching an editor.
  --amend: Replace the tip of the current branch by creating a new commit.
  --no-post-rewrite: Bypass the post-rewrite hook.
  -i, --include: Before making a commit out of staged contents so far, stage the contents of paths given on the command line as well.
  -o, --only: Make a commit by taking the updated working tree contents of the paths specified on the command line, disregarding any contents that have been staged for other paths.
  --pathspec-from-file=<file>: Pathspec is passed in <file> instead of commandline args.
  --pathspec-file-nul: Pathspec elements are separated with NUL character and all other characters are taken literally.
  -u[<mode>], --untracked-files[=<mode>]:
    description: Show untracked files.
    values:
      - no: Show no untracked files
      - normal: Shows untracked files and directories
      - all: Also shows individual files in untracked directories.
  -v, --verbose: Show unified diff between the HEAD commit and what would be committed at the bottom of the commit message template to help the user describe the commit by reminding what changes the commit has.
  -q, --quiet: Suppress commit summary message.
  --dry-run: Do not create a commit, but show a list of paths that are to be committed, paths with local changes that will be left uncommitted and paths that are untracked.
  --status: Include the output of git-status in the commit message template when using an editor to prepare the commit message.
  --no-status: Do not include the output of git-status in the commit message template when using an editor to prepare the default commit message.
  -S[<keyid>], --gpg-sign[=<keyid>]: GPG-sign commits.
  --no-gpg-sign: Countermand an earlier --gpg-sign option on the command line