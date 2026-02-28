description: Displays a list of the files and folders in a specified image
synopses:
- Get-WindowsImageContent -ImagePath <String> -Name <String> [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Get-WindowsImageContent -ImagePath <String> -Index <UInt32> [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -ImagePath String:
    required: true
  -Index UInt32:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Name String:
    required: true
  -ScratchDirectory String: ~
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
