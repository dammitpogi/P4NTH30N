description:
  compress or expand files
synopses:
  - gzip [ -acdfhklLnNrtvV19 ] [--rsyncable] [-S suffix] [ name ... ]
options:
  -a, --ascii: Ascii text mode, convert end-of-lines using local conventions.
  -c, --stdout, --to-stdout: Write output on standard output; keep original files unchanged.
  -d, --decompress, --uncompress: Decompress.
  -f, --force: Force compression or decompression even if the file has multiple links or the corresponding file already exists, or if the compressed data is read from or written to a terminal.
  -h, --help: Display a help screen and quit.
  -k, --keep: Keep (don't delete) input files during compression or decompression.
  -l, --list: Display the compression info
  -L, --license: Display the gzip license and quit.
  -n, --no-name: Do not save or restore the original file name and time stamp by default.
  -N, --name: Always save or restore the original file name and time stamp by default.
  -q, --quiet: Suppress all warnings.
  -r, --recursive: Travel the directory structure recursively.
  --rsyncable: While compressing, synchronize the output occasionally based on the input.
  -S, --suffix suffix: When compressing, use suffix .suf instead of .gz.
  -t, --test: Test. Check the compressed file integrity.
  -v, --verbose: Verbose. Display the name and percentage reduction for each file compressed or decompressed.
  -V, --version: Version. Display the version number and compilation options then quit.
  --best: Use the best speed of compression.
  --fast: Use the fast speed of compression.
  -1, -2, -3, -4, -5, -6, -7, -8, -9: Regulate the speed of compression using the specified digit.