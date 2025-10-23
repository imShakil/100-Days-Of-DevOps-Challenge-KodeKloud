# Setup Docker Installation

The Nautilus DevOps team aims to containerize various applications following a recent meeting with the application development team. They intend to conduct testing with the following steps:

- Install docker-ce and docker compose packages on App Server 2.
- Initiate the docker service.

## Steps

1. Login into App server 2 and find out the linux distros

    ```sh
    cat /etc/os-release
    uname -a
    ```

    ```shell
    [steve@stapp02 ~]$ cat /etc/os-release 
    NAME="CentOS Stream"
    VERSION="9"
    ID="centos"
    ID_LIKE="rhel fedora"
    VERSION_ID="9"
    PLATFORM_ID="platform:el9"
    PRETTY_NAME="CentOS Stream 9"
    ANSI_COLOR="0;31"
    LOGO="fedora-logo-icon"
    CPE_NAME="cpe:/o:centos:centos:9"
    HOME_URL="https://centos.org/"
    BUG_REPORT_URL="https://issues.redhat.com/"
    REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
    REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
    ```

    > We can see it's CentOS 9 os
    > To install Docker on CentOS, follow the [official docs](https://docs.docker.com/engine/install/centos/)

2. Available Methods

    You can install docker in many ways, like using RPM repository, downloading the docker package, or using a bash script. I would recommended to install using rpm repository, or using one script solution.

3. Install Using BASH Script

    ```sh
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    ```

4. Enable Docker Service

    ```sh
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    ```

## Good to Know?

### Docker Fundamentals

- **Containerization**: Package applications with dependencies
- **Images**: Read-only templates for creating containers
- **Containers**: Running instances of Docker images
- **Dockerfile**: Text file with instructions to build images

### Docker Architecture

- **Docker Engine**: Core runtime for containers
- **Docker Daemon**: Background service managing containers
- **Docker CLI**: Command-line interface for Docker
- **Docker Registry**: Store and distribute Docker images

### Installation Methods

- **Repository**: Add Docker repo and install via package manager
- **Package**: Download and install .deb/.rpm packages
- **Script**: Automated installation script (convenience)
- **Docker Desktop**: GUI application for development

### Key Benefits

- **Portability**: Run anywhere Docker is installed
- **Consistency**: Same environment across dev/test/prod
- **Efficiency**: Share OS kernel, lightweight
- **Scalability**: Easy horizontal scaling
