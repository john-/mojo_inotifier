package Inotifier::Model::MPD;

use strict;
use warnings;

use Net::MPD;

sub new {
    my $class = shift;

    my $self = {
	mpd => Net::MPD->connect(),
    };

    @{ $self->{tracks} } = grep {$_->{type} eq 'file'} $self->{mpd}->list_all();
    
    return bless $self, $class;
}

sub random {
    my ($self, $number, $filter) = @_;

    my @tracks = @{$self->{tracks}};
    my $num_tracks = scalar(@tracks);

    $number = $number < $num_tracks ? $number : $num_tracks;
    my @random_trail;
    ATTEMPT: while (scalar(@random_trail) < $number) {
	my $attempt = int(rand($num_tracks));

	next ATTEMPT if grep(/^$attempt$/, @random_trail);
	
        eval { $self->{mpd}->ping };  # restablish connection if it dropped
	$self->{mpd}->add($tracks[$attempt]->{uri});
	push @random_trail, $attempt;
    }

    return scalar(@random_trail);
}

sub play {
    my $self = shift;

    eval { $self->{mpd}->ping };  # restablish connection if it dropped
    $self->{mpd}->play;
}

sub pause {
    my $self = shift;

    eval { $self->{mpd}->ping };  # restablish connection if it dropped
    $self->{mpd}->pause;
}

sub next {
    my $self = shift;

    eval { $self->{mpd}->ping };  # restablish connection if it dropped
    $self->{mpd}->next;
}

sub volume {
    my ($self, $direction) = @_;

    eval { $self->{mpd}->ping };  # restablish connection if it dropped
    $self->{mpd}->update_status;
    
    
    if ($direction eq 'up') { 
	$self->{mpd}->volume( $self->{mpd}->volume + 10 );
    } else {
	$self->{mpd}->volume( $self->{mpd}->volume - 10 );
    }
    
    return $self->{mpd}->volume;
}

1;
