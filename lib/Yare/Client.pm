# +---------------------------------------------------------------------------+
# | Yare::Client                                                              |
# |                                                                           |
# | A Yare shell client.                                                      |
# |                                                                           |
# | Version: 0.0.6 (change inline)                                            |
# |                                                                           |
# | Changes:                                                                  |
# |                                                                           |
# | 0.0.6 2023-03-09 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Improve writing                                                     |
# |     - Improve verbose printing feedback                                   |
# |     - Improve comments                                                    |
# |     - Add front boiler plate                                              |
# |     - Fix online detection (pingecho -> ping syn)                         |
# | 0.0.5 2014-08-22 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - YARE_CFG feature (secondary todo lists)                             |
# | 0.0.4 2013-08-06 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Add version (2013-08-27)                                            |
# |     - Comments and sort output alphabetically                             |
# | 0.0.3 2013-07-23 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Add idea "yatta!"                                                   |
# |     - Refactor Digest::MD5 call                                           |
# | 0.0.2 2013-06-10 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Improve index number output in fetch list                           |
# |     - Add POD                                                             |
# | 0.0.1 2013-06-09 Christian Külker <christian.kuelker@cipworx.org>         |
# |     - Initial release                                                     |
# |                                                                           |
# +---------------------------------------------------------------------------+

package Yare::Client;
use Config::INI::Reader;
use Digest::MD5;
use File::Find;
use Git::Repository;
use Moose;
use namespace::autoclean;
use Net::Ping;
use Time::Piece ();
our $VERSION = '0.0.6';

extends 'Term::Shell';

my $dir
    = ( defined $ENV{YARE_CFG} and -d glob $ENV{YARE_CFG} )
    ? glob $ENV{YARE_CFG}
    : glob "~/.yare";
my $dd = '0000-00-00T00:00:00';

# Configuration
my $cfg = Config::INI::Reader->read_file("$dir/yare.ini");

# Working tree
my $wt = glob $cfg->{git}->{worktree};

# -------------------- shell ------------------------------------------------
sub prompt_str {
    if   ( online() ) { "yare (online)> "; }
    else              { "yare (offline)> "; }
}

sub run_fetch {
    my ($s) = @_;
    $s->git_pull;
    my ( $todo_hr, $o, $fn_idx_hr, $cnt_idx_hr, $print_hr )
        = $s->fetch_todo_data;
    print "-" x 78 . "\n";
    foreach my $fn (
        sort { lc $print_hr->{$a} cmp lc $print_hr->{$b} }
        keys %{$print_hr}
        )
    {
        printf( "%4s: %s\n", $fn_idx_hr->{$fn}, $print_hr->{$fn} );
    }
    print "-" x 78 . "\n";
}

sub run_done {
    my ( $s, $i ) = @_;
    if ( not defined $i or $i eq {} ) {
        print "USAGE: \n" . $s->help_done;
        return;
    }
    print "Mark entry [$i] as 'yatta!' (done) ...\n";
    my ( $todo_hr, $o, $fn_idx_hr, $cnt_idx_hr ) = $s->fetch_todo_data;
    if ( not exists $cnt_idx_hr->{$i} or not defined $cnt_idx_hr->{$i} ) {
        print "ERROR: no entry $i! Maximum is $o. Use 'fetch' to see\n";
        return;
    }
    my $date  = Time::Piece::localtime->strftime('%FT%T');
    my $fn    = "$wt/" . $cnt_idx_hr->{$i} . ".yare";
    my $entry = $s->read_entry_from_fs($fn);
    $s->git_remove($fn);
    $s->git_commit( $fn, 'yatta! (done)' );
    $entry =~ s{^\[\s{1,1}\]}{[O]}mx;
    $entry =~ s{$dd}{$date}gmxe;
    my $nfn = $s->write_entry_to_fs( [$entry] );
    $s->git_add($nfn);
    $s->git_commit( $nfn, 'history' );
    $s->git_pull;
    $s->git_push;
    print "yatta! (done)\n\n";
}

sub run_add {
    my ( $s, @msg ) = @_;
    if ( scalar @msg == 0 ) {
        print "USAGE: \n" . $s->help_add;
        return;
    }
    my $date = Time::Piece::localtime->strftime('%FT%T');
    my $msg = join q{ }, '[', ']', $date, $dd, @msg;
    print "Add message: $msg\n";
    my $fn = $s->write_entry_to_fs( [$msg] );
    $s->git_add($fn);
    $s->git_commit( $fn, 'init' );
    $s->git_pull;
    $s->git_push;
    return $msg;
}

# -------------------- shell summary ----------------------------------------
sub smry_fetch { return "Displays all pending todo entries"; }
sub smry_add   { return "Adds a todo entry"; }
sub smry_done  { return "Marks one todo entry as 'yatta!' (done)"; }

# -------------------- shell help -------------------------------------------
sub help_fetch {
    <<'FETCH';
    fetch
FETCH
}

sub help_add {
    <<'ADD';
    add <Text that describes the todo entry>
ADD
}

sub help_done {
    <<'DONE';
    done <NUMBER>
DONE
}

# -------------------- shell utilities --------------------------------------
sub read_entry_from_fs {
    my ( $s, $fn ) = @_;
    my $entry = q{};
    open my $c, q{<}, $fn or die "ERROR: Can not read [$fn]!\n";
    while ( my $line = <$c> ) { chomp $line; $entry .= "$line\n"; }
    close $c;
    return $entry;
}

sub write_entry_to_fs {
    my ( $s, $c_ar ) = @_;
    my $data = join qq{\n}, @{$c_ar};
    my $fn = "$wt/" . Digest::MD5->new->add($data)->hexdigest . '.yare';
    open my $f, q{>}, $fn or die "ERROR: Can not write [$fn]\n";
    foreach my $line ( @{$c_ar} ) { print $f "$line\n"; }
    close $f;
    return $fn;
}

sub fetch_todo_data {
    my ($s) = @_;

    # Fetches file names and their contents from the working tree and stores
    # them in 4 hashes.
    #
    # todo    = {  file_name => complete_content  }
    # fn_idx  = {  file_name => ID                }
    # cnt_idx = {  ID        => file_name         }
    # print   = {  file_name => print_content     }
    my ( %todo, %print, %cnt_idx, %fn_idx ) = ();
    my @t = ();
    find( sub { push @t, "$File::Find::name$/" if (/\.yare$/) }, $wt );
    foreach my $fn (@t) {
        chomp $fn;
        my $entry = $s->read_entry_from_fs($fn);
        $fn =~ s{^$wt/(.*)\.yare}{$1}gmx;
        next if not $entry =~ m{^\[\s{1,1}\]}mx;
        chomp $entry;
        $todo{$fn} = $entry;
        $entry =~ s{^\[\s{1,1}\]\s+}{}mx;
        $entry =~ s{^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\s+}{}mx;
        $entry =~ s{^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\s+}{}mx;
        $print{$fn} = $entry;
    }
    my $o = 0;
    foreach my $fn ( sort { lc $print{$a} cmp lc $print{$b} } keys %print ) {
        $fn_idx{$fn} = $o;
        $cnt_idx{$o} = $fn;
        $o++;
    }

    # TODO: nr_of_files, file_name_index_hr, count_index_hr, print
    return \%todo, $o - 1, \%fn_idx, \%cnt_idx, \%print;
}

# -------------------- networking -------------------------------------------
sub online {
    my $hostname = $cfg->{online}->{hostname};
    my $p        = Net::Ping->new('syn');
    my $r        = $p->ping($hostname);
    $p->close();
    return 1 if $r;
    return 0;
}

# -------------------- repository/ storage/  git ----------------------------
sub git_pull {
    my $git = Git::Repository->new( work_tree => $wt );
    print $git->run('pull') . "\n" if online();
}

sub git_push {
    my $git = Git::Repository->new( work_tree => $wt );
    print $git->run('push') . "\n" if online();
}

sub git_remove {
    my $git = Git::Repository->new( work_tree => $wt );
    my ( $s, $i ) = @_;
    print $git->run( 'rm' => $i ) . "\n";
}

sub git_add {
    my $git = Git::Repository->new( work_tree => $wt );
    my ( $s, $i ) = @_;
    print $git->run( 'add' => $i ) . "\n";
}

sub git_commit {
    my $git = Git::Repository->new( work_tree => $wt );
    my ( $s, $i, $j ) = @_;
    print $git->run( 'commit' => '-m', $j, $i ) . "\n";
}

# -------------------- Perl object ------------------------------------------
# http://search.cpan.org/~stevan/Moose-0.54/lib/Moose/Cookbook\
# /FAQ.pod#How_do_I_make_non-Moose_constructors_work_with_Moose?
sub new {
    my $class = shift;
    my $obj   = $class->SUPER::new(@_);
    return $class->meta->new_object( __INSTANCE__ => $obj, @_, );
}

1;
__END__

=pod

=head1 NAME

Yare::Client

=head1 VERSION

version 0.0.6

=head1 SYNOPSIS

    use Yare::Client;
    my $c = Yare::Client->new;
    $c->cmdloop;

=head1 DESCRIPTION

Yare is a proof of concept. It proves how to make a shared todo list possible.
Yare::Client implements access to a Yare-based todo list. For this to work, it
does not matter if the clients (e.g. laptops) are always online or not, or if
they try to enter the same information at the same time or not. Of course it
will not work with a client that will never be online, but that is obvious.

Yare::Client is a Term::Shell based class that can be used very easily by a
program by calling the shell loop start command.

=head1 METHODS

=head2 cmdloop

This is the only officially supported method (for now). See the SYNOPSIS for
how to use it.

=head1 SEE ALSO

    - L<Yare> - general explanation of motivation, function  and usage

=head1 AUTHOR

Christian Külker <christian.kuelker@ciwporx.org>

=cut
