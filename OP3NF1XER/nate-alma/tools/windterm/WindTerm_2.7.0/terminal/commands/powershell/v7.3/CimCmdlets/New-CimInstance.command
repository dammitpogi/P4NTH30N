description: Creates a CIM instance
synopses:
- New-CimInstance [-ClassName] <String> [-Key <String[]>] [[-Property] <IDictionary>]
  [-Namespace <String>] [-OperationTimeoutSec <UInt32>] [-ComputerName <String[]>]
  [-ClientOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-CimInstance [-ClassName] <String> [-Key <String[]>] [[-Property] <IDictionary>]
  [-Namespace <String>] [-OperationTimeoutSec <UInt32>] -CimSession <CimSession[]>
  [-ClientOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-CimInstance -ResourceUri <Uri> [-Key <String[]>] [[-Property] <IDictionary>]
  [-Namespace <String>] [-OperationTimeoutSec <UInt32>] -CimSession <CimSession[]>
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-CimInstance -ResourceUri <Uri> [-Key <String[]>] [[-Property] <IDictionary>]
  [-Namespace <String>] [-OperationTimeoutSec <UInt32>] [-ComputerName <String[]>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- New-CimInstance [-CimClass] <CimClass> [[-Property] <IDictionary>] [-OperationTimeoutSec
  <UInt32>] -CimSession <CimSession[]> [-ClientOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-CimInstance [-CimClass] <CimClass> [[-Property] <IDictionary>] [-OperationTimeoutSec
  <UInt32>] [-ComputerName <String[]>] [-ClientOnly] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimClass Microsoft.Management.Infrastructure.CimClass:
    required: true
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ClassName System.String:
    required: true
  -ClientOnly,-Local Switch: ~
  -ComputerName,-CN,-ServerName System.String[]: ~
  -Key System.String[]: ~
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -Property,-Arguments System.Collections.IDictionary: ~
  -ResourceUri System.Uri:
    required: true
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
