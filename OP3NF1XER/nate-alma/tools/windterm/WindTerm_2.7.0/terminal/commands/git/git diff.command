description:
  Show changes between commits, commit and working tree, etc
synopses:
  - git diff [<options>] [<commit>] [--] [<path>…​]
  - git diff [<options>] --cached [--merge-base] [<commit>] [--] [<path>…​]
  - git diff [<options>] [--merge-base] <commit> [<commit>…​] <commit> [--] [<path>…​]
  - git diff [<options>] <commit>…​<commit> [--] [<path>…​]
  - git diff [<options>] <blob> <blob>
  - git diff [<options>] --no-index [--] <path> <path>
options:
  -p, -u, --patch: Generate patch.
  -s, --no-patch: Suppress diff output.
  --diff-merges=format:
    description: Specify diff format to be used for merge commits.
    values:
      - off: Disable output of diffs for merge commits.
      - none: Disable output of diffs for merge commits.
      - on: Enable output of diffs for merge commits.
      - first-parent: This option makes merge commits show the full diff with respect to the first parent only.
      - 1: This option makes merge commits show the full diff with respect to the first parent only.
      - separate: This makes merge commits show the full diff with respect to each of the parents.
      - m: This option makes diff output for merge commits to be shown in the default format.
      - combined: With this option, diff output for a merge commit shows the differences from each of the parents to the merge result simultaneously instead of showing pairwise diff between a parent and the result one at a time. 
      - c: With this option, diff output for a merge commit shows the differences from each of the parents to the merge result simultaneously instead of showing pairwise diff between a parent and the result one at a time. 
      - dense-combined: With this option the output produced by --diff-merges=combined is further compressed by omitting uninteresting hunks whose contents in the parents have only two variants and the merge result picks one of them without modification. 
      - cc: With this option the output produced by --diff-merges=combined is further compressed by omitting uninteresting hunks whose contents in the parents have only two variants and the merge result picks one of them without modification. 
      - remerge: With this option, two-parent merge commits are remerged to create a temporary tree object
      - r: With this option, two-parent merge commits are remerged to create a temporary tree object
  --combined-all-paths: This flag causes combined diffs to list the name of the file from all parents.
  -U<n>, --unified=<n>: Generate diffs with <n> lines of context instead of the usual three. Implies --patch.
  --output=<file>: Output to a specific file instead of stdout.
  --output-indicator-new=<char>: Specify the character used to indicate new lines in the generated patch.
  --output-indicator-old=<char>: Specify the character used to indicate old lines in the generated patch.
  --output-indicator-context=<char>: Specify the character used to indicate context lines in the generated patch.
  --raw: Generate the diff in raw format.
  --patch-with-raw: Synonym for -p --raw.
  --indent-heuristic: Enable the heuristic that shifts diff hunk boundaries to make patches easier to read.
  --no-indent-heuristic: Disable the indent heuristic.
  --minimal: Spend extra time to make sure the smallest possible diff is produced.
  --patience: Generate a diff using the "patience diff" algorithm.
  --histogram: Generate a diff using the "histogram diff" algorithm.
  --anchored=<text>: Generate a diff using the "anchored diff" algorithm.
  --diff-algorithm=algorithm:
    description: Choose a diff algorithm.
    values:
      - default: The basic greedy diff algorithm.
      - myers: The basic greedy diff algorithm.
      - minimal: Spend extra time to make sure the smallest possible diff is produced.
      - patience: Use "patience diff" algorithm when generating patches.
      - histogram: This algorithm extends the patience algorithm to "support low-occurrence common elements".
  --stat[=<width>[,<name-width>[,<count>]]]: Generate a diffstat.
  --stat-width=<width>: Set the width of the output.
  --stat-name-width=<name-width>: Set the width of the filename.
  --stat-count=<count>: Limit the output to the first <count> lines.
  --compact-summary: Output a condensed summary of extended header information such as file creations or deletions and mode changes in diffstat. Implies --stat.
  --numstat: Similar to --stat, but shows number of added and deleted lines in decimal notation and pathname without abbreviation, to make it more machine friendly. For binary files, outputs two - instead of saying 0 0.
  --shortstat: Output only the last line of the --stat format containing total number of modified files, as well as number of added and deleted lines.
  -X[<param1,param2,…​>], --dirstat[=<param1,param2,…​>]:
    description: Output the distribution of relative amount of changes for each sub-directory.
    values:
      - changes: Compute the dirstat numbers by counting the lines that have been removed from the source, or added to the destination.
      - lines: Compute the dirstat numbers by doing the regular line-based diff analysis, and summing the removed/added line counts.
      - files: Compute the dirstat numbers by counting the number of files changed.
      - cumulative: Count changes in a child directory for the parent directory as well.
      - <limit>: An integer parameter specifies a cut-off percent (3% by default).
  --cumulative: Synonym for --dirstat=cumulative
  --dirstat-by-file[=<param1,param2>…​]:
    description: Synonym for --dirstat=files,param1,param2…​
    values:
      - changes: Compute the dirstat numbers by counting the lines that have been removed from the source, or added to the destination.
      - lines: Compute the dirstat numbers by doing the regular line-based diff analysis, and summing the removed/added line counts.
      - files: Compute the dirstat numbers by counting the number of files changed.
      - cumulative: Count changes in a child directory for the parent directory as well.
      - <limit>: An integer parameter specifies a cut-off percent (3% by default).
  --summary: Output a condensed summary of extended header information such as creations, renames and mode changes.
  --patch-with-stat: Synonym for -p --stat.
  -z: When --raw, --numstat, --name-only or --name-status has been given, do not munge pathnames and use NULs as output field terminators.
  --name-only: Show only names of changed files.
  --name-status: Show only names and status of changed files.
  --submodule[=<format>]:
    description: Specify how differences in submodules are shown.
    values:
      - short: This format shows the names of the commits at the beginning and end of the range. 
      - long: This format lists the commits in the range like git-submodule[1] summary does.
      - diff: This format shows an inline diff of the changes in the submodule contents between the commit range.
  --color[=<when>]:
    description: Show colored diff.
    values:
      - always
      - auto
      - never
  --no-color: Turn off colored diff. It is the same as --color=never.
  --color-moved[=<mode>]:
    description: Moved lines of code are colored differently.
    values:
      - no: Moved lines are not highlighted.
      - default: Is a synonym for zebra.
      - plain: Any line that is added in one location and was removed in another location will be colored with color.diff.newMoved.
      - blocks: Blocks of moved text of at least 20 alphanumeric characters are detected greedily.
      - zebra: Blocks of moved text are detected as in blocks mode.
      - dimmed-zebra: Similar to zebra, but additional dimming of uninteresting parts of moved code is performed.
  --no-color-moved: Turn off move detection. It is the same as --color-moved=no.
  --color-moved-ws=<modes>:
    description: This configures how whitespace is ignored when performing the move detection for --color-moved.
    values:
      - no: Do not ignore whitespace when performing move detection.
      - ignore-space-at-eol: Ignore changes in whitespace at EOL.
      - ignore-space-change: Ignore changes in amount of whitespace.
      - ignore-all-space: Ignore whitespace when comparing lines.
      - allow-indentation-change: Initially ignore any whitespace in the move detection, then group the moved code blocks only into a block if the change in whitespace is the same per line.
  --no-color-moved-ws: Do not ignore whitespace when performing move detection. It is the same as --color-moved-ws=no.
  --word-diff[=<mode>]:
    description: Show a word diff, using the <mode> to delimit changed words.
    values:
      - color: Highlight changed words using only colors. Implies --color.
      - plain: Show words as [-removed-] and {+added+}.
      - porcelain: Use a special line-based format intended for script consumption.
      - none: Disable word diff again.
  --word-diff-regex=<regex>: Use <regex> to decide what a word is, instead of considering runs of non-whitespace to be a word.
  --color-words[=<regex>]: Equivalent to --word-diff=color plus (if a regex was specified) --word-diff-regex=<regex>.
  --no-renames: Turn off rename detection, even when the configuration file gives the default to do so.
  --renmae-empty, --no-rename-empty: Whether to use empty blobs as rename source.
  --check: Warn if changes introduce conflict markers or whitespace errors.
  --ws-error-highlight=<kind>:
    description: Highlight whitespace errors in the context, old or new lines of the diff.
    values:
      - new: Highlight whitespace errors in "new" lines.
      - old: Highlight whitespace errors in "old" lines.
      - context: Highlight whitespace errors in "context" lines.
      - none: Resets previous values.
      - default: Highlight whitespace errors in "new" lines.
      - all: Is a shorthand for "old, new, context" lines.
  --full-index: Instead of the first handful of characters, show the full pre- and post-image blob object names on the "index" line when generating patch format output.
  --binary: In addition to --full-index, output a binary diff that can be applied with git-apply. Implies --patch.
  --abbrev[=<n>]: Instead of showing the full 40-byte hexadecimal object name in diff-raw format output and diff-tree header lines, show the shortest prefix that is at least <n> hexdigits long that uniquely refers the object.
  -B[<n>][/<m>], --break-rewrites[=[<n>][/<m>]]: Break complete rewrite changes into pairs of delete and create.
  -M[<n>], --find-renames[=<n>]: Detect renames. If n is specified, it is a threshold on the similarity index.
  -C[<n>], --find-copies[=<n>]: Detect copies as well as renames. If n is specified, it has the same meaning as for -M<n>.
  --find-copies-harder: This flag makes the command inspect unmodified files as candidates for the source of copy.
  -D, --irreversible-delete: Omit the preimage for deletes, i.e. print only the header but not the diff between the preimage and /dev/null.
  -l<num>: This option prevents the exhaustive portion of rename/copy detection from running if the number of source/destination files involved exceeds the specified number.
  --diff-filter=[(A|C|D|M|R|T|U|X|B)…​[*]]:
    description: Select only files by the combination of the filter characters.
    values:
      - A: Added
      - B: Broken
      - C: Copied
      - D: Deleted
      - M: Modified
      - R: Renamed
      - T: Changed
      - U: Unmerged
      - X: Unknown
      - a: Not added
      - b: Not broken
      - c: Not copied
      - d: Not deleted
      - m: Not modified
      - r: Not renamed
      - t: Not changed
      - u: Not unmerged
      - x: Not unknown
      - '*': All-or-none
  -S<string>: Look for differences that change the number of occurrences of the specified string (i.e. addition/deletion) in a file.
  -G<regex>: Look for differences whose patch text contains added/removed lines that match <regex>.
  --find-object=<object-id>: Look for differences that change the number of occurrences of the specified object.
  --pickaxe-all: When -S or -G finds a change, show all the changes in that changeset, not just the files that contain the change in <string>.
  --pickaxe-regex: Treat the <string> given to -S as an extended POSIX regular expression to match.
  -O<orderfile>: Control the order in which files appear in the output.
  --skip-to=<file>, --rotate-to=<file>: Discard the files before the named <file> from the output (i.e. skip to), or move them to the end of the output (i.e. rotate to).
  -R: Swap two inputs; that is, show differences from index or on-disk file to tree contents.
  --relative[=<path>]: When run from a subdirectory of the project, it can be told to exclude changes outside the directory and show pathnames relative to it with this option.
  --no-relative: Countermand both diff.relative config option and previous --relative.
  -a, --text: Treat all files as text.
  --ignore-cr-at-eol: Ignore carriage-return at the end of line when doing a comparison.
  --ignore-space-at-eol: Ignore changes in whitespace at EOL.
  -b, --ignore-space-change: Ignore changes in amount of whitespace. This ignores whitespace at line end, and considers all other sequences of one or more whitespace characters to be equivalent.
  -w, --ignore-all-space: Ignore whitespace when comparing lines. This ignores differences even if one line has whitespace where the other line has none.
  --ignore-blank-lines: Ignore changes whose lines are all blank.
  -I<regex>, --ignore-matching-lines=<regex>: Ignore changes whose all lines match <regex>. This option may be specified more than once.
  --inter-hunk-context=<lines>: Show the context between diff hunks, up to the specified number of lines, thereby fusing hunks that are close to each other.
  -W, --function-context: Show whole function as context lines for each change.
  --exit-code: Make the program exit with codes similar to diff. That is, it exits with 1 if there were differences and 0 means no differences.
  --quiet: Disable all output of the program. Implies --exit-code.
  --ext-diff: Allow an external diff helper to be executed.
  --no-ext-diff: Disallow external diff drivers.
  --textconv, --no-textconv: Allow (or disallow) external text conversion filters to be run when comparing binary files.
  --ignore-submodules[=<when>]:
    description: Ignore changes to submodules in the diff generation.
    values:
      - none: Submodule is not considered modified when it either contains untracked or modified files or its HEAD differs from the commit recorded in the superproject
      - untracked: Submodules are not considered dirty when they only contain untracked content
      - dirty: Ignores all changes to the work tree of submodules, only changes to the commits stored in the superproject are shown
      - all: Hides all changes to submodules
  --src-prefix=<prefix>: Show the given source prefix instead of "a/".
  --dst-prefix=<prefix>: Show the given destination prefix instead of "b/".
  --no-prefix: Do not show any source or destination prefix.
  --line-prefix=<prefix>: Prepend an additional prefix to every line of output.
  --ita-invisible-in-index: This option makes the entry appear as a new file in "git diff" and non-existent in "git diff --cached".