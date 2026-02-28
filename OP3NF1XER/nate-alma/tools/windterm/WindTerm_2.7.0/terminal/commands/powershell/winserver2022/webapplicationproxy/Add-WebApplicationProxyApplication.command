description: Publishes a web application through Web Application Proxy
synopses:
- Add-WebApplicationProxyApplication [-Name] <String> [-ExternalPreauthentication
  <String>] [-ClientCertificateAuthenticationBindingMode <String>] [-BackendServerCertificateValidation
  <String>] -ExternalUrl <String> [-ExternalCertificateThumbprint <String>] [-EnableSignOut]
  [-InactiveTransactionsTimeoutSec <UInt32>] [-ClientCertificatePreauthenticationThumbprint
  <String>] [-EnableHTTPRedirect] [-ADFSUserCertificateStore <String>] [-DisableHttpOnlyCookieProtection]
  [-PersistentAccessCookieExpirationTimeSec <UInt32>] -BackendServerUrl <String> [-DisableTranslateUrlInRequestHeaders]
  [-DisableTranslateUrlInResponseHeaders] [-BackendServerAuthenticationSPN <String>]
  [-ADFSRelyingPartyName <String>] [-UseOAuthAuthentication] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -ADFSRelyingPartyName,-RPName String: ~
  -ADFSUserCertificateStore String: ~
  -AsJob Switch: ~
  -BackendServerAuthenticationSPN,-SPN String: ~
  -BackendServerCertificateValidation String:
    values:
    - None
    - ValidateCertificate
  -BackendServerUrl,-BackendUrl String:
    required: true
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
  -ExternalPreauthentication,-PreAuthN String:
    values:
    - PassThrough
    - ADFS
    - ClientCertificate
    - ADFSforRichClients
    - ADFSforOAuth
    - ADFSforBrowsersAndOffice
  -ExternalUrl String:
    required: true
  -InactiveTransactionsTimeoutSec UInt32: ~
  -Name,-FriendlyName String:
    required: true
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
