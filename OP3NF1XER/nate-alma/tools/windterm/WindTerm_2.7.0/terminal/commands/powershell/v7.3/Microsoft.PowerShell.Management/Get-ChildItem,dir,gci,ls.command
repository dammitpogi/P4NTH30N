description: Gets the items and child items in one or more specified locations
synopses:
- Get-ChildItem [[-Path] <string[]>] [[-Filter] <string>] [-Include <string[]>] [-Exclude
  <string[]>] [-Recurse] [-Depth <uint32>] [-Force] [-Name] [-Attributes <FlagsExpression[FileAttributes]>]
  [-FollowSymlink] [-Directory] [-File] [-Hidden] [-ReadOnly] [-System] [<CommonParameters>]
- Get-ChildItem [[-Filter] <string>] -LiteralPath <string[]> [-Include <string[]>]
  [-Exclude <string[]>] [-Recurse] [-Depth <uint32>] [-Force] [-Name] [-Attributes
  <FlagsExpression[FileAttributes]>] [-FollowSymlink] [-Directory] [-File] [-Hidden]
  [-ReadOnly] [-System] [<CommonParameters>]
options:
  -Attributes System.Management.Automation.FlagsExpression`1[System.IO.FileAttributes]:
    values:
    - Archive
    - Compressed
    - Device
    - Directory
    - Encrypted
    - Hidden
    - IntegrityStream
    - Normal
    - NoScrubData
    - NotContentIndexed
    - Offline
    - ReadOnly
    - ReparsePoint
    - SparseFile
    - System
    - Temporary
  -Depth System.UInt32: ~
  -Directory,-ad Switch: ~
  -Exclude System.String[]: ~
  -File,-af Switch: ~
  -Filter System.String: ~
  -FollowSymlink Switch: ~
  -Force Switch: ~
  -Hidden,-ah,-h Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Name Switch: ~
  -Path System.String[]: ~
  -ReadOnly,-ar Switch: ~
  -Recurse,-s Switch: ~
  -System,-as Switch: ~
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~
