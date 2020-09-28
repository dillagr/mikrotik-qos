:local queueName "Hotspot - $leaseActMAC";
:if (($leaseBound=1) && ($leaseActIP>"192.168.11.9")) do {
    /queue simple add name=$queueName target=($leaseActIP . "/32") parent=hotspot max-limit=1M/3M \
    comment=[/ip dhcp-server lease get [find where active-mac-address=$leaseActMAC && active-address=$leaseActIP] host-name];
}
:if (($leaseBound=0) && ($leaseActIP>"192.168.11.9")) do {
    /queue simple remove $queueName
}
