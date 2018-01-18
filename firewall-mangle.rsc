/ip firewall mangle
add action=mark-connection chain=prerouting comment=">>>>> INTRANET TRAFFIC" disabled=yes new-connection-mark=no-mark
add action=jump chain=forward dst-address=10.0.0.0/8 jump-target=local-net src-address=10.0.0.0/8
add action=mark-connection chain=local-net new-connection-mark=local-net passthrough=yes
add action=fasttrack-connection chain=local-net connection-mark=local-net add action=accept chain=local-net connection-mark=local-net
add action=return chain=local-net
add action=accept chain=prerouting comment=">>>>> SEPARATOR (DO NOT ENABLE)" disabled=yes
add action=mark-packet chain=prerouting in-interface=all-ethernet new-packet-mark=dnld_pr4_beff
add action=mark-packet chain=postrouting new-packet-mark=upld_pr4_beff out-interface=all-ethernet
add action=accept chain=prerouting comment=">>>>> SEPARATOR (DO NOT ENABLE)" disabled=yes
add action=jump chain=prerouting comment="NEW CONNECTIONS" connection-state=new in-interface=all-ethernet jump-target=crit-dnld-pr1
add action=jump chain=postrouting connection-state=new jump-target=crit-upld-pr1 out-interface=all-ethernet
add action=jump chain=prerouting jump-target=crit-dnld-pr1 port=53 protocol=udp
add action=jump chain=prerouting comment="BIG BYTES (IN)" connection-bytes=2500000-0 \
 connection-rate=2500-1G in-interface=ether1 jump-target=beff-bulk-download protocol=tcp
add action=mark-packet chain=beff-bulk-download new-packet-mark=dnld_pr8_beff passthrough=no
add action=return chain=beff-bulk-download
add action=jump chain=postrouting comment="BIG BYTES (OUT)" connection-bytes=2500000-0 \
 connection-rate=2500-1G jump-target=beff-bulk-upload out-interface=ether1 protocol=tcp
add action=mark-packet chain=beff-bulk-upload new-packet-mark=upld_pr8_beff passthrough=no
add action=return chain=beff-bulk-upload
add action=jump chain=prerouting comment="WEB TRAFFIC - INBOUND" in-interface=ether1 jump-target=beff-http-down port=80,443 protocol=tcp
add action=jump chain=prerouting in-interface=ether1 jump-target=beff-http-down port=80,443 protocol=udp
add action=jump chain=beff-http-down connection-bytes=2500000-0 jump-target=beff-bulk-download protocol=tcp
add action=mark-packet chain=beff-http-down new-packet-mark=dnld_pr6_beff passthrough=no
add action=return chain=beff-http-down
add action=jump chain=prerouting comment="SYN PACKETS" in-interface=ether1 jump-target=crit-dnld-pr2 protocol=tcp tcp-flags=syn
add action=jump chain=postrouting jump-target=crit-upld-pr2 out-interface=ether1 protocol=tcp tcp-flags=syn
add action=jump chain=forward comment="PR1 - RTP conn/packet" jump-target=crit-dnld-pr1 port=10000-20000 protocol=udp
add action=jump chain=forward comment="PR1 -- FACETIME" jump-target=crit-dnld-pr2 port=5223,4080,3478 protocol=tcp
add action=mark-connection chain=forward comment="DSCP 46 (VoIP)" connection-mark=no-mark dscp=46 new-connection-mark=VoIP-conn \
 passthrough=yes
add action=jump chain=prerouting comment="PR2 -- SIP (VoIP)" jump-target=crit-dnld-pr1 port=5060-5061 protocol=tcp
add action=jump chain=prerouting jump-target=crit-dnld-pr1 port=5060-5061 protocol=udp
add action=jump chain=forward comment="PR8 -- P2P conn/packet" jump-target=beff-p2p p2p=all-p2p src-address=10.0.0.0/8
add action=mark-packet chain=beff-p2p new-packet-mark=dnld_pr8_lmtd passthrough=no
add action=return chain=beff-p2p
add action=accept chain=prerouting comment=">>>>> SEPARATOR (DO NOT ENABLE)" disabled=yes
add action=mark-packet chain=crit-dnld-pr1 new-packet-mark=dnld_pr1_crit passthrough=no
add action=return chain=crit-dnld-pr1
add action=mark-packet chain=crit-dnld-pr2 new-packet-mark=dnld_pr2_crit passthrough=no
add action=return chain=crit-dnld-pr2
add action=mark-packet chain=crit-upld-pr1 new-packet-mark=upld_pr1_crit passthrough=no
add action=return chain=crit-upld-pr1
add action=mark-packet chain=crit-upld-pr2 new-packet-mark=upld_pr2_crit passthrough=no
add action=return chain=crit-upld-pr2
