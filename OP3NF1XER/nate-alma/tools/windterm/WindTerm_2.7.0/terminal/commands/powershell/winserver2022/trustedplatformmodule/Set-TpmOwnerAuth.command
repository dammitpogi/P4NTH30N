description: Changes the TPM owner authorization value
synopses:
- Set-TpmOwnerAuth -File <String> -NewOwnerAuthorization <String> [<CommonParameters>]
- Set-TpmOwnerAuth -File <String> -NewFile <String> [<CommonParameters>]
- Set-TpmOwnerAuth [[-OwnerAuthorization] <String>] -NewFile <String> [<CommonParameters>]
- Set-TpmOwnerAuth [[-OwnerAuthorization] <String>] -NewOwnerAuthorization <String>
  [<CommonParameters>]
options:
  -File String:
    required: true
  -NewFile,-nf String:
    required: true
  -NewOwnerAuthorization,-no String:
    required: true
  -OwnerAuthorization,-o String: ~
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
