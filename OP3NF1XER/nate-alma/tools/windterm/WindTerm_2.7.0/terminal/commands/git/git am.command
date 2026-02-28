description:
  Apply a series of patches from a mailbox
synopses:
  - git am [--signoff] [--keep] [--keep-cr | --no-keep-cr] [--utf8 | --no-utf8]
    [--3way | --no-3way] [--interactive] [--committer-date-is-author-date]
    [--ignore-date] [--ignore-space-change | --ignore-whitespace]
    [--whitespace=<option>] [-C <n>] [-p <n>] [--directory=<dir>]
    [--exclude=<path>] [--include=<path>] [--reject] [-q | --quiet]
    [--scissors | --no-scissors] [-S [<keyid>]] [--patch-format=<format>]
    [--quoted-cr=<action>]
    [--empty=(stop|drop|keep)]
    [(<mbox> | <Maildir>)…​]
  - git am (--continue | --skip | --abort | --quit | --show-current-patch[=(diff|raw)] | --allow-empty)
options:
  -s, --signoff: Add a Signed-off-by trailer to the commit message, using the committer identity of yourself.
  -k, --keep: Pass -k flag to git mailinfo.
  --keep-non-patch: Pass -b flag to git mailinfo.
  --keep-cr: Call git mailsplit with the same option, to prevent it from stripping CR at the end of lines.
  --no-keep-cr: Override am.keepcr.
  -c, --scissors: Remove everything in body before a scissors line.
  --no-scissors: Ignore scissors lines.
  --quoted-cr=<action>: This flag will be passed down to git mailinfo.
  --empty=(stop|drop|keep):
    description: By default, or when the option is set to stop, the command errors out on an input e-mail message lacking a patch and stops into the middle of the current am session. When this option is set to drop, skip such an e-mail message instead. When this option is set to keep, create an empty commit, recording the contents of the e-mail message as its log.
    values:
      - stop
      - drop
      - keep
  -m, --message-id: Pass the -m flag to git mailinfo, so that the Message-ID header is added to the commit message.
  --no-message-id: Do not add the Message-ID header to the commit message.
  -q, --quiet: Be quiet. Only print error messages.
  -u, --utf8: Pass -u flag to git mailinfo. The proposed commit log message taken from the e-mail is re-coded into UTF-8 encoding.
  --no-utf8: Pass -n flag to git mailinfo.
  -3, --3way, --no-3way: When the patch does not apply cleanly, fall back on 3-way merge if the patch records the identity of blobs it is supposed to apply to and we have those blobs available locally.
  --rerere-autoupdate: Allow the rerere mechanism to update the index with the result of auto-conflict resolution if possible.
  --no-rerere-autoupdate: Allow the rerere mechanism to update the index with the result of auto-conflict resolution if possible.
  --ignore-space-change: Pass this flag to the git apply program that applies the patch.
  --ignore-whitespace: Pass this flag to the git apply program that applies the patch.
  --whitespace=<option>: Pass this flag to the git apply program that applies the patch.
  -C<n>: Pass this flag to the git apply program that applies the patch.
  -p<n>: Pass this flag to the git apply program that applies the patch.
  --directory=<dir>: Pass this flag to the git apply program that applies the patch.
  --exclude=<path>: Pass this flag to the git apply program that applies the patch.
  --include=<path>: Pass this flag to the git apply program that applies the patch.
  --reject: Pass this flag to the git apply program that applies the patch.
  --patch-format=<format>:
    description: Allows the user to bypass the automatic detection and specify the patch format that the patch(es) should be interpreted as.
    values:
     - mbox
     - mboxrd
     - stgit
     - stgit-series
     - hg
  -i, --interactive: Run interactively.
  --committer-date-is-author-date: Allows the user to lie about the committer date by using the same value as the author date.
  --ignore-date: Allows the user to lie about the author date by using the same value as the committer date.
  --skip: Skip the current patch. This is only meaningful when restarting an aborted patch.
  -S[<keyid>], --gpg-sign[=<keyid>]: GPG-sign commits.
  --no-gpg-sign: Countermand both commit.gpgSign configuration variable, and earlier --gpg-sign.
  -r, --continue, --resolved: Make a commit using the authorship and commit log extracted from the e-mail message and the current index file, and continue.
  --resolvemsg=<msg>: When a patch failure occurs, <msg> will be printed to the screen before exiting.
  --abort: Restore the original branch and abort the patching operation.
  --quit: Abort the patching operation but keep HEAD and the index untouched.
  --show-current-patch[=(diff|raw)]:
    description: Show the message at which git am has stopped due to conflicts.
    values:
      - diff: diff portion only
      - raw: raw contents
  --allow-empty: After a patch failure on an input e-mail message lacking a patch, create an empty commit with the contents of the e-mail message as its log message.