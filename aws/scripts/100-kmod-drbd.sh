cd ~/work/MQServer/Advanced/RDQM/PreReqs/el8/kmod-drbd-9
sudo dnf -y install $(./modver) --nogpgcheck

cd ~/work/MQServer/Advanced/RDQM/PreReqs/el8/pacemaker-2
sudo dnf -y install *.rpm --nogpgcheck

cd ~/work/MQServer/Advanced/RDQM/PreReqs/el8/drbd-utils-9/
sudo dnf -y install *.rpm --nogpgcheck

sudo dnf -y install policycoreutils-python-utils
sudo semanage permissive -a drbd_t