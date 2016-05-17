Cuckoo
======

A management system for desktop-oriented virtual machines (based on QEMU) written in pure Shell.

Uses Shell (not Bash) with following system utilities:

    dirname, basename, echo, printf, ls, cat, cp, rm, mkdir, chmod, getopt, cd, pwd, uname, curl, tar


Installation
------------

Quick network-based install:

    curl -sSL https://raw.githubusercontent.com/magenete/cuckoo/master/cuckoo/bin/cuckoo-installer | sh -s verbose

Alternative local install (e.g. after cloning git repo, etc.) in verbose mode:

    cuckoo-installer install verbose


Running
-------

    cuckoo -h


License
-------

Copyright (c) 2016 Magenete Systems OÜ

[![GPLv3](http://www.gnu.org/graphics/gplv3-88x31.png)](http://www.gnu.org/licenses/gpl-3.0.txt)

See also [LICENSE](LICENSE)
