# Setup Ansible

During the weekly meeting, the Nautilus DevOps team discussed about the automation and configuration management solutions that they want to implement. While considering several options, the team has decided to go with Ansible for now due to its simple setup and minimal pre-requisites. The team wanted to start testing using Ansible, so they have decided to use jump host as an Ansible controller to test different kind of tasks on rest of the servers.

Install ansible version 4.8.0 on Jump host using pip3 only. Make sure Ansible binary is available globally on this system, i.e all users on this system are able to run Ansible commands.

## Steps

To install run the following command on the jump host server:

```sh
sudo pip3 install ansible==4.8.0
```

## Good to Know?

### Ansible Fundamentals

- **Agentless**: No software installation required on managed nodes
- **SSH-based**: Uses SSH for communication (secure by default)
- **YAML**: Playbooks written in human-readable YAML format
- **Idempotent**: Safe to run multiple times, same result

### Ansible Components

- **Control Node**: Machine running Ansible (jump host)
- **Managed Nodes**: Target servers being configured
- **Inventory**: List of managed nodes and groups
- **Playbooks**: YAML files defining automation tasks
- **Modules**: Reusable units of work (copy, service, user)

### Installation Methods

- **pip**: `pip install ansible` (Python package manager)
- **Package Manager**: `yum install ansible` (OS packages)
- **Source**: Git clone for development versions
- **Virtual Environment**: Isolated Python environment

### Version Considerations

- **Compatibility**: Different versions support different features
- **Collections**: Ansible 2.10+ uses collections model
- **Python**: Requires Python 3.6+ on control node
- **Dependencies**: May need additional Python packages
