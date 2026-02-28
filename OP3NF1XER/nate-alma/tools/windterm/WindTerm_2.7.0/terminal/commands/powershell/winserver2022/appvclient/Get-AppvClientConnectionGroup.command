description: Returns an App-V connection group object
synopses:
- Get-AppvClientConnectionGroup [[-Name] <String>] [-All] [<CommonParameters>]
- Get-AppvClientConnectionGroup [-GroupId] <Guid> [[-VersionId] <Guid>] [-All] [<CommonParameters>]
options:
  -All Switch: ~
  -GroupId Guid:
    required: true
  -Name String: ~
  -VersionId Guid: ~
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
