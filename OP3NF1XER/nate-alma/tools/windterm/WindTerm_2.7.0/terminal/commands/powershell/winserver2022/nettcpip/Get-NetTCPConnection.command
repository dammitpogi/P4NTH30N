description: Gets TCP connections
synopses:
- Get-NetTCPConnection [[-LocalAddress] <String[]>] [[-LocalPort] <UInt16[]>] [-RemoteAddress
  <String[]>] [-RemotePort <UInt16[]>] [-State <State[]>] [-AppliedSetting <AppliedSetting[]>]
  [-OwningProcess <UInt32[]>] [-CreationTime <DateTime[]>] [-OffloadState <OffloadState[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AppliedSetting AppliedSetting[]:
    values:
    - Internet
    - Datacenter
    - Compat
    - DatacenterCustom
    - InternetCustom
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CreationTime DateTime[]: ~
  -LocalAddress,-IPAddress String[]: ~
  -LocalPort UInt16[]: ~
  -OffloadState OffloadState[]:
    values:
    - InHost
    - Offloading
    - Offloaded
    - Uploading
  -OwningProcess UInt32[]: ~
  -RemoteAddress String[]: ~
  -RemotePort UInt16[]: ~
  -State State[]:
    values:
    - Closed
    - Listen
    - SynSent
    - SynReceived
    - Established
    - FinWait1
    - FinWait2
    - CloseWait
    - Closing
    - LastAck
    - TimeWait
    - DeleteTCB
    - Bound
  -ThrottleLimit Int32: ~
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
