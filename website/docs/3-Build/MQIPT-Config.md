---
id: solution-mqipt-config
sidebar_position: 4
title: MQIPT Configuration
---

## MQIPT Security with TLS

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