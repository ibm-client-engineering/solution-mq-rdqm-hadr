# Solution Document
<img align="right" src="https://user-images.githubusercontent.com/95059/166857681-99c92cdc-fa62-4141-b903-969bd6ec1a41.png" width="491" >

<!-- vscode-markdown-toc -->
* 1. [Background](#Background)
* 2. [Goals](#Goals)
* 3. [Overview](#Overview)
* 4. [Building Block View](#BuildingBlockView)
* 5. [Deployment](#Deployment)
* 6. [Security](#Security)
* 7. [Cost](#Cost)
* 8. [Risks and Technical Debts](#RisksandTechnicalDebts)
* 9. [Testing](#Testing)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

# Introduction and Goals

##  1. <a name='Background'></a>Background


##  2. <a name='Goals'></a>Goals
The goal of this project is to demonstrate the following proposed topologies in a hybrid multi-cloud scenario:
- Setting up architectures, configurations and standards for distributed app rotation
- Guaranteed message delivery
- Overall guidance on security exits
- Delivery over other mechanisms, not just MQ server
- Multiple availability zones across multiple clouds
- 
Doing this would be great, because we will:
- Validate MQIPT use cases
- Enhance productivity and user experience by how easy it is to define and deploy
- Develop pattern for modernization efforts

## Goals


# Solution Strategy

##  3. <a name='Overview'></a>Overview

This solution architecture demonstrates how you can deploy the Replicated Data Queue Manager in a Highly Available, Disaster Recovery enabled configuration across two isolated regions (MZRs in IBM Cloud or Regions in AWS).

- MQIPT nodes are setup in the DMZ to accept traffic from the internet and proxy the traffic to Application Load Balancer that in turn will direct the traffic to the active RDQM instance in one of the three active zones.

##  4. <a name='BuildingBlockView'></a>Building Block View

![test](./resources/rdqm-hadr-ibmcloud.png)
##  5. <a name='Deployment'></a>Deployment

## Manual Deployment
### Installing and Configuring IBM MQ and RDQM

This document serves as a documented process for installing IBM MQ and RDMQ bound to the # Solution Strategy. It assumes some basic familiarlity with Linux command line.

### Installation of MQ

In order to build out our setup, we are assuming three hosts that live in three different zones in a Dallas region and three hosts in three zones living in the Washington DC region . Our bastion host will also live in WDC and that's where we'll base our primary HA stack. We also assume root access via ssh to all hosts here. The OS on the mq hosts for our purposes will be **Red Hat 8.4**. We will also assume they are properly subscribed.

```
10.241.1.4      wdc-bastion      

# WDC mq hosts
10.241.0.4	        wdc1-mq1
10.241.64.4    	    wdc2-mq1
10.241.128.4	    wdc3-mq1

# DAL mq hosts
10.240.0.4	        dal1-mq1
10.240.64.4	        dal2-mq1
10.240.128.4	    dal3-mq1
```

Above is what the hosts file on our bastion host should look like. We would connect to the bastion host via a public ip. We won't go into configuring ssh `proxyjump` in this section.

### Host layout

Each of the above hosts barring the bastion have two extra disks attached:

```
Disk /dev/vda: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk /dev/vdb: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk /dev/vde: 25 GiB, 26843545600 bytes, 52428800 sectors
```

- `/dev/vda` is our boot volume
- `/dev/vdb` will become our logical volume for `/var/mqm`
- `/dev/vde` will be our RDQM managed volume

IBM MQ installation recommends multiple separate disks for various aspects of MQ to increase performance and minimize overall I/O during heavy operations. For our purposes, we will only be going with one volume for MQ.

### System preparation

1. Create the mqm userid and group. This step occurs on all host minus the bastion host.

```
groupadd -g 1001 mqm
useradd -g mqm -u 1001 -m -c "MQM User" mqm 
```
2. Update mqm user's bashrc and bash profile. These paths don't exist as of yet until the actual installation of MQ.
```
echo "export MQ_INSTALLATION_PATH=/opt/mqm" >> ~mqm/.bashrc
echo '. $MQ_INSTALLATION_PATH/bin/setmqenv -s' >> ~mqm/.bashrc
echo 'export PATH=$PATH:/opt/mqm/bin:/opt/mqm/samp/bin:' >> ~mqm/.bash_profile
```

3. Update `/etc/sudoers` with the correct permissions for mqm user
```
echo "%mqm ALL=(ALL) NOPASSWD: /opt/mqm/bin/crtmqm,/opt/mqm/bin/dltmqm,/opt/mqm/bin/rdqmadm,/opt/mqm/bin/rdqmstatus" >> /etc/sudoers
``` 
4. **OPTIONAL** - for ease of use and communication, you can create an ssh key for the `mqm` user and propagate it across the nodes in each stack. This isn't required, but it can mean you might only need to run some commands on the primary node in each stack and it will run the appropriate commands on each node behind the scenes.

    On Node 1:
```
as mqm user
[mqm@wdc1-mq1 ~]$ ssh-keygen -t rsa -f /home/mqm/.ssh/id_rsa -N ''
[mqm@dal1-mq1 ~]$ ssh-keygen -t rsa -f /home/mqm/.ssh/id_rsa -N ''
```

Manually copy the public key to the `authorized_keys` file in `~/.ssh` for `mqm` user on each node in each stack.

5. Install lvm2 if it's not already there
```
dnf -y install lvm2
```
6. Setup the volume group and logical volume for `/var/mqm`
```
pvcreate /dev/vdb
vgcreate MQStorageVG /dev/vdb
lvcreate -n MQStorageLV -l100%VG MQStorageVG
```
7. Create the `/var/mqm` directory and format the storage volume
```
mkdir /var/mqm
mkfs.xfs /dev/MQStorageVG/MQStorageLV
mount /dev/MQStorageVG/MQStorageLV /var/mqm
```
8. Make sure `/var/mqm` is fully owned by the mqm user and that everything is setup in `/etc/fstab`
```
chown -R mqm:mqm /var/mqm
chmod 755 /var/mqm
echo "/dev/MQStorageVG/MQStorageLV      /var/mqm        xfs     defaults        1 2" >> /etc/fstab
```
9. Configure the storage volume for RDQM. **It's critical that the volume group is named `drbdpool`.**
```
parted -s -a optimal /dev/vde mklabel gpt 'mkpart primary ext4 1 -1'
pvcreate /dev/vde1
vgcreate drbdpool /dev/vde1
```
10. Add the following settings to `/etc/sysctl.conf`
```
kernel.shmmni = 4096
kernel.shmall = 2097152
kernel.shmmax = 268435456
kernel.sem = 32 4096 32 128
fs.file-max = 524288

sysctl -p
```
11. Set the ulimit for the mqm user by adding the following to `/etc/security/limits.conf`
```
# For MQM User
mqm       hard  nofile     10240
mqm       soft  nofile     10240
```

### Installing MQ

This requires you to go to the following link and retrieving IBM MQ Advanced developer version 9.2.5:

[**mqadv_dev925_linux_x86-64.tar.gz**](https://www14.software.ibm.com/cgi-bin/weblap/lap.pl?popup=Y&li_formnum=L-APIG-BYHCL7&accepted_url=https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev925_linux_x86-64.tar.gz)

Once you have the package,  you will need to upload it to all six hosts. This document will assume you have done this. The following steps need to be taken on each host.

1. Extract the package on each host
```
tar zxvf mqadv_dev925_linux_x86-64.tar.gz
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

### **Installing RDQM**

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

### **Creating A Disaster Recovery Queue**

Now we are at the meat and potatoes. We're going to cover the steps to create a DR queue that is async replicated between regions. Let's get started.

Order is everything when it comes to creating a DR queue. The creation command is always run on the last node first and first node last.

#### **Creating DRHAQM1 With Primary in DC**

```
WDC region
[mqm@wdc3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1
[mqm@wdc2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr p -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1
[mqm@wdc1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr p -p 1501 -rl 10.241.0.4,10.241.64.4,10.241.128.4 -ri 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1 # Primary node in the stack

DAL region
[mqm@ceng-dal3-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1
[mqm@ceng-dal2-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sxs -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1
[mqm@ceng-dal1-mq1 ~]$ sudo /opt/mqm/bin/crtmqm -sx -rr s -ri 10.241.0.4,10.241.64.4,10.241.128.4 -rl 10.240.0.4,10.240.64.4,10.240.128.4 -rp 7001 -fs 3072M DRHAQM1 # Primary node in the stack
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

##  6. <a name='Security'></a>Security
<b>MQIPT Security with TLS</b>
MQIPT accepts a TLS from a queue manager or a client, the certificate is validated. The MQIPT also terminates the connection this allows for dynamic configuration of backend servers.

- Certificates can be blocked or accepted based on the Distinguished Name.
- Certificate revocation checking is preformed.
- A certificate exit can be written to perform additional checks.  

![test](./resources/MQIPT_TLS_Security.png)

<b>Advanced Message Security ( AMS )</b> expands IBM MQ security services to provide data signing and encryption at the message level. The expanded services guarantees that message data has not been modified between when it is originally placed on a queue and when it is retrieved. In addition, AMS verifies that a sender of message data is authorized to place signed messages on a target queue.

Referance Links:

https://www.ibm.com/docs/en/ibm-mq/9.0?topic=tls-configuring-security-mq

https://www.ibm.com/docs/en/ibm-mq/9.0?topic=securing-planning-your-security-requirements

https://www.ibm.com/docs/en/ibm-mq/9.0?topic=mechanisms-message-security-in-mq


##  7. <a name='Cost'></a>Cost

##  8. <a name='RisksandTechnicalDebts'></a>Risks and Technical Debts

##  9. <a name='Testing'></a>Testing

# Architecture Decisions
