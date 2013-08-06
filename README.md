yare
====

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

For example via Gitosis you can clone an existing one like this:

    cd ~/.yare
    git clone gitosis@server.tld:todo.git

The name server.tld is the FQDN of your gitosis server. 

It is perfectly fine to use other shared git servers. However make
sure that you can push and pull without passwords.

Create a configuration file:

    echo "[online]"                       > ~/.yare/yare.ini
    echo "hostname=<name of git server>" >> ~/.yare/yare.ini
    echo "[git]"                         >> ~/.yare/yare.ini
    echo "worktree=~/.yare/todo          >> ~/.yare/yare.ini

## USAGE

Execute the script

    yare

If you enter 'help' you get a brief list of available commands. Use 'add' to
create an entry. Add is used like:

    add Something I need to do

Use 'fetch' to display the list:

    fetch
    ----------------------------------------------------------------------------
    0: Something I need to do
    ----------------------------------------------------------------------------

To remove this entry, you can mark it as 'yatta!' (done) like:

    done 0

After processing you will see the success

    yatta! (done)

## FURTHER INFORMATION

You can get further information (for example: why this software has been
written and what concept to be proved) via the ordinary Perl documentation.

    perldoc Yare

or

    man Yare

## AUTHOR

Christian Külker <christian.kuelker@cipworx.org> 

Tolmezzo, 2013

## COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Christian Külker

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.

## LICENSE AND COPYRIGHT

    Copyright (C) 2013 by Christian Kuelker

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
