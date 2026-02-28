description: Gets message queues
synopses:
- Get-MsmqQueue [[-Name] <String[]>] [-QueueType <QueueType>] [<CommonParameters>]
- Get-MsmqQueue [[-Name] <String[]>] [-QueueType <QueueType>] [-Journal] [<CommonParameters>]
- Get-MsmqQueue [[-Name] <String[]>] [-QueueType <QueueType>] [-SubQueue <String>]
  [<CommonParameters>]
options:
  -Journal Switch: ~
  -Name String[]: ~
  -QueueType QueueType:
    values:
    - PrivateAndPublic
    - Private
    - Public
    - SystemJournal
    - SystemDeadLetter
    - SystemTransactionalDeadLetter
  -SubQueue String: ~
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
