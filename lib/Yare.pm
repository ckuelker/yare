# +---------------------------------------------------------------------------+
# | Yare                                                                      |
# |                                                                           |
# | Manual.                                                                   |
# |                                                                           |
# | Version: 0.0.6 (change inline)                                            |
# |                                                                           |
# | Changes:                                                                  |
# |                                                                           |
# | 0.0.6 2023-03-09 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Add boiler plate                                                    |
# |     - Improve writing                                                     |
# |     - Improve formatting                                                  |
# | 0.0.5 2014-08-22 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Explanation of YARE_CFG feature                                     |
# | 0.0.4 2013-08-06 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Fix further information (self reference)                            |
# | 0.0.3 2023-07-23 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Add idea "yatta!"                                                   |
# | 0.0.2 2013-03-10 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Add headings for POD                                                |
# |     - Improve POD                                                         |
# | 0.0.1 2013-03-09 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Initial release                                                     |
# |                                                                           |
# +---------------------------------------------------------------------------+

package Yare;

# ABSTRACT: Yare - do it! Distributed todo prove of concept.

our $VERSION = '0.0.6';

1;
__END__

=pod

=head1 NAME

Yare - do it! Distributed todo prove of concept.

=head1 MOTIVATION

I have often seen data lost when using calendar or todo lists shared via a
central daemon. This is quite disappointing. Other software claims to be easy
to share and synchronize because they only use one file. I doubt that there is
a secure way to share a file across (say) three laptops, considering that
laptops are not always online. Even Git - which handles merges quite well - is
no solution to this problem. It is very likely that the inexperienced or busy
user will end up with a complex merge conflict.

=head1 TARGET

Synchronize todo list information between 3 clients, which can be online or
offline, without merge conflicts or loss of (non-unique!) data.

=head1 THESIS

a) The loss of non-unique (duplicate) data can be tolerated by the user.

b) Conflicts caused by duplicate data can be easily resolved by the user. (by
deleting unwanted entries)

=head1 SOLUTION

(1) A git repository for centralized storage and sharing.

(2) Each todo item has a timestamp indicating when it was created.

(3) Each todo entry has a timestamp of when it was marked as "yatta!" (done).

(4) Every 'add', 'remove' and 'commit' can be done also offline.

(5) When the Internet connection is restored, the information is shared among
all clients.

(6) Each todo entry is stored in a separate file, and the name of the file is
the md5 sum of its contents.

=head1 DISCUSSION

As you can see from points (2), (3) and (6), a git merge conflict is rare.
However, it is not impossible. It is possible, for example, if computer A
creates the same todo text as computer B at exactly the same second. If both
computers synchronize their todo lists at the same time, only one git push/pull
will succeed. The other will fail.

This sounds like a problem, but it is not. The only thing that was rejected was
binary identical information in a binary identical filename. A second push/pull
is not rejected.

This has been verified experimentally with 2 laptops.

Regarding the second point: The user can easily remove duplicate entries.

I would like to hear more opinions about this concept, and of course I am
interested if there is a flaw in this concept.

=head1 USAGE

Run the script

   yare

If you type 'help'<RETRUN> you will get a short list of available commands.
Use 'add' to create an entry. Add is used like:

    add Something I need to do

Use 'fetch' to display the list:

    fetch
    ----------------------------------------------------------------------------
    0: Something I need to do
    ----------------------------------------------------------------------------

To remove this entry, you can mark it as 'yatta!' (done) like:

    done 0

Yare will then print

    yatta! (done)

## ADVANCED USAGE

It is possible to use more than one todo list. The example shows how to create
a second todo list for work and how to use it.

    mkdir -p ~/.yare/work
    echo "[online]" > ~/.yare/work/yare.ini
    echo "hostname=server.tld" >> ~/.yare/work/yare.ini
    echo "[git]" >> ~/.yare/work/yare.ini
    echo "worktree=~/.yare/work/todo-work" ~/.yare/work/yare.ini

You need to create a remote git repository called 'todo-work' and clone it to
~/.yare/work/todo-work. Then you can use it as usual:

    export YARE_CFG=~/.yare/work
    yare

## FURTHER INFORMATION

For more information, see the standard Perl documentation.

    perldoc Yare::Client

or

    man Yare::Client

=head1 SEE ALSO

L<Yare::Client> - the current implementation

=head1 AUTHOR

    Christian Külker <christian.kuelker@cipworx.org>

=cut

