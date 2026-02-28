description: Configures, starts, and stops a trace of PowerShell components
synopses:
- Set-TraceSource [-Name] <String[]> [[-Option] <PSTraceSourceOptions>] [-ListenerOption
  <TraceOptions>] [-FilePath <String>] [-Force] [-Debugger] [-PSHost] [-PassThru]
  [<CommonParameters>]
- Set-TraceSource [-Name] <String[]> [-RemoveListener <String[]>] [<CommonParameters>]
- Set-TraceSource [-Name] <String[]> [-RemoveFileListener <String[]>] [<CommonParameters>]
options:
  -Debugger Switch: ~
  -FilePath,-PSPath,-Path System.String: ~
  -Force Switch: ~
  -ListenerOption System.Diagnostics.TraceOptions:
    values:
    - None
    - LogicalOperationStack
    - DateTime
    - Timestamp
    - ProcessId
    - ThreadId
    - Callstack
  -Name System.String[]:
    required: true
  -Option System.Management.Automation.PSTraceSourceOptions:
    values:
    - None
    - Constructor
    - Dispose
    - Finalizer
    - Method
    - Property
    - Delegates
    - Events
    - Exception
    - Lock
    - Error
    - Errors
    - Warning
    - Verbose
    - WriteLine
    - Data
    - Scope
    - ExecutionFlow
    - Assert
    - All
  -PassThru Switch: ~
  -PSHost Switch: ~
  -RemoveFileListener System.String[]: ~
  -RemoveListener System.String[]: ~
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
