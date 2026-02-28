description: Retrieves information about established iSCSI sessions
synopses:
- Get-IscsiSession [<CommonParameters>]
- Get-IscsiSession [-SessionIdentifier <String[]>] [-TargetSideIdentifier <String[]>]
  [-NumberOfConnections <UInt32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-InitiatorSideIdentifier <String[]>] [-NumberOfConnections <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-NumberOfConnections <UInt32[]>] [-IscsiTarget <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-NumberOfConnections <UInt32[]>] [-InitiatorPort <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-NumberOfConnections <UInt32[]>] [-IscsiTargetPortal <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-NumberOfConnections <UInt32[]>] [-Disk <CimInstance>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiSession [-NumberOfConnections <UInt32[]>] [-IscsiConnection <CimInstance>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Disk CimInstance: ~
  -InitiatorPort CimInstance: ~
  -InitiatorSideIdentifier String[]: ~
  -IscsiConnection CimInstance: ~
  -IscsiTarget CimInstance: ~
  -IscsiTargetPortal CimInstance: ~
  -NumberOfConnections UInt32[]: ~
  -SessionIdentifier String[]: ~
  -TargetSideIdentifier String[]: ~
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
