description: Performs an operation against each item in a collection of input objects
synopses:
- ForEach-Object [-InputObject <PSObject>] [-Begin <ScriptBlock>] [-Process] <ScriptBlock[]>
  [-End <ScriptBlock>] [-RemainingScripts <ScriptBlock[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- ForEach-Object [-InputObject <PSObject>] [-MemberName] <String> [-ArgumentList <Object[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- ForEach-Object [-InputObject <PSObject>] -Parallel <ScriptBlock> [-ThrottleLimit
  <Int32>] [-TimeoutSeconds <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ArgumentList,-Args System.Object[]: ~
  -AsJob Switch: ~
  -Begin System.Management.Automation.ScriptBlock: ~
  -End System.Management.Automation.ScriptBlock: ~
  -InputObject System.Management.Automation.PSObject: ~
  -MemberName System.String:
    required: true
  -Parallel System.Management.Automation.ScriptBlock:
    required: true
  -Process System.Management.Automation.ScriptBlock[]:
    required: true
  -RemainingScripts System.Management.Automation.ScriptBlock[]: ~
  -ThrottleLimit System.Int32: ~
  -TimeoutSeconds System.Int32: ~
  -UseNewRunspace Switch: ~
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
