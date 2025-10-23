# Setup a Cron Job

The `Nautilus` system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in `Stratos DC` on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:

- Install `cronie` package on all `Nautilus` app servers and start `crond` service.
- Add a cron `*/5 * * * * echo hello > /tmp/cron_text` for `root` user.

## Steps

1. Login into each server using ssh (check [day01](./001.md))
2. Install `cronie` package into centos:

    ```sh
    sudo yum install cronie -y
    ```

3. Start crond service

    ```sh
    sudo systemctl enable crond
    sudo systemctl start crond
    ```

4. Create cron schedule:

    ```sh
    sudo crontab -e
    */5 * * * * echo hello > /tmp/cron_text
    ```

5. Verify crontab:

    ```sh
    sudo crontab -l
    ```

    and wait 5 minutes to check cron_text in /tmp/

## Automation Script

```sh
#!/bin/sh

# setup_cron_job.sh
# Script to setup cron job on CentOS for Nautilus app servers

set -e  # Exit on any error

echo "=== Setting up Cron Job on CentOS ==="

# Step 1: Install cronie package
echo "Installing cronie package..."
if ! rpm -q cronie &>/dev/null; then
    sudo yum install cronie -y
    echo "✓ cronie package installed successfully"
else
    echo "✓ cronie package already installed"
fi

# Step 2: Start and enable crond service
echo "Starting and enabling crond service..."
sudo systemctl start crond
sudo systemctl enable crond

# Verify service is running
if systemctl is-active --quiet crond; then
    echo "✓ crond service is running"
else
    echo "✗ Failed to start crond service"
    exit 1
fi

# Step 3: Add cron job for root user
echo "Adding cron job for root user..."

# Define the cron job
CRON_JOB="*/5 * * * * echo hello > /tmp/cron_text"

# Check if cron job already exists
if sudo crontab -l 2>/dev/null | grep -q "echo hello > /tmp/cron_text"; then
    echo "✓ Cron job already exists"
else
    # Add the cron job
    (sudo crontab -l 2>/dev/null || true; echo "$CRON_JOB") | sudo crontab -
    echo "✓ Cron job added successfully"
fi

# Step 4: Verify the setup
echo "Verifying cron job setup..."
echo "Current cron jobs for root user:"
sudo crontab -l

echo ""
echo "=== Setup Complete ==="
echo "The cron job will run every 5 minutes and write 'hello' to /tmp/cron_text"
echo "To monitor: sudo tail -f /var/log/cron"
echo "To check output: cat /tmp/cron_text (after 5+ minutes)"

# Optional: Show service status
echo ""
echo "Crond service status:"
sudo systemctl status crond --no-pager -l
```

## Good to Know?

### Cron Job Scheduling

- **Format**: `minute hour day month weekday command`
- **Ranges**: 0-59 (min), 0-23 (hour), 1-31 (day), 1-12 (month), 0-7 (weekday)
- **Special Characters**: `*` (any), `,` (list), `-` (range), `/` (step)
- **Examples**: `0 2 * * *` (daily 2 AM), `*/15 * * * *` (every 15 min)

### Cron Types

- **User Crontab**: `crontab -e` (per-user scheduling)
- **System Crontab**: `/etc/crontab` (system-wide)
- **Cron Directories**: `/etc/cron.d/`, `/etc/cron.daily/`

### Best Practices

- **Absolute Paths**: Always use full paths in cron jobs
- **Environment**: Set PATH, SHELL, MAILTO variables
- **Logging**: Redirect output to files for debugging
- **Testing**: Test commands manually before scheduling

### Troubleshooting

- **Logs**: Check `/var/log/cron` for execution history
- **Environment**: Cron runs with minimal environment
- **Permissions**: Ensure user has execute permissions
