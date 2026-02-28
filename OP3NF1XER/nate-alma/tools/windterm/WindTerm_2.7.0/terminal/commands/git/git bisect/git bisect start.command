description:
  Start a bisect session
synopses:
  - git bisect start [--term-new=<term> --term-old=<term>] [--term-bad=<term> --term-good=<term>]
    [--no-checkout] [--first-parent] [<bad> [<good>...]] [--] [<paths>
options:
  --no-checkout: Do not checkout the new working tree at each iteration of the bisection process.
  --first-parent: Follow only the first parent commit upon seeing a merge commit.