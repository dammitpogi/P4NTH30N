description: Performs prerequisite checks for cloning a domain controller and generates
  a clone configuration file if all checks succeed
synopses:
- New-ADDCCloneConfigFile [-CloneComputerName <String>] [-IPv4DNSResolver <String[]>]
  [-Path <String>] [-SiteName <String>] [<CommonParameters>]
- New-ADDCCloneConfigFile [-AlternateWINSServer <String>] [-CloneComputerName <String>]
  [-IPv4Address <String>] [-IPv4DefaultGateway <String>] [-IPv4DNSResolver <String[]>]
  [-IPv4SubnetMask <String>] [-IPv6DNSResolver <String[]>] [-Offline] -Path <String>
  [-PreferredWINSServer <String>] [-SiteName <String>] [-Static] [<CommonParameters>]
- New-ADDCCloneConfigFile [-AlternateWINSServer <String>] [-CloneComputerName <String>]
  -IPv4Address <String> [-IPv4DefaultGateway <String>] -IPv4DNSResolver <String[]>
  -IPv4SubnetMask <String> [-Path <String>] [-PreferredWINSServer <String>] [-SiteName
  <String>] [-Static] [<CommonParameters>]
- New-ADDCCloneConfigFile [-CloneComputerName <String>] [-IPv6DNSResolver <String[]>]
  [-Path <String>] [-SiteName <String>] [<CommonParameters>]
- New-ADDCCloneConfigFile [-CloneComputerName <String>] -IPv6DNSResolver <String[]>
  [-Path <String>] [-SiteName <String>] [-Static] [<CommonParameters>]
options:
  -AlternateWINSServer String: ~
  -CloneComputerName,-cn String: ~
  -IPv4Address String: ~
  -IPv4DefaultGateway String: ~
  -IPv4DNSResolver String[]: ~
  -IPv4SubnetMask String: ~
  -IPv6DNSResolver String[]: ~
  -Offline Switch:
    required: true
  -Path String: ~
  -PreferredWINSServer String: ~
  -SiteName String: ~
  -Static Switch: ~
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
