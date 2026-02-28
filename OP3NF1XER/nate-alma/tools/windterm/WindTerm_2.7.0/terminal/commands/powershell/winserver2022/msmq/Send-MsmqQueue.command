description: Sends a test message to remote queues
synopses:
- Send-MsmqQueue [-Name] <String> [-MessageObject <Message>] [-Body <Object>] [-Label
  <String>] [-Recoverable] [-Authenticated] [-Journaling] [-Transactional] [-AcknowledgeType
  <AcknowledgeTypes>] [-AdminQueuePath <String>] [-ResponseQueuePath <String>] [-TimeToReachQueue
  <TimeSpan>] [-TimeToBeReceived <TimeSpan>] [<CommonParameters>]
- Send-MsmqQueue -InputObject <MessageQueue[]> [-MessageObject <Message>] [-Body <Object>]
  [-Label <String>] [-Recoverable] [-Authenticated] [-Journaling] [-Transactional]
  [-AcknowledgeType <AcknowledgeTypes>] [-AdminQueuePath <String>] [-ResponseQueuePath
  <String>] [-TimeToReachQueue <TimeSpan>] [-TimeToBeReceived <TimeSpan>] [<CommonParameters>]
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
  -InputObject MessageQueue[]:
    required: true
  -Journaling Switch: ~
  -Label String: ~
  -MessageObject Message: ~
  -Name String:
    required: true
  -Recoverable Switch: ~
  -ResponseQueuePath String: ~
  -TimeToBeReceived,-TTBR TimeSpan: ~
  -TimeToReachQueue,-TTRQ TimeSpan: ~
  -Transactional Switch: ~
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
