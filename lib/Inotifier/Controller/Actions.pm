package Inotifier::Controller::Actions;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub base {
    my $self = shift;

    $self->render(template => 'base');
}

sub wsinit {
    my $self => shift;
    $self->on(message => sub {
        $self->app->log->debug( 'websocket opened' );
        $self->send( {json => {fu => 'bar'}} );
    });

}

1;
