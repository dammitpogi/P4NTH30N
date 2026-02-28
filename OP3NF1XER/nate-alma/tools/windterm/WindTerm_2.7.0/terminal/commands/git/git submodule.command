description:
  Initialize, update or inspect submodules
synopses:
  - git submodule [--quiet] [--cached]
  - git submodule [--quiet] add [<options>] [--] <repository> [<path>]
  - git submodule [--quiet] status [--cached] [--recursive] [--] [<path>…​]
  - git submodule [--quiet] init [--] [<path>…​]
  - git submodule [--quiet] deinit [-f|--force] (--all|[--] <path>…​)
  - git submodule [--quiet] update [<options>] [--] [<path>…​]
  - git submodule [--quiet] set-branch [<options>] [--] <path>
  - git submodule [--quiet] set-url [--] <path> <newurl>
  - git submodule [--quiet] summary [<options>] [--] [<path>…​]
  - git submodule [--quiet] foreach [--recursive] <command>
  - git submodule [--quiet] sync [--recursive] [--] [<path>…​]
  - git submodule [--quiet] absorbgitdirs [--] [<path>…​]
options:
  -q, --quiet: Only print error messages.
  --progress: Progress status is reported on the standard error stream by default when it is attached to a terminal, unless -q is specified.
  --all: This option is only valid for the deinit command. Unregister all submodules in the working tree.
  -b <branch>, --branch <branch>: Branch of repository to add as submodule.
  -f, --force: This option is only valid for add, deinit and update commands.
  --cached: This option is only valid for status and summary commands. These commands typically use the commit found in the submodule HEAD, but with this option, the commit stored in the index is used instead.
  --files: This option is only valid for the summary command. This command compares the commit in the index with that in the submodule HEAD when this option is used.
  -n, --summary-limit: This option is only valid for the summary command.
  --remote: This option is only valid for the update command. Instead of using the superproject's recorded SHA-1 to update the submodule, use the status of the submodule's remote-tracking branch.
  -N, --no-fetch: This option is only valid for the update command. Don't fetch new objects from the remote site.
  --checkout: This option is only valid for the update command. Checkout the commit recorded in the superproject on a detached HEAD in the submodule.
  --merge: This option is only valid for the update command. Merge the commit recorded in the superproject into the current branch of the submodule.
  --rebase: This option is only valid for the update command. Rebase the current branch onto the commit recorded in the superproject.
  --init: This option is only valid for the update command. Initialize all submodules for which "git submodule init" has not been called so far before updating.
  --name: This option is only valid for the add command. It sets the submodule's name to the given string instead of defaulting to its path.
  --reference <repository>: This option is only valid for add and update commands. These commands sometimes need to clone a remote repository. In this case, this option will be passed to the git-clone command
  --dissociate: This option is only valid for add and update commands. These commands sometimes need to clone a remote repository. In this case, this option will be passed to the git-clone command.
  --recursive: This option is only valid for foreach, update, status and sync commands. Traverse submodules recursively.
  --depth: This option is valid for add and update commands. Create a shallow clone with a history truncated to the specified number of revisions.
  --recommend-shallow: This option is only valid for the update command. The initial clone of a submodule will use the recommended submodule.<name>.shallow as provided by the .gitmodules file by default.
  --no-recommend-shallow: To ignore the --recommend-shallow.
  -j <n>, --jobs <n>: This option is only valid for the update command. Clone new submodules in parallel with as many jobs.
  --single-branch, --no-single-branch: 'This option is only valid for the update command. Clone only one branch during update: HEAD or one specified by --branch.'