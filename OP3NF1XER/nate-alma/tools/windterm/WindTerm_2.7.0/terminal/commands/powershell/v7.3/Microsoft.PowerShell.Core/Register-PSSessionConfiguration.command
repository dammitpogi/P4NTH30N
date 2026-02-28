description: Creates and registers a new session configuration
synopses:
- Register-PSSessionConfiguration [-ProcessorArchitecture <String>] [-Name] <String>
  [-ApplicationBase <String>] [-RunAsCredential <PSCredential>] [-ThreadApartmentState
  <ApartmentState>] [-ThreadOptions <PSThreadOptions>] [-AccessMode <PSSessionConfigurationAccessMode>]
  [-UseSharedProcess] [-StartupScript <String>] [-MaximumReceivedDataSizePerCommandMB
  <Double>] [-MaximumReceivedObjectSizeMB <Double>] [-SecurityDescriptorSddl <String>]
  [-ShowSecurityDescriptorUI] [-Force] [-NoServiceRestart] [-PSVersion <Version>]
  [-SessionTypeOption <PSSessionTypeOption>] [-TransportOption <PSTransportOption>]
  [-ModulesToImport <Object[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Register-PSSessionConfiguration [-ProcessorArchitecture <String>] [-Name] <String>
  [-AssemblyName] <String> [-ApplicationBase <String>] [-ConfigurationTypeName] <String>
  [-RunAsCredential <PSCredential>] [-ThreadApartmentState <ApartmentState>] [-ThreadOptions
  <PSThreadOptions>] [-AccessMode <PSSessionConfigurationAccessMode>] [-UseSharedProcess]
  [-StartupScript <String>] [-MaximumReceivedDataSizePerCommandMB <Double>] [-MaximumReceivedObjectSizeMB
  <Double>] [-SecurityDescriptorSddl <String>] [-ShowSecurityDescriptorUI] [-Force]
  [-NoServiceRestart] [-PSVersion <Version>] [-SessionTypeOption <PSSessionTypeOption>]
  [-TransportOption <PSTransportOption>] [-ModulesToImport <Object[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Register-PSSessionConfiguration [-ProcessorArchitecture <String>] [-Name] <String>
  [-RunAsCredential <PSCredential>] [-ThreadApartmentState <ApartmentState>] [-ThreadOptions
  <PSThreadOptions>] [-AccessMode <PSSessionConfigurationAccessMode>] [-UseSharedProcess]
  [-StartupScript <String>] [-MaximumReceivedDataSizePerCommandMB <Double>] [-MaximumReceivedObjectSizeMB
  <Double>] [-SecurityDescriptorSddl <String>] [-ShowSecurityDescriptorUI] [-Force]
  [-NoServiceRestart] [-TransportOption <PSTransportOption>] -Path <String> [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AccessMode System.Management.Automation.Runspaces.PSSessionConfigurationAccessMode:
    values:
    - Disabled
    - Local
    - Remote
  -ApplicationBase System.String: ~
  -AssemblyName System.String:
    required: true
  -ConfigurationTypeName System.String:
    required: true
  -Force Switch: ~
  -MaximumReceivedDataSizePerCommandMB System.Nullable`1[System.Double]: ~
  -MaximumReceivedObjectSizeMB System.Nullable`1[System.Double]: ~
  -ModulesToImport System.Object[]: ~
  -Name System.String:
    required: true
  -NoServiceRestart Switch: ~
  -Path System.String:
    required: true
  -ProcessorArchitecture,-PA System.String:
    values:
    - x86
    - amd64
  -PSVersion,-PowerShellVersion System.Version: ~
  -RunAsCredential System.Management.Automation.PSCredential: ~
  -SecurityDescriptorSddl System.String: ~
  -SessionTypeOption System.Management.Automation.PSSessionTypeOption: ~
  -ShowSecurityDescriptorUI Switch: ~
  -StartupScript System.String: ~
  -ThreadApartmentState System.Threading.ApartmentState: ~
  -ThreadOptions System.Management.Automation.Runspaces.PSThreadOptions:
    values:
    - Default
    - UseNewThread
    - ReuseThread
    - UseCurrentThread
  -TransportOption System.Management.Automation.PSTransportOption: ~
  -UseSharedProcess Switch: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
