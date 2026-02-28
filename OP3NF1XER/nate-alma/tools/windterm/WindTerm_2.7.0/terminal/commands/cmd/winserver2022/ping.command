description:
  Verifies IP-level connectivity to another TCP/IP computer.
synopses:
  - ping [/t] [/a] [/n <count>] [/l <size>] [/f] [/I <TTL>] [/v <TOS>] [/r <count>]
    [/s <count>] [/j <hostlist> | /k <hostlist>] [/w <timeout>] [/R] [/S <Srcaddr>]
    [/4] [/6] <targetname>
options:
  /t: Specifies ping continue sending echo Request messages to the destination until interrupted.
  /a: Specifies reverse name resolution be performed on the destination IP address.
  /n <count>: Specifies the number of echo Request messages be sent. The default is 4.
  /l <size>: Specifies the length, in bytes, of the Data field in the echo Request messages.
  /f: Specifies that echo Request messages are sent with the Do not Fragment flag in the IP header set to 1 (available on IPv4 only).
  /I <TTL>: Specifies the value of the Time To Live (TTL) field in the IP header.
  /v <TOS>: Specifies the value of the Type Of Service (TOS) field in the IP header.
  /r <count>: Specifies the Record Route option in the IP header.
  /s <count>: Specifies that the Internet timestamp option in the IP header.
  /j <hostlist>: Specifies the echo Request messages use the Loose Source Route option in the IP header (available on IPv4 only).
  /k <hostlist>: Specifies the echo Request messages use the Strict Source Route option in the IP header (available on IPv4 only).
  /w <timeout>: Specifies the amount of time, in milliseconds, to wait for the echo Reply message corresponding to a given echo Request message.
  /R: Specifies the round-trip path is traced (available on IPv6 only).
  /S <Srcaddr>: Specifies the source address to use (available on IPv6 only).
  /4: Specifies IPv4 used to ping.
  /6: Specifies IPv6 used to ping.
  /?: Displays help at the command prompt.