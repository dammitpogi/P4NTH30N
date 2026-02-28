description:
  Formats a disk to accept Windows files.
synopses:
  - format volume [/FS:file-system] [/V:label] [/Q] [/L[:state]] [/A:size] [/C] [/I:state] [/X] [/P:passes] [/S:state]
  - format volume [/V:label] [/Q] [/F:size] [/P:passes]
  - format volume [/V:label] [/Q] [/T:tracks /N:sectors] [/P:passes]
  - format volume [/V:label] [/Q] [/P:passes]
  - format volume [/Q]
options:
  /FS:filesystem:
    description: Specifies the type of file system
    values:
      - FAT
      - FAT32
      - NTFS
      - exFAT
      - ReFS
      - UDF
  /V:<label>: Specifies the volume label.
  /A:<size>:
    description: Specifies the allocation unit size to use on FAT, FAT32, NTFS, exFAT, or ReFS volumes.
    values:
      - 512
      - 1024
      - 2048
      - 4096
      - 8192
      - 16K
      - 32K
      - 64K
      - 128K
      - 256K
      - 512K
      - 1M
      - 2M
      - 4M
      - 8M
      - 16M
      - 32M
  /Q: Performs a quick format.
  /F:<size>:
    description: Specifies the size of the floppy disk to format.
    values:
      - 1440
      - 1440k
      - 1440kb
      - 1.44
      - 1.44m
      - 1.44mb
      - 1.44-MB
  /T:<tracks>: Specifies the number of tracks on the disk.
  /N:<sectors>: Specifies the number of sectors per track.
  /P:<count>: Zero every sector on the volume.
  /C: NTFS only. Files created on the new volume will be compressed by default.
  /X: Forces the volume to dismount, if necessary, before it's formatted.
  /R: NTFS only. Files created on the new volume will be compressed by default.
  /D: UDF 2.50 only. Metadata will be duplicated.
  /L:<state>:
    description: NTFS only. Overrides the default size of file record.
    values:
      - enable: Use large size file records
      - disable: Use small size file records
  /S:<state>:
    description: Specifies support for short filenames.
    values:
      - enable: Enable short filenames
      - disable: Disable short filenames
  /TXF:<state>:
    description: Specifies TxF is enabled/disabled.
    values:
      - enable: Enable TxF
      - disable: Disable TxF
  /I:<state>:
    description: ReFS only. Specifies whether integrity should be enabled on the new volume.
    values:
      - enable: Enable integrity
      - disable: Disable integrity
  /DAX:<state>:
    description: NTFS only. Enable direct access storage (DAX) mode for this volume.
    values:
      - enable: Enable direct access storage
      - disable: Disable direct access storage
  /LogSize:<size>: NTFS only Specifies the size for NTFS log file in kilobytes. The minimum supported size is 2MB.
  /NoRepairLogs: NTFS only. Disables NTFS repair logs.
  /?: Displays help at the command prompt.