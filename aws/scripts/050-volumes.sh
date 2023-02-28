sudo su
parted -s -a optimal /dev/nvme1n1 mklabel gpt 'mkpart primary ext4 1 -1'
pvcreate /dev/nvme1n1p1
vgcreate MQStorageVG /dev/nvme1n1p1
lvcreate -n MQStorageLV -l100%VG MQStorageVG


mkdir /var/mqm
mkfs.xfs /dev/MQStorageVG/MQStorageLV
mount /dev/MQStorageVG/MQStorageLV /var/mqm

chown -R mqm:mqm /var/mqm
chmod 755 /var/mqm
echo "/dev/MQStorageVG/MQStorageLV      /var/mqm        xfs     defaults        1 2" >> /etc/fstab
mount -a

parted -s -a optimal /dev/nvme2n1 mklabel gpt 'mkpart primary ext4 1 -1'
pvcreate /dev/nvme2n1p1
vgcreate drbdpool /dev/nvme2n1p1


