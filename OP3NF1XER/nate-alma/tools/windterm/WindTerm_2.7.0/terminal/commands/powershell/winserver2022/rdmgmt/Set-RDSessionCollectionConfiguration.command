description: Modifies configuration options for an existing session collection
synopses:
- Set-RDSessionCollectionConfiguration [-CollectionName] <String> [-CollectionDescription
  <String>] [-UserGroup <String[]>] [-ClientDeviceRedirectionOptions <RDClientDeviceRedirectionOptions>]
  [-MaxRedirectedMonitors <Int32>] [-ClientPrinterRedirected <Boolean>] [-RDEasyPrintDriverEnabled
  <Boolean>] [-ClientPrinterAsDefault <Boolean>] [-TemporaryFoldersPerSession <Boolean>]
  [-BrokenConnectionAction <RDBrokenConnectionAction>] [-TemporaryFoldersDeletedOnExit
  <Boolean>] [-AutomaticReconnectionEnabled <Boolean>] [-ActiveSessionLimitMin <Int32>]
  [-DisconnectedSessionLimitMin <Int32>] [-IdleSessionLimitMin <Int32>] [-AuthenticateUsingNLA
  <Boolean>] [-EncryptionLevel <RDEncryptionLevel>] [-SecurityLayer <RDSecurityLayer>]
  [-LoadBalancing <RDSessionHostCollectionLoadBalancingInstance[]>] [-CustomRdpProperty
  <String>] [-ConnectionBroker <String>] [<CommonParameters>]
- Set-RDSessionCollectionConfiguration [-CollectionName] <String> [-DisableUserProfileDisk]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Set-RDSessionCollectionConfiguration [-CollectionName] <String> [-EnableUserProfileDisk]
  [-IncludeFolderPath <String[]>] [-ExcludeFolderPath <String[]>] [-IncludeFilePath
  <String[]>] [-ExcludeFilePath <String[]>] -MaxUserProfileDiskSizeGB <Int32> -DiskPath
  <String> [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -ActiveSessionLimitMin Int32: ~
  -AuthenticateUsingNLA Boolean: ~
  -AutomaticReconnectionEnabled Boolean: ~
  -BrokenConnectionAction RDBrokenConnectionAction:
    values:
    - None
    - Disconnect
    - LogOff
  -ClientDeviceRedirectionOptions RDClientDeviceRedirectionOptions:
    values:
    - None
    - AudioVideoPlayBack
    - AudioRecording
    - COMPort
    - PlugAndPlayDevice
    - SmartCard
    - Clipboard
    - LPTPort
    - Drive
    - TimeZone
  -ClientPrinterAsDefault Boolean: ~
  -ClientPrinterRedirected Boolean: ~
  -CollectionDescription String: ~
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -CustomRdpProperty String: ~
  -DisableUserProfileDisk Switch:
    required: true
  -DisconnectedSessionLimitMin Int32: ~
  -DiskPath String:
    required: true
  -EnableUserProfileDisk Switch:
    required: true
  -EncryptionLevel RDEncryptionLevel:
    values:
    - None
    - Low
    - ClientCompatible
    - High
    - FipsCompliant
  -ExcludeFilePath String[]: ~
  -ExcludeFolderPath String[]: ~
  -IdleSessionLimitMin Int32: ~
  -IncludeFilePath String[]: ~
  -IncludeFolderPath String[]: ~
  -LoadBalancing RDSessionHostCollectionLoadBalancingInstance[]: ~
  -MaxRedirectedMonitors Int32: ~
  -MaxUserProfileDiskSizeGB Int32:
    required: true
  -RDEasyPrintDriverEnabled Boolean: ~
  -SecurityLayer RDSecurityLayer:
    values:
    - RDP
    - Negotiate
    - SSL
  -TemporaryFoldersDeletedOnExit Boolean: ~
  -TemporaryFoldersPerSession Boolean: ~
  -UserGroup String[]: ~
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
