description: Creates an automatic classification rule
synopses:
- New-FsrmClassificationRule [-Name] <String> [-Description <String>] -Property <String>
  [-PropertyValue <String>] -Namespace <String[]> [-Disabled] [-ReevaluateProperty
  <RuleReevaluatePropertyEnum>] [-Flags <RuleFlagsEnum[]>] [-ContentRegularExpression
  <String[]>] [-ContentString <String[]>] [-ContentStringCaseSensitive <String[]>]
  -ClassificationMechanism <String> [-Parameters <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClassificationMechanism String:
    required: true
  -Confirm,-cf Switch: ~
  -ContentRegularExpression String[]: ~
  -ContentString String[]: ~
  -ContentStringCaseSensitive String[]: ~
  -Description String: ~
  -Disabled Switch: ~
  -Flags RuleFlagsEnum[]:
    values:
    - ClearAutomaticallyClassifiedProperty
    - ClearManuallyClassifiedProperty
    - Deprecated
  -Name String:
    required: true
  -Namespace String[]:
    required: true
  -Parameters String[]: ~
  -Property String:
    required: true
  -PropertyValue String: ~
  -ReevaluateProperty RuleReevaluatePropertyEnum:
    values:
    - Never
    - Aggregate
    - Overwrite
  -ThrottleLimit Int32: ~
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
