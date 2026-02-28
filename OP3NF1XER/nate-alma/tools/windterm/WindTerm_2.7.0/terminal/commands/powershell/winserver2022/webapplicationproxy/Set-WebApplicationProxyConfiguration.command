description: Modifies the configuration settings of a Web Application Proxy server
synopses:
- Set-WebApplicationProxyConfiguration [-ADFSUrl <Uri>] [-ADFSTokenSigningCertificatePublicKey
  <String>] [-ADFSWebApplicationProxyRelyingPartyUri <Uri>] [-RegenerateAccessCookiesEncryptionKey]
  [-ConnectedServersName <String[]>] [-OAuthAuthenticationURL <Uri>] [-ConfigurationChangesPollingIntervalSec
  <UInt32>] [-UpgradeConfigurationVersion] [-ADFSTokenAcceptanceDurationSec <UInt32>]
  [-ADFSSignOutURL <Uri>] [-UserIdleTimeoutSec <UInt32>] [-UserIdleTimeoutAction <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -ADFSSignOutURL Uri: ~
  -ADFSTokenAcceptanceDurationSec UInt32: ~
  -ADFSTokenSigningCertificatePublicKey String: ~
  -ADFSUrl Uri: ~
  -ADFSWebApplicationProxyRelyingPartyUri Uri: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ConfigurationChangesPollingIntervalSec UInt32: ~
  -ConnectedServersName String[]: ~
  -OAuthAuthenticationURL Uri: ~
  -RegenerateAccessCookiesEncryptionKey Switch: ~
  -ThrottleLimit Int32: ~
  -UpgradeConfigurationVersion Switch: ~
  -UserIdleTimeoutAction String:
    values:
    - Signout
    - Reauthenticate
  -UserIdleTimeoutSec UInt32: ~
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
