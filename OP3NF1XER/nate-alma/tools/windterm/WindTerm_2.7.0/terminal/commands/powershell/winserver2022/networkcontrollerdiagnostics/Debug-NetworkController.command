description: Queries a Network Controller for detailed diagnostic information
synopses:
- Debug-NetworkController [-NetworkController] <String> [-SetupDiagnostics] [[-IncludeTraces]
  <Boolean>] [[-OutputDirectory] <String>] [[-Credential] <PSCredential>] [[-RestURI]
  <String>] [[-CertificateThumbprint] <String>] [[-DeviceCredentials] <Hashtable>]
  [-ExcludeSlbState] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -DeviceCredentials Hashtable: ~
  -ExcludeSlbState Switch: ~
  -IncludeTraces Boolean: ~
  -NetworkController String:
    required: true
  -OutputDirectory String: ~
  -RestURI String: ~
  -SetupDiagnostics Switch: ~
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
