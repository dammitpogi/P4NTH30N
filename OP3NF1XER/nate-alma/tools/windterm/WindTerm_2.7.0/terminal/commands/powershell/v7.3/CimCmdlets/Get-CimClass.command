description: Gets a list of CIM classes in a specific namespace
synopses:
- Get-CimClass [[-ClassName] <String>] [[-Namespace] <String>] [-OperationTimeoutSec
  <UInt32>] [-ComputerName <String[]>] [-MethodName <String>] [-PropertyName <String>]
  [-QualifierName <String>] [<CommonParameters>]
- Get-CimClass [[-ClassName] <String>] [[-Namespace] <String>] [-OperationTimeoutSec
  <UInt32>] -CimSession <CimSession[]> [-MethodName <String>] [-PropertyName <String>]
  [-QualifierName <String>] [<CommonParameters>]
options:
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ClassName System.String: ~
  -ComputerName,-CN,-ServerName System.String[]: ~
  -MethodName System.String: ~
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -PropertyName System.String: ~
  -QualifierName System.String: ~
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
