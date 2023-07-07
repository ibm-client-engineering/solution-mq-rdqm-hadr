# mq-install 

The "mq-automation" Ansible role is designed to automate the process of setting up and managing IBM MQ (Message Queue) infrastructure. It comprises a series of tasks that collectively handle the preparation of the operating system, creation of the MQ user and group, setup of necessary file systems, downloading and staging of the MQ software, installation of the software, creation of Queue Managers, creation of queues (based on a condition), and starting or stopping the Queue Managers. By leveraging this Ansible role, users can streamline the deployment and management of IBM MQ, ensuring consistent and efficient configuration while reducing manual effort and potential errors.

## Prepare the OS:

This task imports the tasks defined in the mq-os-setup.yaml file to prepare the operating system for IBM MQ installation.
It includes actions such as configuring OS settings and dependencies required for MQ.

- Configure Sysctl settings:

  - The code modifies various kernel parameters using the sysctl command to optimize system performance and resource allocation.
  - By adjusting parameters such as kernel.shmmni, kernel.shmall, kernel.shmmax, kernel.sem, and fs.file-max, we can fine-tune the behavior of the Linux kernel to better suit the needs of IBM MQ and potentially improve its performance. 


- Update PAM limits for the mqm group:

  - PAM (Pluggable Authentication Modules) limits define the maximum system resources available to users or groups.
  - In this case, the code updates the limits for the mqm group by setting the maximum number of open file descriptors (nofile) to 10240.
  - This ensures that IBM MQ processes, which run under the mqm group, have sufficient file descriptor limits to handle concurrent connections and messaging.


- Install policy core utils:

  - The code installs the policycoreutils-python-utils package using the DNF package manager.
  - This package provides essential utilities for managing SELinux (Security-Enhanced Linux) policies and permissions.
  - SELinux is a security framework that provides access controls and policy enforcement mechanisms to further secure the system. Installing the policy core utils is crucial for working with SELinux in an IBM MQ environment.

## Create the MQ User and Group:

This task imports the tasks defined in the mq-create-users.yaml file to create the necessary user and group entities for IBM MQ. It ensures that the dedicated MQ user and group are created with appropriate permissions and configurations.

- Create MQM User and Group:

  - This code block performs the necessary steps to create the mqm group and user.
  - The mqm group is created with a specified group ID (mqm_gid).
  - The mqm user is created with a specific user ID (mqm_uid) and assigned to the mqm group.
  - Creating a separate user and group for MQ helps maintain security and isolation for MQ processes.


- Set up MQ user's environment variables:

  - This task ensures that the MQ user (mqm) has the appropriate environment variables set up.
  - The .bashrc file, which contains environment configurations, is copied from the files/bashrc source to the MQ user's home directory (/home/mqm/.bashrc).
  - This file is owned by the mqm user and group, and it has read permissions (0644).
  - Setting up environment variables helps provide the necessary settings for the MQ user's session.


- Set up MQ user's sudoer privileges:

  - This task grants specific sudoer privileges to the MQ user (mqm).
  - The community.general.sudoers module is used to manage sudoers configurations.
  - It creates a sudoers file named mqm-user-privs and specifies that the mqm user should have the privileges to execute specific MQ-related commands (/opt/mqm/bin/crtmqm, /opt/mqm/bin/dltmqm, /opt/mqm/bin/rdqmadm, /opt/mqm/bin/rdqmstatus).
  - Additionally, the nopassword option is set to true, allowing the mqm user to execute these commands without a password prompt.

## Create the filesystems:

This task imports the tasks defined in the mq-filesystems.yaml file to create the required filesystems for MQ. It handles the setup and configuration of filesystems necessary for storing MQ data and log files.

- Configure MQ Storage Device:

  - This block of tasks executes only when the "MQStorageVG" volume group is not present on the system. It ensures that the necessary storage configuration is in place.
  - The community.general.lvg module is used to create the "MQStorageVG" volume group. It associates the volume group with the physical volume specified by the 'mq_storage_dev' variable.
  - Following that, the community.general.lvol module creates the "MQStorageLV" logical volume within the "MQStorageVG" volume group. The logical volume is sized to occupy 100% of the available free space within the volume group.


- Set Fact and Debug:

  - The set_fact task sets the part_name fact based on the value of the 'rdqm_storage_dev' variable. This fact determines the name of the storage device partition to be created.
  - The debug task is used to display the value of the 'part_name' fact for debugging purposes. It helps verify the correctness of the fact assignment.


- Create the DRBD Pool storage:

  - This block of tasks executes only when the "drbdpool" volume group is not present on the system, ensuring the required storage configuration for the DRBD (Distributed Replicated Block Device) pool.
  - If the 'rdqm_storage_dev' variable contains the substring "nvme," the part_name fact is modified by appending "p1" to the device name. This accounts for NVME SSD devices that use a different partition naming scheme.
  - The community.general.parted module creates a partition (number 1) on the rdqm_storage_dev device. The partition is formatted with the ext4 filesystem.
  - Finally, the community.general.lvg module is used to create the "drbdpool" volume group. It associates the volume group with the partition specified by the part_name fact.

## Download and stage MQ software:

This task imports the tasks defined in the mq-download.yaml file to download and stage the IBM MQ software. It handles the retrieval and preparation of the software package required for the subsequent installation steps. It dynamically creates a URL that allows for flexibility in fetching the appropriate software version, specific to either Linux or Ubuntu. This automation simplifies the setup and deployment of IBM MQ.

- Set fact for Linux as our OS:

  - This task sets the 'ouros' fact to "linux" when the target operating system is either RHEL (Red Hat Enterprise Linux) or CentOS.
  - By setting this fact, the code determines the appropriate download URL for the MQ software based on the Linux operating system.


- Set fact for Ubuntu as our OS:

  - This task sets the 'ouros' fact to "ubuntu" when the target operating system is Ubuntu.
  -  Similar to the previous task, this fact is used to determine the correct download URL for the MQ software specific to the Ubuntu operating system.


- Download MQ Advanced for Developers:

  - This task utilizes the get_url module to download the MQ Advanced for Developers software package.
  - The URL is constructed dynamically based on the 'mq_dl_url' variable, version variable (replacing periods with empty spaces), and the 'ouros' fact (representing the Linux distribution).
  -  The downloaded software is saved to the /tmp/mq.tar.gz file.
  -  This task is tagged with "download" for easy identification and selective execution.


- Extract MQ from TAR:

  - This task uses the unarchive module to extract the MQ software from the /tmp/mq.tar.gz archive.
  - The archive is extracted to the /tmp directory on the target system.
  - The remote_src option is set to "yes" to indicate that the source archive resides on the Ansible control machine.
  - Like the previous task, this task is tagged with "download."

## Install MQ software:

This task imports the tasks defined in the mq-install.yaml file to install the IBM MQ software on the target system.
It handles the installation process, including software verification and configuration.

- Accept MQ License:

  - This task runs the MQ license acceptance script by executing the mqlicense.sh -accept command in the /tmp/MQServer/ directory.
  - The output of the command is stored in the 'license_out' variable using the register keyword. This helps capture the result of the license acceptance process.


- Collect a list of MQ packages to install:

  - This task retrieves a list of MQ package files available in the /tmp/MQServer/ directory using the ls command.
  - The list of package files is stored in the 'packagelist' variable using the register keyword.


- Install MQ Software RPMS or DEB files:

  - Depending on the operating system (os), either RPM packages (for rhel) or DEB files (for ubuntu) are installed using the appropriate package manager (ansible.builtin.dnf or ansible.builtin.apt).
  - The package names to install are provided as the values of the 'packagelist.stdout_lines' variable.
  - The installation is performed with additional settings like disabling GPG check and ensuring the desired package state (present).


- Run setmqinst on primary nodes:

  - This task executes the `setmqinst` command, which initializes the MQ installation by setting the installation path (MQ_INSTALLATION_PATH).
  - The command is only executed on nodes where the "primary" role is assigned. This ensures that the MQ installation is properly configured on primary nodes only.


- Install RDQM block:
  - This RDQM block of tasks focuses on installing and configuring components related to RDQM, which enables the replication and disaster recovery capabilities of IBM MQ. It ensures data redundancy and high availability in messaging systems.
  
- Get the DRBD kmod version:

  - This task retrieves the version of the DRBD (Distributed Replicated Block Device) kernel module installed on the system.
  - The shell module executes the command `'/tmp/MQServer/Advanced/RDQM/PreReqs/{{ rel }}/kmod-drbd-9/modver'`, storing the output in the 'kmodver' variable using the register keyword.
  - The failed_when condition checks if the return code (rc) is 1, indicating a failure in retrieving the version. This allows for handling scenarios where the DRBD kernel module is not present.


- Collect a list of pacemaker packages to install:

  - This task retrieves a list of pacemaker packages available in the '/tmp/MQServer/Advanced/RDQM/PreReqs/{{ rel }}/pacemaker-2/' directory using the ls command.
  - The list of package files is stored in the 'pacemakerlist' variable using the register keyword.
  - The packages will be installed later to ensure the necessary dependencies for pacemaker are met.


- Collect a list of DRBD packages to install:

  - This task retrieves a list of DRBD packages available in the '/tmp/MQServer/Advanced/RDQM/PreReqs/{{ rel }}/drbd-utils-9/drbd-*/' directory using the ls command.
  - The list of package files is stored in the 'drbdlist' variable using the register keyword.
  - The packages will be installed later to ensure the necessary dependencies for DRBD are met.


- Grab the name of the RDQM package to install:

  - This task retrieves the name of the RDQM package available in the '/tmp/MQServer/Advanced/RDQM/MQSeriesRDQM-*' directory using the ls command.
  - The package name is stored in the 'rdqmpkg' variable using the register keyword.
  - This package will be installed later to enable RDQM features in IBM MQ.


- Install DRBD kmod:

  - This task uses the ansible.builtin.dnf module to install the DRBD kernel module (kmod-drbd) package.
  - The package path is constructed dynamically based on the retrieved version (kmodver.stdout), allowing for the installation of the specific version required by the system.
  - Additional settings such as disabling GPG check and ensuring the package state (present) are applied during installation.


- Install pacemaker packages:

  - This task uses the ansible.builtin.dnf module to install the pacemaker packages necessary for RDQM.
  - The package names are provided as values from the 'pacemakerlist.stdout_lines' variable.
  - Additional settings such as disabling GPG check and ensuring the package state (present) are applied during installation.


- Install DRBD packages:

  - This task uses the ansible.builtin.dnf module to install the DRBD packages required for RDQM.
  - The package names are provided as values from the 'drbdlist.stdout_lines' variable.
  - Additional settings such as disabling GPG check and ensuring the package state (present) are applied during installation.


- Install RDQM Package:

  - This task uses the ansible.builtin.dnf module to install the RDQM package.
  - The package name is provided as the value from the 'rdqmpkg.stdout' variable.
  - Additional settings such as disabling GPG check and ensuring the package state (present) are applied during installation.


- Set the SELinux Context for DRBD:

  - This task uses the shell module to execute the `semanage permissive -a drbd_t` command.
  - It sets the SELinux context to permissive for the DRBD component, allowing it to function properly within the SELinux security framework.


- Set the mq user to be in the haclient group:

  - This task uses the ansible.builtin.user module to add the "mqm" user to the "haclient" group.
  - The name parameter specifies the user to modify, and the groups parameter specifies the group to which the user should be added.
  - The append parameter ensures that the user is added to the group without removing any existing group memberships.


- Generate the rdqm.ini file for primary hosts:

  - This task generates the rdqm.ini configuration file for primary hosts using the ansible.builtin.template module.
  - The source template file (rdqm.ini.j2) and destination path (/var/mqm/rdqm.ini) are specified.
  - The owner, group, and mode parameters set the ownership and permissions of the generated file.
  - The 'hostgroup' variable is passed to the template, allowing customization based on the primary host's group.


- Generate the rdqm.ini file for standby hosts:

  - This task generates the rdqm.ini configuration file for standby hosts, similar to the previous task.
  - The generation occurs only if the host is in the "standby" group and the DR state includes "passive".
  - The 'hostgroup' variable is passed to the template, allowing customization based on the standby host's group.


- Enable the local cluster:

  - This task uses the shell module to execute the `/opt/mqm/bin/rdqmadm -c `command, enabling the local cluster for RDQM.
  - The register keyword captures the output and status of the command in the 'clusterconfigprimary' variable.
  - The task fails if the return code (rc) is not equal to 0, indicating a failure in enabling the local cluster.
  - The execution of this task depends on whether changes were made to the rdqm.ini file (createdrdqmprimary.changed).


- Enable the remote cluster:

  - This task uses the shell module to execute the `/opt/mqm/bin/rdqmadm -c` command, enabling the remote cluster for RDQM.
  - The register keyword captures the output and status of the command in the 'clusterconfigstandby' variable.
  - The task fails if the return code (rc) is not equal to 0, indicating a failure in enabling the remote cluster.
  - The execution of this task depends on whether changes were made to the rdqm.ini file for standby hosts (createdrdqmstandby.changed) and the DR state includes "passive".

## Create Queue Managers 

This task creates queue managers defined in the 'group_vars' (/solution-mq-rdqm-hadr/resources/ansible/mq-automation/group_vars/all/main.yml). The task is setup to handle HA (High Availability) and HADR (High Availability Disaster Recovery) configurations and setup of the queue managers on the nodes based on the desired configuration.

- Get a list of existing Queue Managers:

  - This task retrieves a list of currently existing queue managers using the `dspmq` command and some text processing with `awk` and `sed`.
  - The list of queue manager names is stored in the 'qmgrlist' variable using the register keyword.
  - This information helps determine if a queue manager needs to be created and which may already exist. 


- Create Queue Managers:

  - This block of tasks handles the creation of queue managers based on certain conditions.
  - The templates/create_qm.sh.j2 template file is used to generate a shell script for queue manager creation.
  - The shell script is created for each queue manager defined in the 'queuemgrs' list.
  - The generated script is then executed on both standby and primary nodes, depending on the mq_role and 'qmgrlist' conditions.
  - The generated script will look for  the desired state for each queue manager in the 'queuemgrs' list. Each queue manager has two variables called "is_dr" and "is_ha". These stand for "is disaster recovery" and "is high availability". Based on these desired states, specific MQ commands need to be run on the 'primary' and 'standby' host groups and 'primary' and 'standby' nodes. The script looks at the configuration of the inventory.ini file and uses this to setup the queue manager desired HA/HADR state on the nodes. 
  - After execution, the script files are deleted.
  - If the queue manager is marked as HA (High Availability) and not DR (Disaster Recovery), an additional MQSC (MQ Scripting Command) file template templates/qmgr_settings.mqsc.j2 is set up.
  - The MQSC file is applied to the queue managers, configuring specific settings related to channel, queues, security, and listener.
  - Once applied, the MQSC template file is cleaned up.


- Open the firewall if necessary:

  - This block of tasks manages the opening of firewall ports if the enable_rdqm variable is set to true.
  - It checks the status of the 'firewalld' service and, if active, opens the specified port for each queue manager defined in the 'queuemgrs' list.

## Create Queues 

This task imports the tasks defined in the mq-create-queues.yaml and is designed to automate the creation of queues within an IBM MQ environment. It consists of tasks that generate command files for queue creation and then execute those commands using the 'runmqsc' utility. The task is conditional, running only on primary nodes when the 'create_queues' variable is set to true. 

- Generate Command Files:

  - This block of tasks is executed on primary nodes when the 'create_queues' variable is set to true.
  - It generates command files for creating queues using a template file templates/create_queue.in.j2.
  - The template file is customized for each queue manager defined in the 'queuemgrs' list.
  - The resulting command files are stored in /tmp/ with the queue manager name as the filename.


- Create the Queues:

  - This task is executed when changes occur in the generated command files.
  - It runs the `runmqsc` command, which executes the command files to create queues within each queue manager.
  - The task is run as the mqm user using become_user.
  - The success or failure of the queue creation is determined based on the output of the `runmqsc` command.
  - If the queue creation fails, the task fails if the return code (rc) is not 0 or 10, and the output doesn't contain the message indicating no syntax errors.


- Clean Up:

  - After the queue creation task, the command files (*.in) generated earlier are removed to clean up the temporary files.

## Stop/Start MQ Queue Managers

This task imports the tasks defined in the mq-start-RDQM.yaml and mq-stop-RDQM.yaml and is designed to stop and start queue managers created during installation.

<br>

# Requirements

To use this role, ensure that the following requirements are met:

- Ansible: Ensure that Ansible is installed on the control machine.
- Linux or Ubuntu: This role supports both Linux and Ubuntu distributions.

# Role Variables

To use this role, you may may need to change the following variables withing the following files:

resources/ansible/mq-automation/inventory.ini

- group name
  - Can be set to 'primary' or 'standby'
  - In order for the mq-install role to setup the DR/HA RDQM, you must have a group called 'primary' and 'standby'. The 'primary' group will be the actively running RDQM and the 'standby' group will be the failover group that the RDQM switches to when there is a failure of the 'primary' group. 
- ansible_host/backend_ip
  - Set this to the IP Addresses of your nodes
  - Depending on your environment, you can define either ansible_host IP or a backend IP. This is the IP address you want to use to configure your nodes. You must set one OR the other. 
- mq_role
  - Can be set to 'primary' or 'standby'
  - Within each group, you must specify a host to run the queue manager. This host will be set to 'primary'. The other two hosts will be set to 'standby'. As stated above, the 'primary' runs the queue manager and synchronously replicates its data to the 'standby' hosts. If the server running this queue manager fails, another instance of the queue manager starts and has current data to operate with.
- private_key_file
  - Set this to the path of your hosts' SSH key 

resources/ansible/mq-automation/group_vars/all/main.yml

- name
  - You can set the name of your queue manager 
- channel
  - Set this with the name you gave your queue manager followed by '.SRVCONN' 
- listener
  - Set this with the name you gave your queue manager followed by '.LISTENER'
- is_dr
  - This must be set to 'true' or 'false'
  - When set to true, this will setup the queue with disaster recovery (DR). When false, the queue manager will only reside within the 'primary' group and will not failover to the 'standby' group. 
- size
  - You can set the file size of your queue manager in megabytes (M) or gigabytes (G). 
  - It's important to choose an appropriate file system size based on your anticipated workload and storage requirements.
- listen-port
  - Can set the port your queue manager listens on. 
 
# Dependencies

This role does not have any external role dependencies and relies on default Ansible community plugins.

# Example Playbook
```
- hosts: all
  become: true
  become_user: root
  gather_facts: true
  roles:
  - role: mq-install
```
## CLI
```
~$ cd ../solution-mq-rdqm-hadr/resources/ansible/mq-automation/playbook.yaml
~$ ansible-playbook -i inventory.ini playbook.yml
```

# License

BSD
