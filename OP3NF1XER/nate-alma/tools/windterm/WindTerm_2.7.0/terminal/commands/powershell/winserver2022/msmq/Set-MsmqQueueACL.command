description: Modifies the access rights of queues
synopses:
- Set-MsmqQueueACL [-InputObject] <MessageQueue[]> -UserName <String[]> [-Allow <MessageQueueAccessRights>]
  [-Deny <MessageQueueAccessRights>] [-Remove <MessageQueueAccessRights>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -Allow MessageQueueAccessRights:
    values:
    - DeleteMessage
    - PeekMessage
    - ReceiveMessage
    - WriteMessage
    - DeleteJournalMessage
    - ReceiveJournalMessage
    - SetQueueProperties
    - GetQueueProperties
    - DeleteQueue
    - GetQueuePermissions
    - GenericWrite
    - GenericRead
    - ChangeQueuePermissions
    - TakeQueueOwnership
    - FullControl
  -Confirm,-cf Switch: ~
  -Deny MessageQueueAccessRights:
    values:
    - DeleteMessage
    - PeekMessage
    - ReceiveMessage
    - WriteMessage
    - DeleteJournalMessage
    - ReceiveJournalMessage
    - SetQueueProperties
    - GetQueueProperties
    - DeleteQueue
    - GetQueuePermissions
    - GenericWrite
    - GenericRead
    - ChangeQueuePermissions
    - TakeQueueOwnership
    - FullControl
  -InputObject MessageQueue[]:
    required: true
  -Remove MessageQueueAccessRights:
    values:
    - DeleteMessage
    - PeekMessage
    - ReceiveMessage
    - WriteMessage
    - DeleteJournalMessage
    - ReceiveJournalMessage
    - SetQueueProperties
    - GetQueueProperties
    - DeleteQueue
    - GetQueuePermissions
    - GenericWrite
    - GenericRead
    - ChangeQueuePermissions
    - TakeQueueOwnership
    - FullControl
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
