description: Formats objects as a wide table that displays only one property of each
  object
synopses:
- Format-Wide [[-Property] <Object>] [-AutoSize] [-Column <int>] [-GroupBy <Object>]
  [-View <string>] [-ShowError] [-DisplayError] [-Force] [-Expand <string>] [-InputObject
  <psobject>] [<CommonParameters>]
options:
  -AutoSize Switch: ~
  -Column System.Int32: ~
  -DisplayError Switch: ~
  -Expand System.String:
    values:
    - CoreOnly
    - EnumOnly
    - Both
  -Force Switch: ~
  -GroupBy System.Object: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Property System.Object: ~
  -ShowError Switch: ~
  -View System.String: ~
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
