description: Lists all installed trusted provisioning certificates
synopses:
- Get-TrustedProvisioningCertificate [[-Thumbprint] <String>] [-LogsDirectoryPath
  <String>] [-WprpFile <String>] [-ConnectedDevice] [<CommonParameters>]
options:
  -ConnectedDevice,-Device Switch: ~
  -LogsDirectoryPath,-Logs String: ~
  -Thumbprint,-Id String: ~
  -WprpFile,-Wprp String: ~
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
