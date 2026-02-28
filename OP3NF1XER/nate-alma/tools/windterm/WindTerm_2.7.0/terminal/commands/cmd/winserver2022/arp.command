description:
  Displays and modifies entries in the Address Resolution Protocol (ARP) cache.
synopses:
  - arp [/a [<inetaddr>] [/n <ifaceaddr>]] [/g [<inetaddr>] [-n <ifaceaddr>]] [/d <inetaddr> [<ifaceaddr>]] [/s <inetaddr> <etheraddr> [<ifaceaddr>]]
options:
  /a [<inetaddr>]: Displays current arp cache tables for all interfaces.
  /g [<inetaddr>]: Identical to /a.
  /n <ifaceaddr>: The IP address assigned to the interface
  /d <inetaddr> [<ifaceaddr>]: Deletes an entry with a specific IP address.
  /s <inetaddr> <etheraddr> [<ifaceaddr>]: Adds a static entry to the arp cache that resolves the IP address "inetaddr" to the physical address "etheraddr".
  /?: Displays help at the command prompt.