description:
  Use binary search to find the commit that introduced a bug
synopses:
  - git bisect <subcommand> <options>
options:
  --no-checkout: Do not checkout the new working tree at each iteration of the bisection process.
  --first-parent: Follow only the first parent commit upon seeing a merge commit.