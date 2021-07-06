#!/usr/bin/env php
<?php

require('routeros_api.class.php');

$API = new RouterosAPI();
// $API->debug = true;

if ($API->connect('10.1.1.1', 'username', 'password')) {

    // RETRIEVE USERS&COOKIES
    $API->write('/ip/hotspot/active/getall');
    $AREAD = $API->read();
    $API->write('/ip/hotspot/cookie/getall');
    $CREAD = $API->read();

    // preg_match('/user (\w+) logged in from.* via api/', $LINE["message"], $match);
    $VCODE = $argv[1];
    foreach ( $AREAD as $ACTIVE => $USER ) {
        #print_r($USER);

        if ( $USER["user"] == $VCODE ) {
            #print_r($USER[".id"]);
            $API->comm("/ip/hotspot/active/remove", array( ".id" => $USER[".id"] ));

            // REMOVE COOKIES!!
            foreach ( $CREAD as $CREAX => $COOKIE ) {
                if ( $COOKIE["user"] == $VCODE ) {
                    $API->comm("/ip/hotspot/cookie/remove", array( ".id" => $COOKIE[".id"] ));
                }
           }
       }
   }

   // WE'RE DONE HERE
   $API->disconnect();

}

?>
