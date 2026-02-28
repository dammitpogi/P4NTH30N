description: Defines settings for the RD Licensing server and the licensing mode of
  the Remote Desktop deployment
synopses:
- Set-RDLicenseConfiguration -Mode <LicensingMode> [-Force] [-ConnectionBroker <String>]
  [<CommonParameters>]
- Set-RDLicenseConfiguration -Mode <LicensingMode> -LicenseServer <String[]> [-Force]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Set-RDLicenseConfiguration -LicenseServer <String[]> [-Force] [-ConnectionBroker
  <String>] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -Force Switch: ~
  -LicenseServer String[]:
    required: true
  -Mode LicensingMode:
    required: true
    values:
    - PerDevice
    - PerUser
    - NotConfigured
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
