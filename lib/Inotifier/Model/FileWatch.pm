package Inotifier::Model::FileWatch;

use Linux::Inotify2;
use EV;
use AnyEvent;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {};

    return bless $self, $class;
}

sub file_added {
    my ( $self, $event ) = @_;

    my $file = $event->fullname;

    my $xmit = {
        'freq' => '11111.111',
        'file' => $file,
        'type' => 'audio',
        'stop' => time(),
    };

    $self->{cb}->($xmit);
}

sub watch {
    my ( $self, $msg ) = @_;

    $self->{cb} = $msg;

    my $inotify = new Linux::Inotify2;
    $inotify->watch( '/tmp/foo', IN_CLOSE_WRITE,
        sub { $self->file_added(@_) } );

    my $io = AnyEvent->io(
        fh   => $inotify->{fd},
        poll => 'r',
        cb   => sub { $inotify->poll }
    );

    print "watcher has been setup\n";
    return $io;
}

1;
