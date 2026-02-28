description: Creates a signer rule and adds it to a policy
synopses:
- Add-SignerRule -FilePath <String> -CertificatePath <String> [-Kernel] [-User] [-Update]
  [-Supplemental] [-Deny] [<CommonParameters>]
- Add-SignerRule -FilePath <String> -CertStorePath <String> [-Kernel] [-User] [-Update]
  [-Supplemental] [-Deny] [<CommonParameters>]
options:
  -CertificatePath,-c String:
    required: true
  -CertStorePath String:
    required: true
  -Deny Switch: ~
  -FilePath,-f String:
    required: true
  -Kernel Switch: ~
  -Supplemental Switch: ~
  -Update Switch: ~
  -User Switch: ~
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
