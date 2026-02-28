description: Changes configuration settings of classification rules
synopses:
- Set-FsrmClassificationRule [-Name] <String[]> [-Description <String>] [-Property
  <String>] [-PropertyValue <String>] [-Namespace <String[]>] [-Disabled] [-ReevaluateProperty
  <RuleReevaluatePropertyEnum>] [-Flags <RuleFlagsEnum[]>] [-ContentRegularExpression
  <String[]>] [-ContentString <String[]>] [-ContentStringCaseSensitive <String[]>]
  [-ClassificationMechanism <String>] [-Parameters <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-FsrmClassificationRule -InputObject <CimInstance[]> [-Description <String>]
  [-Property <String>] [-PropertyValue <String>] [-Namespace <String[]>] [-Disabled]
  [-ReevaluateProperty <RuleReevaluatePropertyEnum>] [-Flags <RuleFlagsEnum[]>] [-ContentRegularExpression
  <String[]>] [-ContentString <String[]>] [-ContentStringCaseSensitive <String[]>]
  [-ClassificationMechanism <String>] [-Parameters <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClassificationMechanism String: ~
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
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -Namespace String[]: ~
  -Parameters String[]: ~
  -PassThru Switch: ~
  -Property String: ~
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
