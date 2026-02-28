description:
  find files by name
synopses:
  - locate [OPTION]... PATTERN...
options:
  -A, --all: Print only entries that match all PATTERNs instead of requiring only one of them to match.
  -b, --basename: Match only the base name against the specified patterns.	This is the opposite of --wholename.
  -c, --count: Instead of writing file names on standard output, write the number of matching entries only.
  -d, --database DBPATH: Replace the default database with DBPATH. DBPATH is a :-separated list of database file names.
  -e, --existing: Print only entries that refer to files existing at the time locate is run.
  -L, --follow: When checking whether files exist (if the --existing option is specified), follow trailing symbolic links.
  -h, --help: Write a summary of the available options to standard output and exit successfully.
  -i, --ignore-case: Ignore case distinctions when matching patterns.
  -p, --ignore-spaces: Ignore punctuation and spaces when matching patterns.
  -t, --transliterate: Ignore accents using iconv transliteration when matching patterns.
  -l, --limit, -n LIMIT: Exit successfully after finding LIMIT entries.
  -m, --mmap: Ignored, for compatibility with BSD and GNU locate.
  -P, --nofollow, -H: When checking whether files exist (if the --existing option is specified), do not follow trailing symbolic links.
  -0, --null: Separate	the entries on output using the ASCII NUL character instead of writing each entry on a separate line.
  -S, --statistics: Write statistics about each read database to standard output instead of searching for files and exit successfully.
  -q, --quiet: Write no messages about errors encountered while reading and processing databases.
  -r, --regexp REGEXP: Search for a basic regexp REGEXP.
  --regex: Interpret all PATTERNs as extended regexps.
  -s, --stdio: Ignored, for compatibility with BSD and GNU locate.
  -V, --version: Write information about the version and license of locate on standard output and exit successfully.
  -w, --wholename: Match only the whole path name against the specified patterns.