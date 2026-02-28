description:
  Create, list, delete or verify a tag object signed with GPG
synopses:
  - git tag [-a | -s | -u <keyid>] [-f] [-m <msg> | -F <file>] [-e]
    <tagname> [<commit> | <object>]
  - git tag -d <tagname>…​
  - git tag [-n[<num>]] -l [--contains <commit>] [--no-contains <commit>]
    [--points-at <object>] [--column[=<options>] | --no-column]
    [--create-reflog] [--sort=<key>] [--format=<format>]
    [--merged <commit>] [--no-merged <commit>] [<pattern>…​]
  - git tag -v [--format=<format>] <tagname>…​
options:
  -a, --annotate: Make an unsigned, annotated tag object
  -s, --sign: Make a GPG-signed tag, using the default e-mail address's key.
  --no-sign: Override tag.gpgSign configuration variable that is set to force each and every tag to be signed.
  -u <keyid>, --local-user=<keyid>: Make a GPG-signed tag, using the given key.
  -f, --force: Replace an existing tag with the given name (instead of failing)
  -d, --delete: Delete existing tags with the given names.
  -v, --verify: Verify the GPG signature of the given tag names.
  -n<num>: <num> specifies how many lines from the annotation, if any, are printed when using -l. Implies --list.
  -l [<pattern>...], --list [<pattern>...]: List tags. With optional <pattern>..., list only the tags that match the pattern(s).
  --sort=<key>: Sort based on the key given. Prefix - to sort in descending order of the value.
  --color[=<when>]:
    description: Respect any colors specified in the --format option.
    values:
      - always
      - auto
      - never
  -i, --ignore-case: Sorting and filtering tags are case insensitive.
  --column[=<options>]:
    description: Display tag listing in columns.
    values:
      - always: always show in columns
      - auto: show in columns if the output is to the terminal
      - never: never show in columns
      - column: fill columns before rows
      - row: fill rows before columns
      - plain: show in one column
      - dense: make unequal size columns to utilize more space
      - nodense: make equal size columns
  --no-column: Hide tag listing in columns.
  --contains [<commit>]: Only list tags which contain the specified commit (HEAD if not specified). Implies --list.
  --no-contains [<commit>]: Only list tags which don't contain the specified commit (HEAD if not specified). Implies --list.
  --merged [<commit>]: Only list tags whose commits are reachable from the specified commit (HEAD if not specified).
  --no-merged [<commit>]: Only list tags whose commits are not reachable from the specified commit (HEAD if not specified).
  --points-at <object>: Only list tags of the given object (HEAD if not specified). Implies --list.
  -m <msg>, --message=<msg>: Use the given tag message (instead of prompting).
  -F <file>, --file=<file>: Take the tag message from the given file. Use - to read the message from the standard input.
  -e, --edit: The message taken from file with -F and command line with -m are usually used as the tag message unmodified.
  --cleanup=<mode>:
    description: This option sets how the tag message is cleaned up.
    values:
      - verbatim: does not change message
      - whitespace: removes leading/trailing whitespace lines
      - strip: removes both whitespace and commentary
  --create-reflog: Create a reflog for the tag.
  --format=<format>: A string that interpolates %(fieldname) from a tag ref being shown and the object it points at.