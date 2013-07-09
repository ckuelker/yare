package Yare::Client;
use Config::INI::Reader;
use Digest::MD5;
use File::Find;
use Moose;
use Git::Repository;
use namespace::autoclean;
use Net::Ping;
extends 'Term::Shell';
use Time::Piece ();
my $dir = glob "~/.yare";
my $dd  = '0000-00-00T00:00:00';
my $cfg = Config::INI::Reader->read_file("$dir/yare.ini");
my $wt  = glob $cfg->{git}->{worktree};

# -------------------- shell ------------------------------------------------
sub prompt_str {
    if   ( online() ) { "yare (online)> "; }
    else              { "yare (offline)> "; }
}

sub run_fetch {
    my ($s) = @_;
    $s->git_pull;
    my ( $todo_hr, $o, $fn_idx_hr, $cnt_idx_hr ) = $s->fetch_todo_data;
    print "-" x 78 . "\n";
    foreach my $fn ( sort keys %{$todo_hr} ) {
        foreach my $line ( @{ $todo_hr->{$fn} } ) {
            chomp $line;
            $line =~ s{^\[\s{1,1}\]\s+}{}mx;
            $line =~ s{^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\s+}{}mx;
            $line =~ s{^\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d\s+}{}mx;
            printf( "%s: %s\n", $fn_idx_hr->{$fn}, $line );
        }
    }
    print "-" x 78 . "\n";
}

sub run_done {
    my ( $s, $i ) = @_;
    if ( not defined $i or $i eq {} ) {
        print "USAGE: \n" . $s->help_done;
        return;
    }
    print "mark entry [$i] as done ...\n";
    my ( $todo_hr, $o, $fn_idx_hr, $cnt_idx_hr ) = $s->fetch_todo_data;
    if ( not exists $cnt_idx_hr->{$i} or not defined $cnt_idx_hr->{$i} ) {
        print "ERROR: no entry $i! Maximum is $o. Use 'fetch' to see\n";
        return;
    }
    my $date  = Time::Piece::localtime->strftime('%FT%T');
    my $fn    = "$wt/" . $cnt_idx_hr->{$i} . ".yare";
    my $entry = $s->read_entry_from_fs($fn);
    $s->git_remove($fn);
    $s->git_commit( $fn, 'done' );
    $entry =~ s{^\[\s{1,1}\]}{[O]}mx;
    $entry =~ s{$dd}{$date}gmxe;
    my $nfn = $s->write_entry_to_fs( [$entry] );
    $s->git_add($nfn);
    $s->git_commit( $nfn, 'history' );
    $s->git_pull;
    $s->git_push;
}

sub run_add {
    my ( $s, @msg ) = @_;
    if ( scalar @msg == 0 ) {
        print "USAGE: \n" . $s->help_add;
        return;
    }
    my $date = Time::Piece::localtime->strftime('%FT%T');
    my $msg = join q{ }, '[', ']', $date, $dd, @msg;
    print "add message: $msg\n";
    my $fn = $s->write_entry_to_fs( [$msg] );
    $s->git_add($fn);
    $s->git_commit( $fn, 'init' );
    $s->git_pull;
    $s->git_push;
    return $msg;
}

# -------------------- shell summary ----------------------------------------
sub smry_fetch { return "displays all pending todo entries"; }
sub smry_add   { return "adds a todo entry"; }
sub smry_done  { return "marks one todo entry as 'done'"; }

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

# -------------------- shell utils ------------------------------------------
sub read_entry_from_fs {
    my ( $s, $fn ) = @_;
    my $entry = q{};
    open my $c, q{<}, $fn or die "can not read [$fn]!\n";
    while ( my $line = <$c> ) { chomp $line; $entry .= "$line\n"; }
    close $c;
    return $entry;
}

sub write_entry_to_fs {
    my ( $s, $c_ar ) = @_;
    my $data = join qq{\n}, @{$c_ar};
    my $ctx = Digest::MD5->new;
    $ctx->add($data);
    my $digest = $ctx->hexdigest;
    my $fn     = "$wt/$digest.yare";
    open my $f, q{>}, $fn or die "can not write [$fn]\n";
    foreach my $line ( @{$c_ar} ) { print $f "$line\n"; }
    close $f;
    return $fn;
}

sub fetch_todo_data {
    my ($s) = @_;
    my ( %todo, %cnt_idx, %fn_idx ) = ();
    my $o = 0;
    my @t = ();
    find( sub { push @t, "$File::Find::name$/" if (/\.yare$/) }, $wt );
    foreach my $fn (@t) {
        chomp $fn;
        my $entry = $s->read_entry_from_fs($fn);
        $fn =~ s{^$wt/(.*)\.yare}{$1}gmx;
        next if not $entry =~ m{^\[\s{1,1}\]}mx;
        push @{ $todo{$fn} }, $entry;
        $fn_idx{$fn} = $o;
        $cnt_idx{$o} = $fn;
        $o++;
    }
    return \%todo, $o - 1, \%fn_idx, \%cnt_idx;
}

# -------------------- networking -------------------------------------------
sub online {
    my $hostname = $cfg->{online}->{hostname};
    return 1 if pingecho($hostname);
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

