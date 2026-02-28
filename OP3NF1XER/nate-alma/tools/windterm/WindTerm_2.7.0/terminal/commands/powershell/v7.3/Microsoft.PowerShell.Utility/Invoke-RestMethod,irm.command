description: Sends an HTTP or HTTPS request to a RESTful web service
synopses:
- Invoke-RestMethod [-Method <WebRequestMethod>] [-FollowRelLink] [-MaximumFollowRelLink
  <Int32>] [-ResponseHeadersVariable <String>] [-StatusCodeVariable <String>] [-UseBasicParsing]
  [-Uri] <Uri> [-HttpVersion <Version>] [-WebSession <WebRequestSession>] [-SessionVariable
  <String>] [-AllowUnencryptedAuthentication] [-Authentication <WebAuthenticationType>]
  [-Credential <PSCredential>] [-UseDefaultCredentials] [-CertificateThumbprint <String>]
  [-Certificate <X509Certificate>] [-SkipCertificateCheck] [-SslProtocol <WebSslProtocol>]
  [-Token <SecureString>] [-UserAgent <String>] [-DisableKeepAlive] [-TimeoutSec <Int32>]
  [-Headers <IDictionary>] [-MaximumRedirection <Int32>] [-MaximumRetryCount <Int32>]
  [-RetryIntervalSec <Int32>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-ProxyUseDefaultCredentials]
  [-Body <Object>] [-Form <IDictionary>] [-ContentType <String>] [-TransferEncoding
  <String>] [-InFile <String>] [-OutFile <String>] [-PassThru] [-Resume] [-SkipHttpErrorCheck]
  [-PreserveAuthorizationOnRedirect] [-SkipHeaderValidation] [<CommonParameters>]
- Invoke-RestMethod [-Method <WebRequestMethod>] [-FollowRelLink] [-MaximumFollowRelLink
  <Int32>] [-ResponseHeadersVariable <String>] [-StatusCodeVariable <String>] [-UseBasicParsing]
  [-Uri] <Uri> [-HttpVersion <Version>] [-WebSession <WebRequestSession>] [-SessionVariable
  <String>] [-AllowUnencryptedAuthentication] [-Authentication <WebAuthenticationType>]
  [-Credential <PSCredential>] [-UseDefaultCredentials] [-CertificateThumbprint <String>]
  [-Certificate <X509Certificate>] [-SkipCertificateCheck] [-SslProtocol <WebSslProtocol>]
  [-Token <SecureString>] [-UserAgent <String>] [-DisableKeepAlive] [-TimeoutSec <Int32>]
  [-Headers <IDictionary>] [-MaximumRedirection <Int32>] [-MaximumRetryCount <Int32>]
  [-RetryIntervalSec <Int32>] -NoProxy [-Body <Object>] [-Form <IDictionary>] [-ContentType
  <String>] [-TransferEncoding <String>] [-InFile <String>] [-OutFile <String>] [-PassThru]
  [-Resume] [-SkipHttpErrorCheck] [-PreserveAuthorizationOnRedirect] [-SkipHeaderValidation]
  [<CommonParameters>]
- Invoke-RestMethod -CustomMethod <String> [-FollowRelLink] [-MaximumFollowRelLink
  <Int32>] [-ResponseHeadersVariable <String>] [-StatusCodeVariable <String>] [-UseBasicParsing]
  [-Uri] <Uri> [-HttpVersion <Version>] [-WebSession <WebRequestSession>] [-SessionVariable
  <String>] [-AllowUnencryptedAuthentication] [-Authentication <WebAuthenticationType>]
  [-Credential <PSCredential>] [-UseDefaultCredentials] [-CertificateThumbprint <String>]
  [-Certificate <X509Certificate>] [-SkipCertificateCheck] [-SslProtocol <WebSslProtocol>]
  [-Token <SecureString>] [-UserAgent <String>] [-DisableKeepAlive] [-TimeoutSec <Int32>]
  [-Headers <IDictionary>] [-MaximumRedirection <Int32>] [-MaximumRetryCount <Int32>]
  [-RetryIntervalSec <Int32>] [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [-ProxyUseDefaultCredentials]
  [-Body <Object>] [-Form <IDictionary>] [-ContentType <String>] [-TransferEncoding
  <String>] [-InFile <String>] [-OutFile <String>] [-PassThru] [-Resume] [-SkipHttpErrorCheck]
  [-PreserveAuthorizationOnRedirect] [-SkipHeaderValidation] [<CommonParameters>]
- Invoke-RestMethod -CustomMethod <String> [-FollowRelLink] [-MaximumFollowRelLink
  <Int32>] [-ResponseHeadersVariable <String>] [-StatusCodeVariable <String>] [-UseBasicParsing]
  [-Uri] <Uri> [-HttpVersion <Version>] [-WebSession <WebRequestSession>] [-SessionVariable
  <String>] [-AllowUnencryptedAuthentication] [-Authentication <WebAuthenticationType>]
  [-Credential <PSCredential>] [-UseDefaultCredentials] [-CertificateThumbprint <String>]
  [-Certificate <X509Certificate>] [-SkipCertificateCheck] [-SslProtocol <WebSslProtocol>]
  [-Token <SecureString>] [-UserAgent <String>] [-DisableKeepAlive] [-TimeoutSec <Int32>]
  [-Headers <IDictionary>] [-MaximumRedirection <Int32>] [-MaximumRetryCount <Int32>]
  [-RetryIntervalSec <Int32>] -NoProxy [-Body <Object>] [-Form <IDictionary>] [-ContentType
  <String>] [-TransferEncoding <String>] [-InFile <String>] [-OutFile <String>] [-PassThru]
  [-Resume] [-SkipHttpErrorCheck] [-PreserveAuthorizationOnRedirect] [-SkipHeaderValidation]
  [<CommonParameters>]
options:
  -AllowUnencryptedAuthentication Switch: ~
  -Authentication Microsoft.PowerShell.Commands.WebAuthenticationType:
    values:
    - None
    - Basic
    - Bearer
    - OAuth
  -Body System.Object: ~
  -Certificate System.Security.Cryptography.X509Certificates.X509Certificate: ~
  -CertificateThumbprint System.String: ~
  -ContentType System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -CustomMethod,-CM System.String:
    required: true
  -DisableKeepAlive Switch: ~
  -FollowRelLink,-FL Switch: ~
  -Form System.Collections.IDictionary: ~
  -Headers System.Collections.IDictionary: ~
  -HttpVersion System.Version: ~
  -InFile System.String: ~
  -MaximumFollowRelLink,-ML System.Int32: ~
  -MaximumRedirection System.Int32: ~
  -MaximumRetryCount System.Int32: ~
  -Method Microsoft.PowerShell.Commands.WebRequestMethod:
    values:
    - Default
    - Get
    - Head
    - Post
    - Put
    - Delete
    - Trace
    - Options
    - Merge
    - Patch
  -NoProxy Switch:
    required: true
  -OutFile System.String: ~
  -PassThru Switch: ~
  -PreserveAuthorizationOnRedirect Switch: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -ProxyUseDefaultCredentials Switch: ~
  -ResponseHeadersVariable,-RHV System.String: ~
  -Resume Switch: ~
  -RetryIntervalSec System.Int32: ~
  -SessionVariable,-SV System.String: ~
  -SkipCertificateCheck Switch: ~
  -SkipHeaderValidation Switch: ~
  -SkipHttpErrorCheck Switch: ~
  -SslProtocol Microsoft.PowerShell.Commands.WebSslProtocol:
    values:
    - Default
    - Tls
    - Tls11
    - Tls12
    - Tls13
  -StatusCodeVariable System.String: ~
  -TimeoutSec System.Int32: ~
  -Token System.Security.SecureString: ~
  -TransferEncoding System.String:
    values:
    - chunked
    - compress
    - deflate
    - gzip
    - identity
  -Uri System.Uri:
    required: true
  -UseBasicParsing Switch: ~
  -UseDefaultCredentials Switch: ~
  -UserAgent System.String: ~
  -WebSession Microsoft.PowerShell.Commands.WebRequestSession: ~
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
