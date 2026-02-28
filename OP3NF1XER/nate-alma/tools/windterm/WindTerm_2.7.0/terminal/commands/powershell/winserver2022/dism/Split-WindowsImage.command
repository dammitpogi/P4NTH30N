description: Splits an existing .wim file into multiple read-only split .wim files
synopses:
- Split-WindowsImage -ImagePath <String> -SplitImagePath <String> -FileSize <UInt64>
  [-CheckIntegrity] [-LogPath <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>]
  [<CommonParameters>]
options:
  -CheckIntegrity Switch: ~
  -FileSize UInt64:
    required: true
  -ImagePath String:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -ScratchDirectory String: ~
  -SplitImagePath String:
    required: true
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
