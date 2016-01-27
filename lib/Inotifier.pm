package Inotifier;
use Mojo::Base 'Mojolicious';
use Mojo::Log;

use Inotifier::Model::MPD;

# This method will run once at server start
sub startup {
    my $self = shift;

    $self->secrets(['A secret for you']);

    $self->helper(mpd => sub { state $mpd = Inotifier::Model::MPD->new });

    # Router
    my $r = $self->routes;

    $r->any('/')->to(controller => 'actions', action => 'base');
    $r->any('/execute')->to(controller => 'actions', action => 'execute');
}

1;
