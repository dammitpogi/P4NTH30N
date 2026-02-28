description: Invokes a method of a CIM class
synopses:
- Invoke-CimMethod [-ClassName] <String> [-ComputerName <String[]>] [[-Arguments]
  <IDictionary>] [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-CimMethod [-ClassName] <String> -CimSession <CimSession[]> [[-Arguments]
  <IDictionary>] [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-CimMethod -ResourceUri <Uri> [-ComputerName <String[]>] [[-Arguments] <IDictionary>]
  [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec <UInt32>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Invoke-CimMethod [-ResourceUri <Uri>] [-InputObject] <CimInstance> -CimSession <CimSession[]>
  [[-Arguments] <IDictionary>] [-MethodName] <String> [-OperationTimeoutSec <UInt32>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-CimMethod [-ResourceUri <Uri>] [-InputObject] <CimInstance> [-ComputerName
  <String[]>] [[-Arguments] <IDictionary>] [-MethodName] <String> [-OperationTimeoutSec
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-CimMethod -ResourceUri <Uri> -CimSession <CimSession[]> [[-Arguments] <IDictionary>]
  [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec <UInt32>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Invoke-CimMethod [-CimClass] <CimClass> [-ComputerName <String[]>] [[-Arguments]
  <IDictionary>] [-MethodName] <String> [-OperationTimeoutSec <UInt32>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Invoke-CimMethod [-CimClass] <CimClass> -CimSession <CimSession[]> [[-Arguments]
  <IDictionary>] [-MethodName] <String> [-OperationTimeoutSec <UInt32>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Invoke-CimMethod -Query <String> [-QueryDialect <String>] [-ComputerName <String[]>]
  [[-Arguments] <IDictionary>] [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Invoke-CimMethod -Query <String> [-QueryDialect <String>] -CimSession <CimSession[]>
  [[-Arguments] <IDictionary>] [-MethodName] <String> [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Arguments System.Collections.IDictionary: ~
  -CimClass Microsoft.Management.Infrastructure.CimClass:
    required: true
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ClassName,-Class System.String:
    required: true
  -ComputerName,-CN,-ServerName System.String[]: ~
  -InputObject,-CimInstance Microsoft.Management.Infrastructure.CimInstance:
    required: true
  -MethodName,-Name System.String:
    required: true
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -Query System.String:
    required: true
  -QueryDialect System.String: ~
  -ResourceUri System.Uri: ~
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
