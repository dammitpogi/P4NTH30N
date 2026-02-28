description: Formats certificates or hashes into a content object that is returned
  and creates a file that is ready to be signed
synopses:
- Format-SecureBootUEFI -Name <String> -SignatureOwner <Guid> -CertificateFilePath
  <String[]> [-FormatWithCert] [-SignableFilePath <String>] [-Time <String>] [-AppendWrite]
  [-ContentFilePath <String>] [<CommonParameters>]
- Format-SecureBootUEFI -Name <String> -SignatureOwner <Guid> -Hash <String[]> -Algorithm
  <String> [-SignableFilePath <String>] [-Time <String>] [-AppendWrite] [-ContentFilePath
  <String>] [<CommonParameters>]
- Format-SecureBootUEFI -Name <String> [-Delete] [-SignableFilePath <String>] [-Time
  <String>] [<CommonParameters>]
options:
  -Algorithm,-alg String:
    required: true
    values:
    - sha1
    - sha256
    - sha384
    - sha512
  -AppendWrite,-append Switch: ~
  -CertificateFilePath,-c String[]:
    required: true
  -ContentFilePath,-f String: ~
  -Delete,-del Switch:
    required: true
  -FormatWithCert,-cert Switch: ~
  -Hash,-h String[]:
    required: true
  -Name,-n String:
    required: true
    values:
    - PK
    - KEK
    - db
    - dbx
  -SignableFilePath,-s String: ~
  -SignatureOwner,-g Guid:
    required: true
  -Time,-t String: ~
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
