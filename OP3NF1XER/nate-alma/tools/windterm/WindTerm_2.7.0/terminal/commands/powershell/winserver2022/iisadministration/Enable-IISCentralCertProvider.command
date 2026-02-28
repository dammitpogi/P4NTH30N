description: Enables the IIS central certificate store
synopses:
- Enable-IISCentralCertProvider -CertStoreLocation <String> -UserName <String> -Password
  <SecureString> -PrivateKeyPassword <SecureString> [<CommonParameters>]
options:
  -CertStoreLocation String:
    required: true
  -Password SecureString:
    required: true
  -PrivateKeyPassword SecureString:
    required: true
  -UserName String:
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
