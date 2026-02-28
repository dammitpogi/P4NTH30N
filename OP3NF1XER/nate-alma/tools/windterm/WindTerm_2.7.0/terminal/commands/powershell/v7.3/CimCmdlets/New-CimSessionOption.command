description: Specifies advanced options for the New-CimSession cmdlet
synopses:
- New-CimSessionOption [-Protocol] <ProtocolType> [-UICulture <CultureInfo>] [-Culture
  <CultureInfo>] [<CommonParameters>]
- New-CimSessionOption [-NoEncryption] [-SkipCACheck] [-SkipCNCheck] [-SkipRevocationCheck]
  [-EncodePortInServicePrincipalName] [-Encoding <PacketEncoding>] [-HttpPrefix <Uri>]
  [-MaxEnvelopeSizeKB <UInt32>] [-ProxyAuthentication <PasswordAuthenticationMechanism>]
  [-ProxyCertificateThumbprint <String>] [-ProxyCredential <PSCredential>] [-ProxyType
  <ProxyType>] [-UseSsl] [-UICulture <CultureInfo>] [-Culture <CultureInfo>] [<CommonParameters>]
- New-CimSessionOption [-Impersonation <ImpersonationType>] [-PacketIntegrity] [-PacketPrivacy]
  [-UICulture <CultureInfo>] [-Culture <CultureInfo>] [<CommonParameters>]
options:
  -Culture System.Globalization.CultureInfo: ~
  -EncodePortInServicePrincipalName Switch: ~
  -Encoding Microsoft.Management.Infrastructure.Options.PacketEncoding:
    values:
    - Default
    - Utf8
    - Utf16
  -HttpPrefix System.Uri: ~
  -Impersonation Microsoft.Management.Infrastructure.Options.ImpersonationType:
    values:
    - Default
    - None
    - Identify
    - Impersonate
    - Delegate
  -MaxEnvelopeSizeKB System.UInt32: ~
  -NoEncryption Switch: ~
  -PacketIntegrity Switch: ~
  -PacketPrivacy Switch: ~
  -Protocol Microsoft.Management.Infrastructure.CimCmdlets.ProtocolType:
    required: true
    values:
    - Dcom
    - Default
    - Wsman
  -ProxyAuthentication Microsoft.Management.Infrastructure.Options.PasswordAuthenticationMechanism:
    values:
    - Default
    - Digest
    - Negotiate
    - Basic
    - Kerberos
    - NtlmDomain
    - CredSsp
  -ProxyCertificateThumbprint System.String: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -ProxyType Microsoft.Management.Infrastructure.Options.ProxyType:
    values:
    - None
    - WinHttp
    - Auto
    - InternetExplorer
  -SkipCACheck Switch: ~
  -SkipCNCheck Switch: ~
  -SkipRevocationCheck Switch: ~
  -UICulture System.Globalization.CultureInfo: ~
  -UseSsl Switch: ~
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
