description: Gets the current date and time
synopses:
- Get-Date [[-Date] <DateTime>] [-Year <Int32>] [-Month <Int32>] [-Day <Int32>] [-Hour
  <Int32>] [-Minute <Int32>] [-Second <Int32>] [-Millisecond <Int32>] [-DisplayHint
  <DisplayHintType>] [-Format <String>] [-AsUTC] [<CommonParameters>]
- Get-Date [[-Date] <DateTime>] [-Year <Int32>] [-Month <Int32>] [-Day <Int32>] [-Hour
  <Int32>] [-Minute <Int32>] [-Second <Int32>] [-Millisecond <Int32>] [-DisplayHint
  <DisplayHintType>] -UFormat <String> [<CommonParameters>]
- Get-Date -UnixTimeSeconds <Int64> [-Year <Int32>] [-Month <Int32>] [-Day <Int32>]
  [-Hour <Int32>] [-Minute <Int32>] [-Second <Int32>] [-Millisecond <Int32>] [-DisplayHint
  <DisplayHintType>] [-Format <String>] [-AsUTC] [<CommonParameters>]
- Get-Date -UnixTimeSeconds <Int64> [-Year <Int32>] [-Month <Int32>] [-Day <Int32>]
  [-Hour <Int32>] [-Minute <Int32>] [-Second <Int32>] [-Millisecond <Int32>] [-DisplayHint
  <DisplayHintType>] -UFormat <String> [<CommonParameters>]
options:
  -AsUTC Switch: ~
  -Date,-LastWriteTime System.DateTime: ~
  -Day System.Int32: ~
  -DisplayHint Microsoft.PowerShell.Commands.DisplayHintType:
    values:
    - Date
    - Time
    - DateTime
  -Format System.String: ~
  -Hour System.Int32: ~
  -Millisecond System.Int32: ~
  -Minute System.Int32: ~
  -Month System.Int32: ~
  -Second System.Int32: ~
  -UFormat System.String: ~
  -UnixTimeSeconds,-UnixTime System.Int64:
    required: true
  -Year System.Int32: ~
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
