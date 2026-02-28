description: Disables debugging on one or more runspaces, and releases any pending
  debugger stop
synopses:
- Disable-RunspaceDebug [[-RunspaceName] <String[]>] [<CommonParameters>]
- Disable-RunspaceDebug [-Runspace] <Runspace[]> [<CommonParameters>]
- Disable-RunspaceDebug [-RunspaceId] <Int32[]> [<CommonParameters>]
- Disable-RunspaceDebug [-RunspaceInstanceId] <Guid[]> [<CommonParameters>]
- Disable-RunspaceDebug [[-ProcessName] <String>] [[-AppDomainName] <String[]>] [<CommonParameters>]
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
