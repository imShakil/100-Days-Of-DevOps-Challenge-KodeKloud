# Day 001: Linux User Setup with Non-interactive Shell

**Difficulty**: 🟢 Beginner | **Time**: 10 minutes | **Category**: Linux Administration

## 🎯 Objective

Create a user with non-interactive shell for your organization on a specific server. This is essential for service accounts and automated processes that don't require interactive login capabilities.

## 📋 Prerequisites

- Access to a Linux server (CentOS/Ubuntu/RHEL)
- sudo privileges
- Basic understanding of Linux user management

## 🔧 Technologies Used

- Linux user management commands
- SSH access
- System administration

## Steps

1. First, login into the app server using `SSH`:

    ```sh
    ssh user@app-server-ip or ssh user@server-name
    ```

    > It will ask for user password, enter the correct password.

2. After login into server, run the following command to create user with non-interactive shell

    ```sh
    sudo useradd -m -s /usr/sbin/nologin user-name
    ```

    `s`: for shell, here we are giving nologin shell

    `m`: for user home directory, It will create a directory with user-name under /home

3. Verify the result

    ```sh
    cat /etc/passwd
    ```

    It should give you a list of users where you will find your created user. It will look like this:
    `kareem:x:1003:1004::/home/kareem:/usr/sbin/nologin`

    Try to login using:

    ```sh
    sudo su user-name
    ```

    Output: `This account is currently not available.`

## Verification & Troubleshooting

### Common Issues

- **Permission denied**: Ensure you have sudo privileges
- **User already exists**: Check existing users with `cat /etc/passwd | grep username`
- **Shell not found**: Verify `/usr/sbin/nologin` exists on your system

### Additional Commands

```bash
# List all users with nologin shell
grep nologin /etc/passwd

# Check user details
id username

# Remove user if needed
sudo userdel -r username
```

## Related Topics

- [Day 002: Temporary User Setup with Expiry Date](./002.md)
- [Day 003: Secure SSH Root Access](./003.md)
- Linux user management best practices

## Key Takeaways

- Non-interactive shells prevent direct user login
- Service accounts should use `/usr/sbin/nologin` or `/bin/false`
- Always verify user creation with multiple methods
- Understanding user shells is crucial for system security

## Good to Know?

### Linux User Management

- **User Types**: Regular users, system users, service accounts
- **Shell Types**: `/bin/bash` (interactive), `/usr/sbin/nologin` (non-interactive), `/bin/false` (deny access)
- **User Database**: `/etc/passwd` stores user information, `/etc/shadow` stores passwords

### useradd Command Options

- `-m`: Create home directory
- `-s`: Specify shell
- `-d`: Custom home directory path
- `-g`: Primary group
- `-G`: Additional groups
- `-e`: Account expiry date

### Security Best Practices

- Service accounts should use non-interactive shells
- Regular users need interactive shells like `/bin/bash`
- Always verify user creation with multiple commands
- Use principle of least privilege

**Next Challenge**: [Day 002 - Temporary User Setup](./002.md)
