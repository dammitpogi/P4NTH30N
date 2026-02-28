description:
  Create an archive of files from a named tree
synopses:
  - git archive [--format=<fmt>] [--list] [--prefix=<prefix>/] [<extra>]
    [-o <file> | --output=<file>] [--worktree-attributes]
    [--remote=<repo> [--exec=<git-upload-archive>]] <tree-ish>
    [<path>…​]
options:
  --format=<fmt>:
    description: Format of the resulting archive.
    values:
      - tar
      - zip
  -l, --list: Show all available formats.
  -v, --verbose: Report progress to stderr.
  --prefix=<prefix>/: Prepend <prefix>/ to each filename in the archive.
  -o <file>, --output=<file>: Write the archive to <file> instead of stdout.
  --add-file=<file>: Add a non-tracked file to the archive.
  --worktree-attributes: Look for attributes in .gitattributes files in the working tree as well.
  --remote=<repo>: Instead of making a tar archive from the local repository, retrieve a tar archive from a remote repository.
  --exec=<git-upload-archive>: Used with --remote to specify the path to the git-upload-archive on the remote side.