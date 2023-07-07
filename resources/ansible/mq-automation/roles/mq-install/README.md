# mq-install 

The "mq-automation" Ansible role is designed to automate the process of setting up and managing IBM MQ (Message Queue) infrastructure. It comprises a series of tasks that collectively handle the preparation of the operating system, creation of the MQ user and group, setup of necessary file systems, downloading and staging of the MQ software, installation of the software, creation of Queue Managers, creation of queues (based on a condition), and starting or stopping the Queue Managers. By leveraging this Ansible role, users can streamline the deployment and management of IBM MQ, ensuring consistent and efficient configuration while reducing manual effort and potential errors.


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
