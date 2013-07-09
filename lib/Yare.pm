package Yare;

# ABSTRACT: yare - do it! Distributed todo prove of concept 

1;
__END__

=pod

NAME yare - do it! Distributed todo prove of concept

MOTIVATION

Often I experienced that data gets lost, when using calendar or todo lists
shared over a central daemon. That is quite disappointing. Other software
claims that its easy to share and to synchronize them, because they are just
using one file. I doubt that there is a safe way for sharing one file over
three laptops (for example), if in addition one consider that laptops are not
always online. Even Git - which handles merges quite good - is not a solution
to this problem. It is very likely that the unexperienced or busy user ends up
in front of a complex merge conflict question. 

TARGET

Synchronize todo list information among 3 clients, which can be online or offline
without merge conflicts or loss of (non unique!) data.

THESIS

a) The loss of non unique (doubled) data can be tolerated by the user.
b) Conflicts rose by duplicated data can be solved easily by the user.
   (by deleting unwanted entries)

SOLUTION

(1) A git repository as central storage and share facility. 

(2) Every todo entry has a time stamp when it was created

(3) Every todo entry has a time stamp when it was marked as 'done'

(4) Every add, remove and commit can be done also offline

(5) When Internet connection is restored the information will be shared among
    all clients.

(6) Every todo entry is stored in a separate file and the name of the file is
    the md5 sum of its content.

DISCUSSION

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



Tolmezzo, 2013

Christian Külker <christian.kuelker@cipworx.org> 

=cut




















