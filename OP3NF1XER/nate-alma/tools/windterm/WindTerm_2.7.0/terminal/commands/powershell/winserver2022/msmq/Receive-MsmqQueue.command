description: Does a destructive read from a queue
synopses:
- Receive-MsmqQueue -InputObject <MessageQueue> [-Transactional] [-RetrieveBody] [-Timeout
  <TimeSpan>] [-Count <Int32>] [<CommonParameters>]
- Receive-MsmqQueue -InputObject <MessageQueue> [-Peek] [-RetrieveBody] [-Timeout
  <TimeSpan>] [-Count <Int32>] [<CommonParameters>]
options:
  -Count Int32: ~
  -InputObject MessageQueue:
    required: true
  -Peek Switch: ~
  -RetrieveBody Switch: ~
  -Timeout TimeSpan: ~
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
