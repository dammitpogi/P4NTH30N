description:
  create a new group
synopses:
  - groupadd [options] group
options:
  -f, --force: This option causes the command to simply exit with success status if the specified group already exists.
  -g, --gid GID: The numerical value of the group's ID.
  -h, --help: Display help message and exit.
  -K, --key KEY=VALUE:
    description: Overrides /etc/login.defs defaults (GID_MIN, GID_MAX and others). Multiple -K options can be specified.
    values:
      - GID_MIN={value}
      - GID_MAX={value}
  -o, --non-unique: This option permits to add a group with a non-unique GID.
  -p, --password PASSWORD: The encrypted password, as returned by crypt(3). The default is to disable the password.
  -r, --system: Create a system group.
  -R, --root CHROOT_DIR: Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.