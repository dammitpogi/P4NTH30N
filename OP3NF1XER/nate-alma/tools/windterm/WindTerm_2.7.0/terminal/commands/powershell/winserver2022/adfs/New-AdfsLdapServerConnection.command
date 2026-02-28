description: Creates a connection object
synopses:
- New-AdfsLdapServerConnection [-HostName] <String> [-Port <Int32>] [-SslMode <LdapSslMode>]
  [-AuthenticationMethod <LdapAuthenticationMethod>] [-Credential <PSCredential>]
  [<CommonParameters>]
options:
  -AuthenticationMethod LdapAuthenticationMethod:
    values:
    - Basic
    - Kerberos
    - Negotiate
  -Credential PSCredential: ~
  -HostName String:
    required: true
  -Port Int32: ~
  -SslMode LdapSslMode:
    values:
    - None
    - Ssl
    - Tls
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
