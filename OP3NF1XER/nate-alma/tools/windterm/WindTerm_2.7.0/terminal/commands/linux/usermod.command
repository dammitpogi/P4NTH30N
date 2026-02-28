description:
  modify a user account
synopses:
  - usermod [options] LOGIN
options:
  -a, --append: Add the user to the supplementary group(s). Use only with the -G option.
  -c, --comment COMMENT: The new value of the user's password file comment field.
  -d, --home HOME_DIR: The user's new login directory.
  -e, --expiredate EXPIRE_DATE: The date on which the user account will be disabled.
  -f, --inactive INACTIVE: The number of days after a password expires until the account is permanently disabled.
  -g, --gid GROUP: The group name or number of the user's new initial login group.
  -G, --groups GROUP1[,GROUP2,...[,GROUPN]]]: A list of supplementary groups which the user is also a member of.
  -l, --login NEW_LOGIN: The name of the user will be changed from LOGIN to NEW_LOGIN.
  -L, --lock: Lock a user's password.
  -m, --move-home: Move the content of the user's home directory to the new location.
  -o, --non-unique: When used with the -u option, this option allows to change the user ID to a non-unique value.
  -p, --password PASSWORD: The encrypted password, as returned by crypt(3).
  -R, --root CHROOT_DIR: Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
  -s, --shell SHELL: The name of the user's new login shell.
  -u, --uid UID: The new numerical value of the user's ID.
  -U, --unlock: Unlock a user's password.
  -v, --add-subuids FIRST-LAST: Add a range of subordinate uids to the user's account.
  -V, --del-subuids FIRST-LAST: Remove a range of subordinate uids from the user's account.
  -w, --add-subgids FIRST-LAST: Add a range of subordinate gids to the user's account.
  -W, --del-subgids FIRST-LAST: Remove a range of subordinate gids from the user's account.
  -Z, --selinux-user SEUSER: The new SELinux user for the user's login.
