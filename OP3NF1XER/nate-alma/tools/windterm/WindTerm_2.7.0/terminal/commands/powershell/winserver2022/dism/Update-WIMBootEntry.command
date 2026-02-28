description: Updates the Windows image file boot (WIMBoot) configuration entry, associated
  with either the specified data source ID, the renamed image file path or the moved
  image file path
synopses:
- Update-WIMBootEntry -Path <String> -ImagePath <String> -DataSourceID <Int64> [-LogPath
  <String>] [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -DataSourceID Int64:
    required: true
  -ImagePath String:
    required: true
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
  -LogPath,-LP String: ~
  -Path String:
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
