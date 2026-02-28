description: Creates a file management property condition object
synopses:
- New-FsrmFmjCondition [-Property] <String> [-Condition] <FmjConditionTypeEnum> [-Value
  <String>] [-DateOffset <Int32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Condition FmjConditionTypeEnum:
    required: true
    values:
    - Equal
    - NotEqual
    - GreaterThan
    - LessThan
    - Contain
    - Exist
    - NotExist
    - StartWith
    - EndWith
    - ContainedIn
    - PrefixOf
    - SuffixOf
    - MatchesPattern
  -Confirm,-cf Switch: ~
  -DateOffset Int32: ~
  -Property String:
    required: true
  -ThrottleLimit Int32: ~
  -Value String: ~
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
