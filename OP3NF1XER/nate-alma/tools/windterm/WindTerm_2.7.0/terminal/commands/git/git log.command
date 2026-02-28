description:
  Show commit logs
synopses:
  - git log [<options>] [<revision-range>] [[--] <path>…​]
options:
  --follow: Continue listing the history of a file beyond renames (works only for a single file).
  --no-decorate: Same as --decorate=no.
  --decorate[=short|full|auto|no]:
    description: Print out the ref names of any commits that are shown.
    values:
      - short: The ref name prefixes refs/heads/, refs/tags/ and refs/remotes/ will not be printed.
      - full: The full ref name (including prefix) will be printed.
      - auto: If the output is going to a terminal, the ref names are shown as if short were given, otherwise no ref names are shown.
      - no: The full ref name (including prefix) will not be printed.
  --decorate-refs=<pattern>: For each candidate, do not use it for decoration if it doesn't match any of the patterns given to --decorate-refs.
  --decorate-refs-exclude=<pattern>: For each candidate, do not use it for decoration if it matches any patterns given to --decorate-refs-exclude.
  --source: Print out the ref name given on the command line by which each commit was reached.
  --mailmap, no-mailmap: Use mailmap file to map author and committer names and email addresses to canonical real names and email addresses.
  --use-mailmap, no-use-mailmap: Use mailmap file to map author and committer names and email addresses to canonical real names and email addresses.
  --full-diff: The full diff is shown for commits that touch the specified paths.
  --log-size: Include a line "log size <number>" in the output for each commit, where <number> is the length of that commit's message in bytes.
  -L<start>,<end>:<file>: Trace the evolution of the line range given by <start>,<end>.
  -L:<funcname>:<file>: Trace the evolution of the line range given by the function name regex <funcname>, within the <file>.
  -n <number>, --max-count=<number>: Limit the number of commits to output.
  --skip=<number>: Skip number commits before starting to show the commit output.
  --since=<date>, --after=<date>: Show commits more recent than a specific date.
  --until=<date>, --before=<date>: Show commits older than a specific date.
  --author=<pattern>: Limit the commits output to ones with author header lines that match the specified pattern.
  --committer=<pattern>: Limit the commits output to ones with committer header lines that match the specified pattern.
  --grep-reflog=<pattern>: Limit the commits output to ones with reflog entries that match the specified pattern.
  --grep=<pattern>: Limit the commits output to ones with log message that matches the specified pattern.
  --all-match: Limit the commits output to ones that match all given --grep, instead of ones that match at least one.
  --invert-grep: Limit the commits output to ones with log message that do not match the pattern specified with --grep=<pattern>.
  -i, --regexp-ignore-case: Match the regular expression limiting patterns without regard to letter case.
  --basic-regexp: Consider the limiting patterns to be basic regular expressions; this is the default.
  -E, --extended-regexp: Consider the limiting patterns to be extended regular expressions instead of the default basic regular expressions.
  -F, --fixed-strings: Consider the limiting patterns to be fixed strings.
  -P, --perl-regexp: Consider the limiting patterns to be Perl-compatible regular expressions.
  --remove-empty: Stop when a given path disappears from the tree.
  --merges: Print only merge commits. This is exactly the same as --min-parents=2.
  --no-merges: Do not print commits with more than one parent. This is exactly the same as --max-parents=1.
  --min-parents=<number>: Show only commits which have at least that many parent commits.
  --max-parents=<number>: Show only commits which have at most that many parent commits.
  --no-min-parents, --no-max-parents:  Reset the many parent commit again.
  --first-parent: When finding commits to include, follow only the first parent commit upon seeing a merge commit.
  --exclude-first-parent-only: When finding commits to exclude (with a ^), follow only the first parent commit upon seeing a merge commit.
  --not: Reverses the meaning of the ^ prefix (or lack thereof) for all following revision specifiers, up to the next --not.
  --all: Pretend as if all the refs in refs/, along with HEAD, are listed on the command line as <commit>.
  --branches[=<pattern>]: Pretend as if all the refs in refs/heads are listed on the command line as <commit>. If <pattern> is given, limit branches to ones matching given shell glob.
  --tags[=<pattern>]: Pretend as if all the refs in refs/tags are listed on the command line as <commit>. If <pattern> is given, limit tags to ones matching given shell glob.
  --remotes[=<pattern>]: Pretend as if all the refs in refs/remotes are listed on the command line as <commit>. If <pattern> is given, limit remote-tracking branches to ones matching given shell glob.
  --glob=<glob-pattern>: Pretend as if all the refs matching shell glob <glob-pattern> are listed on the command line as <commit>. Leading refs/, is automatically prepended if missing.
  --exclude=<glob-pattern>: Do not include refs matching <glob-pattern> that the next --all, --branches, --tags, --remotes, or --glob would otherwise consider.
  --reflog: Pretend as if all objects mentioned by reflogs are listed on the command line as <commit>.
  --alternate-refs: Pretend as if all objects mentioned as ref tips of alternate repositories were listed on the command line.
  --single-worktree: Forces them to examine the current working tree only.
  --ignore-missing: Upon seeing an invalid object name in the input, pretend as if the bad input was not given.
  --bisect: Pretend as if the bad bisection ref refs/bisect/bad was listed and as if it was followed by --not and the good bisection refs refs/bisect/good-* on the command line.
  --stdin: In addition to the <commit> listed on the command line, read them from the standard input. If a -- separator is seen, stop reading commits and start reading paths to limit the result.
  --cherry-mark: Like --cherry-pick (see below) but mark equivalent commits with = rather than omitting them, and inequivalent ones with +.
  --cherry-pick: Omit any commit that introduces the same change as another commit on the "other side" when the set of commits are limited with symmetric difference.
  --left-only, --right-only: List only commits on the respective side of a symmetric difference
  --cherry: A synonym for --right-only --cherry-mark --no-merges.
  -g, --walk-reflogs: Instead of walking the commit ancestry chain, walk reflog entries from the most recent one to older ones.
  --merge: After a failed merge, show refs that touch files having a conflict and don't exist on all heads to merge.
  --boundary: Output excluded boundary commits. Boundary commits are prefixed with -.
  --simplify-by-decoration: Commits that are referred by some branch or tag are selected.
  --show-pulls: Include all commits from the default mode, but also any merge commits that are not TREESAME to the first parent but are TREESAME to a later parent.
  --full-history: Same as the default mode, but does not prune some history.
  --dense: Only the selected commits are shown, plus some to have a meaningful history.
  --sparse: All commits in the simplified history are shown.
  --simplify-merges: Additional option to --full-history to remove some needless merges from the resulting history, as there are no selected commits contributing to this merge.
  --ancestry-path: When given a range of commits to display (e.g. commit1..commit2 or commit2 ^commit1), only display commits that exist directly on the ancestry chain between the commit1 and commit2.
  --dense: Commits that are walked are included if they are not TREESAME to any parent.
  --sparse: All commits that are walked are included.
  --simplify-merges: First, build a history graph in the same way that --full-history with parent rewriting does. Then simplify each commit C to its replacement C' in the final history.
  --ancestry-path: Limit the displayed commits to those directly on the ancestry chain between the "from" and "to" commits in the given commit range.
  --show-pulls: In addition to the commits shown in the default history, show each merge commit that is not TREESAME to its first parent but is TREESAME to a later parent.
  --date-order: Show no parents before all of its children are shown, but otherwise show commits in the commit timestamp order.
  --author-date-order: Show no parents before all of its children are shown, but otherwise show commits in the author timestamp order.
  --topo-order: Show no parents before all of its children are shown, and avoid showing commits on multiple lines of history intermixed.
  --reverse: Output the commits chosen to be shown in reverse order. Cannot be combined with --walk-reflogs.
  --no-walk[=(sorted|unsorted)]:
    description: Only show the given commits, but do not traverse their ancestors.
    values:
      - sorted
      - unsorted
  --do-walk: Overrides a previous --no-walk.
  --pretty[=<format>], --format=<format>:
    description: Pretty-print the contents of the commit logs in a given format.
    values:
      - oneline
      - short
      - medium
      - full
      - fuller
      - reference
      - email
      - raw
      - format:<string>
      - tformat:<string>
  --abbrev-commit: Instead of showing the full 40-byte hexadecimal commit object name, show a prefix that names the object uniquely.
  --no-abbrev-commit: Show the full 40-byte hexadecimal commit object name.
  --oneline: This is a shorthand for "--pretty=oneline --abbrev-commit" used together.
  --encoding=<encoding>: Re-code the commit log message in the encoding preferred by the user.
  --expand-tabs=<n>: Perform a tab expansion (replace each tab with enough spaces to fill to the next display column that is multiple of <n>) in the log message before showing it in the output.
  --expand-tabs: A short-hand for --expand-tabs=8
  --no-expand-tabs: A short-hand for --expand-tabs=0.
  --notes[=<ref>]: Show the notes that annotate the commit, when showing the commit log message.
  --no-notes: Do not show notes.
  --show-notes[=<ref>]: Deprecated. Use --notes options instead.
  --standard-notes, --no-standard-notes: Deprecated. Use --notes/--no-notes options instead.
  --show-signature: Check the validity of a signed commit object by passing the signature to gpg --verify and show the output.
  --relative-date: Synonym for --date=relative.
  --date=<format>:
    description: Only takes effect for dates shown in human-readable format, such as when using --pretty.
    values:
      - default: The default format, and is similar to --date=rfc2822.
      - relative: Shows dates relative to the current time.
      - local: An alias for --date=default-local.
      - iso: Shows timestamps in a ISO 8601-like format.
      - iso8601: Shows timestamps in a ISO 8601-like format.
      - iso-strict: Shows timestamps in strict ISO 8601 format.
      - iso8601-strict: Shows timestamps in strict ISO 8601 format.
      - rfc: Shows timestamps in RFC 2822 format.
      - rfc2822: Shows timestamps in RFC 2822 format.
      - short: Shows only the date, but not the time, in YYYY-MM-DD format.
      - raw: Shows the date as seconds since the epoch (1970-01-01 00:00:00 UTC).
      - human: Shows the timezone if the timezone does not match the current time-zone.
      - unix: Shows the date as a Unix epoch timestamp (seconds since 1970).
      - format:...: Feeds the format ... to the system strftime.
  --parents: Print also the parents of the commit.
  --children: Print also the children of the commit.
  --left-right: Mark which side of a symmetric difference a commit is reachable from.
  --graph: Draw a text-based graphical representation of the commit history on the left hand side of the output.
  --show-linear-break[=<barrier>]: When --graph is not used, all history branches are flattened which can make it hard to see that the two consecutive commits do not belong to a linear branch. This option puts a barrier in between them in that case. If <barrier> is specified, it is the string that will be shown instead of the default one.
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
  --no-diff-merges: Specify diff format to be used for merge commits.
  --combined-all-paths: This flag causes combined diffs to list the name of the file from all parents.
  -U<n>, --unified=<n>: Generate diffs with <n> lines of context instead of the usual three. Implies --patch.
  --output=<file>: Output to a specific file instead of stdout.
  --output-indicator-new=<char>: Specify the character used to indicate new lines in the generated patch.
  --output-indicator-old=<char>: Specify the character used to indicate old lines in the generated patch.
  --output-indicator-context=<char>: Specify the character used to indicate context lines in the generated patch.
  --raw: Generate the diff in raw format.
  --patch-with-raw: Synonym for -p --raw.
  -t: Show the tree objects in the diff output.
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
  -z: Separate the commits with NULs instead of with new newlines.
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