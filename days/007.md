# Linux SSH Automation

The system admins team of xFusionCorp Industries has set up some scripts on jump host that run on regular intervals and perform operations on all app servers in Stratos Datacenter. To make these scripts work properly we need to make sure the thor user on jump host has password-less SSH access to all app servers through their respective sudo users (i.e tony for app server 1). Based on the requirements, perform the following:

Set up a password-less authentication from user thor on jump host to all app servers through their respective sudo users.

## Steps

1. On jump server, run the following command:

    ```sh
    ssh-keygen -t rsa -b 2048
    ```

    It will generate an ssh pub key and private key. We are going to share the pub key to all the app server for respective users.

2. Login into each app server and run the following command:

    ```sh
    mkdir -p .ssh
    vi .ssh/authorized_keys
    ```

    copy id_rsa.pub key from jump host inside /home/thor/.ssh/ and paste it there

## Optimized Automated Solution

```sh
#!/bin/sh

ssh-copy-id user@host
```

It will create .ssh directory for each app server if doesn't exist then copy paste host key to `authorized_keys` file.

## Good to Know?

### SSH Key Authentication

- **Key Types**: RSA (2048+ bits), Ed25519 (modern, faster), ECDSA
- **Components**: Private key (keep secret), Public key (share freely)
- **Location**: `~/.ssh/id_rsa` (private), `~/.ssh/id_rsa.pub` (public)
- **Security**: Much stronger than password authentication

### SSH Key Management

- **Generation**: `ssh-keygen -t rsa -b 4096` (strong RSA key)
- **Copy**: `ssh-copy-id user@host` (automated deployment)
- **Manual**: Copy public key to `~/.ssh/authorized_keys`
- **Permissions**: `700` for `.ssh/`, `600` for private keys, `644` for public keys

### Automation Benefits

- **Password-less**: No interactive password prompts
- **Scripting**: Enables automated deployments and backups
- **Security**: Eliminates password brute force attacks
- **Audit**: Key-based access is more traceable

### Best Practices

- **Passphrase**: Protect private keys with passphrases
- **Agent**: Use `ssh-agent` for passphrase caching
- **Rotation**: Regularly rotate SSH keys
- **Monitoring**: Track key usage and access patterns
