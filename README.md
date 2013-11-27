# Unix Tips

Catalog of information about Linux/Unix that I've found useful

## Unix Philosphy

> This is the Unix philosophy: <br />
> Write programs that do one thing and do it well.  <br />
> Write programs to work together. <br />
> Write programs to handle text streams, because that is a universal interface. <br />
>    – Douglas McIlroy

>"Unix is simple. It just takes a genius to understand its simplicity." <br />
>    – Dennis Ritchie, Inventor of the C Programming Language

## Table of Contents

1. [Basics](#basics)
2. [Searching](#searching)
3. [Manipulating Text](#manipulating-text-output)
4. [System Administration](#system-administration)
5. [Development](#development)
6. [Portability](#portability)
7. [Fun Commands](#fun-commands)

## Basics

**Redirect I/O for a great good**

Text is the input and the output of almost every program that you use on 
the command line. The redirection of that input and the output via communication
channels is the most powerful tool in Unix.

- Each program/process has 3 communication channels available to it:
  + Standard Input (STDIN)
  + Standard Output (STDOUT)
  + Standard Error (STDERR)
- Each comm. channel has an associated integer (called a "File descriptor"):
  + STDIN=0
  + STDOUT=1
  + STDERR=2
- In a terminal window:
  + STDIN reads from the keyboard
  + STDOUT & STDERR write to the term window

- STDIN:
    + '<' allows you connect a program's STDIN to a file
    Examples:
        mail -s "Send mail from file" tyler@tylercipriani.com < /path/to/file.txt
        mysql -h sa2peop_sa2 < somedumpfile.sql

- STDOUT
    + '>' and '>>' redirect STDOUT
    + '>' replaces a target file's contents with a program's STDOUT
    + '>>' appends a program's STDOUT to a file
    + A file will be created if it does not exist
    Examples:
        echo "This is some text" > /tmp/somefile.txt
        ls -lh > this_directorys_contents.txt

- STDERR
    + '2>' redirects STDERR
      - USE CASE:
        sometimes the find command throws errors (if you don't have the 
        appropriate permissions to view a directory) to not see the errors
        in your terminal window but still see all the results (STDOUT) of 
        the find command , redirect STDERR to /dev/null (the system black hole). 
      - find . -type f -name "*.php" 2> /dev/null


**File System Hierarchy**

- EVERYTHING IS A FILE in Linux
- Your speakers are located at /dev/dsp
- The number of processor cores available to your system is located at /proc/cpuinfo

_Run down of the FSH:_

- `/`          — Root of the filesystem
- `/bin`       — system binaries—computer needs to boot
- `/boot`      — boot loader (/boot/grub/grub.conf or menu.lst), Linux kernel (/boot/vmlinuz)
- `/dev`       — System devices (more info: http://en.wikipedia.org/wiki/Device_file)
- `/etc`       — System-wide configuration files
- `/home`      — User configuration files, users can ususally only write files in their home directory
- `/lib`       — shared library files used by system binaries
- `/media`     — auto-mounting removable media (CDRom, USB Drives, etc)
- `/mnt`       — temp filesystems (USB Drives mounted manually)
- `/opt`       — "optional software", Libreoffice installs here, some sysadmins like to install software here
- `/proc`      — provides kernel information as files
- `/root`      — home directory for root user
- `/srv`       — media served by the system - I think it makes sense to have website data here rather than /var/www
- `/sbin`      — sysadmin binaries (e.g., /sbin/ifconfig gives you ip information)
- `/tmp`       — temporary storage - cleaned frequently
- `/usr`       — programs, libraries etc for all system users
- `/usr/bin`   — programs installed for all users by linux (e.g. /usr/bin/find)
- `/usr/local` — sysadmins (me) download and install things here (executables in /usr/local/bin, source files in /usr/local/src)
- `/usr/sbin`  — more sysadmin binaries (e.g., /usr/sbin/usermod lets me modify a user)
- `/var`       — data that chanes frequently is stored here (e.g. /var/log for log files /var/www/ for webservers)

**The Shell**

You access the command line through a shell. Most Linux distros default to
using the Bash shell. Bash stands for Bourne Again SHell. Bourne refers to
the Bourne shell, which was the default Unix shell in Unix Version 7.

iTerm, Konsole, Terminal and the like are Terminal Emulators.

A Shell runs inside of a terminal emulator.

_Command Examples:_

- check shell environment                            <br /> `cat /etc/passwd | grep `whoami` | cut -d ':' -f 7`
- check what shell environments are installed        <br /> `cat /etc/shells`
- change your default shell                          <br /> `chsh `whoami` -s <valid login shell>`
- change another user’s shell                        <br /> `sudo chsh <username> -s <valid login shell>`
- switch users                                       <br /> `su <username> (or su - to switch to root)`


**Environment**

`env` is used to either print a list of environment variables or run 
another utility in an altered environment without having to modify the 
currently existing environment. 

`env` is usually located at `/usr/bin/env`

`/usr/bin/env <whatever>/` is also a more portable way of running an executable.
It also runs the first executable in a User's `$PATH` ([reference](http://unix.stackexchange.com/questions/29608/why-is-it-better-to-use-usr-bin-env-name-instead-of-path-to-name-as-my))

_Command Examples:_

- list all variables on your environment             <br /> `env`
- set temp variable for shell session                <br /> `export VARNAME=value`
- where env vars are set                             <br /> `/home/<username>/.bashrc`
                                                     <br /> `/home/<username>/.bash_profile`
                                                     <br /> `grep -P '(^\s+\.|^\s+source)' .bashrc`
                                                     <br /> `grep -P '(^\s+\.|^\s+source)' .bash_profile`
- check specific variable                            <br /> `echo $<varname>`
- check system path                                  <br /> `echo $PATH`
- check if a program is installed and in system path <br /> `which <program_name>`


## Searching

**Find**

- Find stuff in the Filesystem Heirarchy
- Usually located at /usr/bin/find
- Searches recursivly below specified search path
- more info and examples: man find

```Shell
find <search_path> [options]
```

_Command Examples:_

- Find a file name 'cats.txt' below current directory

  ```Shell
  find . -name 'cats.txt'
  ```

- Find all files below current directory

  ```Shell
  find . -type f
  ```

- Find all directories below current directory

  ```Shell
  find . -type d`
  ```

- .txt files

  ```Shell
  find . -type f -name "*.txt"
  ```

- case insensitive file name

  ```Shell
  find . -iname "nOtSuReOfCaSiNg.txt"
  ```

- join find options with `-and` ex: find php files that start with cat

  ```Shell
  find . -iname "*.php" -and -iname "cat*"
  ```

- txt files recursively to a depth of 2 

  ```Shell
  find . -maxdepth 2 -type f -name "*.txt"
  ```

- Exclude files with `-not` ex: find all NON-text files

  ```Shell
  find . -not -name "*.txt"
  ```

- Files modified less than a day ago

  ```Shell
  find . -type f -mtime -1
  ```

- Directories modified more than 10 days ago

  ```Shell
  find . -type d -mtime +10
  ```

- All Files greater than 100 MB

  ```Shell
  find . -type f -size +100M
  ```

- All files smaller than 10 KB

  ```Shell
  find . -type f -size -10K
  ```

- Remove all zip files bigger than 100MB

  ```Shell
  find . -name "*.zip" -size +100M -exec rm -i "{}" \;
  ```

- Remove all files in /tmp older than 2 days

  ```Shell
  find /tmp -maxdepth 1 -type f -mtime +2 -exec rm -i "{}" \;
  ```

- Create a `.gitkeep` file in all empty directories:

  ```Shell
  find . -type d -empty -print0 | xargs -0 -I{} touch {}/.gitkeep
  ```


**Grep**

- Grep (g/re/p) stands for global regular-expression print. Its name is
  derived from a command in "ed" a Unix line-editor built in 1971.
- use flag i for case insensitve search
- use flag v to negate
- use flag P to use Perl-Compatible Regular Expressions (still "Highly Experimental" ::eye-roll::)
- use flag c to count matches (or pipe to wc -l [word-count lines - see man wc for details])

_Grep Examples:_

- Find out if Apache is running
  - On CentOS                                                            <br> `ps aux | grep -i httpd`
  - On Debian                                                            <br> `ps aux | grep -i apache`
- Find out how many instances of ffmpeg are running (wc -l counts lines) <br> `ps aux | grep -i ffmpeg | grep -v grep | wc -l`
- Find text 'get_user' in all files below current dir with line numbers  <br> `grep -HiERn 'get_user' .`
- Same as above, don't include .svn directory                            <br> `grep -HiERn 'get_user' . | grep -v '.svn'`
- How many proccessors does a system have                                <br> `grep -c CPU /proc/cpuinfo`
- Same as above                                                          <br> `cat /proc/cpuinfo | grep -i cpu    | wc -l`
- Same as above                                                          <br> `grep -i cpu /proc/cpuinfo | wc -l`
- How many users are on a system besides you?                            <br> `grep -cv `whoami` /etc/passwd`
- Same number as above + 1 (total system users)                          <br> `cat /etc/passwd | wc -l`
- What shell is dave using?                                              <br> `cat /etc/passwd | grep dave | cut -d: -f7`


**Ack**

- Ack searches files below the current directory
  recursively. It's ideal for use with code since
  it automatically excludes any .svn, .git or .cvs
  direcories from its search

- ack is not a gnu utility and therefore is not included by default on most
  unix-like systems. To install:
  on debian: apt-get install ack-grep
  on centos: yum install ack

_Ack Examples:_

- search for a pattern in all files recursively     <br> `ack <pattern>`
- search for a pattern recursively case-insensitive <br> `ack <pattern>`
- search php files for thing recursively            <br> `ack --php <pattern>`
- search all files except javascript files          <br> `ack --nojs <pattern>`


**Silver Searcher (ag)**

- Works mostly like `Ack` except it's 3–5× faster

[get it](https://github.com/ggreer/the_silver_searcher)

## Manipulating Text Output

**Cut**:

- Print a column base on a delimeter
- The default delimeter is the tab character
- Works with Pipes to STDIN
- Useage: `cut -d "<delimeter" -f "<field>"`

_Command Examples:_

- `/etc/passwd` is delimited by ":" so… first column | `cat /etc/passwd | cut -d ":" -f $1`
- `/etc/passwd` 7th column                           | `cat /etc/passwd | cut -d ":" -f $7`


**Sed** – Ed Substitution:

- Used to find and replace in text stream
- Can be used to append to a file after or before a given pattern
- I mainly use it with Unix Pipes (e.g., with STDIN)
- http://sed.sourceforge.net/sed1line.txt

_Command Examples:_

- Change day into night in a file                        | `cat <somefile.txt> | sed -e 's/day/night/g' > newfile.txt`
- ReName all text files to <whatever>-old.txt            | `find . -maxdepth 1 -type f -iname '*.txt' | sed -e 's,\(\(.*\).txt\),mv "\1" "\2-old.txt",g' | /bin/bash`
- ReName all those text files back to <whatever>-old.txt | `find . -maxdepth 1 -type f -iname '*.txt' | sed -e 's,\(.*\)-old.txt,mv "\0" "\1.txt",g' | /bin/bash`
- Add line to file after 3rd line
     ```bash 
     sed '3 a\
     some line' <somefile>.txt
     ```
- Add line to file after regex pattern
     ```bash
     sed '/pattern/a\
     some line' <somefile>.txt
     ```
- Add a line at the end of the file
     ```bash
     sed '$ a\
     some line at the end' <somefile>.txt
     ```
- Print all lines between n1 and n2 | `sed -n 'n1,n2p'`


**Awk** – Like sed but different

- I use a mix of cut, sed and grep instead of Awk
- Usage examples: http://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/
- Oneliners: http://www.pement.org/awk/awk1line.txt
- **AWK tutorial**—http://www.grymoire.com/Unix/Awk.html

## System Administration

**Shell Startup Files**

The order in which Shell startup scripts are run and which scripts are run
varies based on whether you are:

1. On a Mac or Linux Machine
2. In a logon shell (TTY) or a Terminal Emulator (e.g., Gnome-Terminal)
3. Running the shell interactively or from a script
4. What shell you are running

_On Linux_

- Bash:
  - via SSH:<br />
    `/etc/profile` &rarr; first of `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists

  - via Terminal Emulator:<br />
    `/etc/bash.bashrc` &rarr; `.bashrc`

  - scripts using `/usr/bin/env bash`:<br />
    looks for `$BASH_ENV` var and sources the expansion of that variable

- Z-Shell:
  - via SSH:<br />
    `/etc/zshenv` &rarr; `~/.zshenv` &rarr; `/etc/zprofile` &rarr; `~/.zprofile` &rarr; `/etc/zshrc` &rarr; `~/.zshrc` &rarr; `/etc/zlogin` &rarr; `~/.zslogin`

  - `/etc/z*` is the default; however `/etc/zsh/z*` seems to be common (at least on Ubuntu)

  - via Terminal Emulator:<br />
    `/etc/zshrc` &rarr; `~/.zshrc`

  - Scripts:<br />
    `/etc/zshenv`


_On OSX_

- Bash:
  - Terminal, iTerm or SSH:<br />
    `/etc/profile` &rarr; first of `~/.bash_profile`, `~/.bash_login`, `~/.profile` that exists

  - scripts using `/usr/bin/env bash`:<br />
    looks for `$BASH_ENV` var and sources the expansion of that variable


- Z-Shell:
  - Terminal, iTerm or SSH:<br />
    `/etc/zshenv` &rarr; `~/.zshenv` &rarr; `/etc/zprofile` &rarr; `~/.zprofile` &rarr; `/etc/zshrc` &rarr; `~/.zshrc` &rarr; `/etc/zlogin` &rarr; `~/.zslogin`

  - Scripts:<br />
    `/etc/zshenv`

**Hostname**

- Setting your hostname
  - Debian and Ubuntu:

    Edit `/etc/hostname` and add you unqualified hostname, e.g., `echo "parabola" > /etc/hostname` 

    Run `hostname -F /etc/hostname` to update your hostname

    Edit `/etc/hosts`:

    ```
    sudo vim /etc/hosts
    ```

    Add an entry of your desired hostname by replacing 
    `parabola.tylercipriani.com parabola` where 
    `parabola.tylercipriani.com` is the fully qualified hostname and 
    `parabola` is the hostname.

    ```
    127.0.1.1 parabola.tylercipriani.com parabola localhost
    ```
    test both of these with: `hostname` &amp; `hostname -f`

**.inputrc**

http://www.reddit.com/r/commandline/comments/kbeoe/you_can_make_readline_and_bash_much_more_user/

**Cron Jobs**

- Cronjobs are sheduled system tasks
- Cronjobs are per user. 
  The root user has a different set of crons than the Tyler user
- Crontab is the program used to manage cronjobs
- To edit cronjobs use the command `crontab -e`

_Cronjob Time Syntax:_

- m h dom m dow <what_to_do>
  - m - minute(0–59)
  - h - hour(0–23)
  - dom - day-of-month(0–31)
  - m - month(0-11)
  - dow - day-of-week(0–6)
  - <what_to_do> - anycommand

_Crontab Examples:_

- Execute <command> every 15 minutes                   <br> `*/15 * * * * <command>`
- Execute <command> at top of every hour on monday     <br> `0 * * * 1 <command>`
- Execute <command> at 10 after, 15 after and 20 after <br> `10,15,20 * * * * <command>`


**Users**

- Difference between adduser & useradd                                          <br> [tl;dr no difference in Centos, use useradd in debian](http://www.garron.me/en/go2linux/useradd-vs-adduser-ubuntu-linux.html)
- Add a user                                                                    <br> `useradd <new_username>`
- Add an existing user to a group                                               <br> `usermod -a -G <new_username>`
- Find group ids for a user                                                     <br> `id -G <username>`
- Find groupnames for a user                                                    <br> `groups <username>`
- Edit defaults for adding a user (e.g., the user's shell, default group etc)   <br> `sudo vim /etc/default/useradd`
- Edit default files created for a user (e.g., .profile, .bashrc, .vimrc, etc ) <br> `sudo cp <file_to_add> /etc/skel/`
- Manage group permissions                                                      <br> `visudo` checkout lines that begin with `%<groupname>` or `<username>`


**Unix Mail**

- `mail`
  `mail` is a Mail User Agent for Unix systems. This program is typically 
  located in `/usr/bin/mail`; however, this program is, often, a symlink
  (sometimes through `updatealternatives`) to `mailx`.

  When sending mail the `mail` command uses `sendmail`. As do most 
  command-line ways of sending mail.

  [More info](http://publib.boulder.ibm.com/infocenter/pseries/v5r3/index.jsp?topic=/com.ibm.aix.cmds/doc/aixcmds3/mail.htm)

_Command Examples and Use_:

- View your mailbox:

  `mail`

- View your mailbox:

  `mail`

- Send mail:

  `echo "Message Body" | mail -s "Mail Subject" user@example.com

- Send mail to multiple people:

  `echo "Message Body" | mail -s "Mail Subject" -c "user2@example.com user3@example.com" user@example.com

_Mailbox Subcommands_
- `help` or `?`
  inside the mail program shows you mail help

- `h`
  shows message headers

- `d`
  deletes a message

- `d 1-100`
  deletes messages between 1 and 100

- `dp`
  Delete current message and display next message

- `q`
  quits


## Development

Commands that may be useful in development

**cURL**

Important flags:

* `-X`: type either POST, GET, DELETE whatever
* `-H`: header like 'x-someheader: header'
* `-F`: form data e.g., `curl -F 'username=tyler'`
* `Files`: use `-F` with `@` e.g., `curl -F 'file_is=@/path/to/file'`

_Command Examples:_

1. POST username and password:

```Shell
curl -X 'POST' -F 'username=tyler' -F 'password=pass123' www.example.com/login
```

2. Upload file with required `Accept` header

```Shell
curl -X 'POST' -H 'Accept: application/json' -F 'file_name=Test File' -F 'file_contents=@/path/to/file.type' www.example.com/file/add
```

## Portability

**`echo` vs `printf`**

Always use `printf` in shell scripting. See discussion on 
[StackExchange](http://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo)

**CheckBashisms**

Perl script to check for non-POSIX-compliance available in the [debian repo](http://debian.inode.at/debian/pool/main/d/devscripts/)

[ShellCheck](http://www.shellcheck.net/)

## Fun Commands

Linux Fun Crap

- Generate a list of your most used commands— 
    ```bash
    history | sed "s/^[0-9 ]*//" | sed "s/ *| */\n/g" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 100 > commands.txt
    ```
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