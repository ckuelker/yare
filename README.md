yare
====

yare - do it! Distributed todo prove of concept

## INSTALLATION

Use the usual Perl ways to install. For example:

    tar xvzf Yare-0.0.2.tar.gz
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

To remove this entry, you can mark it as 'done' like:

    done 0

## AUTHOR

Christian Külker <christian.kuelker@cipworx.org> 

Tolmezzo, 2013
