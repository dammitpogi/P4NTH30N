description: Modifies settings for the specified iSCSI target
synopses:
- Set-IscsiServerTarget [-TargetName] <String> [-TargetIqn <Iqn>] [-Description <String>]
  [-Enable <Boolean>] [-EnableChap <Boolean>] [-Chap <PSCredential>] [-EnableReverseChap
  <Boolean>] [-ReverseChap <PSCredential>] [-MaxReceiveDataSegmentLength <Int32>]
  [-FirstBurstLength <Int32>] [-MaxBurstLength <Int32>] [-ReceiveBufferCount <Int32>]
  [-EnforceIdleTimeoutDetection <Boolean>] [-InitiatorIds <InitiatorId[]>] [-PassThru]
  [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Set-IscsiServerTarget -InputObject <IscsiServerTarget> [-TargetIqn <Iqn>] [-Description
  <String>] [-Enable <Boolean>] [-EnableChap <Boolean>] [-Chap <PSCredential>] [-EnableReverseChap
  <Boolean>] [-ReverseChap <PSCredential>] [-MaxReceiveDataSegmentLength <Int32>]
  [-FirstBurstLength <Int32>] [-MaxBurstLength <Int32>] [-ReceiveBufferCount <Int32>]
  [-EnforceIdleTimeoutDetection <Boolean>] [-InitiatorIds <InitiatorId[]>] [-PassThru]
  [-ComputerName <String>] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -Chap PSCredential: ~
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Description String: ~
  -Enable Boolean: ~
  -EnableChap Boolean: ~
  -EnableReverseChap Boolean: ~
  -EnforceIdleTimeoutDetection Boolean: ~
  -FirstBurstLength Int32: ~
  -InitiatorIds InitiatorId[]: ~
  -InputObject IscsiServerTarget:
    required: true
  -MaxBurstLength Int32: ~
  -MaxReceiveDataSegmentLength Int32: ~
  -PassThru Switch: ~
  -ReceiveBufferCount Int32: ~
  -ReverseChap PSCredential: ~
  -TargetIqn Iqn: ~
  -TargetName String:
    required: true
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
