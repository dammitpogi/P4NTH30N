description: Dismounts a Windows image from the directory it is mapped to
synopses:
- Dismount-WindowsImage -Path <String> [-Discard] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Dismount-WindowsImage -Path <String> [-Save] [-CheckIntegrity] [-Append] [-LogPath
  <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -Append Switch: ~
  -CheckIntegrity Switch: ~
  -Discard Switch:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Path String:
    required: true
  -Save Switch:
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
