package Yare;

# ABSTRACT: yare - do it! Distributed todo prove of concept

our $VERSION = '0.0.5';

1;
__END__

=pod

=head1 NAME 

yare - do it! Distributed todo prove of concept

=head1 MOTIVATION

Often I experienced that data gets lost, when using calendar or todo lists
shared over a central daemon. That is quite disappointing. Other software
claims that its easy to share and to synchronize them, because they are just
using one file. I doubt that there is a safe way for sharing one file over
three laptops (for example), if in addition one consider that laptops are not
always online. Even Git - which handles merges quite good - is not a solution
to this problem. It is very likely that the unexperienced or busy user ends up
in front of a complex merge conflict question. 

=head1 TARGET

Synchronize todo list information among 3 clients, which can be online or
offline without merge conflicts or loss of (non unique!) data.

=head1 THESIS

a) The loss of non unique (doubled) data can be tolerated by the user.
b) Conflicts rose by duplicated data can be solved easily by the user.
   (by deleting unwanted entries)

=head1 SOLUTION

(1) A git repository as central storage and share facility. 

(2) Every todo entry has a time stamp when it was created

(3) Every todo entry has a time stamp when it was marked as 'yatta!' (done)

(4) Every add, remove and commit can be done also offline

(5) When Internet connection is restored the information will be shared among
    all clients.

(6) Every todo entry is stored in a separate file and the name of the file is
    the md5 sum of its content.

=head1 DISCUSSION

As it is obvious from point (2), (3) and (6) a git merge conflict is seldom.
However not impossible. It is possible if computer A create the same todo text
as computer B at exactly the same second for example. If then both computers
will sync their todo list at the same time, only one git push/pull will
succeed. The other will be rejected. 

This sounds like a problem, but in reality it is not. The only thing which was
rejected was a binary identical information in a binary identical file name. A
second push/pull will not be rejected. 

This was experimental proven with 2 laptops. 

Regarding point b). The user can easily remove doubled entries.

I would like to hear more opinions about this concept and of course I am
interested in, if there is a flaw in this concept.

=head1 USAGE

Execute the script

   yare

If you enter 'help'<RETRUN> you get a brief list of available commands.  Use
'add' to create an entry. Add is used like:

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

It is possible to use more then one yare todo list. The example show how to
create a second todo list for work and how to use it

    mkdir -p ~/.yare/work
    echo "[online]" > ~/.yare/work/yare.ini
    echo "hostname=server.tld" >> ~/.yare/work/yare.ini
    echo "[git]" >> ~/.yare/work/yare.ini
    echo "worktree=~/.yare/work/todo-work" ~/.yare/work/yare.ini

You have to create a remote git repository 'todo-work' and clone it to
~/.yare/work/todo-work. Then you can use it like:

    export YARE_CFG=~/.yare/work
    yare

## FURTHER INFORMATION

You can get further information via the ordinary Perl documentation.

    perldoc Yare::Client

or

    man Yare::Client

=head1 SEE ALSO

L<Yare::Client> - the current implementation

=head1 AUTHOR

    Christian Külker <christian.kuelker@cipworx.org> 

=cut

