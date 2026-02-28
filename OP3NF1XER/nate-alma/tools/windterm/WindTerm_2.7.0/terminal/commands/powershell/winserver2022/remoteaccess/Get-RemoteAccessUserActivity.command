description: Displays the resources accessed over the active DirectAccess (DA) and
  VPN connections and the resources accessed over historical DA and VPN connections
synopses:
- Get-RemoteAccessUserActivity [-ComputerName <String>] [-EndDateTime <DateTime>]
  [-StartDateTime <DateTime>] [-UserName] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-RemoteAccessUserActivity [-ComputerName <String>] -SessionId <UInt64> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-RemoteAccessUserActivity [-ComputerName <String>] -HostIPAddress <String> [-EndDateTime
  <DateTime>] [-StartDateTime <DateTime>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -EndDateTime DateTime: ~
  -HostIPAddress String:
    required: true
  -SessionId UInt64:
    required: true
  -StartDateTime DateTime: ~
  -ThrottleLimit Int32: ~
  -UserName String:
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
