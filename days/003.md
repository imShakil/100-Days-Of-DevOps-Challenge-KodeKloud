# Secure SSH Root Access

Disable all app server SSH root access.

## Steps

1. Login into each app server ([this way](./001.md))
2. Modify `sshd_config` and restart sshd `service`

    ```sh
    sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    ```

## Good to Know?

### SSH Security Best Practices

- **Root Access**: Disable direct root login for security
- **Alternative**: Use sudo for administrative tasks
- **Key-based Auth**: Prefer SSH keys over passwords
- **Port Changes**: Consider changing default SSH port (22)

### SSH Configuration Options

- `PermitRootLogin no`: Disable root login
- `PasswordAuthentication no`: Disable password auth
- `PubkeyAuthentication yes`: Enable key-based auth
- `Port 2222`: Change default port

### Security Benefits

- **Audit Trail**: sudo logs all administrative actions
- **Principle of Least Privilege**: Users get minimal required access
- **Attack Surface**: Reduces brute force attack targets
- **Accountability**: Individual user accountability vs shared root
