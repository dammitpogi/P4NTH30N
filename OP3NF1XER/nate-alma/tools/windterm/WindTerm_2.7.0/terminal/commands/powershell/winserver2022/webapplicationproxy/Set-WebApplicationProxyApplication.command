description: Modifies settings of a web application published through Web Application
  Proxy
synopses:
- Set-WebApplicationProxyApplication [-ClientCertificateAuthenticationBindingMode
  <String>] [-BackendServerCertificateValidation <String>] [-ExternalUrl <String>]
  [-ExternalCertificateThumbprint <String>] [-BackendServerUrl <String>] [-DisableTranslateUrlInRequestHeaders]
  [-EnableHTTPRedirect] [-ADFSUserCertificateStore <String>] [-DisableHttpOnlyCookieProtection]
  [-PersistentAccessCookieExpirationTimeSec <UInt32>] [-EnableSignOut] [-BackendServerAuthenticationMode
  <String>] [-DisableTranslateUrlInResponseHeaders] [-BackendServerAuthenticationSPN
  <String>] [-Name <String>] [-UseOAuthAuthentication] [-InactiveTransactionsTimeoutSec
  <UInt32>] [-ClientCertificatePreauthenticationThumbprint <String>] [-ID] <Guid>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -ADFSUserCertificateStore String: ~
  -AsJob Switch: ~
  -BackendServerAuthenticationMode String: ~
  -BackendServerAuthenticationSPN,-SPN String: ~
  -BackendServerCertificateValidation String:
    values:
    - None
    - ValidateCertificate
  -BackendServerUrl,-BackendUrl String: ~
  -CimSession,-Session CimSession[]: ~
  -ClientCertificateAuthenticationBindingMode String:
    values:
    - None
    - ValidateCertificate
  -ClientCertificatePreauthenticationThumbprint String: ~
  -DisableHttpOnlyCookieProtection Switch: ~
  -DisableTranslateUrlInRequestHeaders Switch: ~
  -DisableTranslateUrlInResponseHeaders Switch: ~
  -EnableHTTPRedirect Switch: ~
  -EnableSignOut Switch: ~
  -ExternalCertificateThumbprint,-ExternalCert String: ~
  -ExternalUrl String: ~
  -ID,-ApplicationID Guid:
    required: true
  -InactiveTransactionsTimeoutSec UInt32: ~
  -Name,-FriendlyName String: ~
  -PersistentAccessCookieExpirationTimeSec UInt32: ~
  -ThrottleLimit Int32: ~
  -UseOAuthAuthentication Switch: ~
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
