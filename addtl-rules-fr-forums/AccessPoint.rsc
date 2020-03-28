###############################################################################
# Topic:		Using RouterOS to VLAN your network
# Example:		Access Point
# Web:			https://forum.mikrotik.com/viewtopic.php?t=143620
# RouterOS:		6.43.13
# Date:			Mar 31, 2019
# Notes:		Start with a reset (/system reset-configuration)
# Thanks:		mkx, sindy
###############################################################################

#######################################
# Naming
#######################################

# name the device being configured
/system identity set name="AccessPoint"


#######################################
# VLAN Overview
#######################################

# 10 = BLUE
# 20 = GREEN
# 30 = RED
# 99 = BASE (MGMT) VLAN


#######################################
# WIFI Setup
#
# Example wireless settings only. Do
# NOT use in production!
#######################################

# Blue SSID
/interface wireless security-profiles set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless set [ find default-name=wlan1 ] ssid=BLUE_SSID frequency=auto mode=ap-bridge disabled=no

# Green SSID
/interface wireless security-profiles add name=GREEN_PROFILE authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless add name=wlan2 ssid=GREEN_SSID master-interface=wlan1 security-profile=GREEN_PROFILE disabled=no

# Red SSID
/interface wireless security-profiles add name=RED_PROFILE authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key="password"
/interface wireless add name=wlan3 ssid=RED_SSID master-interface=wlan1 security-profile=RED_PROFILE disabled=no


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

# Blue, Green, Red VLAN
add bridge=BR1 interface=wlan1 pvid=10
add bridge=BR1 interface=wlan2 pvid=20
add bridge=BR1 interface=wlan3 pvid=30

# egress behavior
/interface bridge vlan

# Blue, Green, Red VLAN
add bridge=BR1 untagged=wlan1 vlan-ids=10
add bridge=BR1 untagged=wlan2 vlan-ids=20
add bridge=BR1 untagged=wlan3 vlan-ids=30


#######################################
#
# -- Trunk Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Purple Trunk. Leave pvid set to default of 1
add bridge=BR1 interface=ether1

# egress behavior
/interface bridge vlan

# Purple Trunk. L2 switching only, Bridge not needed as tagged member (except BASE_VLAN)
set bridge=BR1 tagged=ether1 [find vlan-ids=10]
set bridge=BR1 tagged=ether1 [find vlan-ids=20]
set bridge=BR1 tagged=ether1 [find vlan-ids=30]
add bridge=BR1 tagged=BR1,ether1 vlan-ids=99


#######################################
# IP Addressing & Routing
#######################################

# LAN facing AP's Private IP address on a BASE_VLAN
/interface vlan add interface=BR1 name=BASE_VLAN vlan-id=99
/ip address add address=192.168.0.3/24 interface=BASE_VLAN

# The Router's IP this AP will use
/ip route add distance=1 gateway=192.168.0.1


#######################################
# IP Services
#######################################

# We have a router that will handle this. Nothing to set here.
# Attach this AP to a router configured as shown under the "RoaS" example.


#######################################
# VLAN Security
#######################################

# Only allow ingress packets without tags on Access Ports
/interface bridge port
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan1]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan2]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=wlan3]

# Only allow ingress packets WITH tags on Trunk Ports
/interface bridge port set bridge=BR1 ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=ether1]


#######################################
# MAC Server settings
#######################################

# Ensure only visibility and availability from BASE_VLAN, the MGMT network
/interface list add name=BASE
/interface list member add interface=BASE_VLAN list=BASE
/ip neighbor discovery-settings set discover-interface-list=BASE
/tool mac-server mac-winbox set allowed-interface-list=BASE
/tool mac-server set allowed-interface-list=BASE


#######################################
# Turn on VLAN mode
#######################################
/interface bridge set BR1 vlan-filtering=yes

