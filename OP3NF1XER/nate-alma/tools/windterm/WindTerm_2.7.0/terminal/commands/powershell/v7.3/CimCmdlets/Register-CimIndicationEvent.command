description: Subscribes to indications using a filter expression or a query expression
synopses:
- Register-CimIndicationEvent [-Namespace <String>] [-ClassName] <String> [-OperationTimeoutSec
  <UInt32>] [-ComputerName <String>] [[-SourceIdentifier] <String>] [[-Action] <ScriptBlock>]
  [-MessageData <PSObject>] [-SupportEvent] [-Forward] [-MaxTriggerCount <Int32>]
  [<CommonParameters>]
- Register-CimIndicationEvent [-Namespace <String>] [-ClassName] <String> [-OperationTimeoutSec
  <UInt32>] -CimSession <CimSession> [[-SourceIdentifier] <String>] [[-Action] <ScriptBlock>]
  [-MessageData <PSObject>] [-SupportEvent] [-Forward] [-MaxTriggerCount <Int32>]
  [<CommonParameters>]
- Register-CimIndicationEvent [-Namespace <String>] [-Query] <String> [-QueryDialect
  <String>] [-OperationTimeoutSec <UInt32>] -CimSession <CimSession> [[-SourceIdentifier]
  <String>] [[-Action] <ScriptBlock>] [-MessageData <PSObject>] [-SupportEvent] [-Forward]
  [-MaxTriggerCount <Int32>] [<CommonParameters>]
- Register-CimIndicationEvent [-Namespace <String>] [-Query] <String> [-QueryDialect
  <String>] [-OperationTimeoutSec <UInt32>] [-ComputerName <String>] [[-SourceIdentifier]
  <String>] [[-Action] <ScriptBlock>] [-MessageData <PSObject>] [-SupportEvent] [-Forward]
  [-MaxTriggerCount <Int32>] [<CommonParameters>]
options:
  -Action System.Management.Automation.ScriptBlock: ~
  -CimSession Microsoft.Management.Infrastructure.CimSession:
    required: true
  -ClassName System.String:
    required: true
  -ComputerName,-CN,-ServerName System.String: ~
  -Forward Switch: ~
  -MaxTriggerCount System.Int32: ~
  -MessageData System.Management.Automation.PSObject: ~
  -Namespace System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -Query System.String:
    required: true
  -QueryDialect System.String: ~
  -SourceIdentifier System.String: ~
  -SupportEvent Switch: ~
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
