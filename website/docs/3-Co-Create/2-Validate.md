---
id: validate
sidebar_position: 2
title: Validate
---

### SSL configuration for MQ and MQ-IPT

For testing purposes, we are going to createa new queue manager and configure it with LDAP authentication and SSL.

#### Configuring OpenLDAP in a container

_If you already have an Active Directory server or an LDAP host, you can skip this next part._

Now let's get ldap going. For that, we're gonna spin up an ldap container on a docker host that's on the same networks as your clusters. Since this is a regional failover HADR cluster, you should probably have a second LDAP host running in this DR region and have replication for LDAP set up, but we won't go into that here.

Let's create some persistent file storage directories for the container to use first on our docker host:

```
mkdir -p /LDAP_DIR/ldap /LDAP_DIR/slapd.d
chmod -R 777 /LDAP_DIR
```
We are going to seed an ldif into this container. Create a file under `/LDAP_DIR` called `bootstrap.ldif`:
```
dn: ou=people,dc=ibm,dc=com
objectClass: organizationalUnit
description: All people in organization
ou: people

dn: ou=groups,dc=ibm,dc=com
objectClass: organizationalUnit
objectClass: top
ou: groups

#MQ user + group
dn: uid=app,ou=people,dc=ibm,dc=com
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
cn: appCN
sn: appSN
uid: app
userPassword: app

dn: cn=apps,ou=groups,dc=ibm,dc=com
objectClass: groupOfUniqueNames
objectClass: top
cn: apps
uniquemember: uid=app,ou=people,dc=ibm,dc=com

dn: uid=mqadmin,ou=people,dc=ibm,dc=com
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
objectClass: top
cn: mqadminCN
sn: mqadminSN
uid: mqadmin
userPassword: mqadmin

dn: cn=mqadmins,ou=groups,dc=ibm,dc=com
objectClass: groupOfUniqueNames
objectClass: top
cn: mqadmins
uniquemember: uid=mqadmin,ou=people,dc=ibm,dc=com
```

And now spin up a container making sure to mount that file as a custom seed. For our test setup we are using the osixia/openldap container image.

```
docker run \
--restart=always \
-p 1636:1636 \
-p 389:389 \
-p 636:636 \
-v /LDAP_DIR/bootstrap.ldif:/container/service/slapd/assets/config/bootstrap/ldif/custom/50-bootstrap.ldif \
-v /LDAP_DIR/ldap:/var/lib/ldap \
-v /LDAP_DIR/slapd.d:/etc/ldap/slapd.d \
--env LDAP_ORGANIZATION="IBM" \
--env LDAP_ADMIN_PASSWORD="p@ssw0rd" \
--env LDAP_CONFIG_PASSWORD="p@ssw0rd" \
--env LDAP_ENABLE_TLS="yes" \
--env LDAP_DOMAIN="ibm.com" \
--hostname mq.openldap \
--name mq-openldap-container \
--detach osixia/openldap:latest \
--copy-service
```
For our purposes, we set the domain to `ibm.com` and then set an admin password of `p@ssw0rd`.

Now we're going to configure our new queue mgr to auth with ldap. First we need to create the AUTHINFO object that will contain our ldap server info. This must be run by a member of the mqm group.

```
[mqm@wdc1-mq1 ~]$ runmqsc SSLDRHAQM1
5724-H72 (C) Copyright IBM Corp. 1994, 2022.
Starting MQSC for queue manager SSLDRHAQM1.

DEFINE AUTHINFO(SSLDRHAQM1.IDPW.LDAP) AUTHTYPE(IDPWLDAP) ADOPTCTX(YES) CONNAME('10.241.2.5(389)') SECCOMM(NO) CHCKLOCL(OPTIONAL) CHCKCLNT(OPTIONAL) CLASSGRP('groupOfUniqueNames') CLASSUSR('inetOrgPerson') FINDGRP('uniqueMember') BASEDNG('ou=groups,dc=ibm,dc=com') BASEDNU('ou=people,dc=ibm,dc=com') LDAPUSER('cn=admin,dc=ibm,dc=com') LDAPPWD('p@ssw0rd') SHORTUSR('uid') GRPFIELD('cn') USRFIELD('uid') AUTHORMD(SEARCHGRP) NESTGRP(YES)
```
Above we've created an authinfo object. While everything above is needed, here are the most important settings:

- AUTHINFO - we've named it `SSLDRHAQM1.IDPQ.LDAP`
- AUTHTYPE - `IDPWLDAP` Connection authentication user ID and password checking is done using an LDAP server.
- ADOPTCTX - `YES` - This means authenticated users are used for authorization checks, shown on administrative displays, and appear in messages.
- CONNAME - `10.241.2.5(389)` This the actual ip address of our docker host where our ldap container is running
- CHCKLOCL - This attribute determines the authentication requirements for locally bound applications, and is valid only for an AUTHTYPE of `IDPWOS` or `IDPWLDAP`. We are setting this to `OPTIONAL` which means locally bound applications are not required to provide a user ID and password. This is ideal for testing purposes.
- CHCKCLNT - This attribute determines the authentication requirements for client applications, and is valid only for an AUTHTYPE of IDPWOS or IDPWLDAP. We're setting it to `OPTIONAL` which means that client applications are not required to provide a user ID and password, but any provided will be authenticated against your authentication method. In our case, that's LDAP.
- SECCOMM - We aren't using LDAPS in this example, so this is set to `NO`

The rest of the settings are LDAP specific and should be mostly self-explanatory.

Next, execute the following command to reconfigure the **LDAPQM** queue manager to use the new **SSLDRHAQM1.IDPW.LDAP AUTHINFO object:**

```
ALTER QMGR CONNAUTH(SSLDRHAQM1.IDPW.LDAP)
REFRESH QMGR TYPE(CONFIGEV) OBJECT(AUTHREC)
REFRESH SECURITY
```

Now restart the queuemgr

```
[mqm@dwdc1-mq1 ~]$ endmqm -i SSLDRHAQM1 && strmqm SSLDRHAQM1
```

Now we need to set the authorizations and hope it all works. Make sure to run this command on the primary node as the `mqm` user:

```
setmqaut -m SSLDRHAQM1 -t qmgr -g "mqadmins" +connect +inq +alladm
setmqaut -m SSLDRHAQM1 -n "**" -t q -g "mqadmins" +alladm +crt +browse
setmqaut -m SSLDRHAQM1 -n "**" -t topic -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t channel -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t process -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t namelist -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t authinfo -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t clntconn -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t listener -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t service -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n "**" -t comminfo -g "mqadmins" +alladm +crt
setmqaut -m SSLDRHAQM1 -n SYSTEM.MQEXPLORER.REPLY.MODEL -t q -g "mqadmins" +dsp +inq +get
setmqaut -m SSLDRHAQM1 -n SYSTEM.ADMIN.COMMAND.QUEUE -t q -g "mqadmins" +dsp +inq +put
```

You can verify that LDAP auth is now working by running the following command using `mqadmin` as the user:

```
[mqm@wdc1-mq1 ~]$ runmqsc -u mqadmin SSLDRHAQM1
5724-H72 (C) Copyright IBM Corp. 1994, 2021.
Enter password:
*******
Starting MQSC for queue manager SSLDRHAQM1.
```
The password for mqadmin is `mqadmin`

## Testing

### Summary of Results:
- Mean time to failover between regions: `2.8 seconds`
- Mean time to failover between zones: `547 millisecond`
- Data-Loss during local(zonal) failover: `0`
- Data-loss during regional failover: `0`

### Testing Tools
-  [MQ Toolkit for Mac][https://developer.ibm.com/tutorials/mq-macos-dev/] comes with sample client programs to test.

## Failover testing for MQ HADR and RDQM
We have two avenues for testing failover:
1. Local failover between nodes in each cluster
	1. Loadbalancer lives in each region and handles the traffic failover between nodes
2. Regional failover between regions for disaster recovery
	1. MQIPT currently runs on our bastion host and provides proxied connections between regions. This does not support failover per se but does support converged proxying between sites.

### Setup

It's important to note that with a three node HA cluster, two nodes must be available to allow for a quorum. This is by design as in order to preserve the quorum between nodes, at least two nodes must be available.

Our two regions are defined thusly:
- DC
	- DRHAQM1 - queue manager with primary cluster in DC
	- DRHAQM2 - standby queue manager for DRHAQM2
- Dallas
	- DRHAQM2 - queue manager with primary cluster in Dallas
	- DRHAQM1 - standby queue manager for DRHAQM1

Each cluster is made up of three nodes:

DC
- wdc1-mq1
- wdc2-mq1
- wdc3-mq1

Dallas
- dal1-mq1
- dal2-mq1
- dal3-mq1

We create the following queues on each cluster. For the purposes of this test, we aren't going to enable any security.

On wdc1-mq1

```
runmqsc DRHAQM1
ALTER QMGR CHLAUTH(DISABLED)
ALTER QMGR CONNAUTH(' ')
REFRESH SECURITY (*)
DEFINE CHANNEL(DRHAMQ1.MQIPT) CHLTYPE(SVRCONN)
DEFINE QLOCAL(MQIPT.LOCAL.QUEUE)
DEFINE listener(LISTENER) trptype(tcp) control(qmgr) port(1501)
start listener(LISTENER)
QUIT

```

On dal1-mq1

```
runmqsc DRHAQM1
ALTER QMGR CHLAUTH(DISABLED)
ALTER QMGR CONNAUTH(' ')
REFRESH SECURITY (*)
DEFINE CHANNEL(DRHAMQ2.MQIPT) CHLTYPE(SVRCONN)
DEFINE QLOCAL(MQIPT.LOCAL.QUEUE)
DEFINE listener(LISTENER) trptype(tcp) control(qmgr) port(1502)
start listener(LISTENER)
QUIT
```

We configure our settings on our MQIPT host

```
[route]
Name=DRHAQM1
Active=true
ListenerPort=1501
Destination=3bdf30c3-us-east.lb.appdomain.cloud
DestinationPort=1501

[route]
Name=DRHAQM2
Active=true
ListenerPort=1502
Destination=e8deec77-us-south.lb.appdomain.cloud
DestinationPort=1502
```

The destination addresses are the load balancer for each region. This will move the connections between each node during failover.

We create a user that is part of the `mqm` group on each node. This is the user we must connect as when we run the tests.

### Testing with persistent messages with syncpoint

Relevant github link:
https://github.com/ibm-messaging/mq-rdqm

For these utilities to work you must install `MQSeriesSDK-9.2.5-0.x86_64.rpm` which is part of the MQ client/server installation package `mqadv_dev925_linux_x86-64.tar.gz`

**LINUX**
Clone the above repo to your home directory

```
git clone https://github.com/ibm-messaging/mq-rdqm.git
```

Install the relevant build tools

```
dnf -y install make cmake gcc
```

Go to the samples directory:

```
cd mq-rdqm/samples/C/linux
```

Update the `Makefile` to point to the `/opt/mqm` directory since that's where all of MQ's libs are installed.

```
MQDIR=/opt/mqm
```

Build the `rdqmget` and `rdqmput` binaries

```
[kramerro@wdc-mq-client linux]$ make all
gcc -m64 -I /opt/mqm/inc -c ../complete.c
gcc -m64 -I /opt/mqm/inc -c ../connection.c
gcc -m64 -I /opt/mqm/inc -c ../globals.c
gcc -m64 -I /opt/mqm/inc -c ../log.c
gcc -m64 -I /opt/mqm/inc -c ../options.c
gcc -m64 -I /opt/mqm/inc -o rdqmget ../rdqmget.c complete.o connection.o globals.o log.o options.o -L /opt/mqm/lib64 -l mqic_r -Wl,-rpath=/opt/mqm/lib64 -Wl,-rpath=/usr/lib64
gcc -m64 -I /opt/mqm/inc -o rdqmput ../rdqmput.c complete.o connection.o globals.o log.o options.o -L /opt/mqm/lib64 -l mqic_r -Wl,-rpath=/opt/mqm/lib64 -Wl,-rpath=/usr/lib64
```

Export the MQSERVER env var and kick off the `rdqmget` command. The `<mqipt adress>` is our MQIPT server.

```
export MQSERVER="DRHAMQ1.MQIPT/TCP/<mqipt address>(1501)"
```

The syntax is the same as the default sample application
```
<sample> [options] <queue manager name> <queue name>

./rdqmput -b10 -m5 -v 1 DRHAQM1 MQIPT.LOCAL.QUEUE
```

The default number of batches is 20 and the default batch size is 10 so by default rdqmput will put a total of 200 messages and rdqmget will get a total of 200 messages.

The above options will create 10 batches of 5 messages each. So we should see 50 messages when rdqmget drains the queue.

```
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 put successfully, committing...
Batch 1 committed successfully
Batch 2 put successfully, committing...
Batch 2 committed successfully
Batch 3 put successfully, committing...
Batch 3 committed successfully
Batch 4 put successfully, committing...
Batch 4 committed successfully
Batch 5 put successfully, committing...
Batch 5 committed successfully
Batch 6 put successfully, committing...
Batch 6 committed successfully
Batch 7 put successfully, committing...
Batch 7 committed successfully
Batch 8 put successfully, committing...
Batch 8 committed successfully
Batch 9 put successfully, committing...
Batch 9 committed successfully
Batch 10 put successfully, committing...
Batch 10 committed successfully
Completed

```

Now we retrieve them
```
[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 got successfully, committing...
Batch 1 committed successfully
Batch 2 got successfully, committing...
Batch 2 committed successfully
Batch 3 got successfully, committing...
Batch 3 committed successfully
Batch 4 got successfully, committing...
Batch 4 committed successfully
Batch 5 got successfully, committing...
Batch 5 committed successfully
Batch 6 got successfully, committing...
Batch 6 committed successfully
Batch 7 got successfully, committing...
Batch 7 committed successfully
Batch 8 got successfully, committing...
Batch 8 committed successfully
Batch 9 got successfully, committing...
Batch 9 committed successfully
Batch 10 got successfully, committing...
Batch 10 committed successfully
Completed
```

And the queue should be empty.

Next lets try a failover in the WDC cluster. FIrst we'll load up the queue with 10 batches of 5 messages each.

```
[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 put successfully, committing...
Batch 1 committed successfully
Batch 2 put successfully, committing...
Batch 2 committed successfully
Batch 3 put successfully, committing...
Batch 3 committed successfully
Batch 4 put successfully, committing...
Batch 4 committed successfully
Batch 5 put successfully, committing...
Batch 5 committed successfully
Batch 6 put successfully, committing...
Batch 6 committed successfully
Batch 7 put successfully, committing...
Batch 7 committed successfully
Batch 8 put successfully, committing...
Batch 8 committed successfully
Batch 9 put successfully, committing...
Batch 9 committed successfully
Batch 10 put successfully, committing...
Batch 10 committed successfully
Completed
```

Now lets failover the cluster to node2.

```
[root@wdc1-mq1 ~]# rdqmadm -s
The replicated data node 'wdc1-mq1' has been suspended.

```

This puts the primary node into standby node and shifts the queue over to node2. This can be verified with the following command on node2.

```
[root@wdc2-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s
QMNAME(DRHAQM1)                                           STATUS(Running)
    INSTANCE(wdc2-mq1) MODE(Active)

```

The load balancer should have shifted over the connection as well. So now from our client going through MQIPT, let's see if we can retrieve the messages we put in.

```
[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 got successfully, committing...
Batch 1 committed successfully
Batch 2 got successfully, committing...
Batch 2 committed successfully
Batch 3 got successfully, committing...
Batch 3 committed successfully
Batch 4 got successfully, committing...
Batch 4 committed successfully
Batch 5 got successfully, committing...
Batch 5 committed successfully
Batch 6 got successfully, committing...
Batch 6 committed successfully
Batch 7 got successfully, committing...
Batch 7 committed successfully
Batch 8 got successfully, committing...
Batch 8 committed successfully
Batch 9 got successfully, committing...
Batch 9 committed successfully
Batch 10 got successfully, committing...
Batch 10 committed successfully
Completed
```

And there they are. Let's push some messages back into the queue and fail back to node1.

```
[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 put successfully, committing...
Batch 1 committed successfully
Batch 2 put successfully, committing...
Batch 2 committed successfully
Batch 3 put successfully, committing...
Batch 3 committed successfully
Batch 4 put successfully, committing...
Batch 4 committed successfully
Batch 5 put successfully, committing...
Batch 5 committed successfully
Batch 6 put successfully, committing...
Batch 6 committed successfully
Batch 7 put successfully, committing...
Batch 7 committed successfully
Batch 8 put successfully, committing...
Batch 8 committed successfully
Batch 9 put successfully, committing...
Batch 9 committed successfully
Batch 10 put successfully, committing...
Batch 10 committed successfully
Completed
```

Now fail things back over

```
[root@wdc1-mq1 ~]# rdqmadm -r
The replicated data node 'wdc1-mq1' has been resumed.
```

We should see the queue back on node1 now.

```
[root@wdc1-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s
QMNAME(DRHAQM1)                                           STATUS(Running)
    INSTANCE(wdc1-mq1) MODE(Active)
```

Now from our client, let's get these messages.

```
[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 got successfully, committing...
Batch 1 committed successfully
Batch 2 got successfully, committing...
Batch 2 committed successfully
Batch 3 got successfully, committing...
Batch 3 committed successfully
Batch 4 got successfully, committing...
Batch 4 committed successfully
Batch 5 got successfully, committing...
Batch 5 committed successfully
Batch 6 got successfully, committing...
Batch 6 committed successfully
Batch 7 got successfully, committing...
Batch 7 committed successfully
Batch 8 got successfully, committing...
Batch 8 committed successfully
Batch 9 got successfully, committing...
Batch 9 committed successfully
Batch 10 got successfully, committing...
Batch 10 committed successfully
Completed
```

And there they are.

### Regional failover testing
First. let's write some messages to the queue. We'll export the MQSERVER env var still pointing to the MQIPT host and then write those messages.

```
[kramerro@wdc-mq-client linux]$ export MQSERVER="DRHAMQ1.MQIPT/TCP/<mqipt address>(1501)"
[kramerro@wdc-mq-client linux]$ ./rdqmput -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 put successfully, committing...
Batch 1 committed successfully
Batch 2 put successfully, committing...
Batch 2 committed successfully
Batch 3 put successfully, committing...
Batch 3 committed successfully
Batch 4 put successfully, committing...
Batch 4 committed successfully
Batch 5 put successfully, committing...
Batch 5 committed successfully
Batch 6 put successfully, committing...
Batch 6 committed successfully
Batch 7 put successfully, committing...
Batch 7 committed successfully
Batch 8 put successfully, committing...
Batch 8 committed successfully
Batch 9 put successfully, committing...
Batch 9 committed successfully
Batch 10 put successfully, committing...
Batch 10 committed successfully
Completed


```

**IMPORTANT**: _When failing between regions, this is not an automated process. If Region 1 went down completely, Region 2 would need to be manually started as it is for Disaster Recovery and not High Availibility. These processes can be automated externally with a monitoring solution that detects the loss of Region 1 and triggers an automated process that starts up Region 2. An example of how one might achieve this using Ansible has been provided in the **resources** folder in this repo._ 

### Failing over to Dallas
```
[root@wdc1-mq1 ~]# rdqmdr -s -m DRHAQM1
Queue manager 'DRHAQM1' has been made the DR secondary on this node.
```

And in Dallas, we have to tell node 1 that it's now primary for that queue manager

```
[root@ceng-dal1-mq1 ~]# rdqmdr -p -m DRHAQM1
Queue manager 'DRHAQM1' has been made the DR primary on this node.
```

Now we should see on node 1 in Dallas that we are now primary for that queue manager

```
[root@ceng-dal1-mq1 ~]# /opt/mqm/bin/dspmq -a -x -s
QMNAME(DRHAQM1)                                           STATUS(Running)
    INSTANCE(ceng-dal1-mq1) MODE(Active)
```

Now let's modify MQIPT to point to the Dallas cluster for this queue manager. Edit `/opt/mqipt/installation1/mqipt/HAMQ/mqipt.conf`

```
[route]
Name=DRHAQM1
Active=true
ListenerPort=1501
Destination=3bdf30c3-us-east.lb.appdomain.cloud
DestinationPort=1501

[route]
Name=DRHAQM2
Active=true
ListenerPort=1502
Destination=e8deec77-us-south.lb.appdomain.cloud
DestinationPort=1502
```

We are going to change the Destination for DRHAMQ1 to point to the load balancer in Dallas.

```
[route]
Name=DRHAQM1
Active=true
ListenerPort=1501
Destination=e8deec77-us-south.lb.appdomain.cloud
DestinationPort=1501

[route]
Name=DRHAQM2
Active=true
ListenerPort=1502
Destination=e8deec77-us-south.lb.appdomain.cloud
DestinationPort=1502
```

Now refresh mqipt with the following command. We have named this MQIPT instance to HAMQ:

```
root@wdc-bastion:/opt/mqipt/installation1/mqipt/HAMQ# /opt/mqipt/installation1/mqipt/bin/mqiptAdmin -refresh -n HAMQ
June 2, 2022 7:26:11 PM UTC
MQCAI105 Sending REFRESH command to MQIPT instance with name HAMQ
MQCAI025 MQIPT HAMQ has been refreshed
```

Now from our client, let's see if the messages are there.

```
[kramerro@wdc-mq-client linux]$ ./rdqmget -b10 -m5 -v1 DRHAQM1 MQIPT.LOCAL.QUEUE
Connected to queue manager DRHAQM1
Opened queue MQIPT.LOCAL.QUEUE
Batch 1 got successfully, committing...
Batch 1 committed successfully
Batch 2 got successfully, committing...
Batch 2 committed successfully
Batch 3 got successfully, committing...
Batch 3 committed successfully
Batch 4 got successfully, committing...
Batch 4 committed successfully
Batch 5 got successfully, committing...
Batch 5 committed successfully
Batch 6 got successfully, committing...
Batch 6 committed successfully
Batch 7 got successfully, committing...
Batch 7 committed successfully
