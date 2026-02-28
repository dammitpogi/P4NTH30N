description: Creates a claims provider trust group based on metadata that contains
  multiple entities
synopses:
- Add-AdfsClaimsProviderTrustsGroup -MetadataFile <String> [-Force] [-PassThru] [-AcceptanceTransformRules
  <String>] [-AcceptanceTransformRulesFile <String>] [-MonitoringEnabled <Boolean>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsClaimsProviderTrustsGroup -MetadataUrl <Uri> [-AutoUpdateEnabled <Boolean>]
  [-Force] [-PassThru] [-AcceptanceTransformRules <String>] [-AcceptanceTransformRulesFile
  <String>] [-MonitoringEnabled <Boolean>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AcceptanceTransformRules String: ~
  -AcceptanceTransformRulesFile String: ~
  -AutoUpdateEnabled Boolean: ~
  -Force Switch: ~
  -MetadataFile String:
    required: true
  -MetadataUrl Uri:
    required: true
  -MonitoringEnabled Boolean: ~
  -PassThru Switch: ~
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
