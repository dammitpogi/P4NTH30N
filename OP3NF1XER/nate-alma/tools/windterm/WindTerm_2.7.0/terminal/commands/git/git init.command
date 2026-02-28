description:
  Create an empty Git repository or reinitialize an existing one
synopses:
  - git init [-q | --quiet] [--bare] [--template=<template-directory>]
    [--separate-git-dir <git-dir>] [--object-format=<format>]
    [-b <branch-name> | --initial-branch=<branch-name>]
    [--shared[=<permissions>]] [<directory>]
options:
  -q, --quiet: Only print error and warning messages; all other output will be suppressed.
  --bare: Create a bare repository.
  --object-format=<format>:
    description: Specify the given object format (hash algorithm) for the repository.
    values:
      - sha1
      - sha256
  --template=<template-directory>: Specify the directory from which templates will be used.
  --separate-git-dir=<git-dir>: Instead of initializing the repository as a directory to either $GIT_DIR or ./.git/, create a text file there containing the path to the actual repository. This file acts as filesystem-agnostic Git symbolic link to the repository.
  -b <branch-name>, --initial-branch=<branch-name>: Use the specified name for the initial branch in the newly created repository.
  --shared=permissions:
    description: Specify that the Git repository is to be shared amongst several users.
    values:
      - umask: by umask
      - false: by umask
      - group: group writable
      - true: group writable
      - all: group writable, all readable
      - world: group writable, all readable
      - everybody: group writable, all readable
      - <perm>: by custom umask