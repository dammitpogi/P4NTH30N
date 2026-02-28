description:
  Update remote refs along with associated objects
synopses:
  - git push [--all | --mirror | --tags] [--follow-tags] [--atomic] [-n | --dry-run] [--receive-pack=<git-receive-pack>]
    [--repo=<repository>] [-f | --force] [-d | --delete] [--prune] [-v | --verbose]
    [-u | --set-upstream] [-o <string> | --push-option=<string>]
    [--signed | --no-signed |--signed=(true|false|if-asked)]
    [--force-with-lease[=<refname>[:<expect>]] [--force-if-includes]]
    [--no-verify] [<repository> [<refspec>…​]]
options:
  --all: Push all branches.
  --prune: Remove remote branches that don't have a local counterpart.
  --mirror: Instead of naming each ref to push, specifies that all refs under refs/ be mirrored to the remote repository.
  -n, --dry-run: Do everything except actually send the updates.
  --porcelain: Produce machine-readable output.
  -d, --delete: All listed refs are deleted from the remote repository.
  --tags: All refs under refs/tags are pushed, in addition to refspecs explicitly listed on the command line.
  --follow-tags: Push annotated tags in refs/tags that are missing from the remote.
  --signed, --no-signed: Signing will be attempted.
  --signed=(true|false|if-asked):
    description: GPG-sign the push request to update refs on the receiving side, to allow it to be checked by the hooks and/or be logged.
    values:
      - true
      - false
      - if-asked
  --atomic, --no-atomic: Use an atomic transaction on the remote side if available.
  -o <option>, --push-option=<option>: Transmit the given string to the server, which passes them to the pre-receive as well as the post-receive hook.
  --receive-pack=<git-receive-pack>, --exec=<git-receive-pack>: Path to the git-receive-pack program on the remote end.
  --no-force-with-release: Cancel all the previous --force-with-lease on the command line.
  --force-with-lease: Forces 'push' to update a remote ref that is not an ancestor of the local ref used to overwrite it.
  --force-with-lease=<refname>[:<expect>]: Forces 'push' to update a remote ref that is not an ancestor of the local ref used to overwrite it.
  -f, --force: Forces 'push' to update a remote ref anyway.
  --force-if-includes, --no-force-if-includes: Forces an update only if the tip of the remote-tracking ref has been integrated locally.
  --repo=<repository>: This option is equivalent to the <repository> argument.
  -u, --set-upstream: For every branch that is up to date or successfully pushed, add upstream (tracking) reference.
  --thin, --no-thin: A thin transfer significantly reduces the amount of sent data when the sender and receiver share many of the same objects in common.
  -q, --quiet: Suppress all output, including the listing of updated refs, unless an error occurs.
  -v, --verbose: Run verbosely.
  --progress: Forces progress status even if the standard error stream is not directed to a terminal.
  --no-recurse-submodules: Override the push.recurseSubmodules configuration variable when no submodule recursion is required.
  --recurse-submodules=check|on-demand|only|no:
    description: May be used to make sure all submodule commits used by the revisions to be pushed are available on a remote-tracking branch.
    values:
      - check
      - no-demand
      - only
      - no
  --verify: Give the pre-push hook a chance to prevent the push.
  --no-verify: Bypass the pre-push hook completely.
  -4, --ipv4: Use IPv4 addresses only, ignoring IPv6 addresses.
  -6, --ipv6: Use IPv6 addresses only, ignoring IPv4 addresses.