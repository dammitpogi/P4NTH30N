description: Fetches the current diagnostic store capacity. Parameter \[-Size\] returns
  the diagnostic store size capacity in megabytes. Parameter \[-Time\] returns the
  diagnostic store capacity in days. The default diagnostic data store size capacity
  is 1024 MB. The default time capacity is 30 days
synopses:
- Get-DiagnosticStoreCapacity [-Size] [-Time] [<CommonParameters>]
options:
  -Size,-s Switch: ~
  -Time,-t Switch: ~
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
