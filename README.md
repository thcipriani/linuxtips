# Linux Notes

This is a list of things I either think are neat, or things I'm always Googling.

Locale Settings [locale(7)]:

    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

Process Tree [pstree(1)]:

    pstree -p

Remove all files in /tmp older than 2 days [find(1) EXPRESSIONS]

    find /tmp -maxdepth 1 -type f -mtime +2 -exec rm -i "{}" \;

Bash Special Variables [bash(1) PARAMETERS, Special Parameters]:

- `$*`<br>Expands to the positional parameters, starting from one. Quoted expands to words sparated by 1st char of `$IFS`
- `$@`<br>`$*` except expands to words separated by space when quoted
- `$#`<br> Number of positional params in decimal
- `$?`<br>Exit status of most recent foreground pipeline
- `$-`<br>Option flags set by the `set` builtin command
- `$$`<br>PID of current shell
- `$!`<br>PID of most recent async/bg command
- `$0`<br>Name of shell or script
- `$_`<br>The underscore variable is set at shell startup and contains the absolute file name of the shell or script being executed as passed in the argument list. Subsequently, it expands to the last argument to the previous command, after expansion.

Bash test a socket exists [bash(1) CONDITIONAL EXPRESSIONS]

  test -S [socketname] && echo 'true'

Shell Startup Files [bash(1)/zsh(1) INVOCATION]:

- Linux/Bash/TTY:<br>
  `/etc/profile` &rarr; first of `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists

- Linux/Bash/XTerm:<br>
  `/etc/bash.bashrc` &rarr; `.bashrc`

- Linux/Bash/Scripts (#!/usr/bin/env bash):<br>
  looks for `$BASH_ENV` var and sources the expansion of that variable

- Linux/ZShell/TTY:<br>
  `/etc/zshenv` &rarr; `~/.zshenv` &rarr; `/etc/zprofile` &rarr; `~/.zprofile` &rarr; `/etc/zshrc` &rarr; `~/.zshrc` &rarr; `/etc/zlogin` &rarr; `~/.zslogin` (`/etc/z*` is the default; however `/etc/zsh/z*` seems to be common (at least on Ubuntu))

- Linux/ZShell/XTerm:<br>
  `/etc/zshrc` &rarr; `~/.zshrc`

- Linux/ZShell/Scripts (#!/usr/bin/env zsh):<br>
  `/etc/zshenv`

- OSX/Bash/TTY/XTerm:<br>
  `/etc/profile` &rarr; first of `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists

- OSX/Bash/Scripts (/usr/bin/env bash):<br>
  looks for `$BASH_ENV` var and sources the expansion of that variable

- OSX/ZShell/TTY/XTerm:<br>
  `/etc/zshenv` &rarr; `~/.zshenv` &rarr; `/etc/zprofile` &rarr; `~/.zprofile` &rarr; `/etc/zshrc` &rarr; `~/.zshrc` &rarr; `/etc/zlogin` &rarr; `~/.zslogin`

- OSX/ZShell/Scripts (/usr/bin/env zsh):<br>
  `/etc/zshenv`

Setting your hostname&#8212;Debian and Ubuntu [hostname(1)/hosts(5)]:

1. Edit `/etc/hostname` and add you FQDN, e.g., `echo "parabola.tylercipriani.com" > /etc/hostname` 
2. Run `hostname -F /etc/hostname` to update your hostname
3. Edit `/etc/hosts`:

    127.0.1.1 parabola.tylercipriani.com parabola localhost

Get the permission octal and file name for all files in a directory [stat(1)]:

    stat -c "%a %n" *

Show linked library dependencies of a binary [ldd(1)]

    ldd $(command -v <binary>)

Cronjob Time Syntax [crontab(5)]:

- m h dom m dow <what_to_do>
  - m - minute(0–59)
  - h - hour(0–23)
  - dom - day-of-month(0–31)
  - m - month(0-11)
  - dow - day-of-week(0–6)
  - <what_to_do> - anycommand

Send mail [mail(1)]

    echo "Message Body" | mail -s "Mail Subject" user@example.com

Send mail to multiple people [mail(1)]:

    echo "Message Body" | mail -s "Mail Subject" -c "user2@example.com user3@example.com" user@example.com

Create a `.gitkeep` file in all empty directories [find(1)]:

    find . -type d -empty -print0 | xargs -0 -I{} touch {}/.gitkeep

Git stash unstaged commits [git-stash(1)]

    git stash

Git show stash (just changed files) at reference 0 [git-show(1)]

    git show stash stash@{0}

Git show contents of stash at stash ref 1 [git-stash(1)]

    git stash show -p stash@{1}

Git list all stashes [git-stash(1)]

    git stash list

Git list repo contribution authors, order by # of commits [git-shortlog(1)]

    git shortlog -sn

Git create patch file from the last commit[git-format-patch(1)]

    git format-patch HEAD~ --stdout > <file.patch>

Git check what's in a patch file [git-apply(1)]

    git apply --stat <file.patch>

Git test patch file before applying to repo [git-apply(1)]

    git apply --check <file.patch>

Git apply patch file [git-apply(1)]

    git apply <file.patch>

Git show history and diff of a file [git-log(1)]

    git log -p -- <path/to/file>

Git search for deleted file [git-log(1)]

    # Search for file path
    git log --diff-filter=D | grep <deleted file name>

    # Find the delete commit id
    git log --all -- <deleted/file/path>

Git check ignored patter matched [git-check-ignore(1) v.1.8.5+)

    git check-ignore [path]

IPTables Block an IPAddress [iptables(8) OPTIONS]

    iptables -A INPUT -s "$BLOCK_THIS_IP" -j DROP

IPTables Insert a rule to allow inbound tcp traffic on port 8000 (puts the rule at the top)[iptables(8) OPTIONS]

    iptables -I INPUT -i eth0 -p tcp --dport 8000 -j ACCEPT

Create gzipped tar from file or directory [tar(1)]

    tar -cvzf tarfile.tar.gz directory file otherfile

Create bzipped tar file from file or directory [tar(1) OTHER OPTIONS]

    tar -cvjf tarfile.tar.bz2 directory file otherfile

List contents of tar.gz file [tar(1)]

    tar -tvzf tarfile.tar.gz

WGet rip a whole site [wget(1)]

    wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains <domain-name> --no-parent http://<domain>

Upload file via cURL [curl(1)]

    curl -X 'POST' -H 'Accept: application/json' -F 'file_name=Test File' -F 'file_contents=@/path/to/file.type' www.example.com/file/add

Fill login form via cURL [curl(1)]

    curl -X 'POST' -F 'username=tyler' -F 'password=pass123' www.example.com/login

MySQL Find Users

    SELECT * FROM mysql.user WHERE User like '%whatever%'\G

MySQL Add User to db

    GRANT USAGE ON *.* TO '<user>'@'%' IDENTIFIED BY '<password>';

MySQL Give User Access

    GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON <database>.* TO '<user>'@'%'

MySQL Delete User

    DROP USER '<user>'@'%';
    FLUSH PRIVILEGES;

MySQL Find User Privileges

    SHOW GRANTS for '<username>';
    -- or
    SHOW GRANTS FOR CURRENT_USER;

MySQL Revoke User Privileges

    REVOKE INSERT ON *.* FROM '<username>'@'%';

MySQL Rename User

    RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'127.0.0.1';

MySQL Set Password

    SET PASSWORD FOR 'bob'@'%.example.org' = PASSWORD('cleartext password');

MySQL Update User Password

    UPDATE mysql.user SET Password=PASSWORD('cleartext password')  WHERE User='bob' AND Host='%.example.org';
    FLUSH PRIVILEGES;

MySQLDump a Single database

    mysqldump --compress -h localhost -u [username] -p --quick --single-transaction [db_name] > [dumpfile]

MySQLDump databases

    -- NOTE TO USE --add-drop-database YOU MUST USE --databases
    mysqldump -h localhost -u [username] -p --add-drop-database --skip-comments --routines --compress --quick --single-transaction --databases [db_name] > [dumpfile]

MySQLDump all DBs like [pattern]

    mysqldump -h localhost --quick --single-transaction [db_name] `mysql -ND [db_name] -h localhost -e "show tables like '[pattern]'" | awk '{ printf $1" " }'` > dumpfile.sql

MySQL Add index:

    ALTER TABLE `table` ADD INDEX `column_name` (`column_name`)
    ALTER TABLE `account_agreement_pricebook` ADD INDEX `pricebook_id` (`pricebook_id`);

MySQL Show indexes:

    SHOW INDEX FROM `table`;

MySQL Show available engines

    mysql> show engines\G

MySQL Enable engine

    INSTALL PLUGIN [engine] SONAME 'ha_[engine].so';

The following plugins are installed into the OS but not into MySQL:

    ha_archive.so - archive
    ha_blackhole.so - blackhole
    ha_example.so - example
    ha_innodb_plugin.so - InnoDB Plugin

MySQL Replication things to know:

* REPLICATION SETUP: http://plusbryan.com/mysql-replication-without-downtime
* Trust Replication
* Monitor Seconds_Behind_Master
* Monitor Exec_Master_Log_Pos
* Run SHOW PROCESSLIST;—take note of the SQL thread to see if it is processing long running queries.
* Keep an eye on master_db_host:/var/log/mysql/slow.log—this is a log of the longest-running mysql queries—try to optimize 'em
* SHOW PROCESSLIST; (or SHOW FULL PROCESSLIST;) on the Slave:
  * there should be two DB Connections whose user name is `system user`
  * One of those DB Connections will have the current SQL statement being processed by replication.
  * As long as a different SQL statement is visible each time you run SHOW PROCESSLIST;, you can trust mysql is still replicating properly.

MySQL Replication Last_Error:  Duplicate Key Entry

    stop slave; set global mysql_slave_skip_counter = 1; start slave; -- repeat :)

Is MySQL Slave Processing Relay Logs?

    STOP SLAVE IO_THREAD;
    SHOW SLAVE STATUS\G
    -- check Exec_Master_Log_Pos --
    SHOW SLAVE STATUS\G
    -- if it doesn't move—it's working—run: --
    START SLAVE IO_THREAD;

PostgreSQL show user defined types

    SELECT n.nspname AS schema,
        pg_catalog.format_type ( t.oid, NULL ) AS name,
        t.typname AS internal_name,
        CASE
            WHEN t.typrelid != 0
            THEN CAST ( 'tuple' AS pg_catalog.text )
            WHEN t.typlen < 0
            THEN CAST ( 'var' AS pg_catalog.text )
            ELSE CAST ( t.typlen AS pg_catalog.text )
        END AS size,
        pg_catalog.array_to_string (
            ARRAY( SELECT e.enumlabel
                    FROM pg_catalog.pg_enum e
                    WHERE e.enumtypid = t.oid
                    ORDER BY e.oid ), E'\n'
            ) AS elements,
        pg_catalog.obj_description ( t.oid, 'pg_type' ) AS description
    FROM pg_catalog.pg_type t
    LEFT JOIN pg_catalog.pg_namespace n
        ON n.oid = t.typnamespace
    WHERE ( t.typrelid = 0
            OR ( SELECT c.relkind = 'c'
                    FROM pg_catalog.pg_class c
                    WHERE c.oid = t.typrelid
                )
        )
        AND NOT EXISTS
            ( SELECT 1
                FROM pg_catalog.pg_type el
                WHERE el.oid = t.typelem
                    AND el.typarray = t.oid
            )
        AND n.nspname <> 'pg_catalog'
        AND n.nspname <> 'information_schema'
        AND pg_catalog.pg_type_is_visible ( t.oid )
    ORDER BY 1, 2;

PostgreSQL show queries the generate `\d...` commands

    \set ECHO_HIDDEN

PostgreSQL equivalent of MySQL's `\G'

    <query>\x\g\x

Debug bash scripts, add:

    set -x

Forward new port in existing SSH session:

    <newline>
    ~C
    ssh> ?

List currently established, closed, orphaned and waiting TCP sockets:

    ss -s

`netstat -tlnp` vs `ss -ln`

    $ time netstat -tlnp
    netstat -tlnp  0.00s user 0.02s system 97% cpu 0.016 total

    $ time ss -ln
    ss -ln  0.00s user 0.00s system 83% cpu 0.005 total

Check disk I/O:

    vmstat 1 10

What's using disk I/O:

    dstat --top-io --top-bio

Show io per-device (needs sysstat package on debian):

    iostat -sk 2

Download missing depedencies automatically on Debian/Ubuntu:

    sudo apt-get -f install

Insert text at beginning of file without sed:

    cat [file] | perl -pe 'BEGIN { print "[text]\n" }' > [outputfile]

Insert text without abusing cat in perl (with backup file):

    perl -i.bak -pe 'print "[text]\n" if $. == 1;' [file]

Insert text at the end of the file with perl (with backup file):

    perl -i.bak -ne 'print $_; print "[text]\n" if eof;' [file]

Show compile flags for Nginx:

    nginx -V 2>&1 | tr -- - '\n' | grep _module

Linux print:

    lp -h [cups_server]:[cups_port:-631] -d [destination_printer_name] -o [print_job_options] [filename]

Check Shared Memory Segments:

    ipcs -m

Find process attached to shared memory segment

    lsof | grep [shmid from ipcs]

Stop space splitting for file in bash:

```shell
#!/usr/bin/env bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for file in $(find . -name 'file'); do
  ...
done

IFS=$SAVEIFS
```

Allow traffic via ufw:

    sudo ufw allow from [ip/any] to [host/any] port [any/port-num] proto [upd/tcp/whatevs]

RCS Bulk Commit all files in directory

    ci -l -t-'[file descriptor]' -m'[commit message]' *

Edit last command with $EDITOR

    fc

Check default runlevel for system:

    grep ^id /etc/inittab

List services/runlevels chkconfig:

    chkconfig --list

Add service to startup with chkconfig:

    chkconfig --level 235 [service] on

Remove service from startup with chkconfig:

    chkconfig --del [service]

List service runlevels without chkconfig:

    ls -l /etc/rc*.d

Add service to startup with update-rc.d:

    update-rc.d [service] defaults

Remove service from startup with update-rc.d:

    update-rc.d -f [service] remove

NPM ingore SSL problems

    npm config set strict-ssl false

Linux Fun Crap

- Generate a list of your most used commands— 

    history | sed "s/^[0-9 ]*//" | sed "s/ *| */\n/g" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 100 > commands.txt

- The Useless Use of `cat` Award ([partmaps](http://partmaps.org/era/unix/award.html#cat))
- Terminal Keynote (Ruby) ([github](https://github.com/fxn/tkn))
- Boom. Motherfucking Text Snippets on the command line ([zachhholman](http://zachholman.com/boom/))
- Spark sparklines for your shell ([zachholman](http://zachholman.com/spark/))
- Lolcat ([github](https://github.com/busyloop/lolcat))
- cowsay ([github](https://github.com/schacon/cowsay))
- Ponysay ([github](https://github.com/erkin/ponysay))
- FIGlet ([figlet](http://www.figlet.org/))
- Libcaca ([caca.zoy](http://caca.zoy.org/wiki/libcaca))
- Toilet ([caca.zoy](http://caca.zoy.org/wiki/toilet))
- Boxes ([thomasjensen](http://boxes.thomasjensen.com/))
- Cadubi (perl) ([langworth](http://langworth.com/pub/cadubi/))
- img2txt ([hit9](http://hit9.org/img2txt/))
- Nyancat ([klange.github](https://github.com/klange/nyancat))
- CMatrix ([asty](http://www.asty.org/cmatrix/))
- janbrennen rice ([github](https://github.com/janbrennen/rice))
- dotshare.it ([dotshare.it](http://dotshare.it))
- linux logo ([freecode](http://freecode.com/projects/linuxlogo))
- bb ([aa-project](http://aa-project.sourceforge.net/bb/))
- Powerline Font symbols ([powerline](https://powerline.readthedocs.org/en/latest/fontpatching.html))
- Stupid Programmer Tricks/Starwars gifs ([rarlindseysmash](http://rarlindseysmash.com/posts/stupid-programmer-tricks-and-star-wars-gifs))