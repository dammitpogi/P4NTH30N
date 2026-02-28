description: Retrieves the CIM instances that are connected to a specific CIM instance
  by an association
synopses:
- Get-CimAssociatedInstance [[-Association] <String>] [-ResultClassName <String>]
  [-InputObject] <CimInstance> [-Namespace <String>] [-OperationTimeoutSec <UInt32>]
  [-ResourceUri <Uri>] [-ComputerName <String[]>] [-KeyOnly] [<CommonParameters>]
- Get-CimAssociatedInstance [[-Association] <String>] [-ResultClassName <String>]
  [-InputObject] <CimInstance> [-Namespace <String>] [-OperationTimeoutSec <UInt32>]
  [-ResourceUri <Uri>] -CimSession <CimSession[]> [-KeyOnly] [<CommonParameters>]
options:
  -Association System.String: ~
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ComputerName,-CN,-ServerName System.String[]: ~
  -InputObject,-CimInstance Microsoft.Management.Infrastructure.CimInstance:
    required: true
  -KeyOnly Switch: ~
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -ResourceUri System.Uri: ~
  -ResultClassName System.String: ~
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
