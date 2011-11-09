#!/usr/bin/perl -T 
use strict;
use warnings;

$ENV{PATH} = "/bin:/usr/bin";
delete @ENV{ 'IFS', 'CDPATH', 'ENV', 'BASH_ENV' };
push (@INC, './');

#use XML::LibXSLT;
use XML::LibXML::Reader;
use LWP::Simple;
use HTML::Template;
use CGI;
use Encode; 
use Audio::MPD;

require "source.pl";
require "cgi.pl";
require "mpd.pl";

my $html_root = "/tmp/ice";
my $host = "radio.flujos.org"; #default host
my $audio_dir = "?file="; #relative audio path
my $cgi = CGI->new;

if (&check_cgi) {
    $host = $ENV{SERVER_NAME}; 
    $cgi->header(-type => 'text/html',
			-charset=>'utf-8',
			);
    print $cgi->header;
}

my $source = &get_source; #grap icecast xml source
my @radios = &parse_source($source); #parse it
my @playlists = &get_playlists;
my $template;

if ( &check_cgi && $ENV{REQUEST_URI} =~ /.m3u/ ) {
    &make_playlist($cgi); 
}elsif ( &check_cgi && $ENV{REQUEST_URI} =~ /.(mp3|og(g|a))/ ) {
    &make_audio_file($cgi); 
} else {
    $template = HTML::Template->new(filename => 'icestat.tmpl');
    $template->param(HOST=> $host);
    $template->param(RADIOS => \@radios); 
    $template->param(PLAYLISTS => \@playlists);
}
if (defined $ENV{SERVER_NAME} && $ENV{SERVER_NAME} =~ //) { # // -> radio
    print $template->output;
}
