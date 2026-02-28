description:
  create a new user or update default new user information
synopses:
  - useradd [options] LOGIN
  - useradd -D
  - useradd -D [options]
options:
  -b, --base-dir BASE_DIR: The default base directory for the system if -d HOME_DIR is not specified.
  -c, --comment COMMENT: Any text string.
  -d, --home-dir HOME_DIR: The new user will be created using HOME_DIR as the value for the user's login directory.
  -D, --defaults: Display or update the default values for the specified options.
  -e, --expiredate EXPIRE_DATE: The date on which the user account will be disabled.
  -f, --inactive INACTIVE: The number of days after a password expires until the account is permanently disabled.
  -g, --gid GROUP: The group name or number of the user's initial login group.
  -G, --groups GROUP1[,GROUP2,...[,GROUPN]]]: A list of supplementary groups which the user is also a member of.
  -h, --help: Display help message and exit.
  -k, --skel SKEL_DIR: The skeleton directory, which contains files and directories to be copied in the user's home directory, when the home directory is created by useradd.
  -K, --key KEY=VALUE:
    description: Overrides /etc/login.defs defaults (UID_MIN, UID_MAX, UMASK, PASS_MAX_DAYS and others).
    values:
      - UID_MIN={value}
      - UID_MAX={value}
      - UMASK={value}
      - PASS_MAX_DAYS={value}
  -l, --no-log-init: Do not add the user to the lastlog and faillog databases.
  -m, --create-home: Create the user's home directory if it does not exist.
  -M, --no-create-home: Do no create the user's home directory.
  -N, --no-user-group: Do not create a group with the same name as the user, but add the user to the group specified by the -g option or by the GROUP variable in /etc/default/useradd.
  -o, --non-unique: Allow the creation of a user account with a duplicate (non-unique) UID.
  -p, --password PASSWORD: The encrypted password, as returned by crypt(3).
  -r, --system: Create a system account.
  -R, --root CHROOT_DIR: Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
  -s, --shell SHELL: The name of the user's login shell.
  -u, --uid UID: The numerical value of the user's ID.
  -U, --user-group: Create a group with the same name as the user, and add the user to this group.
  -Z, --selinux-user SEUSER: The SELinux user for the user's login.