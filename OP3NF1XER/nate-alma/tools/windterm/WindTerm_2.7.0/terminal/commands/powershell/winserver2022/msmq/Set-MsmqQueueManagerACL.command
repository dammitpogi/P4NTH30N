description: Modifies the access rights of a queue manager
synopses:
- Set-MsmqQueueManagerACL -UserName <String[]> [-Allow <QueueManagerAccessRights>]
  [-Deny <QueueManagerAccessRights>] [-Remove <QueueManagerAccessRights>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Allow QueueManagerAccessRights:
    values:
    - FullControl
    - CreateQueue
    - ReceiveDeadLetter
    - ReceiveComputerJournal
    - GetProperties
    - SetProperties
    - GetPermissions
    - SetPermissions
    - TakeOwnership
    - Delete
    - PeekDeadLetter
    - PeekComputerJournal
    - AllExtendedRights
    - CreateAllChildObjects
    - DeleteAllChildObjects
    - ListObjects
  -Confirm,-cf Switch: ~
  -Deny QueueManagerAccessRights:
    values:
    - FullControl
    - CreateQueue
    - ReceiveDeadLetter
    - ReceiveComputerJournal
    - GetProperties
    - SetProperties
    - GetPermissions
    - SetPermissions
    - TakeOwnership
    - Delete
    - PeekDeadLetter
    - PeekComputerJournal
    - AllExtendedRights
    - CreateAllChildObjects
    - DeleteAllChildObjects
    - ListObjects
  -Remove QueueManagerAccessRights:
    values:
    - FullControl
    - CreateQueue
    - ReceiveDeadLetter
    - ReceiveComputerJournal
    - GetProperties
    - SetProperties
    - GetPermissions
    - SetPermissions
    - TakeOwnership
    - Delete
    - PeekDeadLetter
    - PeekComputerJournal
    - AllExtendedRights
    - CreateAllChildObjects
    - DeleteAllChildObjects
    - ListObjects
  -UserName String[]:
    required: true
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
