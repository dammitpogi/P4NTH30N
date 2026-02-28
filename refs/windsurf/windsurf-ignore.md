> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Windsurf Ignore

> Configure which files and directories Windsurf should ignore during indexing using .codeiumignore files with gitignore-style syntax.

## WindsurfIgnore

By default, Windsurf Indexing will ignore:

* Paths specified in `gitignore`
* Files in `node_modules`
* Hidden pathnames (starting with ".")

When a file is ignored, it will not be indexed, and also does not count against the Indexing Max Workspace Size file counts.
Files included in .gtiignore cannot be edited by Cascade.

If you want to further configure files that Windsurf Indexing ignores, you can add a `.codeiumignore` file to your repo root, with the same syntax as `.gitignore`

<Frame>
  <img src="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=9b6143bd6f701e4f25cf93825ee6fde6" data-og-width="732" width="732" data-og-height="450" height="450" data-path="assets/codeiumignore.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=280&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=3a85edaa177c7a7dbcc9da5008c4f10c 280w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=560&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=bdb51589e57ab2f816527319cfae67c1 560w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=840&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=bcca84dfb2a790c903dc623101a584d6 840w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=1100&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=6e9ca44d9d2a0b499caa90b2feedc74a 1100w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=1650&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=f428e6545758fbd7ff766a673f004ca9 1650w, https://mintcdn.com/codeium/DnGnXhZxl1qb2EWt/assets/codeiumignore.png?w=2500&fit=max&auto=format&n=DnGnXhZxl1qb2EWt&q=85&s=27c03d11be18e5f83fe22b3491fe7cef 2500w" />
</Frame>

### Global .codeiumignore

For enterprise customers managing multiple repositories, you can enforce ignore rules across all repositories by placing a global `.codeiumignore` file in the `~/.codeium/` folder. This global configuration will apply to all Windsurf workspaces on your system.

The global `.codeiumignore` file uses the same syntax as `.gitignore` and works in addition to any repository-specific `.codeiumignore` files.

## System Requirements

When first enabled, Windsurf will consume a fraction of CPU while it indexes the workspace. Depending on your workspace size, this should take 5-10 minutes, and only needs to happen once per workspace. CPU usage will return to normal automatically. Windsurf Indexing also requires RAM (\~300MB for a 5000-file workspace).

The "Max Workspace Size (File Count)" setting determines the largest workspace for which Windsurf Indexing will try to index a particular workspace / module. If your workspace does not appear to be indexed, please try adjusting this number higher. For users with \~10GB of RAM, we recommend setting this no higher than 10,000 files.
