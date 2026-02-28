description: Gets the advanced properties for a network adapter
synopses:
- Get-NetAdapterAdvancedProperty [[-Name] <String[]>] [-IncludeHidden] [-AllProperties]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetAdapterAdvancedProperty [[-Name] <String[]>] -RegistryKeyword <String[]>
  [-IncludeHidden] [-AllProperties] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetAdapterAdvancedProperty [[-Name] <String[]>] -DisplayName <String[]> [-IncludeHidden]
  [-AllProperties] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Get-NetAdapterAdvancedProperty -InterfaceDescription <String[]> -RegistryKeyword
  <String[]> [-IncludeHidden] [-AllProperties] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-NetAdapterAdvancedProperty -InterfaceDescription <String[]> -DisplayName <String[]>
  [-IncludeHidden] [-AllProperties] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Get-NetAdapterAdvancedProperty -InterfaceDescription <String[]> [-IncludeHidden]
  [-AllProperties] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AllProperties Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayName,-DispN String[]:
    required: true
  -IncludeHidden Switch: ~
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -Name,-ifAlias,-InterfaceAlias String[]: ~
  -RegistryKeyword,-RegKey String[]:
    required: true
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
