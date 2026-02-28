description: Shuts down the shared virtual environment of a connection group
synopses:
- Stop-AppvClientConnectionGroup [-Global] [-GroupId] <Guid> [-VersionId] <Guid> [<CommonParameters>]
- Stop-AppvClientConnectionGroup [-Global] [-Name] <String> [<CommonParameters>]
- Stop-AppvClientConnectionGroup [-Global] [-ConnectionGroup] <AppvClientConnectionGroup>
  [<CommonParameters>]
options:
  -ConnectionGroup AppvClientConnectionGroup:
    required: true
  -Global Switch: ~
  -GroupId Guid:
    required: true
  -Name String:
    required: true
  -VersionId Guid:
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
