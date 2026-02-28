description: Sets the Secure Boot-related UEFI variables
synopses:
- Set-SecureBootUEFI -Name <String> [-ContentFilePath <String>] [-SignedFilePath <String>]
  -Time <String> [-AppendWrite] [-OutputFilePath <String>] [<CommonParameters>]
- Set-SecureBootUEFI -Name <String> [-Content <Byte[]>] [-SignedFilePath <String>]
  -Time <String> [-AppendWrite] [-OutputFilePath <String>] [<CommonParameters>]
options:
  -AppendWrite,-append Switch: ~
  -Content Byte[]: ~
  -ContentFilePath,-f String: ~
  -Name,-n String:
    required: true
    values:
    - PK
    - KEK
    - db
    - dbx
  -OutputFilePath,-of String: ~
  -SignedFilePath,-s String: ~
  -Time,-t String:
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
