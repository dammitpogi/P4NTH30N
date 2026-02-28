description: Enables a running connection group on the computer running the App-V
  client
synopses:
- Enable-AppvClientConnectionGroup [-Global] [-UserSID <String>] [-GroupId] <Guid>
  [-VersionId] <Guid> [<CommonParameters>]
- Enable-AppvClientConnectionGroup [-Global] [-UserSID <String>] [-Name] <String>
  [<CommonParameters>]
- Enable-AppvClientConnectionGroup [-Global] [-UserSID <String>] [-ConnectionGroup]
  <AppvClientConnectionGroup> [<CommonParameters>]
options:
  -ConnectionGroup AppvClientConnectionGroup:
    required: true
  -Global Switch: ~
  -GroupId Guid:
    required: true
  -Name String:
    required: true
  -UserSID String: ~
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
