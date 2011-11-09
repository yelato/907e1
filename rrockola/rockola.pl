#!/usr/bin/perl -T 
use strict;
use warnings;
use Audio::MPD;
use HTML::Template;
use CGI;

$ENV{PATH} = "/bin:/usr/bin";
delete @ENV{ 'IFS', 'CDPATH', 'ENV', 'BASH_ENV' };
push (@INC, './');

require "source.pl";
require "mpd.pl";
require 'pls.pl';

my $mpd = Audio::MPD->new;
my $cgi = CGI->new;

my $host = $ENV{SERVER_NAME}; 

print $cgi->header(-type => 'text/html',
                   -charset=>'utf-8');

if ( $ENV{REQUEST_URI} =~ /.m3u/ ) {
    &make_playlist($cgi); 
    exit; 
}
if ( $ENV{REQUEST_URI} =~ /barra/ ) {
    &make_barra($cgi); 
    exit; 
}

if ( $ENV{REQUEST_URI} !~ /barra/ || $ENV{REQUEST_URI} !~ /m3u/) {
    my @playlists = &get_playlists;
    &make_rockola; 
    exit; 
}

sub make_rockola
{
    my $host = "rockola.flujos.org";
    my @playlists = &get_playlists; 
    my @playlist_items = &get_playlist_items('mpc');
    #my @showtimes = &cron_find($playlist);
    my $program = &cron_get_current;
    my $song;
    if ( defined $mpd->current) {
       $song = $mpd->current;
    } else {
	$mpd->play;
        $song = $mpd->current;
	    }
    my $template  = HTML::Template->new(
                      filename          => 'playlist.tmpl',
                      die_on_bad_params => 0,
                      global_vars       => 1,
		      force_untaint     => 2,
		      path     => ['/usr/share/templates/'],
                );
    $template->param(PLAYLIST_ITEMS => \@playlist_items);
    $template->param(PLAYLISTS => \@playlists);
    $template->param(HOST=> $host);
    unless (defined $program) {
        $template->param(SHOW=> 'DJ Dinamica');
    } else { 
	$template->param(SHOW=> $program);
    }
    $template->param(LISTEN_URL_OGG=> 'http://radio.flujos.org:8000/rockola.oga');
    $template->param(LISTEN_URL_MP3=> 'http://radio.flujos.org:8000/rockola.mp3');
    $template->param(SONG_TITLE=> encode('utf-8', $song->title));
    $template->param(SONG_ARTIST=> encode('utf-8', $song->artist));
    $template->param(DESC=> 'Rockolateca Virtual al alcanze de sus digitoz');
    print $template->output;
}

sub make_audio_file
{
    # open the html template
    my $template = HTML::Template->new(filename => 'audio.tmpl'); 
    
    my %query = shift;
    #$template->param(HOST=> $host);
    $template->param(FILE=> $query{file});
    $template->param(SONG_TITLE=> $query{title});
    $template->param(SONG_ARTIST=> $query{artist});
    if (  $query{file} =~ /.og(g|a)/ ) {
        $template->param(URL_OGG=> $ENV{FILE});
    }
    if (  $query{file} =~ /.mp3/ ) {
        $template->param(URL_MP3=> $query{FILE});
    }
    if (defined $query{title}) {
	&get_audio_path($query{title});
    }
}
1;
