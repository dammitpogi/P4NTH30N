description: Shows runspace debugging options
synopses:
- Get-RunspaceDebug [[-RunspaceName] <String[]>] [<CommonParameters>]
- Get-RunspaceDebug [-Runspace] <Runspace[]> [<CommonParameters>]
- Get-RunspaceDebug [-RunspaceId] <Int32[]> [<CommonParameters>]
- Get-RunspaceDebug [-RunspaceInstanceId] <Guid[]> [<CommonParameters>]
- Get-RunspaceDebug [[-ProcessName] <String>] [[-AppDomainName] <String[]>] [<CommonParameters>]
options:
  -AppDomainName System.String[]: ~
  -ProcessName System.String: ~
  -Runspace System.Management.Automation.Runspaces.Runspace[]:
    required: true
  -RunspaceId System.Int32[]:
    required: true
  -RunspaceInstanceId System.Guid[]:
    required: true
  -RunspaceName System.String[]: ~
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
