description:
  file perusal filter for crt viewing
synopses:
  - more [options] file...
options:
  -d: Prompt with "[Press  space to continue, 'q' to quit.]", and display "[Press 'h' for instructions.]" instead of ringing the bell when an illegal key is pressed.
  -l: Do not pause after any line containing a ^L (form feed).
  -f: Count logical lines, rather than screen lines (i.e., long lines are not folded).
  -p: Do not scroll. Instead, clear the whole screen and then display the text.
  -c: Do not scroll. Instead, paint each screen from the top, clearing the remainder of each line as it is displayed.
  -s: Squeeze multiple blank lines into one.
  -u: Suppress underlining.
  --help: Display help text and exit.
  -V, --version: Display version information and exit.