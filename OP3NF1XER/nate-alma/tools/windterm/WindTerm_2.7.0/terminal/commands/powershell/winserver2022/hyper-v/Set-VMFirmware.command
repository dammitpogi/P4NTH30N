description: Sets the firmware configuration of a virtual machine
synopses:
- Set-VMFirmware [-CimSession <CimSession[]>] [-ComputerName <String[]>] [-Credential
  <PSCredential[]>] [-VMName] <String[]> [-BootOrder <VMComponentObject[]>] [-FirstBootDevice
  <VMComponentObject>] [-EnableSecureBoot <OnOffState>] [-SecureBootTemplate <String>]
  [-SecureBootTemplateId <Guid>] [-PreferredNetworkBootProtocol <IPProtocolPreference>]
  [-ConsoleMode <ConsoleModeType>] [-PauseAfterBootFailure <OnOffState>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFirmware [-VM] <VirtualMachine[]> [-BootOrder <VMComponentObject[]>] [-FirstBootDevice
  <VMComponentObject>] [-EnableSecureBoot <OnOffState>] [-SecureBootTemplate <String>]
  [-SecureBootTemplateId <Guid>] [-PreferredNetworkBootProtocol <IPProtocolPreference>]
  [-ConsoleMode <ConsoleModeType>] [-PauseAfterBootFailure <OnOffState>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMFirmware [-VMFirmware] <VMFirmware[]> [-BootOrder <VMComponentObject[]>] [-FirstBootDevice
  <VMComponentObject>] [-EnableSecureBoot <OnOffState>] [-SecureBootTemplate <String>]
  [-SecureBootTemplateId <Guid>] [-PreferredNetworkBootProtocol <IPProtocolPreference>]
  [-ConsoleMode <ConsoleModeType>] [-PauseAfterBootFailure <OnOffState>] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BootOrder VMComponentObject[]: ~
  -CimSession CimSession[]: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -ConsoleMode ConsoleModeType:
    values:
    - Default
    - COM1
    - COM2
    - None
  -Credential PSCredential[]: ~
  -EnableSecureBoot OnOffState:
    values:
    - On
    - Off
  -FirstBootDevice VMComponentObject: ~
  -Passthru Switch: ~
  -PauseAfterBootFailure OnOffState:
    values:
    - On
    - Off
  -PreferredNetworkBootProtocol IPProtocolPreference:
    values:
    - IPv4
    - IPv6
  -SecureBootTemplate String: ~
  -SecureBootTemplateId Guid: ~
  -VM VirtualMachine[]:
    required: true
  -VMFirmware VMFirmware[]:
    required: true
  -VMName String[]:
    required: true
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
