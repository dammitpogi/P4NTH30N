description:
  print or set the system date and time
synopses:
  - date [OPTION]... [+FORMAT]
  - date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
options:
  -d, --date=STRING: display time described by STRING, not 'now'
  --debug: annotate the parsed date, and warn about questionable usage to stderr
  -f, --file=DATEFILE: like --date; once for each line of DATEFILE
  -I, --iso-8601[=FMT]:
    description: output date/time in ISO 8601 format
    values:
      - "'date'"
      - "'hours'"
      - "'minutes'"
      - "'seconds'"
      - "'ns'"
  -R, --rfc-email: 'output date and time in RFC 5322 format. Example: Mon, 14 Aug 2006 02:34:56 -0600'
  --rfc-3339=FMT:
    description: output date/time in RFC 3339 format.
    values:
      - date
      - seconds
      - ns
  -r, --reference=FILE: display the last modification time of FILE
  -s, --set=STRING: set time described by STRING
  -u, --utc, --universal: print or set Coordinated Universal Time (UTC)
  --help: display this help and exit
  --version: output version information and exit