description:
  execute a command as another user
synopses:
  - sudoedit [-AknS] [-a type] [-C num] [-c class] [-g group] [-h host] [-p prompt] [-T timeout] [-u user] file ...
options:
  -A, --askpass: Invoke a helper program to read the user's password and output the password to the standard output.
  -b, --background: Run the given command in the background.
  -C, --close-from=num: Close all file descriptors greater than or equal to num before executing a command.
  -E, --preserve-env: Indicates to the security policy that the user wishes to preserve their existing environment variables.
  --preserve-env=list: Indicates to the security policy that the user wishes to add the comma-separated list of environment variables to those preserved from the user's environment.
  -e, --edit: Edit one or more files instead of running a command.l remain in a temporary file.
  -g, --group=group: Run the command with the primary group set to group instead of the primary group specified by the target user's password database entry.
  -H, --set-home: Request that the security policy set the HOME environment variable to the home directory specified by the target user's password database entry.
  -h, --help: Display a short help message to the standard output and exit.
  -h, --host=host: Run the command on the specified host if the security policy plugin supports remote commands.
  -i, --login: Run the shell specified by the target user's password database entry as a login shell.
  -K, --remove-timestamp: Similar to the -k option, except that it removes the user's cached credentials entirely and may not be used in conjunction with a command or other option.
  -k, --reset-timestamp: When used without a command, invalidates the user's cached credentials.
  -l, --list: If no command is specified, list the allowed (and forbidden) commands for the invoking user (or the user specified by the -U option) on the current host. If a command is specified and is permitted by the security policy, the fully-qualified path to the command is displayed along with any command line arguments.
  -n, --non-interactive: Avoid prompting the user for input of any kind.
  -P, --preserve-groups: Preserve the invoking user's group vector unaltered.
  -p, --prompt=prompt: Use a custom password prompt with optional escape sequences.
  -r, --role=role: Run the command with an SELinux security context that includes the specified role.
  -S, --stdin: Write the prompt to the standard error and read the password from the standard input instead of using the terminal device.
  -s, --shell: Run the shell specified by the SHELL environment variable if it is set or the shell specified by the invoking user's password database entry.
  -t, --type=type: Run the command with an SELinux security context that includes the specified type.
  -U, --other-user=user: Used in conjunction with the -l option to list the privileges for user instead of for the invoking user.
  -T, --command-timeout=timeout: Used to set a timeout for the command.
  -u, --user=user: Run the command as a user other than the default target user (usually root).
  -V, --version: Print the sudo version string as well as the version string of the security policy plugin and any I/O plugins.
  -v, --validate: Update the user's cached credentials, authenticating the user if necessary.