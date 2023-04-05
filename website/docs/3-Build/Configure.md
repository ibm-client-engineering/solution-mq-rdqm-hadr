---
id: solution-config
sidebar_position: 3
title: Configure
---

## Creating Disaster Recovery Queues

Now we are at the meat and potatoes. We're going to cover the steps to create a DR queue that is async replicated between regions. Let's get started.

Order is everything when it comes to creating a DR queue. The creation command is always run on the last node first and first node last.

### Creating DRHAQM1 With Primary in DC

```
WDC region
[mqm@wdc3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p \
-rl 10.241.0.4,10.241.64.4,10.241.128.4 \
-ri 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1
[mqm@wdc2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p \
-rl 10.241.0.4,10.241.64.4,10.241.128.4 \
-ri 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1
[mqm@wdc1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr p -p 1501 \
-rl 10.241.0.4,10.241.64.4,10.241.128.4 \
-ri 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1 # Primary node in the stack

DAL region
[mqm@dal3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s \
-ri 10.241.0.4,10.241.64.4,10.241.128.4 \
-rl 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1
[mqm@dal2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s \
-ri 10.241.0.4,10.241.64.4,10.241.128.4 \
-rl 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1
[mqm@dal1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr s \
-ri 10.241.0.4,10.241.64.4,10.241.128.4 \
-rl 10.240.0.4,10.240.64.4,10.240.128.4 \
-rp 7001 -fs 3072M DRHAQM1 # Primary node in the stack
```

Let's break down these commands:

**`crtmqm`** - command to actually create the queues

- **`-sxs`** - Replicated data HA secondary queue manager. This is run only on secondary or standby nodes when creating the queue.
- **`-sx`** - Replicated data HA Primary queue manager. This is run only on a primary node where you want the queue to live.
- **`-rr [p,s]`** - This is region specific. When you create your DR Queue, you would use "p" for the region you want to be DR Primary and "s" for the region you want to be standby. If you accidentally use "p" for both regions, your clusters will not talk to each other.
- **`-rl`**  `10.241.0.4,10.241.64.4,10.241.128.4` - Specifies the local ip address(es) to be used for DR replication of this queue manager. Basically your local region nodes go here.
- **`-ri`**  `10.240.0.4,10.240.64.4,10.240.128.4` - Specifies the IP address of the interface used for replication on the server hosting the secondary instance of the queue manager. Basically your remote region's nodes.
- **`-rp 7001`** - Specifies the port to use for DR replication. We're using port 7001 in this example.
- **`-fs 3072M`** - Specifies the size of the filesystem to create for the queue manager - that is, the size of the logical volume which is created in the drbdpool volume group. Another logical volume of that size is also created, to support the reverting to snapshot operation, so the total storage for the DR RDQM is just over twice that specified here.

If everything was done correctly, you should be able to log into your primary node in your primary region and run the following commands:

```
[mqm@wdc1-mq1 ~]$ sudo rdqmstatus -m DRHAQM1
Node:                                   wdc1-mq1
Queue manager status:                   Running
CPU:                                    0.00%
Memory:                                 182MB
Queue manager file system:              58MB used, 2.9GB allocated [2%]
HA role:                                Primary
HA status:                              Normal
HA control:                             Enabled
HA current location:                    This node
HA preferred location:                  This node
HA blocked location:                    None
HA floating IP interface:               None
HA floating IP address:                 None
DR role:                                Primary
DR status:                              Normal
DR port:                                7001
DR local IP address:                    10.241.0.4
DR remote IP address list:              10.240.0.4,10.240.64.4,10.240.128.4
DR current remote IP address:           10.240.0.4

Node:                                   wdc2-mq1
HA status:                              Normal

Node:                                   wdc3-mq1
HA status:                              Normal

[mqm@dal1-mq1 ~]$ sudo rdqmstatus -m DRHAQM1
Node:                                   dal1-mq1
Queue manager status:                   Ended immediately
HA role:                                Primary
HA status:                              Normal
HA control:                             Enabled
HA current location:                    This node
HA preferred location:                  This node
HA blocked location:                    None
HA floating IP interface:               None
HA floating IP address:                 None
DR role:                                Secondary
DR status:                              Normal
DR port:                                7001
DR local IP address:                    10.240.0.4
DR remote IP address list:              10.241.0.4,10.241.64.4,10.241.128.4
DR current remote IP address:           10.241.0.4

Node:                                   dal2-mq1
HA status:                              Normal

Node:                                   dal3-mq1
HA status:                              Normal
```

This queue service listener should be active on port 1501 on the primary node in the primary region only.

### Manual Failover Test

You can test failover with the following commands:

```
This tells the first node in the WDC region to become DR standby for the DRHAQM1 queue service
[root@wdc1-mq1 ~]# rdqmdr -s -m DRHAQM1


This tells the first node in the DAL region to become DR primary for the DRHAQM1 queue service
[root@dal1-mq1 ~]# rdqmdr -p -m DRHAQM1
```

So now the output of `rdqmstatus` will be:

```
[root@dal1-mq1 ~]# sudo rdqmstatus -m DRHAQM1
Node:                                   dal1-mq1
Queue manager status:                   Running
CPU:                                    1.09%
Memory:                                 182MB
Queue manager file system:              58MB used, 2.9GB allocated [2%]
HA role:                                Primary
HA status:                              Normal
HA control:                             Enabled
HA current location:                    This node
HA preferred location:                  This node
HA blocked location:                    None
HA floating IP interface:               None
HA floating IP address:                 None
DR role:                                Primary
DR status:                              Normal
DR port:                                7001
DR local IP address:                    10.240.0.4
DR remote IP address list:              10.241.0.4,10.241.64.4,10.241.128.4
DR current remote IP address:           10.241.0.4

Node:                                   dal2-mq1
HA status:                              Normal

Node:                                   dal3-mq1
HA status:                              Normal

[root@wdc1-mq1 ~]# sudo rdqmstatus -m DRHAQM1
Node:                                   wdc1-mq1
Queue manager status:                   Ended immediately
HA role:                                Primary
HA status:                              Normal
HA control:                             Enabled
HA current location:                    This node
HA preferred location:                  This node
HA blocked location:                    None
HA floating IP interface:               None
HA floating IP address:                 None
DR role:                                Secondary
DR status:                              Normal
DR port:                                7001
DR local IP address:                    10.241.0.4
DR remote IP address list:              10.240.0.4,10.240.64.4,10.240.128.4
DR current remote IP address:           10.240.0.4

Node:                                   wdc2-mq1
HA status:                              Normal

Node:                                   wdc3-mq1
HA status:                              Normal

```

You can fail everything back with the following commands

```
[root@dal1-mq1 ~]# rdqmdr -s -m DRHAQM1

[root@wdc1-mq1 ~]# rdqmdr -p -m DRHAQM1

```

The queue service should be accessible via port `1501` on the primary node in the primary region.

## MQIPT Configuration

### MQIPT Security with TLS

<b>MQIPT Security with TLS</b>
MQIPT accepts a TLS from a queue manager or a client, the certificate is validated. The MQIPT also terminates the connection this allows for dynamic configuration of backend servers.

- Certificates can be blocked or accepted based on the Distinguished Name.
- Certificate revocation checking is preformed.
- A certificate exit can be written to perform additional checks.

<b>Advanced Message Security ( AMS )</b> expands IBM MQ security services to provide data signing and encryption at the message level. The expanded services guarantees that message data has not been modified between when it is originally placed on a queue and when it is retrieved. In addition, AMS verifies that a sender of message data is authorized to place signed messages on a target queue.

### SSL configuration for MQ and MQ-IPT

For testing purposes, we are going to createa new queue manager and configure it with LDAP authentication and SSL.

#### Creating the new queue manager

Starting with `wdc3-mq1`

```
mqm@wdc3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ secondary queue manager created.
```

`wdc2-mq1`

```
[mqm@dwdc2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ secondary queue manager created.
```

`wdc1-mq1`

```
[mqm@wdc1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr p -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ queue manager 'SSLDRHAQM1' created.
Directory '/var/mqm/vols/ssldrhaqm1/qmgr/ssldrhaqm1' created.
The queue manager is associated with installation 'Installation1'.
Creating or replacing default objects for queue manager 'SSLDRHAQM1'.
Default objects statistics : 83 created. 0 replaced. 0 failed.
Completing setup.
Setup completed.
Enabling replicated data queue manager.
Replicated data queue manager enabled.
Issue the following command on the remote HA group to create the DR/HA
secondary queue manager:
crtmqm -sx -rr s -rl 10.240.0.4,10.240.64.4,10.240.128.4 -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
```

Now wash, rinse, repeat and create the queue with the `-rr` option set as `s` on the DR queue in Dallas:

`dal3-mq1`

```
[mqm@dal3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ secondary queue manager created.
```

`dal2-mq1`

```
[mqm@dal2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ secondary queue manager created.
```

`dal1-mq1`

```
[mqm@ceng-dal1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7005 -fs 3072M SSLDRHAQM1
Creating replicated data queue manager configuration.
IBM MQ secondary queue manager created.
Enabling replicated data queue manager.
Replicated data queue manager enabled.
```

Now we should see a happy replicated queue

```
[root@wdc1-mq1 ~]# rdqmstatus -m SSLDRHAQM1
Node:                                   wdc1-mq1
Queue manager status:                   Running
CPU:                                    0.00%
Memory:                                 182MB
Queue manager file system:              58MB used, 2.9GB allocated [2%]
HA role:                                Primary
HA status:                              Normal
HA control:                             Enabled
HA current location:                    This node
HA preferred location:                  This node
HA blocked location:                    None
HA floating IP interface:               None
HA floating IP address:                 None
DR role:                                Primary
DR status:                              Normal
DR port:                                7005
DR local IP address:                    10.241.0.4
DR remote IP address list:              10.240.0.4,10.240.64.4,10.240.128.4
DR current remote IP address:           10.240.0.4

Node:                                   wdc2-mq1
HA status:                              Normal

Node:                                   wdc3-mq1
HA status:                              Normal
```

Let's create the queue. From the primary node, log into the queue manager and create the channel and the queue and the listener at port 1503:

```
[mqm@wdc1-mq1 ~]$ runmqsc SSLDRHAQM1

DEFINE CHANNEL(SSLDRHAQM1.MQIPT) CHLTYPE(SVRCONN)
DEFINE QLOCAL(MQIPT.LOCAL.QUEUE)
DEFINE listener(LISTENER) trptype(tcp) control(qmgr) port(1503)
start listener(LISTENER)
```
