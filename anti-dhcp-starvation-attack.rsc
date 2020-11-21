##
## NOTES:
## because port-security cannot be fully implemented in a hotspot interface/port
## due to its dynamic nature, dhcp-starvation could not be truly mitigated but
## slowing it down makes the dhcp-offers expire, freeing previously offered IP addresses
##
## MANIFESTATION:
## <IDENTITY> dhcp-hotspot failed to give out IP address: pool <hs-pool> is empty
##

## 1-packet/second, 2-burst (adjust as necessary)
/interface bridge filter
add action=jump chain=input jump-target=dhcp-filter packet-mark=dhcp-packet packet-type=broadcast \
  comment=dhcp-starvation-attack
add action=return chain=dhcp-filter limit=1,2
add action=drop chain=dhcp-filter

## mark dhcp-request packets
/ip firewall mangle
add action=mark-packet chain=prerouting dst-port=67 in-interface=bridge-hotspot \
	new-packet-mark=dhcp-packet passthrough=yes protocol=udp src-port=68 \
	comment=dhcp-starvation-attack
  
