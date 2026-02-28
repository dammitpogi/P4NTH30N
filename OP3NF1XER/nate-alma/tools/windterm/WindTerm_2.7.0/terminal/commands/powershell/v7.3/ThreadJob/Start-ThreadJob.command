description: Creates background jobs similar to the `Start-Job` cmdlet
synopses:
- Start-ThreadJob [-ScriptBlock] <ScriptBlock> [-Name <String>] [-InitializationScript
  <ScriptBlock>] [-InputObject <PSObject>] [-ArgumentList <Object[]>] [-ThrottleLimit
  <Int32>] [-StreamingHost <PSHost>] [<CommonParameters>]
- Start-ThreadJob [-FilePath] <String> [-Name <String>] [-InitializationScript <ScriptBlock>]
  [-InputObject <PSObject>] [-ArgumentList <Object[]>] [-ThrottleLimit <Int32>] [-StreamingHost
  <PSHost>] [<CommonParameters>]
options:
  -ArgumentList System.Object[]: ~
  -FilePath System.String:
    required: true
  -InitializationScript System.Management.Automation.ScriptBlock: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Name System.String: ~
  -ScriptBlock System.Management.Automation.ScriptBlock:
    required: true
  -StreamingHost System.Management.Automation.Host.PSHost: ~
  -ThrottleLimit System.Int32: ~
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
