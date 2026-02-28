description:
  maintain crontab files for individual users
synopses:
  - crontab [ -u user ] file
  - crontab [ -u user ] [ -i ] { -e | -l | -r }
options:
  -i: prompt the user for a 'y/Y' response
  -e: edit the current crontab
  -l: display the current crontab on standard output
  -r: remove the current crontab
  -u: specifies the name of the user whose crontab is to be used