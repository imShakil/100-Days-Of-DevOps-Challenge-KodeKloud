# Debugging MariaDB Issues

There is a critical issue going on with the Nautilus application in Stratos DC. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server.

## Steps

We have to consider few things:

- files permission
- socket file
- data directory
- config issue

1. Login into Database Server:

    ```sh
    ssh peter@stdb01
    ```

2. look at the mariadb logs:

    ```sh
    tail -f /var/log/mariadb.log
    ```

    ```bash
    [root@stdb01 mariadb]# tail -f mariadb.log 
    2025-08-03  8:54:14 0 [Note] /usr/libexec/mariadbd (initiated by: unknown): Normal shutdown
    2025-08-03  8:54:14 0 [Note] Event Scheduler: Purging the queue. 0 events
    2025-08-03  8:54:14 0 [Note] InnoDB: FTS optimize thread exiting.
    2025-08-03  8:54:14 0 [Note] InnoDB: Starting shutdown...
    2025-08-03  8:54:14 0 [Note] InnoDB: Dumping buffer pool(s) to /var/lib/mysql/ib_buffer_pool
    2025-08-03  8:54:14 0 [Note] InnoDB: Buffer pool(s) dump completed at 250803  8:54:14
    2025-08-03  8:54:14 0 [Note] InnoDB: Removed temporary tablespace data file: "ibtmp1"
    2025-08-03  8:54:14 0 [Note] InnoDB: Shutdown completed; log sequence number 45091; transaction id 21
    2025-08-03  8:54:14 0 [Note] /usr/libexec/mariadbd: Shutdown complete
    ```

3. lets see the mariadb service status

    ```sh
    sudo systemctl status mariadb
    ```

    ```bash
    [peter@stdb01 ~]$ systemctl status mariadb
    ○ mariadb.service - MariaDB 10.5 database server
    Loaded: loaded (/usr/lib/systemd/system/mariadb.service; enabled; preset: disabled)
    Active: inactive (dead) since Sun 2025-08-03 08:54:14 UTC; 5min ago
    Duration: 5.819s
    Docs: man:mariadbd(8)
    https://mariadb.com/kb/en/library/systemd/
    ...
    ...
    Status: "MariaDB server is down"
    ```

4. Lets up the mariadb service:

    ```sh
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
    ```

5. Still failed to run, lets looking into config:

    ```sh
    cat /etc/my.cnf.d/mariadb.service
    ```

    datadir: `/var/lib/mysql/`

    actual location: `/var/lib/mysqld`

    so update config and `ib_buffer_pool`

6. Restart

    ```sh
    systemctl restart mariadb
    ```
