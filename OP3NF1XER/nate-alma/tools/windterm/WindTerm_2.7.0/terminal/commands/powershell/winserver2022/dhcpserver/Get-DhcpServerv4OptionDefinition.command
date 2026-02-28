description: Gets the DHCPv4 option definition for the specified option IDs
synopses:
- Get-DhcpServerv4OptionDefinition [-ComputerName <String>] [[-OptionId] <UInt32[]>]
  [[-VendorClass] <String>] [-All] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -All Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -OptionId UInt32[]: ~
  -ThrottleLimit Int32: ~
  -VendorClass,-Name String: ~
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
