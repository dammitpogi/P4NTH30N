description: Gets guarded hosts with TPM 2.0 from the Attestation service HGS
synopses:
- Get-HgsAttestationTpmHost [-Name <String>] [-PolicyVersion <PolicyVersion>] [-Stage]
  [<CommonParameters>]
- Get-HgsAttestationTpmHost [-Name <String>] -Path <String> [-PolicyVersion <PolicyVersion>]
  [-Stage] [<CommonParameters>]
- Get-HgsAttestationTpmHost [-Name <String>] -Xml <XmlDocument> [-PolicyVersion <PolicyVersion>]
  [-Stage] [<CommonParameters>]
options:
  -Name String: ~
  -Path,-FilePath String:
    required: true
  -PolicyVersion PolicyVersion:
    values:
    - None
    - PolicyVersion1503
    - PolicyVersion1704
  -Stage Switch: ~
  -Xml XmlDocument:
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
