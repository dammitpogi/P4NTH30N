description:
  Copies file data from one location to another.
synopses:
  - robocopy <source> <destination> [<file>[ ...]] [<options>]
options:
  /s: Copies subdirectories. This option automatically excludes empty directories.
  /e: Copies subdirectories. This option automatically includes empty directories.
  /lev:<n>: Copies only the top n levels of the source directory tree.
  /z: Copies files in restartable mode.
  /b: Copies files in backup mode.
  /zb: Copies files in restartable mode. If file access is denied, switches to backup mode.
  /j: Copies using unbuffered I/O (recommended for large files).
  /efsraw: Copies all encrypted files in EFS RAW mode.
  /copy:<copyflags>:
    description: Specifies which file properties to copy.
    values:
      - D: Data
      - A: Attributes
      - T: Time stamps
      - S: NTFS access control list (ACL)
      - O: Owner information
      - U: Auditing information
  /dcopy:<copyflags>:
    description: Specifies what to copy in directories.
    values:
      - D: Data
      - A: Attributes
      - T: Time stamps
  /sec: Copies files with security (equivalent to /copy:DATS).
  /copyall: Copies all file information (equivalent to /copy:DATSOU).
  /nocopy: Copies no file information
  /secfix: Fixes file security on all files, even skipped ones.
  /timfix: Fixes file times on all files, even skipped ones.
  /purge: Deletes destination files and directories that no longer exist in the source.
  /mir: Mirrors a directory tree (equivalent to /e plus /purge).
  /mov: Moves files, and deletes them from the source after they are copied.
  /move: Moves files and directories, and deletes them from the source after they are copied.
  /a+:attributes:
    description: Adds the specified attributes to copied files.
    values:
      - R: Read only
      - A: Archive
      - S: System
      - H: Hidden
      - C: Compressed
      - N: Not content indexed
      - E: Encrypted
      - T: Temporary
  /a-:attributes:
    description: Removes the specified attributes from copied files.
    values:
      - R: Read only
      - A: Archive
      - S: System
      - H: Hidden
      - C: Compressed
      - N: Not content indexed
      - E: Encrypted
      - T: Temporary
  /create: Creates a directory tree and zero-length files only.
  /fat: Creates destination files by using 8.3 character-length FAT file names only.
  /256: Turns off support for paths longer than 256 characters.
  /mon:<n>: Monitors the source, and runs again when more than n changes are detected.
  /mot:<m>: Monitors the source, and runs again in m minutes, if changes are detected.
  /MT[:n]: Creates multi-threaded copies with n threads.
  /rh:hhmm-hhmm: Specifies run times when new copies may be started.
  /pf: Checks run times on a per-file (not per-pass) basis.
  /ipg:n: Specifies the inter-packet gap to free bandwidth on slow lines.
  /sl: Don't follow symbolic links and instead create a copy of the link.
  /nodcopy: Copies no directory info
  /nooffload: Copies files without using the Windows Copy Offload mechanism.
  /compress: Requests network compression during file transfer, if applicable.
  /a: Copies only files for which the Archive attribute is set.
  /m: Copies only files for which the Archive attribute is set, and resets the Archive attribute.
  /ia:attributes:
    description: Includes only files for which any of the specified attributes are set.
    values:
      - R: Read only
      - A: Archive
      - S: System
      - H: Hidden
      - C: Compressed
      - N: Not content indexed
      - E: Encrypted
      - T: Temporary
      - O: Offline
  /xa:attributes:
    description: Excludes files for which any of the specified attributes are set.
    values:
      - R: Read only
      - A: Archive
      - S: System
      - H: Hidden
      - C: Compressed
      - N: Not content indexed
      - E: Encrypted
      - T: Temporary
      - O: Offline
  /xf <filename>[ ...]: Excludes files that match the specified names or paths. Wildcard characters (* and ?) are supported.
  /xd <directory>[ ...]: Excludes directories that match the specified names and paths.
  /xc: Excludes changed files.
  /xn: Excludes newer files.
  /xo: Excludes older files.
  /xx: Excludes extra files and directories.
  /xl: Excludes "lonely" files and directories.
  /im: Include modified files (differing change times).
  /is: Includes the same files.
  /it: Includes tweaked files.
  /xc: Excludes existing files with the same timestamp, but different file sizes.
  /xn: Excludes existing files newer than the copy in the source directory.
  /xo: Excludes existing files older than the copy in the source directory.
  /xx: Excludes extra files and directories present in the destination but not the source. Excluding extra files will not delete files from the destination.
  /xl: Excludes "lonely" files and directories present in the source but not the destination. Excluding lonely files prevents any new files from being added to the destination.
  /is: Includes the same files. Same files are identical in name, size, times, and all attributes.
  /it: Includes "tweaked" files. Tweaked files have the same name, size, and times, but different attributes.
  /max:<n>: Specifies the maximum file size (to exclude files bigger than n bytes).
  /min:<n>: Specifies the minimum file size (to exclude files smaller than n bytes).
  /maxage:<n>: Specifies the maximum file age (to exclude files older than n days or date).
  /minage:<n>: Specifies the minimum file age (exclude files newer than n days or date).
  /maxlad:<n>: Specifies the maximum last access date (excludes files unused since n).
  /minlad:<n>: Specifies the minimum last access date (excludes files used since n).
  /xj: Excludes junction points, which are normally included by default.
  /fft: Assumes FAT file times (two-second precision).
  /dst: Compensates for one-hour DST time differences.
  /xjd: Excludes junction points for directories.
  /xjf: Excludes junction points for files.
  /r:<n>: Specifies the number of retries on failed copies.
  /w:<n>: Specifies the wait time between retries, in seconds.
  /reg: Saves the values specified in the /r and /w options as default settings in the registry.
  /tbd: Specifies that the system will wait for share names to be defined (retry error 67).
  /l: Specifies that files are to be listed only (and not copied, deleted, or time stamped).
  /x: Reports all extra files, not just those that are selected.
  /v: Produces verbose output, and shows all skipped files.
  /ts: Includes source file time stamps in the output.
  /fp: Includes the full path names of the files in the output.
  /bytes: Prints sizes, as bytes.
  /ns: Specifies that file sizes are not to be logged.
  /nc: Specifies that file classes are not to be logged.
  /nfl: Specifies that file names are not to be logged.
  /ndl: Specifies that directory names are not to be logged.
  /np: Specifies that the progress of the copying operation will not be displayed.
  /eta: Shows the estimated time of arrival (ETA) of the copied files.
  /log:<logfile>: Writes the status output to the log file (overwrites the existing log file).
  /log+:<logfile>: Writes the status output to the log file (appends the output to the existing log file).
  /unicode: Displays the status output as Unicode text.
  /unilog:<logfile>: Writes the status output to the log file as Unicode text (overwrites the existing log file).
  /unilog+:<logfile>: Writes the status output to the log file as Unicode text (appends the output to the existing log file).
  /tee: Writes the status output to the console window, as well as to the log file.
  /njh: Specifies that there is no job header.
  /njs: Specifies that there is no job summary.
  /job:<jobname>: Specifies that parameters are to be derived from the named job file.
  /save:<jobname>: Specifies that parameters are to be saved to the named job file.
  /quit: Quits after processing command line (to view parameters).
  /nosd: Indicates that no source directory is specified.
  /nodd: Indicates that no destination directory is specified.
  /if: Includes the specified files.