# 
# credits: http://www.pimp-my-rig.com/2016/12/initial-configuration-mikrotik-virtual-router.html
# 
# NOTES:
# 1.1.1.2/30 is to be provided by your ISP
#
/ip address 
  add address=1.1.1.2/30 network=1.1.1.0 comment=WAN-PRI interface=ether1

/user 
  # change PASSWORD your own password for the default user: admin
  set admin password=PASSWORD address=127.0.0.1/32

  # change pimp-my-rig with your own custom username
  #   and PASSWORD with your own password
  add name=pimp-my-rig password=PASSWORD group=full address=192.168.0.0/16

# turn off custom services or make them available from the LAN-side only
/ip service
  set telnet address=192.168.0.0/16 disabled=yes
  set ftp address=192.168.0.0/16 disabled=yes
  set www address=192.168.0.0/16 disabled=yes
  set ssh address=192.168.0.0/16
  set www-ssl address=192.168.0.0/16 disabled=yes
  set api address=192.168.0.0/16 disabled=yes
  set winbox address=192.168.0.0/16
  set api-ssl address=192.168.0.0/16 disabled=yes

# secure the router from external access
/ip firewall filter
  add chain=input action=tarpit protocol=tcp in-interface=!ether3 \
   comment="TARPIT connections not coming from LAN (ETH3)"
  add chain=input action=drop in-interface=!ether3 \
   comment="DROP other traffic not comming from LAN (ETH3)"
