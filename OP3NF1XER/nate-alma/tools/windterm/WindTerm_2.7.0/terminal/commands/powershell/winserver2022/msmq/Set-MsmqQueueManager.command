description: Configures the queue manager
synopses:
- Set-MsmqQueueManager [-RenewEncryptionKey] [-MsgStore <String>] [-MsgLogStore <String>]
  [-TransactionLogStore <String>] [-MessageQuota <Int64>] [-JournalQuota <Int64>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-MsmqQueueManager [-Connect] [-RenewEncryptionKey] [-MsgStore <String>] [-MsgLogStore
  <String>] [-TransactionLogStore <String>] [-MessageQuota <Int64>] [-JournalQuota
  <Int64>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-MsmqQueueManager [-Disconnect] [-RenewEncryptionKey] [-MsgStore <String>] [-MsgLogStore
  <String>] [-TransactionLogStore <String>] [-MessageQuota <Int64>] [-JournalQuota
  <Int64>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -Connect Switch: ~
  -Disconnect Switch: ~
  -JournalQuota Int64: ~
  -MessageQuota Int64: ~
  -MsgLogStore String: ~
  -MsgStore String: ~
  -RenewEncryptionKey Switch: ~
  -TransactionLogStore,-XactLogStore String: ~
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
