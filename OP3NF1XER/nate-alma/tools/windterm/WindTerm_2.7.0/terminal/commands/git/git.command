description:
  the stupid content tracker
synopses:
  - git [--version] [--help] [-C <path>] [-c <name>=<value>]
    [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
    [-p | --paginate | -P | --no-pager] [--no-replace-objects] [--bare]
    [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
    <command> [<args>]
options:
  --version: Prints the Git suite version that the git program came from.
  --help: Prints the synopsis and a list of the most commonly used commands.
  -C <path>: Run as if git was started in <path> instead of the current working directory.
  -c <<name>=<value>>: Pass a configuration parameter to the command.nd sets foo.bar to the boolean true value (just like [foo]bar would in a config file). Including the equals but with an empty value (like git -c foo.bar= ...) sets foo.bar to the empty string which git config --type=bool will convert to false.
  --config-env=<<name>=<envvar>>: Like -c <name>=<value>, give configuration variable <name> a value, where <envvar> is the name of an environment variable from which to retrieve the value.
  --exec-path[=<path>]: Path to wherever your core Git programs are installed.
  --html-path: Print the path, without trailing slash, where Git's HTML documentation is installed and exit.
  --man-path: Print the manpath (see man(1)) for the man pages for this version of Git and exit.
  --info-path: Print the path where the Info files documenting this version of Git are installed and exit.
  -p, --paginate: Pipe all output into less (or if set, $PAGER) if standard output is a terminal.
  -P, --no-pager: Do not pipe Git output into a pager.
  --git-dir=<path>: Set the path to the repository (".git" directory).
  --work-tree=<path>: Set the path to the working tree. It can be an absolute path or a path relative to the current working directory.
  --namespace=<path>: Set the Git namespace.
  --super-prefix=<path>: Currently for internal use only. Set a prefix which gives a path from above a repository down to its root.
  --bare: Treat the repository as a bare repository.
  --no-replace-objects: Do not use replacement refs to replace Git objects.
  --literal-pathspecs: Treat pathspecs literally (i.e. no globbing, no pathspec magic).
  --glob-pathspecs: Add "glob" magic to all pathspec.
  --noglob-pathspecs: Add "literal" magic to all pathspec.
  --icase-pathspecs: Add "icase" magic to all pathspec.
  --no-optional-locks: Do not perform optional operations that require locks.
  --list-cmds=group[,group…​]: List commands by group.