description: Gets IP network configuration
synopses:
- Get-NetIPConfiguration [[-InterfaceAlias] <String>] [-AllCompartments] [-CompartmentId
  <Int32>] [-Detailed] [-CimSession <CimSession>] [<CommonParameters>]
- Get-NetIPConfiguration -InterfaceIndex <Int32> [-AllCompartments] [-CompartmentId
  <Int32>] [-Detailed] [-CimSession <CimSession>] [<CommonParameters>]
- Get-NetIPConfiguration [-All] [-AllCompartments] [-CompartmentId <Int32>] [-Detailed]
  [-CimSession <CimSession>] [<CommonParameters>]
options:
  -InterfaceAlias,-ifAlias String: ~
  -InterfaceIndex,-ifIndex Int32:
    required: true
  -All,-IncludeAllInterfaces Switch:
    required: true
  -AllCompartments,-IncludeAllCompartments Switch: ~
  -CompartmentId Int32: ~
  -Detailed Switch: ~
  -CimSession,-PSComputerName,-ComputerName CimSession: ~
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
