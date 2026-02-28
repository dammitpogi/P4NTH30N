description: Sets properties of queues
synopses:
- Set-MsmqQueue -InputObject <MessageQueue[]> [-Label <String>] [-Authenticate <Boolean>]
  [-Journaling <Boolean>] [-QueueQuota <Int64>] [-JournalQuota <Int64>] [-PrivacyLevel
  <EncryptionRequired>] [-MulticastAddress <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Authenticate Boolean: ~
  -Confirm,-cf Switch: ~
  -InputObject MessageQueue[]:
    required: true
  -JournalQuota Int64: ~
  -Journaling Boolean: ~
  -Label String: ~
  -MulticastAddress String: ~
  -PrivacyLevel EncryptionRequired:
    values:
    - None
    - Optional
    - Body
  -QueueQuota Int64: ~
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
