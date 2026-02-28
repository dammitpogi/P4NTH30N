description: The Publish-SslCertificate cmdlet is deprecated. Instead, use the Set-AdfsSslCertificate
  cmdlet
synopses:
- Publish-SslCertificate -Path <String> -Password <SecureString> [<CommonParameters>]
- Publish-SslCertificate -RawPfx <Byte[]> -Password <SecureString> [<CommonParameters>]
options:
  -Password SecureString:
    required: true
  -Path String:
    required: true
  -RawPfx Byte[]:
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
