---
id: solution-prepare
sidebar_position: 1
title: Prepare
---

# Pre-Requisites
## Environment Setup

In order to build out our setup, we are assuming three hosts that live in three different zones in a Dallas region and three hosts in three zones living in the Washington DC region . Our bastion host will also live in WDC and that's where we'll base our primary HA stack. We also assume root access via ssh to all hosts here. The OS on the mq hosts for our purposes will be **Red Hat 8.4**. We will also assume they are properly subscribed.

```
10.241.1.4          wdc-bastion

# WDC mq hosts
10.241.0.4          wdc1-mq1
10.241.64.4         wdc2-mq1
10.241.128.4        wdc3-mq1

# DAL mq hosts
10.240.0.4          dal1-mq1
10.240.64.4         dal2-mq1
10.240.128.4        dal3-mq1
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

2. Update mqm user's bashrc and bash profile. These paths don't exist as of yet until the actual installation of MQ. This needs to be done on all nodes.

```
echo "export MQ_INSTALLATION_PATH=/opt/mqm" >> ~mqm/.bashrc
echo '. $MQ_INSTALLATION_PATH/bin/setmqenv -s' >> ~mqm/.bashrc
echo 'export PATH=$PATH:/opt/mqm/bin:/opt/mqm/samp/bin:' >> ~mqm/.bash_profile
```

3. Update `/etc/sudoers` with the correct permissions for mqm user on all nodes.

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

5. Install lvm2 if it's not already there on all nodes

```
dnf -y install lvm2
```

6. Setup the volume group and logical volume for `/var/mqm` on all nodes. Device names may be different depending on your environment.

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

10. For SELinux: If keeping selinux set to targeted, run the following:

```
semanage permissive -a drbd_t
```

11. Add the following settings to `/etc/sysctl.conf`

```
kernel.shmmni = 4096
kernel.shmall = 2097152
kernel.shmmax = 268435456
kernel.sem = 32 4096 32 128
fs.file-max = 524288
```

Execute sysctl

```
sysctl -p
```

12. Set the ulimit for the mqm user by adding the following to `/etc/security/limits.conf`

```
# For MQM User
mqm       hard  nofile     10240
mqm       soft  nofile     10240
```
