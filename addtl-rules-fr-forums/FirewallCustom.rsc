###############################################################################
# Topic:		Using RouterOS to VLAN your network
# Example:		Public VLAN, Printer & Server
# Web:			https://forum.mikrotik.com/viewtopic.php?t=143620
# RouterOS:		6.43.12
# Date:			Mar 28, 2019
# Notes:		Small changes made to our "RoaS" router firewall example.
# Thanks:		mkx, sindy
###############################################################################


##########################################
# Firewalling
#
# Here we show the small changes made
# to accomodate a Public VLAN or
# other shared resource (like a server)
##########################################

# Use MikroTik's "list" feature for easy rule matchmaking.

/interface list add name=WAN
/interface list add name=VLAN

/interface list member
add interface=ether1     list=WAN
add interface=BASE_VLAN  list=VLAN
add interface=BLUE_VLAN  list=VLAN
add interface=GREEN_VLAN list=VLAN
add interface=RED_VLAN   list=VLAN
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

# Optional: Disallow the Red VLAN from having Internet access:
# add chain=forward action=drop in-interface=RED_VLAN out-interface-list=WAN comment="Drop Red from Internet"

# Optional: Allow all VLANs to access the Internet AND each other
# add chain=forward action=accept connection-state=new in-interface-list=VLAN comment="VLAN inter-VLAN routing"

# Optional: Allow all VLANs to access a server (or printer) listening on Port 80 in the RED_VLAN
# add chain=forward action=accept connection-state=new in-interface-list=VLAN out-interface=RED_VLAN dst-port=80 protocol=tcp comment="Allow access to Server on RED_VLAN"

# Optional: Allow RED_VLAN to become a Public VLAN
add chain=forward action=accept connection-state=new in-interface-list=VLAN out-interface=RED_VLAN comment="Allow RED_VLAN to be the Public VLAN"

# Allow all VLANs to access the Internet only, NOT each other
add chain=forward action=accept connection-state=new in-interface-list=VLAN out-interface-list=WAN comment="VLAN Internet Access only"

add chain=forward action=drop comment="Drop"

