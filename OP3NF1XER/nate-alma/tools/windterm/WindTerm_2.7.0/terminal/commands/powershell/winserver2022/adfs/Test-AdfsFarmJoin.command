description: Runs prerequisite checks for adding the server computer to a federation
  server farm
synopses:
- Test-AdfsFarmJoin [-CertificateThumbprint <String>] -GroupServiceAccountIdentifier
  <String> [-Credential <PSCredential>] -PrimaryComputerName <String> [-PrimaryComputerPort
  <Int32>] [<CommonParameters>]
- Test-AdfsFarmJoin [-CertificateThumbprint <String>] -ServiceAccountCredential <PSCredential>
  [-Credential <PSCredential>] -PrimaryComputerName <String> [-PrimaryComputerPort
  <Int32>] [<CommonParameters>]
- Test-AdfsFarmJoin [-CertificateThumbprint <String>] -ServiceAccountCredential <PSCredential>
  [-Credential <PSCredential>] -SQLConnectionString <String> [-FarmBehavior <Int32>]
  [<CommonParameters>]
- Test-AdfsFarmJoin [-CertificateThumbprint <String>] -GroupServiceAccountIdentifier
  <String> [-Credential <PSCredential>] -SQLConnectionString <String> [-FarmBehavior
  <Int32>] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -FarmBehavior Int32: ~
  -GroupServiceAccountIdentifier String:
    required: true
  -PrimaryComputerName String:
    required: true
  -PrimaryComputerPort Int32: ~
  -ServiceAccountCredential PSCredential:
    required: true
  -SQLConnectionString String:
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
