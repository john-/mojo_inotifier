package Inotifier::Controller::Actions;
use Mojo::Base 'Mojolicious::Controller';

use Inotifier::Model::FileWatch;

use Mojo::JSON qw(encode_json);

use Data::Dumper;

sub base {
    my $self = shift;

    $self->render( template => 'base' );
}

sub wsinit {
    my $c = shift;

    $c->app->log->debug('websocket opened');

    my $watcher = Inotifier::Model::FileWatch->new;

    our $cb = $watcher->watch(
        sub {
            my $payload = shift;
            $payload->{url} = $c->app->defaults->{audio_url};
            $c = $c->send( { json => encode_json($payload) } );
        }
    );

    $c->on(
        message => sub {
            $c->send( { json => { fu => 'bar' } } );
        }
    );
}

1;
