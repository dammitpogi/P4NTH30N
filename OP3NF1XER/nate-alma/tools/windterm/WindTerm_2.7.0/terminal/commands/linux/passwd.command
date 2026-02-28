description:
  change user password
synopses:
  - passwd [options] [LOGIN]
options:
  -a, --all: This option can be used only with -S and causes show status for all users.
  -d, --delete: Delete a user's password (make it empty).
  -e, --expire: Immediately expire an account's password.
  -h, --help: Display help message and exit.
  -i, --inactive INACTIVE: This option is used to disable an account after the password has been expired for a number of days.
  -k, --keep-tokens: Indicate password change should be performed only for expired authentication tokens (passwords).
  -l, --lock: Lock the password of the named account.nge their password.
  -n, --mindays MIN_DAYS: Set the minimum number of days between password changes to MIN_DAYS.
  -q, --quiet: Quiet mode.
  -r, --repository REPOSITORY: change password in REPOSITORY repository
  -R, --root CHROOT_DIR: Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
  -S, --status: Display account status information.
  -u, --unlock: Unlock the password of the named account.
  -w, --warndays WARN_DAYS: Set the number of days of warning before a password change is required.
  -x, --maxdays MAX_DAYS: Set the maximum number of days a password remains valid.