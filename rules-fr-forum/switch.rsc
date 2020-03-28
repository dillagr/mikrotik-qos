###############################################################################
# Topic:		Using RouterOS to VLAN your network
# Example:		Switch with a separate router (RoaS)
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
/system identity set name="Switch"


#######################################
# VLAN Overview
#######################################

# 10 = BLUE
# 20 = GREEN
# 30 = RED
# 99 = BASE (MGMT) VLAN


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
add bridge=BR1 interface=ether1 pvid=10
add bridge=BR1 interface=ether2 pvid=10
add bridge=BR1 interface=ether3 pvid=10
add bridge=BR1 interface=ether4 pvid=10
add bridge=BR1 interface=ether5 pvid=10
add bridge=BR1 interface=ether6 pvid=10
add bridge=BR1 interface=ether7 pvid=10
add bridge=BR1 interface=ether8 pvid=10

# Green VLAN
add bridge=BR1 interface=ether9  pvid=20
add bridge=BR1 interface=ether10 pvid=20
add bridge=BR1 interface=ether11 pvid=20
add bridge=BR1 interface=ether12 pvid=20
add bridge=BR1 interface=ether13 pvid=20
add bridge=BR1 interface=ether14 pvid=20
add bridge=BR1 interface=ether15 pvid=20
add bridge=BR1 interface=ether16 pvid=20

# Red VLAN
add bridge=BR1 interface=ether17 pvid=30
add bridge=BR1 interface=ether18 pvid=30
add bridge=BR1 interface=ether19 pvid=30
add bridge=BR1 interface=ether20 pvid=30
add bridge=BR1 interface=ether21 pvid=30
add bridge=BR1 interface=ether22 pvid=30
add bridge=BR1 interface=ether23 pvid=30
add bridge=BR1 interface=ether24 pvid=30

# egress behavior
/interface bridge vlan

# Blue, Green, Red VLAN
add bridge=BR1 untagged=ether1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=10
add bridge=BR1 untagged=ether9,ether10,ether11,ether12,ether13,ether14,ether15,ether16 vlan-ids=20
add bridge=BR1 untagged=ether17,ether18,ether19,ether20,ether21,ether22,ether23,ether24 vlan-ids=30


#######################################
#
# -- Trunk Ports --
#
#######################################

# ingress behavior
/interface bridge port

# Purple Trunk. Leave pvid set to default of 1
add bridge=BR1 interface=sfp1
add bridge=BR1 interface=sfp2

# egress behavior
/interface bridge vlan

# Purple Trunk. L2 switching only, Bridge not needed as tagged member (except BASE_VLAN)
set bridge=BR1 tagged=sfp1,sfp2 [find vlan-ids=10]
set bridge=BR1 tagged=sfp1,sfp2 [find vlan-ids=20]
set bridge=BR1 tagged=sfp1,sfp2 [find vlan-ids=30]
add bridge=BR1 tagged=BR1,sfp1,sfp2 vlan-ids=99


#######################################
# IP Addressing & Routing
#######################################

# LAN facing Switch's IP address on a BASE_VLAN
/interface vlan add interface=BR1 name=BASE_VLAN vlan-id=99
/ip address add address=192.168.0.2/24 interface=BASE_VLAN

# The Router's IP this switch will use
/ip route add distance=1 gateway=192.168.0.1


#######################################
# IP Services
#######################################
# We have a router that will handle this. Nothing to set here.


#######################################
# VLAN Security
#######################################

# Only allow ingress packets without tags on Access Ports
/interface bridge port
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether1]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether2]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether3]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether4]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether5]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether6]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether7]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether8]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether9]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether10]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether11]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether12]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether13]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether14]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether15]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether16]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether17]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether18]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether19]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether20]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether21]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether22]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether23]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged [find interface=ether24]

# Only allow ingress packets WITH tags on Trunk Ports
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp1]
set bridge=BR1 ingress-filtering=yes frame-types=admit-only-vlan-tagged [find interface=sfp2]


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


