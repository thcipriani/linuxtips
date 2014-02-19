# Linux Notes

This is a list of things I either think are neat, or things I'm always Googling.

Locale Settings:

    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

Process Tree:

    pstree -p

Create a `.gitkeep` file in all empty directories:

    find . -type d -empty -print0 | xargs -0 -I{} touch {}/.gitkeep

Remove all files in /tmp older than 2 days

    find /tmp -maxdepth 1 -type f -mtime +2 -exec rm -i "{}" \;

Shell Startup Files:

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

Setting your hostname&#8212;Debian and Ubuntu:

1. Edit `/etc/hostname` and add you FQDN, e.g., `echo "parabola.tylercipriani.com" > /etc/hostname` 
2. Run `hostname -F /etc/hostname` to update your hostname
3. Edit `/etc/hosts`:

    127.0.1.1 parabola.tylercipriani.com parabola localhost

Cronjob Time Syntax:

- m h dom m dow <what_to_do>
  - m - minute(0–59)
  - h - hour(0–23)
  - dom - day-of-month(0–31)
  - m - month(0-11)
  - dow - day-of-week(0–6)
  - <what_to_do> - anycommand

Send mail

    echo "Message Body" | mail -s "Mail Subject" user@example.com

Send mail to multiple people:

    echo "Message Body" | mail -s "Mail Subject" -c "user2@example.com user3@example.com" user@example.com

Git show contents of stash

    git stash show -p stash@{1}

IPTables

- Block an IPAddress

    iptables -A INPUT -s "$BLOCK_THIS_IP" -j DROP

- Insert a rule to allow inbound tcp traffic on port 8000 (puts the rule at the top)

    iptables -I INPUT -i eth0 -p tcp --dport 8000 -j ACCEPT

Tar (Tape Archive Utility)

- Create gzipped tar from file or directory

    tar -cvzf tarfile.tar.gz directory file otherfile

- Create bzipped tar file from file or directory

    tar -cvjf tarfile.tar.bz2 directory file otherfile

- List contents of tar.gz file

    tar -tvzf tarfile.tar.gz

Wget/cURL

- Rip a whole site with wget:

    wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains <domain-name> --no-parent http://<domain>

- Upload file via cURL

    curl -X 'POST' -H 'Accept: application/json' -F 'file_name=Test File' -F 'file_contents=@/path/to/file.type' www.example.com/file/add

- Fill login form via cURL

    curl -X 'POST' -F 'username=tyler' -F 'password=pass123' www.example.com/login

MySQL

- Single DB Dump

    mysqldump --compress -h localhost --quick --single-transaction [db_name] > [dumpfile]

- Nice DB Dump

    mysqldump -h localhost -u [username] -p --add-drop-database --skip-comments --routines --compress --quick --single-transaction --databases [db_name] > [dumpfile]

- Dump tables that match pattern:

    mysqldump -h localhost --quick --single-transaction [db_name] `mysql -ND [db_name] -h localhost -e "show tables like '[pattern]'" | awk '{ printf $1" " }'` > dumpfile.sql

Debug bash scripts, add:

    set -x

Forward new port in existing SSH session:

    <newline>
    ~C
    ssh> ?

List currently established, closed, orphaned and waiting TCP sockets:

    ss -s

`netstat -tlnp` vs `ss -ln`

    $ time netstat -tlnp                                                                                                   127 ↵
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