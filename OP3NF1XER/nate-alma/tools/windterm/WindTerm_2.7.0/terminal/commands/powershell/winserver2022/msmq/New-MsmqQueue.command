description: Creates public or private queues
synopses:
- New-MsmqQueue [-Name] <String[]> [-QueueType <MSMQQueueType>] [-Transactional] [-Label
  <String>] [-Authenticate] [-Journaling] [-QueueQuota <Int64>] [-JournalQuota <Int64>]
  [-PrivacyLevel <EncryptionRequired>] [-MulticastAddress <String>] [<CommonParameters>]
options:
  -Authenticate Switch: ~
  -JournalQuota Int64: ~
  -Journaling Switch: ~
  -Label String: ~
  -MulticastAddress String: ~
  -Name String[]:
    required: true
  -PrivacyLevel EncryptionRequired:
    values:
    - None
    - Optional
    - Body
  -QueueQuota Int64: ~
  -QueueType MSMQQueueType:
    values:
    - Private
    - Public
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
