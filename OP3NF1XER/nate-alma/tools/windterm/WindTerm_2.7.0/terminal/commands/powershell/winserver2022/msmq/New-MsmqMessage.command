description: Creates a message object
synopses:
- New-MsmqMessage [[-Body] <Object>] [-Recoverable] [-Authenticated] [-Journaling]
  [-Label <String>] [-AdminQueuePath <String>] [-AcknowledgeType <AcknowledgeTypes>]
  [-ResponseQueuePath <String>] [-TimeToReachQueue <TimeSpan>] [-TimeToBeReceived
  <TimeSpan>] [<CommonParameters>]
options:
  -AcknowledgeType AcknowledgeTypes:
    values:
    - None
    - PositiveArrival
    - PositiveReceive
    - NotAcknowledgeReachQueue
    - FullReachQueue
    - NegativeReceive
    - NotAcknowledgeReceive
    - FullReceive
  -AdminQueuePath String: ~
  -Authenticated Switch: ~
  -Body Object: ~
  -Journaling Switch: ~
  -Label String: ~
  -Recoverable Switch: ~
  -ResponseQueuePath String: ~
  -TimeToBeReceived,-TTBR TimeSpan: ~
  -TimeToReachQueue,-TTRQ TimeSpan: ~
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
