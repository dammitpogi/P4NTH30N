description: Creates a new dynamic module that exists only in memory
synopses:
- New-Module [-ScriptBlock] <ScriptBlock> [-Function <String[]>] [-Cmdlet <String[]>]
  [-ReturnResult] [-AsCustomObject] [-ArgumentList <Object[]>] [<CommonParameters>]
- New-Module [-Name] <String> [-ScriptBlock] <ScriptBlock> [-Function <String[]>]
  [-Cmdlet <String[]>] [-ReturnResult] [-AsCustomObject] [-ArgumentList <Object[]>]
  [<CommonParameters>]
options:
  -ArgumentList,-Args System.Object[]: ~
  -AsCustomObject Switch: ~
  -Cmdlet System.String[]: ~
  -Function System.String[]: ~
  -Name System.String:
    required: true
  -ReturnResult Switch: ~
  -ScriptBlock System.Management.Automation.ScriptBlock:
    required: true
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
