---
id: solution-install
sidebar_position: 2
title: Installation
---

## Downloading the software

This requires you to go to the following link and retrieve IBM MQ Advanced developer version 9.3.x:

[**MQADV Link**](https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/)

Select the latest version of IBM MQ Adv and download it. At the time of this writing, that version should be `mqadv_dev932_linux_x86-64.tar.gz`.

> **Note**
> 
> _We are using the plain Linux release of MQ in this scope since we are using RHEL. There is also a version for Ubuntu._

Once you have the package,  you will need to upload it to all six hosts. This document will assume you have done this. The following steps need to be taken on each host.

1. Extract the package on each host
```
tar zxvf mqadv_dev931_linux_x86-64.tar.gz
cd MQServer
```
2. Run the mqlicense script to accept the IBM license
```
./mqlicense.sh -accept
```
3. Install the packages for MQ on each host
```
dnf -y install MQSeries*.rpm --nogpgcheck
```
4. Run the following command **ONLY** on the primary node in each stack. For example, for our WDC stack we would run this on `wdc1-mq1` and for our Dallas stack we would run this only on `dal1-mq1`
```
[root@dal1-mq1 ~]# /opt/mqm/bin/setmqinst -i -p /opt/mqm
[root@wdc1-mq1 ~]# /opt/mqm/bin/setmqinst -i -p /opt/mqm
```

## Installing RDQM

One of the primary components for RDQM is DRBD. IBM packages its own kmod-drbd packages with the MQ tar file. This is why knowing what kernel version you are running is critical. For this, IBM included a script called `modver`. The following commands need to be performed on every host in each region.

1. On each host, run the `modver` script to determine which kmod to install
```
cd ~/MQServer/Advanced/RDQM/PreReqs/el8/kmod-drbd-9
./modver
kmod-drbd-9.1.5_4.18.0_305-1.x86_64.rpm
```
This should show you which of the kernel packages in that directory that you need to install. If it returns any sort of error, you need to follow the link it provides and download the appropriate kmod-drbd version.

2. Install the kmod-drbd version
```
cd ~/MQServer/Advanced/RDQM/PreReqs/el8/kmod-drbd-9
dnf -y install $(./modver) --nogpgcheck
```
3. Install pacemaker and drbd-utils
```
cd MQServer/Advanced/RDQM/PreReqs/el8/pacemaker-2
dnf -y install *.rpm --nogpgcheck

cd MQServer/Advanced/RDQM/PreReqs/el8/drbd-utils-9/
dnf -y install *.rpm --nogpgcheck
```
4. Install policycoretutils-python-utils to set the correct security context for DRBD
```
dnf -y install policycoreutils-python-utils
semanage permissive -a drbd_t
```
5. Configure `firewalld` on each host. We're going to add a range of ports for async communication between stacks as well as between nodes. We'll also add our listener ports for the queue listener services.
```
firewall-cmd --add-port=6996-7800/tcp --permanent
firewall-cmd --add-port=1414-1514/tcp --permanent
firewall-cmd --reload
```
6. Finally, install the RDQM package itself
```
dnf -y install ~/MQServer/Advanced/RDQM/MQSeriesRDQM-9.2.5-0.x86_64.rpm --nogpgcheck
```
7. Edit `/var/mqm/rdqm.ini` and add in the hosts for that stack. This will be different per region but the `Name` field needs to be added to the default file and it **must** match the hostname of each node:

`/var/mqm/rdqm.ini` in WDC

```
Node:
  Name=wdc1-mq1
  HA_Replication=10.241.0.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=
Node:
  Name=wdc2-mq1
  HA_Replication=10.241.64.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=
Node:
  Name=wdc3-mq1
  HA_Replication=10.241.128.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=

#DRGroup:
#  Name=
#  DR_Replication=
#  DR_Replication=
#  DR_Replication=
```
`/var/mqm/rdqm.ini` in DAL
```
Node:
  Name=dal1-mq1
  HA_Replication=10.240.0.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=
Node:
  Name=dal2-mq1
  HA_Replication=10.240.64.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=
Node:
  Name=dal3-mq1
  HA_Replication=10.240.128.4
#  HA_Primary=
#  HA_Alternate=
#  DR_Replication=

#DRGroup:
#  Name=
#  DR_Replication=
#  DR_Replication=
#  DR_Replication=

```

8. Run the following on the primary node in each region:

```
/opt/mqm/bin/rdqmadm -c
```
If the ssh key was configured as mentioned above, the mqm user should be able to run this command on each node in the background. Otherwise the STDOUT returned will tell you wnat nodes still need to have it run.

9. Verify we're all online with:
```
rdqmstatus -n
```

10. Update the groups for `mqm` user. The `mqm` user must be a member of the `haclient` group in order to perform some tasks on replicated queumanagers like `endmqm` or `strmqm`. This must be run on all nodes.

```
usermod -a -G haclient mqm
```

## Installing MQIPT

- SSH into your MQIPT server(s).
- Download and stage the MQIPT Software from [IBM Fix Central](https://ibm.biz/mq93ipt)

In our instance we are downloading version `9.2.5.0-IBM-MQIPT-LinuxX64`

```
wget https://ak-delivery04-mul.dhe.ibm.com/sdfdl/v2/sar/CM/WS/0abcp/0/Xa.2/Xb.jusyLTSp44S0Bn8mossn7uopQHHST9iA1hmsJz52XllxgZWtruzIzbUG_ZE/Xc.CM/WS/0abcp/0/9.2.5.0-IBM-MQIPT-LinuxX64.tar.gz/Xd./Xf.LPR.D1VK/Xg.11755825/Xi.habanero/XY.habanero/XZ.1osh26bJ4dLZBVRjImrn31hkVvRbtvt0/9.2.5.0-IBM-MQIPT-LinuxX64.tar.gz
```

Please note that the `wget` command will not work - we are simply copying the direct link to the download from Fix Central and using `wget` to stage the software directly on the MQIPT servers.

- Create a directory to unpack the MQ IPT Software

```
mkdir -p /opt/mqipt/installation1
```

- Unpack the MQIPT software and modify permissions

```
cd /opt/mqipt/installation1/
tar zxvf ~/9.2.5.0-IBM-MQIPT-LinuxX64.tar.gz
chmod -R a-w /opt/mqipt/installation1/mqipt
```

- Append the following to your `~/.bashrc` file for your MQIPT user

```
MQIPT_PATH=/opt/mqipt/installation1/mqipt
export MQIPT_PATH
export PATH=$PATH:$MQIPT_PATH/bin
```
- You can now `source` your .bashrc by issuing the following command

```
. ~/.bashrc
```

- Create MQIPT configuration file

```
mkdir /opt/mqipt/installation1/mqipt/configs
cp /opt/mqipt/installation1/mqipt/samples/mqiptSample.conf /opt/mqipt/installation1/mqipt/configs/mqipt.conf
```

In this instance we are copying the sample configuration file to our MQIPT installation destination.

- Modify the `mqipt.conf` file

```
[route]
Name=DRHAQM1
Active=true
ListenerPort=1501
Destination=<hostname of your load balancer>
DestinationPort=1501

[route]
Name=DRHAQM2
Active=true
ListenerPort=1502
Destination=<hostname of your load balancer>
DestinationPort=1502
```
In this implementation we are creating two `[route]` entries for the two different regions that correspond to our 2 queues. Recall that we had previously created `DRHAQM1` and `DRHAQM2` to be listening on ports `1501` and `1502` respectively. Our loadbalanacer was also configured to forward traffic to these ports.


- Start MQIPT

```
mqipt /opt/mqipt/installation1/mqipt -n HAMQ
```

You should see the following output

```
5724-H72 (C) Copyright IBM Corp. 2000, 2022 All Rights Reserved
MQCPI001 IBM MQ Internet Pass-Thru 9.2.5.0 starting
MQCPI004 Reading configuration information from mqipt.conf
MQCPI152 MQIPT name is DRHAMQ
MQCPI022 Password checking has been disabled on the command port
MQCPI144 MQ Advanced capabilities not enabled
MQCPI011 The path /opt/mqipt/installation1/mqipt/configs/logs will be used to store the log files
MQCPI006 Route 1502 is starting and will forward messages to :
MQCPI034 .... ourlb.appdomain.cloud(1502)
MQCPI035 ....using MQ protocol
MQCPI078 Route 1502 ready for connection requests
MQCPI006 Route 1501 is starting and will forward messages to :
MQCPI034 ....ourlb.appdomain.cloud(1501)
MQCPI035 ....using MQ protocol
MQCPI078 Route 1501 ready for connection requests
```
Note that this initial implementation of MQIPT does not account for any mTLS or handshaking. In this mode, it is simply proxying traffic to the MQ servers (through our loadbalancers).

### Enable MQIPT as a system service

*This assumes you are running on Red Hat >= 7.x, CentOS >= 7.x, or Ubuntu >= 16.x*

Create a new systemd service file called `/etc/systemd/system/mqipt.service`
```
[Unit]
Description=MQIPT Service for IBM MQ
Wants=network-online.target
After=network-online.target

[Service]
Type=exec
ExecStart=/bin/bash -c "/opt/mqipt/installation1/mqipt/bin/mqipt /opt/mqipt/installation1/mqipt/configs -n HAMQ"
ExecStop=/bin/bash -c "/opt/mqipt/installation1/mqipt/bin/mqiptAdmin -stop -n HAMQ"

[Install]
WantedBy=multi-user.target
```
In the file we created above, we've named our MQIPT instance as **HAMQ**. Logs can be viewed using the `systemctl` command or the `journalctl` command.

Refresh systemd with `systemctl daemon-reload`

Now MQIPT can be enabled to start on boot

```
systemctl enable mqipt
```
This will install the service file for mqipt to `/etc/init.d` which can be controlled using the `systemctl` command.
```
systemctl start mqipt
```
Make sure to enable this at boot time
```
systemctl enable mqipt
```
### Templating the service file for multiple MQIPT instances

MQIPT has the ability to run with multiple instances and to control that with systemd we can simply create a config directory for each instance we want to control and run each with separate systemd templates. For example, we want to create an instance of MQIPT and name it `HAMQ`:

```
mkdir /opt/mqipt/installation1/mqipt/HAMQ
```
Move our existing `mqipt.conf` to that directory
```
mv /opt/mqipt/installation1/mqipt/configs/mqipt.conf /opt/mqipt/installation1/mqipt/HAMQ
```
Create a systemd service template as `/etc/systemd/system/mqipt-@.service`
```
touch /etc/systemd/system/mqipt-\@.service
vi /etc/systemd/system/mqipt-\@.service
```
Insert the following into the new service file
```
[Unit]
Description=MQIPT Service for IBM MQ %i Instance
Wants=network-online.target
After=network-online.target

[Service]
Type=exec
ExecStart=/bin/bash -c "/opt/mqipt/installation1/mqipt/bin/mqipt /opt/mqipt/installation1/mqipt/%i -n %i"
ExecStop=/bin/bash -c "/opt/mqipt/installation1/mqipt/bin/mqiptAdmin -stop -n %i"
ExecReload=/bin/bash -c "/opt/mqipt/installation1/mqipt/bin/mqiptAdmin -refresh -n %i"

[Install]
WantedBy=multi-user.target
```
Now this service template can be enabled for our `HAMQ` instance with the following:

```
systemctl daemon-reload
systemctl enable mqipt-@HAMQ.service
systemctl start mqipt-@HAMQ.service
```
Now if we want to run multiple instances of MQIPT that bind to different ports, we can do so with separate instance names that are controllable via systemd by simply creating the instance directory in `/opt/mqipt/installation1/mqipt`, putting a unique `mqipt.conf` in that directory, and then enabling it as a service with systemctl.

We can also update our configs and refresh the instance without restarting mqipt with
```
systemctl reload mqipt-@HAMQ.service
```

**It's important to note that your instances can't be on the same ports.**