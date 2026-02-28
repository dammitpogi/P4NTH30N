description: Configures and starts a trace of the specified expression or command
synopses:
- Trace-Command [-InputObject <PSObject>] [-Name] <String[]> [[-Option] <PSTraceSourceOptions>]
  [-Expression] <ScriptBlock> [-ListenerOption <TraceOptions>] [-FilePath <String>]
  [-Force] [-Debugger] [-PSHost] [<CommonParameters>]
- Trace-Command [-InputObject <PSObject>] [-Name] <String[]> [[-Option] <PSTraceSourceOptions>]
  [-Command] <String> [-ArgumentList <Object[]>] [-ListenerOption <TraceOptions>]
  [-FilePath <String>] [-Force] [-Debugger] [-PSHost] [<CommonParameters>]
options:
  -ArgumentList,-Args System.Object[]: ~
  -Command System.String:
    required: true
  -Debugger Switch: ~
  -Expression System.Management.Automation.ScriptBlock:
    required: true
  -FilePath,-PSPath,-Path System.String: ~
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject: ~
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
  -PSHost Switch: ~
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
