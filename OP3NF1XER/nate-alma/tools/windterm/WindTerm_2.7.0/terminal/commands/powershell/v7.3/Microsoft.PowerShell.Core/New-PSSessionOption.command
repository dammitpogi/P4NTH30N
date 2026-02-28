description: Creates an object that contains advanced options for a PSSession
synopses:
- New-PSSessionOption [-MaximumRedirection <Int32>] [-NoCompression] [-NoMachineProfile]
  [-Culture <CultureInfo>] [-UICulture <CultureInfo>] [-MaximumReceivedDataSizePerCommand
  <Int32>] [-MaximumReceivedObjectSize <Int32>] [-OutputBufferingMode <OutputBufferingMode>]
  [-MaxConnectionRetryCount <Int32>] [-ApplicationArguments <PSPrimitiveDictionary>]
  [-OpenTimeout <Int32>] [-CancelTimeout <Int32>] [-IdleTimeout <Int32>] [-ProxyAccessType
  <ProxyAccessType>] [-ProxyAuthentication <AuthenticationMechanism>] [-ProxyCredential
  <PSCredential>] [-SkipCACheck] [-SkipCNCheck] [-SkipRevocationCheck] [-OperationTimeout
  <Int32>] [-NoEncryption] [-UseUTF16] [-IncludePortInSPN] [<CommonParameters>]
options:
  -ApplicationArguments System.Management.Automation.PSPrimitiveDictionary: ~
  -CancelTimeout,-CancelTimeoutMSec System.Int32: ~
  -Culture System.Globalization.CultureInfo: ~
  -IdleTimeout,-IdleTimeoutMSec System.Int32: ~
  -IncludePortInSPN Switch: ~
  -MaxConnectionRetryCount System.Int32: ~
  -MaximumReceivedDataSizePerCommand System.Int32: ~
  -MaximumReceivedObjectSize System.Int32: ~
  -MaximumRedirection System.Int32: ~
  -NoCompression Switch: ~
  -NoEncryption Switch: ~
  -NoMachineProfile Switch: ~
  -OpenTimeout,-OpenTimeoutMSec System.Int32: ~
  -OperationTimeout,-OperationTimeoutMSec System.Int32: ~
  -OutputBufferingMode System.Management.Automation.Runspaces.OutputBufferingMode:
    values:
    - None
    - Drop
    - Block
  -ProxyAccessType System.Management.Automation.Remoting.ProxyAccessType:
    values:
    - None
    - IEConfig
    - WinHttpConfig
    - AutoDetect
    - NoProxyServer
  -ProxyAuthentication System.Management.Automation.Runspaces.AuthenticationMechanism:
    values:
    - Default
    - Basic
    - Negotiate
    - NegotiateWithImplicitCredential
    - Credssp
    - Digest
    - Kerberos
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -SkipCACheck Switch: ~
  -SkipCNCheck Switch: ~
  -SkipRevocationCheck Switch: ~
  -UICulture System.Globalization.CultureInfo: ~
  -UseUTF16 Switch: ~
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
