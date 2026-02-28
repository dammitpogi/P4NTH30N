description: Tests if the local computer can function as a Host Guardian Service server
  node
synopses:
- Test-HgsServer [[-HgsDomainName] <String>] [-SafeModeAdministratorPassword <SecureString>]
  [-LogDirectory <String>] [-DatabasePath <String>] [<CommonParameters>]
- Test-HgsServer [[-HgsDomainName] <String>] [-HgsDomainCredential] <PSCredential>
  [-HgsServerIPAddress] <String> [-SafeModeAdministratorPassword <SecureString>] [-LogDirectory
  <String>] [-DatabasePath <String>] [<CommonParameters>]
options:
  -DatabasePath String: ~
  -HgsDomainCredential PSCredential:
    required: true
  -HgsDomainName String: ~
  -HgsServerIPAddress String:
    required: true
  -LogDirectory String: ~
  -SafeModeAdministratorPassword SecureString: ~
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
