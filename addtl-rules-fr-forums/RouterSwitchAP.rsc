###############################################################################
# Topic:		Using RouterOS to VLAN your network
# Example:		Router-Switch-AP all in one device
# Web:			https://forum.mikrotik.com/viewtopic.php?t=143620
# RouterOS:		6.43.12
# Date:			Mar 28, 2019
# Notes:		Start with a reset (/system reset-configuration)
# Thanks:		mkx, sindy
###############################################################################

#######################################
# Naming
#######################################

# name the device being configured
/system identity set name="RouterSwitchAP"


#######################################
# VLAN Overview
#######################################

# 10 = BLUE
# 20 = GREEN
# 99 = BASE (MGMT) VLAN


#######################################
# WIFI Setup
#
# Example wireless settings only. Do
# NOT use in production!
#######################################

# Blue SSID
/interface wireless security-profiles set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless set [ find default-name=wlan1 ] ssid=BLUE frequency=auto mode=ap-bridge disabled=no

# Green SSID
/interface wireless security-profiles add name=guest authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless add name=wlan2 ssid=GREEN master-interface=wlan1 security-profile=guest disabled=no

# Optional: BASE SSID, admin level access to Winbox the device. Use a local ethernet port if preferred.
/interface wireless security-profiles add name=Base authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless add name=wlan3 ssid=BASE master-interface=wlan1 security-profile=Base disabled=no


#######################################
# Bridge
#######################################

# create one bridge, set VLAN mode off while we configure
/interface bridge add name=BR1 protocol-mode=none vlan-filtering=no


#######################################
#
# -- Access Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Blue VLAN
add bridge=BR1 interface=ether2 pvid=10
add bridge=BR1 interface=ether3 pvid=10
add bridge=BR1 interface=wlan1  pvid=10

# Green VLAN
add bridge=BR1 interface=ether4 pvid=20
add bridge=BR1 interface=wlan2  pvid=20

# BASE_VLAN
add bridge=BR1 interface=wlan3 pvid=99

#
# egress behavior
#
/interface bridge vlan

# Blue, Green, & BASE VLAN
add bridge=BR1 untagged=ether2,ether3,wlan1 vlan-ids=10
add bridge=BR1 untagged=ether4,wlan2 vlan-ids=20
add bridge=BR1 untagged=wlan3 vlan-ids=99

# L3 switching so Bridge must be a tagged member
set bridge=BR1 tagged=BR1 [find vlan-ids=10]
set bridge=BR1 tagged=BR1 [find vlan-ids=20]
set bridge=BR1 tagged=BR1 [find vlan-ids=99]


#######################################
# IP Addressing & Routing
#######################################

# LAN facing router's IP address on the BASE_VLAN
/interface vlan add interface=BR1 name=BASE_VLAN vlan-id=99
/ip address add address=192.168.0.1/24 interface=BASE_VLAN

# DNS server, set to cache for LAN
/ip dns set allow-remote-requests=yes servers="9.9.9.9"

# Yellow WAN facing port with IP Address provided by ISP
/ip address add interface=ether1 address=a.a.a.a/aa network=a.a.a.0

# router's gateway provided by ISP
/ip route add distance=1 gateway=b.b.b.b


#######################################
# IP Services
#######################################

# Blue VLAN interface creation, IP assignment, and DHCP service
/interface vlan add interface=BR1 name=BLUE_VLAN vlan-id=10
/ip address add interface=BLUE_VLAN address=10.0.10.1/24
/ip pool add name=BLUE_POOL ranges=10.0.10.2-10.0.10.254
/ip dhcp-server add address-pool=BLUE_POOL interface=BLUE_VLAN name=BLUE_DHCP disabled=no
/ip dhcp-server network add address=10.0.10.0/24 dns-server=192.168.0.1 gateway=10.0.10.1

# Green VLAN interface creation, IP assignment, and DHCP service
/interface vlan add interface=BR1 name=GREEN_VLAN vlan-id=20
/ip address add interface=GREEN_VLAN address=10.0.20.1/24
/ip pool add name=GREEN_POOL ranges=10.0.20.2-10.0.20.254
/ip dhcp-server add address-pool=GREEN_POOL interface=GREEN_VLAN name=GREEN_DHCP disabled=no
/ip dhcp-server network add address=10.0.20.0/24 dns-server=192.168.0.1 gateway=10.0.20.1

# Optional: Create a DHCP instance for BASE_VLAN. Convenience feature for an admin.
# /ip pool add name=BASE_POOL ranges=192.168.0.10-192.168.0.254
# /ip dhcp-server add address-pool=BASE_POOL interface=BASE_VLAN name=BASE_DHCP disabled=no
# /ip dhcp-server network add address=192.168.0.0/24 dns-server=192.168.0.1 gateway=192.168.0.1


#######################################
# Firewalling & NAT
# A good firewall for WAN. Up to you
# about how you want LAN to behave.
#######################################

# Use MikroTik's "list" feature for easy rule matchmaking.

/interface list add name=WAN
/interface list add name=VLAN
/interface list add name=BASE

/interface list member
add interface=ether1     list=WAN
add interface=BASE_VLAN  list=VLAN
add interface=BLUE_VLAN  list=VLAN
add interface=GREEN_VLAN list=VLAN
add interface=BASE_VLAN  list=BASE

# VLAN aware firewall. Order is important.
/ip firewall filter


##################
# INPUT CHAIN
##################
add chain=input action=accept connection-state=established,related comment="Allow Estab & Related"

# Allow VLANs to access router services like DNS, Winbox. Naturally, you SHOULD make it more granular.
add chain=input action=accept in-interface-list=VLAN comment="Allow VLAN"

# Allow BASE_VLAN full access to the device for Winbox, etc.
add chain=input action=accept in-interface=BASE_VLAN comment="Allow Base_Vlan Full Access"

add chain=input action=drop comment="Drop"

##################
# FORWARD CHAIN
##################
add chain=forward action=accept connection-state=established,related comment="Allow Estab & Related"

# Allow all VLANs to access the Internet only, NOT each other
add chain=forward action=accept connection-state=new in-interface-list=VLAN out-interface-list=WAN comment="VLAN Internet Access only"

add chain=forward action=drop comment="Drop"

##################
# NAT
##################
/ip firewall nat add chain=srcnat action=masquerade out-interface-list=WAN comment="Default masquerade"


#######################################
# VLAN Security
#######################################

# Only allow ingress packets without tags on Access Ports
/interface bridge port
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether2]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether3]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether4]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan1]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan2]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan3]


#######################################
# MAC Server settings
#######################################

# Ensure only visibility and availability from BASE_VLAN, the MGMT network
/ip neighbor discovery-settings set discover-interface-list=BASE
/tool mac-server mac-winbox set allowed-interface-list=BASE
/tool mac-server set allowed-interface-list=BASE


#######################################
# Turn on VLAN mode
#######################################
/interface bridge set BR1 vlan-filtering=yes

