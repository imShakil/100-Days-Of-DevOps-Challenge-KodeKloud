# Temporary User Setup with Expiry Date

As part of the temporary assignment to the Nautilus project, a developer named yousuf requires access for a limited duration. To ensure smooth access management, a temporary user account with an expiry date is needed. Here's what you need to do:

> Create a user named `yousuf` on `App Server 1` in Stratos Datacenter. Set the expiry date to `2024-01-28`, ensuring the user is created in lowercase as per standard protocol.

## Steps

1. Follow the [Day 01](./001.md) to connect server and run the following command:

    ```sh
    sudo useradd -m -e 2024-01-28 yousuf
    ```

2. Verify

    ```sh
    cat /etc/passwd
    sudo su yousuf
    ```

## Good to Know?

### User Account Expiry

- **Purpose**: Automatically disable accounts after specified date
- **Format**: YYYY-MM-DD (ISO 8601 standard)
- **Check Expiry**: `chage -l username` shows account aging info
- **Extend Expiry**: `sudo chage -E 2024-12-31 username`

### Temporary Account Management

- **Best Practice**: Always set expiry for temporary accounts
- **Monitoring**: Use `chage -l` to track account status
- **Cleanup**: Expired accounts remain but cannot login
- **Removal**: Use `userdel -r username` to completely remove

### Related Commands

- `chage`: Modify user password expiry information
- `usermod -e`: Modify existing user's expiry date
- `passwd -S`: Check password status
