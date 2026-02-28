description: Specifies settings for the RD Gateway server for a Remote Desktop deployment
synopses:
- Set-RDDeploymentGatewayConfiguration [-GatewayMode] <GatewayUsage> [[-GatewayExternalFqdn]
  <String>] [[-LogonMethod] <GatewayAuthMode>] [[-UseCachedCredentials] <Boolean>]
  [[-BypassLocal] <Boolean>] [[-ConnectionBroker] <String>] [-Force] [<CommonParameters>]
options:
  -BypassLocal Boolean: ~
  -ConnectionBroker String: ~
  -Force Switch: ~
  -GatewayExternalFqdn String: ~
  -GatewayMode GatewayUsage:
    required: true
    values:
    - DoNotUse
    - Custom
    - Automatic
  -LogonMethod GatewayAuthMode:
    values:
    - Password
    - Smartcard
    - AllowUserToSelectDuringConnection
  -UseCachedCredentials Boolean: ~
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
