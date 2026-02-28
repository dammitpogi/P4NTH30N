description: "Gets a list of IP addresses that need to be added and deleted to an\
  \ IPsec rule based on the differences detected between the IP addresses for the\
  \ existing rule and the IP addresses derived from the input parameters, and creates\
  \ a Windows PowerShell\xAE script (.ps1) that updates the IPsec rule in the appropriate\
  \ policy stores"
synopses:
- Get-DAPolicyChange [[-Servers] <String[]>] [[-Domains] <String[]>] [-DisplayName]
  <String> [[-PolicyStore] <String>] [-PSLocation] <String> [-EndpointType] <String>
  [[-DnsServers] <String[]>] [<CommonParameters>]
options:
  -DisplayName String:
    required: true
  -DnsServers String[]: ~
  -Domains String[]: ~
  -EndpointType String:
    required: true
  -PSLocation String:
    required: true
  -PolicyStore String: ~
  -Servers String[]: ~
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
