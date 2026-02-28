description: Replicates a single object between any two domain controllers that have
  partitions in common
synopses:
- Sync-ADObject [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Destination]
  <String> [-Object] <ADObject> [-PassThru] [-PasswordOnly] [[-Source] <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Destination,-Server,-HostName,-IPv4Address String:
    required: true
  -Object ADObject:
    required: true
  -PassThru Switch: ~
  -PasswordOnly Switch: ~
  -Source String: ~
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
