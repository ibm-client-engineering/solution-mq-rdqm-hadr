"use strict";(self.webpackChunkwebsite=self.webpackChunkwebsite||[]).push([[411],{4137:(e,t,n)=>{n.d(t,{Zo:()=>m,kt:()=>h});var a=n(7294);function s(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){s(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function i(e,t){if(null==e)return{};var n,a,s=function(e,t){if(null==e)return{};var n,a,s={},o=Object.keys(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||(s[n]=e[n]);return s}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(s[n]=e[n])}return s}var c=a.createContext({}),r=function(e){var t=a.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},m=function(e){var t=r(e.components);return a.createElement(c.Provider,{value:t},e.children)},u="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},d=a.forwardRef((function(e,t){var n=e.components,s=e.mdxType,o=e.originalType,c=e.parentName,m=i(e,["components","mdxType","originalType","parentName"]),u=r(n),d=s,h=u["".concat(c,".").concat(d)]||u[d]||p[d]||o;return n?a.createElement(h,l(l({ref:t},m),{},{components:n})):a.createElement(h,l({ref:t},m))}));function h(e,t){var n=arguments,s=t&&t.mdxType;if("string"==typeof e||s){var o=n.length,l=new Array(o);l[0]=d;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i[u]="string"==typeof e?e:s,l[1]=i;for(var r=2;r<o;r++)l[r]=n[r];return a.createElement.apply(null,l)}return a.createElement.apply(null,n)}d.displayName="MDXCreateElement"},5623:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>c,contentTitle:()=>l,default:()=>p,frontMatter:()=>o,metadata:()=>i,toc:()=>r});var a=n(7462),s=(n(7294),n(4137));const o={id:"validate",sidebar_position:2,title:"Validate"},l=void 0,i={unversionedId:"Co-Create/validate",id:"Co-Create/validate",title:"Validate",description:"SSL configuration for MQ and MQ-IPT",source:"@site/docs/3-Co-Create/2-Validate.md",sourceDirName:"3-Co-Create",slug:"/Co-Create/validate",permalink:"/solution-mq-rdqm-hadr/Co-Create/validate",draft:!1,editUrl:"https://github.com/ibm-client-engineering/solution-mq-rdqm-hadr.git/docs/3-Co-Create/2-Validate.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{id:"validate",sidebar_position:2,title:"Validate"},sidebar:"tutorialSidebar",previous:{title:"Deploy",permalink:"/solution-mq-rdqm-hadr/Co-Create/deploy"},next:{title:"Automate",permalink:"/solution-mq-rdqm-hadr/Co-Create/automate"}},c={},r=[{value:"SSL configuration for MQ and MQ-IPT",id:"ssl-configuration-for-mq-and-mq-ipt",level:3},{value:"Configuring OpenLDAP in a container",id:"configuring-openldap-in-a-container",level:4},{value:"Testing",id:"testing",level:2},{value:"Summary of Results:",id:"summary-of-results",level:3},{value:"Testing Tools",id:"testing-tools",level:3},{value:"Failover testing for MQ HADR and RDQM",id:"failover-testing-for-mq-hadr-and-rdqm",level:2},{value:"Setup",id:"setup",level:3},{value:"Testing with persistent messages with syncpoint",id:"testing-with-persistent-messages-with-syncpoint",level:3},{value:"Regional failover testing",id:"regional-failover-testing",level:3},{value:"Failing over to Dallas",id:"failing-over-to-dallas",level:3}],m={toc:r},u="wrapper";function p(e){let{components:t,...n}=e;return(0,s.kt)(u,(0,a.Z)({},m,n,{components:t,mdxType:"MDXLayout"}),(0,s.kt)("h3",{id:"ssl-configuration-for-mq-and-mq-ipt"},"SSL configuration for MQ and MQ-IPT"),(0,s.kt)("p",null,"For testing purposes, we are going to createa new queue manager and configure it with LDAP authentication and SSL."),(0,s.kt)("h4",{id:"configuring-openldap-in-a-container"},"Configuring OpenLDAP in a container"),(0,s.kt)("p",null,(0,s.kt)("em",{parentName:"p"},"If you already have an Active Directory server or an LDAP host, you can skip this next part.")),(0,s.kt)("p",null,"Now let's get ldap going. For that, we're gonna spin up an ldap container on a docker host that's on the same networks as your clusters. Since this is a regional failover HADR cluster, you should probably have a second LDAP host running in this DR region and have replication for LDAP set up, but we won't go into that here."),(0,s.kt)("p",null,"Let's create some persistent file storage directories for the container to use first on our docker host:"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"mkdir -p /LDAP_DIR/ldap /LDAP_DIR/slapd.d\nchmod -R 777 /LDAP_DIR\n")),(0,s.kt)("p",null,"We are going to seed an ldif into this container. Create a file under ",(0,s.kt)("inlineCode",{parentName:"p"},"/LDAP_DIR")," called ",(0,s.kt)("inlineCode",{parentName:"p"},"bootstrap.ldif"),":"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"dn: ou=people,dc=ibm,dc=com\nobjectClass: organizationalUnit\ndescription: All people in organization\nou: people\n\ndn: ou=groups,dc=ibm,dc=com\nobjectClass: organizationalUnit\nobjectClass: top\nou: groups\n\n#MQ user + group\ndn: uid=app,ou=people,dc=ibm,dc=com\nobjectClass: inetOrgPerson\nobjectClass: organizationalPerson\nobjectClass: person\nobjectClass: top\ncn: appCN\nsn: appSN\nuid: app\nuserPassword: app\n\ndn: cn=apps,ou=groups,dc=ibm,dc=com\nobjectClass: groupOfUniqueNames\nobjectClass: top\ncn: apps\nuniquemember: uid=app,ou=people,dc=ibm,dc=com\n\ndn: uid=mqadmin,ou=people,dc=ibm,dc=com\nobjectClass: inetOrgPerson\nobjectClass: organizationalPerson\nobjectClass: person\nobjectClass: top\ncn: mqadminCN\nsn: mqadminSN\nuid: mqadmin\nuserPassword: mqadmin\n\ndn: cn=mqadmins,ou=groups,dc=ibm,dc=com\nobjectClass: groupOfUniqueNames\nobjectClass: top\ncn: mqadmins\nuniquemember: uid=mqadmin,ou=people,dc=ibm,dc=com\n")),(0,s.kt)("p",null,"And now spin up a container making sure to mount that file as a custom seed. For our test setup we are using the osixia/openldap container image."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},'docker run \\\n--restart=always \\\n-p 1636:1636 \\\n-p 389:389 \\\n-p 636:636 \\\n-v /LDAP_DIR/bootstrap.ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif \\\n-v /LDAP_DIR/ldap:/var/lib/ldap \\\n-v /LDAP_DIR/slapd.d:/etc/ldap/slapd.d \\\n--env LDAP_ORGANIZATION="IBM" \\\n--env LDAP_ADMIN_PASSWORD="p@ssw0rd" \\\n--env LDAP_CONFIG_PASSWORD="p@ssw0rd" \\\n--env LDAP_ENABLE_TLS="yes" \\\n--env LDAP_DOMAIN="ibm.com" \\\n--hostname mq.openldap \\\n--name mq-openldap-container \\\n--detach osixia/openldap:latest \\\n--copy-service\n')),(0,s.kt)("p",null,"For our purposes, we set the domain to ",(0,s.kt)("inlineCode",{parentName:"p"},"ibm.com")," and then set an admin password of ",(0,s.kt)("inlineCode",{parentName:"p"},"p@ssw0rd"),"."),(0,s.kt)("p",null,"Now we're going to configure our new queue mgr to auth with ldap. First we need to create the AUTHINFO object that will contain our ldap server info. This must be run by a member of the mqm group."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[mqm@wdc1-mq1 ~]$ runmqsc SSLDRHAQM1\n5724-H72 (C) Copyright IBM Corp. 1994, 2022.\nStarting MQSC for queue manager SSLDRHAQM1.\n\nDEFINE AUTHINFO(SSLDRHAQM1.IDPW.LDAP) AUTHTYPE(IDPWLDAP) ADOPTCTX(YES) CONNAME('10.241.2.5(389)') SECCOMM(NO) CHCKLOCL(OPTIONAL) CHCKCLNT(OPTIONAL) CLASSGRP('groupOfUniqueNames') CLASSUSR('inetOrgPerson') FINDGRP('uniqueMember') BASEDNG('ou=groups,dc=ibm,dc=com') BASEDNU('ou=people,dc=ibm,dc=com') LDAPUSER('cn=admin,dc=ibm,dc=com') LDAPPWD('p@ssw0rd') SHORTUSR('uid') GRPFIELD('cn') USRFIELD('uid') AUTHORMD(SEARCHGRP) NESTGRP(YES)\n")),(0,s.kt)("p",null,"Above we've created an authinfo object. While everything above is needed, here are the most important settings:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"AUTHINFO - we've named it ",(0,s.kt)("inlineCode",{parentName:"li"},"SSLDRHAQM1.IDPQ.LDAP")),(0,s.kt)("li",{parentName:"ul"},"AUTHTYPE - ",(0,s.kt)("inlineCode",{parentName:"li"},"IDPWLDAP")," Connection authentication user ID and password checking is done using an LDAP server."),(0,s.kt)("li",{parentName:"ul"},"ADOPTCTX - ",(0,s.kt)("inlineCode",{parentName:"li"},"YES")," - This means authenticated users are used for authorization checks, shown on administrative displays, and appear in messages."),(0,s.kt)("li",{parentName:"ul"},"CONNAME - ",(0,s.kt)("inlineCode",{parentName:"li"},"10.241.2.5(389)")," This the actual ip address of our docker host where our ldap container is running"),(0,s.kt)("li",{parentName:"ul"},"CHCKLOCL - This attribute determines the authentication requirements for locally bound applications, and is valid only for an AUTHTYPE of ",(0,s.kt)("inlineCode",{parentName:"li"},"IDPWOS")," or ",(0,s.kt)("inlineCode",{parentName:"li"},"IDPWLDAP"),". We are setting this to ",(0,s.kt)("inlineCode",{parentName:"li"},"OPTIONAL")," which means locally bound applications are not required to provide a user ID and password. This is ideal for testing purposes."),(0,s.kt)("li",{parentName:"ul"},"CHCKCLNT - This attribute determines the authentication requirements for client applications, and is valid only for an AUTHTYPE of IDPWOS or IDPWLDAP. We're setting it to ",(0,s.kt)("inlineCode",{parentName:"li"},"OPTIONAL")," which means that client applications are not required to provide a user ID and password, but any provided will be authenticated against your authentication method. In our case, that's LDAP."),(0,s.kt)("li",{parentName:"ul"},"SECCOMM - We aren't using LDAPS in this example, so this is set to ",(0,s.kt)("inlineCode",{parentName:"li"},"NO"))),(0,s.kt)("p",null,"The rest of the settings are LDAP specific and should be mostly self-explanatory."),(0,s.kt)("p",null,"Next, execute the following command to reconfigure the ",(0,s.kt)("strong",{parentName:"p"},"LDAPQM")," queue manager to use the new ",(0,s.kt)("strong",{parentName:"p"},"SSLDRHAQM1.IDPW.LDAP AUTHINFO object:")),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"ALTER QMGR CONNAUTH(SSLDRHAQM1.IDPW.LDAP)\nREFRESH QMGR TYPE(CONFIGEV) OBJECT(AUTHREC)\nREFRESH SECURITY\n")),(0,s.kt)("p",null,"Now restart the queuemgr"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[mqm@dwdc1-mq1 ~]$ endmqm -i SSLDRHAQM1 && strmqm SSLDRHAQM1\n")),(0,s.kt)("p",null,"Now we need to set the authorizations and hope it all works. Make sure to run this command on the primary node as the ",(0,s.kt)("inlineCode",{parentName:"p"},"mqm")," user:"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},'setmqaut -m SSLDRHAQM1 -t qmgr -g "mqadmins" +connect +inq +alladm\nsetmqaut -m SSLDRHAQM1 -n "**" -t q -g "mqadmins" +alladm +crt +browse\nsetmqaut -m SSLDRHAQM1 -n "**" -t topic -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t channel -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t process -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t namelist -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t authinfo -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t clntconn -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t listener -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t service -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n "**" -t comminfo -g "mqadmins" +alladm +crt\nsetmqaut -m SSLDRHAQM1 -n SYSTEM.MQEXPLORER.REPLY.MODEL -t q -g "mqadmins" +dsp +inq +get\nsetmqaut -m SSLDRHAQM1 -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g "mqadmins" +dsp +inq +put\n')),(0,s.kt)("p",null,"You can verify that LDAP auth is now working by running the following command using ",(0,s.kt)("inlineCode",{parentName:"p"},"mqadmin")," as the user:"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[mqm@wdc1-mq1 ~]$ runmqsc -u mqadmin SSLDRHAQM1\n5724-H72 (C) Copyright IBM Corp. 1994, 2021.\nEnter password:\n*******\nStarting MQSC for queue manager SSLDRHAQM1.\n")),(0,s.kt)("p",null,"The password for mqadmin is ",(0,s.kt)("inlineCode",{parentName:"p"},"mqadmin")),(0,s.kt)("h2",{id:"testing"},"Testing"),(0,s.kt)("h3",{id:"summary-of-results"},"Summary of Results:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"Mean time to failover between regions: ",(0,s.kt)("inlineCode",{parentName:"li"},"2.8 seconds")),(0,s.kt)("li",{parentName:"ul"},"Mean time to failover between zones: ",(0,s.kt)("inlineCode",{parentName:"li"},"547 millisecond")),(0,s.kt)("li",{parentName:"ul"},"Data-Loss during local(zonal) failover: ",(0,s.kt)("inlineCode",{parentName:"li"},"0")),(0,s.kt)("li",{parentName:"ul"},"Data-loss during regional failover: ",(0,s.kt)("inlineCode",{parentName:"li"},"0"))),(0,s.kt)("h3",{id:"testing-tools"},"Testing Tools"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"[MQ Toolkit for Mac][https://developer.ibm.com/tutorials/mq-macos-dev/]"," comes with sample client programs to test.")),(0,s.kt)("h2",{id:"failover-testing-for-mq-hadr-and-rdqm"},"Failover testing for MQ HADR and RDQM"),(0,s.kt)("p",null,"We have two avenues for testing failover:"),(0,s.kt)("ol",null,(0,s.kt)("li",{parentName:"ol"},"Local failover between nodes in each cluster",(0,s.kt)("ol",{parentName:"li"},(0,s.kt)("li",{parentName:"ol"},"Loadbalancer lives in each region and handles the traffic failover between nodes"))),(0,s.kt)("li",{parentName:"ol"},"Regional failover between regions for disaster recovery",(0,s.kt)("ol",{parentName:"li"},(0,s.kt)("li",{parentName:"ol"},"MQIPT currently runs on our bastion host and provides proxied connections between regions. This does not support failover per se but does support converged proxying between sites.")))),(0,s.kt)("h3",{id:"setup"},"Setup"),(0,s.kt)("p",null,"It's important to note that with a three node HA cluster, two nodes must be available to allow for a quorum. This is by design as in order to preserve the quorum between nodes, at least two nodes must be available."),(0,s.kt)("p",null,"Our two regions are defined thusly:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"DC",(0,s.kt)("ul",{parentName:"li"},(0,s.kt)("li",{parentName:"ul"},"DRHAQM1 - queue manager with primary cluster in DC"),(0,s.kt)("li",{parentName:"ul"},"DRHAQM2 - standby queue manager for DRHAQM2"))),(0,s.kt)("li",{parentName:"ul"},"Dallas",(0,s.kt)("ul",{parentName:"li"},(0,s.kt)("li",{parentName:"ul"},"DRHAQM2 - queue manager with primary cluster in Dallas"),(0,s.kt)("li",{parentName:"ul"},"DRHAQM1 - standby queue manager for DRHAQM1")))),(0,s.kt)("p",null,"Each cluster is made up of three nodes:"),(0,s.kt)("p",null,"DC"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"wdc1-mq1"),(0,s.kt)("li",{parentName:"ul"},"wdc2-mq1"),(0,s.kt)("li",{parentName:"ul"},"wdc3-mq1")),(0,s.kt)("p",null,"Dallas"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"dal1-mq1"),(0,s.kt)("li",{parentName:"ul"},"dal2-mq1"),(0,s.kt)("li",{parentName:"ul"},"dal3-mq1")),(0,s.kt)("p",null,"We create the following queues on each cluster. For the purposes of this test, we aren't going to enable any security."),(0,s.kt)("p",null,"On wdc1-mq1"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"runmqsc DRHAQM1\nALTER QMGR CHLAUTH(DISABLED)\nALTER QMGR CONNAUTH(' ')\nREFRESH SECURITY (*)\nDEFINE CHANNEL(DRHAMQ1.MQIPT) CHLTYPE(SVRCONN)\nDEFINE QLOCAL(MQIPT.LOCAL.QUEUE)\nDEFINE listener(LISTENER) trptype(tcp) control(qmgr) port(1501)\nstart listener(LISTENER)\nQUIT\n\n")),(0,s.kt)("p",null,"On dal1-mq1"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"runmqsc DRHAQM1\nALTER QMGR CHLAUTH(DISABLED)\nALTER QMGR CONNAUTH(' ')\nREFRESH SECURITY (*)\nDEFINE CHANNEL(DRHAMQ2.MQIPT) CHLTYPE(SVRCONN)\nDEFINE QLOCAL(MQIPT.LOCAL.QUEUE)\nDEFINE listener(LISTENER) trptype(tcp) control(qmgr) port(1502)\nstart listener(LISTENER)\nQUIT\n")),(0,s.kt)("p",null,"We configure our settings on our MQIPT host"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[route]\nName=DRHAQM1\nActive=true\nListenerPort=1501\nDestination=3bdf30c3-us-east.lb.appdomain.cloud\nDestinationPort=1501\n\n[route]\nName=DRHAQM2\nActive=true\nListenerPort=1502\nDestination=e8deec77-us-south.lb.appdomain.cloud\nDestinationPort=1502\n")),(0,s.kt)("p",null,"The destination addresses are the load balancer for each region. This will move the connections between each node during failover."),(0,s.kt)("p",null,"We create a user that is part of the ",(0,s.kt)("inlineCode",{parentName:"p"},"mqm")," group on each node. This is the user we must connect as when we run the tests."),(0,s.kt)("h3",{id:"testing-with-persistent-messages-with-syncpoint"},"Testing with persistent messages with syncpoint"),(0,s.kt)("p",null,"Relevant github link:\n",(0,s.kt)("a",{parentName:"p",href:"https://github.com/ibm-messaging/mq-rdqm"},"https://github.com/ibm-messaging/mq-rdqm")),(0,s.kt)("p",null,"For these utilities to work you must install ",(0,s.kt)("inlineCode",{parentName:"p"},"MQSeriesSDK-9.2.5-0.x86_64.rpm")," which is part of the MQ client/server installation package ",(0,s.kt)("inlineCode",{parentName:"p"},"mqadv_dev925_linux_x86-64.tar.gz")),(0,s.kt)("p",null,(0,s.kt)("strong",{parentName:"p"},"LINUX"),"\nClone the above repo to your home directory"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"git clone https://github.com/ibm-messaging/mq-rdqm.git\n")),(0,s.kt)("p",null,"Install the relevant build tools"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"dnf -y install make cmake gcc\n")),(0,s.kt)("p",null,"Go to the samples directory:"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"cd mq-rdqm/samples/C/linux\n")),(0,s.kt)("p",null,"Update the ",(0,s.kt)("inlineCode",{parentName:"p"},"Makefile")," to point to the ",(0,s.kt)("inlineCode",{parentName:"p"},"/opt/mqm")," directory since that's where all of MQ's libs are installed."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"MQDIR=/opt/mqm\n")),(0,s.kt)("p",null,"Build the ",(0,s.kt)("inlineCode",{parentName:"p"},"rdqmget")," and ",(0,s.kt)("inlineCode",{parentName:"p"},"rdqmput")," binaries"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ make all\ngcc -m64 -I /opt/mqm/inc -c ../complete.c\ngcc -m64 -I /opt/mqm/inc -c ../connection.c\ngcc -m64 -I /opt/mqm/inc -c ../globals.c\ngcc -m64 -I /opt/mqm/inc -c ../log.c\ngcc -m64 -I /opt/mqm/inc -c ../options.c\ngcc -m64 -I /opt/mqm/inc -o rdqmget ../rdqmget.c complete.o connection.o globals.o log.o options.o -L /opt/mqm/lib64 -l mqic_r -Wl,-rpath=/opt/mqm/lib64 -Wl,-rpath=/usr/lib64\ngcc -m64 -I /opt/mqm/inc -o rdqmput ../rdqmput.c complete.o connection.o globals.o log.o options.o -L /opt/mqm/lib64 -l mqic_r -Wl,-rpath=/opt/mqm/lib64 -Wl,-rpath=/usr/lib64\n")),(0,s.kt)("p",null,"Export the MQSERVER env var and kick off the ",(0,s.kt)("inlineCode",{parentName:"p"},"rdqmget")," command. The ",(0,s.kt)("inlineCode",{parentName:"p"},"<mqipt adress>")," is our MQIPT server."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},'export MQSERVER="DRHAMQ1.MQIPT/TCP/<mqipt address>(1501)"\n')),(0,s.kt)("p",null,"The syntax is the same as the default sample application"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"<sample> [options] <queue manager name> <queue name>\n\n./rdqmput -b10 -m5 -v 1 DRHAQM1 MQIPT.LOCAL.QUEUE\n")),(0,s.kt)("p",null,"The default number of batches is 20 and the default batch size is 10 so by default rdqmput will put a total of 200 messages and rdqmget will get a total of 200 messages."),(0,s.kt)("p",null,"The above options will create 10 batches of 5 messages each. So we should see 50 messages when rdqmget drains the queue."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"Connected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 put successfully, committing...\nBatch 1 committed successfully\nBatch 2 put successfully, committing...\nBatch 2 committed successfully\nBatch 3 put successfully, committing...\nBatch 3 committed successfully\nBatch 4 put successfully, committing...\nBatch 4 committed successfully\nBatch 5 put successfully, committing...\nBatch 5 committed successfully\nBatch 6 put successfully, committing...\nBatch 6 committed successfully\nBatch 7 put successfully, committing...\nBatch 7 committed successfully\nBatch 8 put successfully, committing...\nBatch 8 committed successfully\nBatch 9 put successfully, committing...\nBatch 9 committed successfully\nBatch 10 put successfully, committing...\nBatch 10 committed successfully\nCompleted\n\n")),(0,s.kt)("p",null,"Now we retrieve them"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 got successfully, committing...\nBatch 1 committed successfully\nBatch 2 got successfully, committing...\nBatch 2 committed successfully\nBatch 3 got successfully, committing...\nBatch 3 committed successfully\nBatch 4 got successfully, committing...\nBatch 4 committed successfully\nBatch 5 got successfully, committing...\nBatch 5 committed successfully\nBatch 6 got successfully, committing...\nBatch 6 committed successfully\nBatch 7 got successfully, committing...\nBatch 7 committed successfully\nBatch 8 got successfully, committing...\nBatch 8 committed successfully\nBatch 9 got successfully, committing...\nBatch 9 committed successfully\nBatch 10 got successfully, committing...\nBatch 10 committed successfully\nCompleted\n")),(0,s.kt)("p",null,"And the queue should be empty."),(0,s.kt)("p",null,"Next lets try a failover in the WDC cluster. FIrst we'll load up the queue with 10 batches of 5 messages each."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 put successfully, committing...\nBatch 1 committed successfully\nBatch 2 put successfully, committing...\nBatch 2 committed successfully\nBatch 3 put successfully, committing...\nBatch 3 committed successfully\nBatch 4 put successfully, committing...\nBatch 4 committed successfully\nBatch 5 put successfully, committing...\nBatch 5 committed successfully\nBatch 6 put successfully, committing...\nBatch 6 committed successfully\nBatch 7 put successfully, committing...\nBatch 7 committed successfully\nBatch 8 put successfully, committing...\nBatch 8 committed successfully\nBatch 9 put successfully, committing...\nBatch 9 committed successfully\nBatch 10 put successfully, committing...\nBatch 10 committed successfully\nCompleted\n")),(0,s.kt)("p",null,"Now lets failover the cluster to node2."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@wdc1-mq1 ~]# rdqmadm -s\nThe replicated data node 'wdc1-mq1' has been suspended.\n\n")),(0,s.kt)("p",null,"This puts the primary node into standby node and shifts the queue over to node2. This can be verified with the following command on node2."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@wdc2-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s\nQMNAME(DRHAQM1)                                           STATUS(Running)\n    INSTANCE(wdc2-mq1) MODE(Active)\n\n")),(0,s.kt)("p",null,"The load balancer should have shifted over the connection as well. So now from our client going through MQIPT, let's see if we can retrieve the messages we put in."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 got successfully, committing...\nBatch 1 committed successfully\nBatch 2 got successfully, committing...\nBatch 2 committed successfully\nBatch 3 got successfully, committing...\nBatch 3 committed successfully\nBatch 4 got successfully, committing...\nBatch 4 committed successfully\nBatch 5 got successfully, committing...\nBatch 5 committed successfully\nBatch 6 got successfully, committing...\nBatch 6 committed successfully\nBatch 7 got successfully, committing...\nBatch 7 committed successfully\nBatch 8 got successfully, committing...\nBatch 8 committed successfully\nBatch 9 got successfully, committing...\nBatch 9 committed successfully\nBatch 10 got successfully, committing...\nBatch 10 committed successfully\nCompleted\n")),(0,s.kt)("p",null,"And there they are. Let's push some messages back into the queue and fail back to node1."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 put successfully, committing...\nBatch 1 committed successfully\nBatch 2 put successfully, committing...\nBatch 2 committed successfully\nBatch 3 put successfully, committing...\nBatch 3 committed successfully\nBatch 4 put successfully, committing...\nBatch 4 committed successfully\nBatch 5 put successfully, committing...\nBatch 5 committed successfully\nBatch 6 put successfully, committing...\nBatch 6 committed successfully\nBatch 7 put successfully, committing...\nBatch 7 committed successfully\nBatch 8 put successfully, committing...\nBatch 8 committed successfully\nBatch 9 put successfully, committing...\nBatch 9 committed successfully\nBatch 10 put successfully, committing...\nBatch 10 committed successfully\nCompleted\n")),(0,s.kt)("p",null,"Now fail things back over"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@wdc1-mq1 ~]# rdqmadm -r\nThe replicated data node 'wdc1-mq1' has been resumed.\n")),(0,s.kt)("p",null,"We should see the queue back on node1 now."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@wdc1-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s\nQMNAME(DRHAQM1)                                           STATUS(Running)\n    INSTANCE(wdc1-mq1) MODE(Active)\n")),(0,s.kt)("p",null,"Now from our client, let's get these messages."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 got successfully, committing...\nBatch 1 committed successfully\nBatch 2 got successfully, committing...\nBatch 2 committed successfully\nBatch 3 got successfully, committing...\nBatch 3 committed successfully\nBatch 4 got successfully, committing...\nBatch 4 committed successfully\nBatch 5 got successfully, committing...\nBatch 5 committed successfully\nBatch 6 got successfully, committing...\nBatch 6 committed successfully\nBatch 7 got successfully, committing...\nBatch 7 committed successfully\nBatch 8 got successfully, committing...\nBatch 8 committed successfully\nBatch 9 got successfully, committing...\nBatch 9 committed successfully\nBatch 10 got successfully, committing...\nBatch 10 committed successfully\nCompleted\n")),(0,s.kt)("p",null,"And there they are."),(0,s.kt)("h3",{id:"regional-failover-testing"},"Regional failover testing"),(0,s.kt)("p",null,"First. let's write some messages to the queue. We'll export the MQSERVER env var still pointing to the MQIPT host and then write those messages."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},'[kramerro@wdc-mq-client linux]$ export MQSERVER="DRHAMQ1.MQIPT/TCP/<mqipt address>(1501)"\n[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 put successfully, committing...\nBatch 1 committed successfully\nBatch 2 put successfully, committing...\nBatch 2 committed successfully\nBatch 3 put successfully, committing...\nBatch 3 committed successfully\nBatch 4 put successfully, committing...\nBatch 4 committed successfully\nBatch 5 put successfully, committing...\nBatch 5 committed successfully\nBatch 6 put successfully, committing...\nBatch 6 committed successfully\nBatch 7 put successfully, committing...\nBatch 7 committed successfully\nBatch 8 put successfully, committing...\nBatch 8 committed successfully\nBatch 9 put successfully, committing...\nBatch 9 committed successfully\nBatch 10 put successfully, committing...\nBatch 10 committed successfully\nCompleted\n\n\n')),(0,s.kt)("p",null,(0,s.kt)("strong",{parentName:"p"},"IMPORTANT"),": ",(0,s.kt)("em",{parentName:"p"},"When failing between regions, this is not an automated process. If Region 1 went down completely, Region 2 would need to be manually started as it is for Disaster Recovery and not High Availibility. These processes can be automated externally with a monitoring solution that detects the loss of Region 1 and triggers an automated process that starts up Region 2. An example of how one might achieve this using Ansible has been provided in the ",(0,s.kt)("strong",{parentName:"em"},"resources")," folder in this repo.")," "),(0,s.kt)("h3",{id:"failing-over-to-dallas"},"Failing over to Dallas"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@wdc1-mq1 ~]# rdqmdr -s -m DRHAQM1\nQueue manager 'DRHAQM1' has been made the DR secondary on this node.\n")),(0,s.kt)("p",null,"And in Dallas, we have to tell node 1 that it's now primary for that queue manager"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@ceng-dal1-mq1 ~]# rdqmdr -p -m DRHAQM1\nQueue manager 'DRHAQM1' has been made the DR primary on this node.\n")),(0,s.kt)("p",null,"Now we should see on node 1 in Dallas that we are now primary for that queue manager"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[root@ceng-dal1-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s\nQMNAME(DRHAQM1)                                           STATUS(Running)\n    INSTANCE(ceng-dal1-mq1) MODE(Active)\n")),(0,s.kt)("p",null,"Now let's modify MQIPT to point to the Dallas cluster for this queue manager. Edit ",(0,s.kt)("inlineCode",{parentName:"p"},"/opt/mqipt/installation1/mqipt/HAMQ/mqipt.conf")),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[route]\nName=DRHAQM1\nActive=true\nListenerPort=1501\nDestination=3bdf30c3-us-east.lb.appdomain.cloud\nDestinationPort=1501\n\n[route]\nName=DRHAQM2\nActive=true\nListenerPort=1502\nDestination=e8deec77-us-south.lb.appdomain.cloud\nDestinationPort=1502\n")),(0,s.kt)("p",null,"We are going to change the Destination for DRHAMQ1 to point to the load balancer in Dallas."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[route]\nName=DRHAQM1\nActive=true\nListenerPort=1501\nDestination=e8deec77-us-south.lb.appdomain.cloud\nDestinationPort=1501\n\n[route]\nName=DRHAQM2\nActive=true\nListenerPort=1502\nDestination=e8deec77-us-south.lb.appdomain.cloud\nDestinationPort=1502\n")),(0,s.kt)("p",null,"Now refresh mqipt with the following command. We have named this MQIPT instance to HAMQ:"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"root@wdc-bastion:/opt/mqipt/installation1/mqipt/HAMQ# /opt/mqipt/installation1/mqipt/bin/mqiptAdmin -refresh -n HAMQ\nJune 2, 2022 7:26:11 PM UTC\nMQCAI105 Sending REFRESH command to MQIPT instance with name HAMQ\nMQCAI025 MQIPT HAMQ has been refreshed\n")),(0,s.kt)("p",null,"Now from our client, let's see if the messages are there."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre"},"[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE\nConnected to queue manager DRHAQM1\nOpened queue MQIPT.LOCAL.QUEUE\nBatch 1 got successfully, committing...\nBatch 1 committed successfully\nBatch 2 got successfully, committing...\nBatch 2 committed successfully\nBatch 3 got successfully, committing...\nBatch 3 committed successfully\nBatch 4 got successfully, committing...\nBatch 4 committed successfully\nBatch 5 got successfully, committing...\nBatch 5 committed successfully\nBatch 6 got successfully, committing...\nBatch 6 committed successfully\nBatch 7 got successfully, committing...\nBatch 7 committed successfully\n")))}p.isMDXComponent=!0}}]);