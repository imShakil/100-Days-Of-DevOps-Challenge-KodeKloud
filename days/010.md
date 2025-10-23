# Create a BASH Script

The production support team of `xFusionCorp Industries` is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on `App Server 3` in Stratos Datacenter, and they need to create a bash script named `beta_backup.sh` which should accomplish the following tasks. (Also remember to place the script under `/scripts` directory on `App Server 3`).

- Create a zip archive named `xfusioncorp_beta.zip` of `/var/www/html/beta` directory.
- Save the archive in `/backup/` on `App Server 3`. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.
- Copy the created archive to Nautilus Backup Server server in `/backup/` location.
- Please make sure script won't ask for **password** while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.

## Steps

1. Login into app server 3 and generate ssh-key:
2. Copy ssh-pub key to backup server. Follow [day 07](./007.md) to complete these two steps
3. Write the following script in `/scripts/beta_backup.sh`:

    ```sh
    #!/bin/sh

    zip -r /backup/xfusioncorp_beta.zip /var/www/html/beta
    scp /backup/xfusioncorp_beta.zip clint@stbkp01:/backup/
    ```

4. Give the execute permission:

    ```sh
    chmod +x /scripts/beta_backup.sh
    ```

## Good to Know?

### Bash Scripting Best Practices

- **Shebang**: Always start with `#!/bin/bash` or `#!/bin/sh`
- **Error Handling**: Use `set -e` to exit on errors
- **Variables**: Quote variables: `"$variable"` to prevent word splitting
- **Functions**: Break complex logic into reusable functions

### Backup Strategies

- **Full Backup**: Complete copy of all data
- **Incremental**: Only changed files since last backup
- **Differential**: Changed files since last full backup
- **Compression**: Use zip, tar.gz to save space

### Archive Commands

- **zip**: `zip -r archive.zip directory/` (cross-platform)
- **tar**: `tar -czf archive.tar.gz directory/` (Unix standard)
- **Exclusions**: Skip temporary files and logs
- **Verification**: Test archives before relying on them

### Remote Copy Methods

- **scp**: Secure copy over SSH
- **rsync**: Efficient synchronization tool
- **sftp**: Interactive file transfer
- **Authentication**: Use SSH keys for automation
