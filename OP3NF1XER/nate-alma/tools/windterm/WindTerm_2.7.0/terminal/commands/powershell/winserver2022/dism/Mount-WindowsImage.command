description: Mounts a Windows image in a WIM or VHD file to a directory on the local
  computer
synopses:
- Mount-WindowsImage -Path <String> -ImagePath <String> -Index <UInt32> [-ReadOnly]
  [-Optimize] [-CheckIntegrity] [-SupportEa] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Mount-WindowsImage -Path <String> -ImagePath <String> -Name <String> [-ReadOnly]
  [-Optimize] [-CheckIntegrity] [-SupportEa] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
- Mount-WindowsImage -Path <String> [-Remount] [-SupportEa] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -CheckIntegrity Switch: ~
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
  -Optimize Switch: ~
  -Path String:
    required: true
  -ReadOnly Switch: ~
  -Remount Switch:
    required: true
  -ScratchDirectory String: ~
  -SupportEa Switch: ~
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
