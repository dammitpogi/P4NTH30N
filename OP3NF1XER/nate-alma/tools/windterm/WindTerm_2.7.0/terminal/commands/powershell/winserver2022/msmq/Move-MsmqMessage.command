description: Moves messages between subqueues or between the main queue and a subqueue
synopses:
- Move-MsmqMessage -InputObject <MessageQueue> -DestinationQueue <MessageQueue> -Message
  <Message> [-Transactional] [<CommonParameters>]
options:
  -DestinationQueue MessageQueue:
    required: true
  -InputObject MessageQueue:
    required: true
  -Message Message:
    required: true
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
