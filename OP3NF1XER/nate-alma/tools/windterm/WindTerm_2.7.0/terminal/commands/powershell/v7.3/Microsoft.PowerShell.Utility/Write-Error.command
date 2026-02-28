description: Writes an object to the error stream
synopses:
- Write-Error [-Message] <String> [-Category <ErrorCategory>] [-ErrorId <String>]
  [-TargetObject <Object>] [-RecommendedAction <String>] [-CategoryActivity <String>]
  [-CategoryReason <String>] [-CategoryTargetName <String>] [-CategoryTargetType <String>]
  [<CommonParameters>]
- Write-Error [-Exception] <Exception> [[-Message] <String>] [-Category <ErrorCategory>]
  [-ErrorId <String>] [-TargetObject <Object>] [-RecommendedAction <String>] [-CategoryActivity
  <String>] [-CategoryReason <String>] [-CategoryTargetName <String>] [-CategoryTargetType
  <String>] [<CommonParameters>]
- Write-Error [-ErrorRecord] <ErrorRecord> [-RecommendedAction <String>] [-CategoryActivity
  <String>] [-CategoryReason <String>] [-CategoryTargetName <String>] [-CategoryTargetType
  <String>] [<CommonParameters>]
options:
  -Category System.Management.Automation.ErrorCategory:
    values:
    - NotSpecified
    - OpenError
    - CloseError
    - DeviceError
    - DeadlockDetected
    - InvalidArgument
    - InvalidData
    - InvalidOperation
    - InvalidResult
    - InvalidType
    - MetadataError
    - NotImplemented
    - NotInstalled
    - ObjectNotFound
    - OperationStopped
    - OperationTimeout
    - SyntaxError
    - ParserError
    - PermissionDenied
    - ResourceBusy
    - ResourceExists
    - ResourceUnavailable
    - ReadError
    - WriteError
    - FromStdErr
    - SecurityError
    - ProtocolError
    - ConnectionError
    - AuthenticationError
    - LimitsExceeded
    - QuotaExceeded
    - NotEnabled
  -CategoryActivity,-Activity System.String: ~
  -CategoryReason,-Reason System.String: ~
  -CategoryTargetName,-TargetName System.String: ~
  -CategoryTargetType,-TargetType System.String: ~
  -ErrorId System.String: ~
  -ErrorRecord System.Management.Automation.ErrorRecord:
    required: true
  -Exception System.Exception:
    required: true
  -Message,-Msg System.String: ~
  -RecommendedAction System.String: ~
  -TargetObject System.Object: ~
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
