description: Gets the CIM instances of a class from a CIM server
synopses:
- Get-CimInstance [-ClassName] <String> [-ComputerName <String[]>] [-KeyOnly] [-Namespace
  <String>] [-OperationTimeoutSec <UInt32>] [-QueryDialect <String>] [-Shallow] [-Filter
  <String>] [-Property <String[]>] [<CommonParameters>]
- Get-CimInstance -CimSession <CimSession[]> -ResourceUri <Uri> [-KeyOnly] [-Namespace
  <String>] [-OperationTimeoutSec <UInt32>] [-Shallow] [-Filter <String>] [-Property
  <String[]>] [<CommonParameters>]
- Get-CimInstance -CimSession <CimSession[]> [-ResourceUri <Uri>] [-Namespace <String>]
  [-OperationTimeoutSec <UInt32>] -Query <String> [-QueryDialect <String>] [-Shallow]
  [<CommonParameters>]
- Get-CimInstance -CimSession <CimSession[]> [-ClassName] <String> [-KeyOnly] [-Namespace
  <String>] [-OperationTimeoutSec <UInt32>] [-QueryDialect <String>] [-Shallow] [-Filter
  <String>] [-Property <String[]>] [<CommonParameters>]
- Get-CimInstance -CimSession <CimSession[]> [-ResourceUri <Uri>] [-OperationTimeoutSec
  <UInt32>] [-InputObject] <CimInstance> [<CommonParameters>]
- Get-CimInstance [-ResourceUri <Uri>] [-ComputerName <String[]>] [-OperationTimeoutSec
  <UInt32>] [-InputObject] <CimInstance> [<CommonParameters>]
- Get-CimInstance -ResourceUri <Uri> [-ComputerName <String[]>] [-KeyOnly] [-Namespace
  <String>] [-OperationTimeoutSec <UInt32>] [-Shallow] [-Filter <String>] [-Property
  <String[]>] [<CommonParameters>]
- Get-CimInstance [-ResourceUri <Uri>] [-ComputerName <String[]>] [-Namespace <String>]
  [-OperationTimeoutSec <UInt32>] -Query <String> [-QueryDialect <String>] [-Shallow]
  [<CommonParameters>]
options:
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ClassName System.String:
    required: true
  -ComputerName,-CN,-ServerName System.String[]: ~
  -Filter System.String: ~
  -InputObject,-CimInstance Microsoft.Management.Infrastructure.CimInstance:
    required: true
  -KeyOnly Switch: ~
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -Property,-SelectProperties System.String[]: ~
  -Query System.String:
    required: true
  -QueryDialect System.String: ~
  -ResourceUri System.Uri: ~
  -Shallow Switch: ~
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
