:local TOKEN "CHAT-WITH-BOTFATHER:TO-GET-TOKEN";
:local CHATID "YOUR-TELEGRAM-UID";
:local MESSAGE "YOUR-MESSAGE-HERE";

/tool fetch url="https://api.telegram.org/bot$TOKEN/sendMessage\?chat_id=$CHATID&text=$MESSAGE" keep-result=no;
