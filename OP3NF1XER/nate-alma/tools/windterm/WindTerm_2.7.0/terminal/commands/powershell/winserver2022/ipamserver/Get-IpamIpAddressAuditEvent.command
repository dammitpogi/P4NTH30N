description: Gets all IP address audit events in IPAM
synopses:
- Get-IpamIpAddressAuditEvent -UserName <String[]> -StartDate <DateTime> -EndDate
  <DateTime> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamIpAddressAuditEvent -IpAddress <String> -StartDate <DateTime> -EndDate <DateTime>
  [-CorrelateLogonEvents] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-IpamIpAddressAuditEvent -ClientId <String> -StartDate <DateTime> -EndDate <DateTime>
  [-CorrelateLogonEvents] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-IpamIpAddressAuditEvent -HostName <String> -StartDate <DateTime> -EndDate <DateTime>
  [-CorrelateLogonEvents] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientId String:
    required: true
  -CorrelateLogonEvents Switch: ~
  -EndDate DateTime:
    required: true
  -HostName String:
    required: true
  -IpAddress String:
    required: true
  -StartDate DateTime:
    required: true
  -ThrottleLimit Int32: ~
  -UserName String[]:
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
