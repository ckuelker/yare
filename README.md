---
title: README
author: Christian Külker
date: 2023-03-09
version: 0.2.0

---

# YARE

yare - do it! Distributed todo prove of concept

## INSTALLATION

Use the usual Perl ways to install. For example:

    tar xvzf Yare-0.0.3.tar.gz
    cd Yare
    perl Makefile.PL
    make

As root

    make install

## CONFIGURATION

Create the following directories:

    mkdir -p ~/.yare

Create or use a git repository. If possible a shared one.

For example, you can use _gitosis_ to clone an existing repository like this:

    cd ~/.yare
    git clone gitosis@server.tld:todo.git

The name `server.tld` is the FQDN of your _gitosis_ server.

It is perfectly fine to use other shared git servers. Just make sure you can
push and pull without passwords.

Create a configuration file:

    echo "[online]"                       > ~/.yare/yare.ini
    echo "hostname=<name of git server>" >> ~/.yare/yare.ini
    echo "[git]"                         >> ~/.yare/yare.ini
    echo "worktree=~/.yare/todo          >> ~/.yare/yare.ini

## USAGE

Run the script

    yare

If you type 'help' you will get a short list of available commands. Use 'add'
to create an entry. The 'add' command is used in the same way:

    add Something I need to do

Use 'fetch' to display the list:

    fetch
    ----------------------------------------------------------------------------
    0: Something I need to do
    ----------------------------------------------------------------------------

To remove this entry, you can mark it as 'yatta!' with the command 'done'.

    done 0

After processing you will see the success

    yatta! (done)

## FURTHER INFORMATION

For more information (e.g., why this software was written and what concept it
is intended to prove), see the standard Perl documentation.

    perldoc Yare

or

    man Yare

## HISTORY

| README  | Yare  | Date       | Notes                                        |
| ------- | ----- | ---------- | -------------------------------------------- |
| 0.2.0   | 0.0.6 | 2023-03-09 | README.md: Fix version,                      |
|         |       |            | bin/yare: boiler plate, version, FindBin     |
|         |       |            | lib/Yare.pm: Improve writing, boilerplate    |
|         |       |            | lib/Yare/Client.pm: Improve writing, format  |
|         |       |            | Fix online detection (pingecho -> ping syn)  |
| 0.1.9   | 0.0.5 | 2023-03-08 | Add history, improve writing, bump year      |
| 0.1.8   | 0.0.5 | 2023-02-25 | Improve license files: COPYING, LICENSE      |
| 0.1.7   | 0.0.5 | 2014-08-22 | Bump version of yare to 0.0.5                |
| 0.1.6   | 0.0.4 | 2013-08-06 | License and further information              |
| 0.1.5   | 0.0.4 | 2013-08-06 | Bump version of yare to 0.0.4                |
| 0.1.4   | 0.0.3 | 2013-07-23 | Bump version of yare to 0.0.3                |
| 0.1.3   | 0.0.2 | 2013-07-23 | Add idea "yatta!"                            |
| 0.1.2   | 0.0.2 | 2013-06-10 | Bump version of yare to 0.0.2                |
| 0.1.1   | 0.0.1 | 2013-06-09 | Add basic description                        |
| 0.1.0   | 0.0.1 | 2013-06-09 | Initial release                              |

## AUTHOR

Christian Külker <christian.kuelker@cipworx.org>

Tolmezzo, 2013, 2014
Bielefeld, 2023

## COPYRIGHT AND LICENSE

This software is copyright (c) 2013, 2014, 2023 by Christian Külker

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.

## LICENSE AND COPYRIGHT

    Copyright (C) 2013, 2014, 2023 by Christian Kuelker

    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the Free
    Software Foundation; either version 2, or (at your option) any later
    version.

    This program is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
    more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc., 59
    Temple Place, Suite 330, Boston, MA 02111-1307 USA

## DISCLAIMER OF WARRANTY

    BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR
    THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
    OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
    PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
    OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO
    THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU. SHOULD THE
    SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
    REPAIR, OR CORRECTION.

    IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL
    ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE
    THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE TO YOU FOR
    DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
    DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE SOFTWARE (INCLUDING
    BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES
    SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO OPERATE
    WITH ANY OTHER SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN
    ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
