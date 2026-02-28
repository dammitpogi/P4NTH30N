description: Gets the replication metadata for one or more Active Directory replication
  partners
synopses:
- Get-ADReplicationAttributeMetadata [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Filter <String>] [-IncludeDeletedObjects] [-Object] <ADObject> [[-Properties]
  <String[]>] [-Server] <String> [-ShowAllLinkedValues] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Filter String: ~
  -IncludeDeletedObjects Switch: ~
  -Object ADObject:
    required: true
  -Properties,-Property,-Attribute,-Attributes String[]: ~
  -Server String:
    required: true
  -ShowAllLinkedValues Switch: ~
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
