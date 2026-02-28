description:
  Displays all current TCP/IP network configuration values and refreshes DHCP and DNS settings.
synopses:
  - ipconfig [/allcompartments] [/all] [/renew [<adapter>]] [/release [<adapter>]] [/renew6 [<adapter>]]
    [/release6 [<adapter>]] [/flushdns] [/displaydns] [/registerdns] [/showclassid <adapter>]
    [/setclassid <adapter> [<classID>]]
options:
  /all: Displays the full TCP/IP configuration for all adapters.
  /displaydns: Displays the contents of the DNS client resolver cache.
  /flushdns: Flushes and resets the contents of the DNS client resolver cache.
  /registerdns: Initiates manual dynamic registration for the DNS names and IP addresses that are configured at a computer.
  /release [<adapter>]: Discard the IP address configuration for either all adapters or the specific adapter.
  /release6 [<adapter>]: Discard the IPv6 address configuration for either all adapters or the specific adapter.
  /renew [<adapter>]: Renews DHCP configuration for all adapters or for a specific adapter if the adapter parameter is included.
  /renew6 [<adapter>]: Renews DHCPv6 configuration for all adapters or for a specific adapter if the adapter parameter is included.
  /setclassid <adapter>[<classID>]: Configures the DHCP class ID for a specified adapter.
  /showclassid <adapter>: Displays the DHCP class ID for a specified adapter.
  /?: Displays Help at the command prompt.