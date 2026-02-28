description:
  delete a user account and related files
synopses:
  - userdel [options] LOGIN
options:
  -f, --force: This option forces the removal of the user account, even if the user is still logged in.
  -h, --help: Display help message and exit.
  -r, --remove: Files in the user's home directory will be removed along with the home directory itself and the user's mail spool.
  -R, --root CHROOT_DIR: Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
  -Z, --selinux-user: Remove any SELinux user mapping for the user's login.