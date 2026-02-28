description: Adds a driver to an offline Windows image
synopses:
- Add-WindowsDriver [-Recurse] [-ForceUnsigned] [-Driver <String>] [-BasicDriverObject
  <BasicDriverObject>] [-AdvancedDriverObject <AdvancedDriverObject>] -Path <String>
  [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>] [-ScratchDirectory
  <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -AdvancedDriverObject AdvancedDriverObject: ~
  -BasicDriverObject BasicDriverObject: ~
  -Driver String: ~
  -ForceUnsigned Switch: ~
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Path String:
    required: true
  -Recurse Switch: ~
  -ScratchDirectory String: ~
  -SystemDrive String: ~
  -WindowsDirectory String: ~
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
