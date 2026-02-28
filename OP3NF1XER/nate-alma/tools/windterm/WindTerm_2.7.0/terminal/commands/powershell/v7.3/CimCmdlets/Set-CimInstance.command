description: Modifies a CIM instance on a CIM server by calling the ModifyInstance
  method of the CIM class
synopses:
- Set-CimInstance [-ComputerName <String[]>] [-ResourceUri <Uri>] [-OperationTimeoutSec
  <UInt32>] [-InputObject] <CimInstance> [-Property <IDictionary>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-CimInstance -CimSession <CimSession[]> [-ResourceUri <Uri>] [-OperationTimeoutSec
  <UInt32>] [-InputObject] <CimInstance> [-Property <IDictionary>] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-CimInstance -CimSession <CimSession[]> [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-Query] <String> [-QueryDialect <String>] -Property <IDictionary> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-CimInstance [-ComputerName <String[]>] [-Namespace <String>] [-OperationTimeoutSec
  <UInt32>] [-Query] <String> [-QueryDialect <String>] -Property <IDictionary> [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession Microsoft.Management.Infrastructure.CimSession[]:
    required: true
  -ComputerName,-CN,-ServerName System.String[]: ~
  -InputObject,-CimInstance Microsoft.Management.Infrastructure.CimInstance:
    required: true
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -PassThru Switch: ~
  -Property,-Arguments System.Collections.IDictionary: ~
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
