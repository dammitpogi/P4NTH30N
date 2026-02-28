description: Collects and analyzes data relevant to the operation of a guarded fabric
synopses:
- Get-HgsTrace [-Collector <String[]>] [-Target <InputTarget[]>] [[-Path] <String>]
  [-WriteManifest] [-Detailed] [-Compact] [-Diagnostic <String[]>] [<CommonParameters>]
- Get-HgsTrace [-RunDiagnostics] [-Target <InputTarget[]>] [[-Path] <String>] [-WriteManifest]
  [-Detailed] [-Compact] [-Diagnostic <String[]>] [<CommonParameters>]
options:
  -Collector String[]: ~
  -Compact Switch: ~
  -Detailed Switch: ~
  -Diagnostic String[]:
    values:
    - Base
    - All
    - GuardedFabric
    - GuardedFabricTpmMode
    - GuardedFabricADMode
    - BestPractices
    - GuardedHost
    - HostGuardianService
    - Networking
    - Https
    - Hardware
  -Path String: ~
  -RunDiagnostics Switch:
    required: true
  -Target InputTarget[]: ~
  -WriteManifest Switch: ~
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
