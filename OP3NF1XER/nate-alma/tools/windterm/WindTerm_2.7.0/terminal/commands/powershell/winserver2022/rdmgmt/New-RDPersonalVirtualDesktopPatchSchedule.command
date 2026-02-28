description: Creates a patch schedule for a personal virtual desktop
synopses:
- New-RDPersonalVirtualDesktopPatchSchedule [-VirtualDesktopName] <String> [[-ID]
  <String>] [[-Context] <Byte[]>] [[-Deadline] <DateTime>] [[-StartTime] <DateTime>]
  [[-EndTime] <DateTime>] [[-Label] <String>] [[-Plugin] <String>] [[-ConnectionBroker]
  <String>] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -Context Byte[]: ~
  -Deadline DateTime: ~
  -EndTime DateTime: ~
  -ID String: ~
  -Label String: ~
  -Plugin String: ~
  -StartTime DateTime: ~
  -VirtualDesktopName String:
    required: true
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
