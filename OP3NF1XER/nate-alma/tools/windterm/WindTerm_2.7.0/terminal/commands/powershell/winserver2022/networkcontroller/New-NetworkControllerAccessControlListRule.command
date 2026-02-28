description: This cmdlet creates a new ACL rule to allow/deny traffic to/from a particular
  virtual subnet or network interface
synopses:
- New-NetworkControllerAccessControlListRule [-AccessControlListId] <String> [-ResourceId]
  <String> [-Properties] <AclRuleProperties> [[-ResourceMetadata] <ResourceMetadata>]
  [[-Etag] <String>] [-Force] -ConnectionUri <Uri> [-CertificateThumbprint <String>]
  [-Credential <PSCredential>] [-PassInnerException] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessControlListId string:
    required: true
  -CertificateThumbprint string: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag string: ~
  -Force Switch: ~
  -PassInnerException Switch: ~
  -Properties AclRuleProperties:
    required: true
  -ResourceId string:
    required: true
  -ResourceMetadata ResourceMetadata: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
