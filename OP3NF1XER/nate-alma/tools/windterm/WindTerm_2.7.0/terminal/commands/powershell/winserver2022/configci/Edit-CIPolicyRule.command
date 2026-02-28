description: This cmdlet is not supported
synopses:
- Edit-CIPolicyRule [-Id] <String> [-Name <String>] [-RType <String>] [-FileName <String>]
  [-Version <String>] [-HashPath <String>] -FilePath <String> [<CommonParameters>]
- Edit-CIPolicyRule [-Id] <String> [-Name <String>] [-RType <String>] [-Root <String>]
  [-AddEkus <String[]>] [-RemoveEkus <String[]>] [-Issuer <String>] [-Publisher <String>]
  [-OemId <String>] [-AddExceptions <String[]>] [-RemoveExceptions <String[]>] -FilePath
  <String> [<CommonParameters>]
options:
  -AddEkus String[]: ~
  -AddExceptions String[]: ~
  -FileName String: ~
  -FilePath,-f String:
    required: true
  -HashPath,-h String: ~
  -Id String:
    required: true
  -Issuer String: ~
  -Name,-n String: ~
  -OemId String: ~
  -Publisher String: ~
  -RemoveEkus String[]: ~
  -RemoveExceptions String[]: ~
  -Root String: ~
  -RType,-t String:
    values:
    - Allow
    - Deny
    - a
    - d
  -Version,-v String: ~
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
