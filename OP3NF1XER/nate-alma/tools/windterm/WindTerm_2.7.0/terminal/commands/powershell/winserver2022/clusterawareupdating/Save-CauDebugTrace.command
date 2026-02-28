description: Saves CAU debug tracing information to a local zip file
synopses:
- Save-CauDebugTrace [[-ClusterName] <String>] [[-FilePath] <String>] [-Credential
  <PSCredential>] [-RunId <Guid>] [-Force] [<CommonParameters>]
options:
  -ClusterName String: ~
  -Credential PSCredential: ~
  -FilePath,-Path String: ~
  -Force,-f Switch: ~
  -RunId Guid: ~
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
