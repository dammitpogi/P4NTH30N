description: Creates session option hash table to use as input parameters for WS-Management
  cmdlets
synopses:
- New-WSManSessionOption [-ProxyAccessType <ProxyAccessType>] [-ProxyAuthentication
  <ProxyAuthentication>] [-ProxyCredential <PSCredential>] [-SkipCACheck] [-SkipCNCheck]
  [-SkipRevocationCheck] [-SPNPort <Int32>] [-OperationTimeout <Int32>] [-NoEncryption]
  [-UseUTF16] [<CommonParameters>]
options:
  -NoEncryption Switch: ~
  -OperationTimeout,-OperationTimeoutMSec System.Int32: ~
  -ProxyAccessType Microsoft.WSMan.Management.ProxyAccessType:
    values:
    - ProxyIEConfig
    - ProxyWinHttpConfig
    - ProxyAutoDetect
    - ProxyNoProxyServer
  -ProxyAuthentication Microsoft.WSMan.Management.ProxyAuthentication:
    values:
    - Negotiate
    - Basic
    - Digest
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -SkipCACheck Switch: ~
  -SkipCNCheck Switch: ~
  -SkipRevocationCheck Switch: ~
  -SPNPort System.Int32: ~
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
