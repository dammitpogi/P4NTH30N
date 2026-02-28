description: Gets the results of the PowerShell background jobs in the current session
synopses:
- Receive-Job [-Job] <Job[]> [[-Location] <String[]>] [-Keep] [-NoRecurse] [-Force]
  [-Wait] [-AutoRemoveJob] [-WriteEvents] [-WriteJobInResults] [<CommonParameters>]
- Receive-Job [-Job] <Job[]> [[-ComputerName] <String[]>] [-Keep] [-NoRecurse] [-Force]
  [-Wait] [-AutoRemoveJob] [-WriteEvents] [-WriteJobInResults] [<CommonParameters>]
- Receive-Job [-Job] <Job[]> [[-Session] <PSSession[]>] [-Keep] [-NoRecurse] [-Force]
  [-Wait] [-AutoRemoveJob] [-WriteEvents] [-WriteJobInResults] [<CommonParameters>]
- Receive-Job [-Keep] [-NoRecurse] [-Force] [-Wait] [-AutoRemoveJob] [-WriteEvents]
  [-WriteJobInResults] [-Name] <String[]> [<CommonParameters>]
- Receive-Job [-Keep] [-NoRecurse] [-Force] [-Wait] [-AutoRemoveJob] [-WriteEvents]
  [-WriteJobInResults] [-InstanceId] <Guid[]> [<CommonParameters>]
- Receive-Job [-Keep] [-NoRecurse] [-Force] [-Wait] [-AutoRemoveJob] [-WriteEvents]
  [-WriteJobInResults] [-Id] <Int32[]> [<CommonParameters>]
options:
  -AutoRemoveJob Switch: ~
  -ComputerName,-Cn System.String[]: ~
  -Force Switch: ~
  -Id System.Int32[]:
    required: true
  -InstanceId System.Guid[]:
    required: true
  -Job System.Management.Automation.Job[]:
    required: true
  -Keep Switch: ~
  -Location System.String[]: ~
  -Name System.String[]:
    required: true
  -NoRecurse Switch: ~
  -Session System.Management.Automation.Runspaces.PSSession[]: ~
  -Wait Switch: ~
  -WriteEvents Switch: ~
  -WriteJobInResults Switch: ~
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
