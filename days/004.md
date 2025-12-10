# Script Execute Permissions

In a bid to automate backup processes, the `xFusionCorp Industries` sysadmin team has developed a new bash script named `xfusioncorp.sh`. While the script has been distributed to all necessary servers, it lacks executable permissions on `App Server 1` within the Stratos Datacenter.

Your task is to grant executable permissions to the `/tmp/xfusioncorp.sh` script on `App Server 1`. Additionally, ensure that all users have the capability to execute it.

## Steps

1. Connect to App server 1
2. Check the current file permission status:

    ```sh
    ls -la /tmp
    ```

    ```txt
    4 ---------- 1 root root   40 Jul 30 02:21 xfusioncorp.sh
    ```

3. Run the following command to update permissions:

    ```sh
    sudo chmod 755 /tmp/xfusioncorp.sh
    ```

4. Verify the results:

    ```sh
    ls -la /tmp
    ```

    ```txt
    4 -rwxr-xr-x 1 root root   40 Jul 30 02:21 xfusioncorp.sh
    ```

## Understanding `chmod` in Linux

The `chmod` command in Linux is used to change the permissions (mode) of a file or directory. File permissions determine who can read, write, or execute a file.

### File Permission Basics

Each file in Linux has three types of permissions:

- Read (r) – Permission to read the file (4)
- Write (w) – Permission to modify the file (2)
- Execute (x) – Permission to run the file as a program (1)

Permissions are set for three categories of users:

- User (u) – The owner of the file (usually the one who created it)
- Group (g) – Users who belong to the same group as the file
- Others (o) – All other users on the system

Each of these categories can have its own combination of r, w, and x.

Two Ways to Use chmod

1. Symbolic Mode
    Use letters to set permissions:

    ```sh
    chmod u=rwx,g=rx,o=r test.sh
    ```

    This sets:

    - User (u): read, write, execute
    - Group (g): read, execute
    - Others (o): read only

    You can also use +, -, or =:

    - `+` adds permission
    - `-` removes permission
    - `=` sets exact permission

    Example:

    ```sh
    chmod g+w test.sh     # Add write permission for group
    chmod o-r test.sh     # Remove read permission for others
    ```

2. Numeric (Octal) Mode
    Each permission is represented by a binary digit:
    - r = 4
    - w = 2
    - x = 1

    You sum them up per category and write a 3-digit number:

    ```sh
    chmod 754 test.sh
    ```

    Breakdown:

    - 7 (User): 4+2+1 = rwx
    - 5 (Group): 4+0+1 = r-x
    - 4 (Others): 4+0+0 = r--

### Summary Table

| Role | Symbol | Permissions | Value |
|---|---|---|---|
|User|u|rwx|7|
|Group|g|r-x|5|
|Others|o|r--|4|

This system gives you fine-grained control over who can access your files and how they can interact with them.

## Good to Know?

### File Permission Fundamentals

- **Security Model**: Unix permissions protect system resources
- **Three Levels**: User (owner), Group, Others
- **Three Types**: Read (4), Write (2), Execute (1)
- **Octal System**: Base-8 numbering for permission representation

### Common Permission Patterns

- **755**: Standard executable (rwxr-xr-x)
- **644**: Standard file (rw-r--r--)
- **600**: Private file (rw-------)
- **777**: Full access (dangerous - avoid)

### Security Considerations

- **Principle of Least Privilege**: Grant minimum required permissions
- **Execute Bit**: Required for scripts and directories
- **Directory Permissions**: Execute needed to access directory contents
- **Sticky Bit**: Special permission for shared directories (/tmp)
