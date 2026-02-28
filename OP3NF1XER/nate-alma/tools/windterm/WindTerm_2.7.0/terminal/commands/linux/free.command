description:
  Display amount of free and used memory in the system
synopses:
  - free [options]
options:
  -b, --bytes: Display the amount of memory in bytes.
  -k, --kibi: Display the amount of memory in kibibytes. This is the default.
  -m, --mebi: Display the amount of memory in mebibytes.
  -g, --gibi: Display the amount of memory in gibibytes.
  --tebi: Display the amount of memory in tebibytes.
  --pebi: Display the amount of memory in pebibytes.
  --kilo: Display the amount of memory in kilobytes. Implies --si.
  --mega: Display the amount of memory in megabytes. Implies --si.
  --giga: Display the amount of memory in gigabytes. Implies --si.
  --tera: Display the amount of memory in terabytes. Implies --si.
  --peta: Display the amount of memory in petabytes. Implies --si.
  -h, --human unit:
    description: Show all output fields automatically	scaled to shortest three digit unit and display the units of print out.
    values:
      - B: bytes
      - K: kibibyte
      - M: mebibyte
      - G: gibibyte
      - T: tebibyte
      - P: pebibyte
  -w, --wide: Switch to the wide mode.
  -c, --count count: Display the result count times. Requires the -s option.
  -l, --lohi: Show detailed low and high memory statistics.
  -s, --seconds delay: Continuously display the result delay seconds apart.
  --si: Use kilo, mega, giga etc (power of 1000) instead of kibi, mebi, gibi (power of 1024).
  -t, --total: Display a line showing the column totals.
  --help: Print help.
  -V, --version: Display version information.