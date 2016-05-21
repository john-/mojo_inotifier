package Inotifier;
use Mojo::Base 'Mojolicious';
use Mojo::Log;

use Inotifier::Model::FileWatch;

# This method will run once at server start
sub startup {
    my $self = shift;

    $self->secrets( ['A secret for you'] );

    # Router
    my $r = $self->routes;

    $r->any('/')->to( controller => 'actions', action => 'base' );
    $r->websocket('/wsinit')->to( controller => 'actions', action => 'wsinit' );
}

1;
