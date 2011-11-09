#!/usr/bin/perl -T
use warnings;
use strict;
use File::Basename;

my $pdir= "/var/lib/mpd/playlists";

if (defined $ENV{REQUEST_URI} && $ENV{REQUEST_URI} =~ /\.m3u/)
{
my $host = $ENV{HTTP_HOST};
    print "Content-Type: audio/mpegurl\n\n";
    my $base = basename$ENV{REQUEST_URI};
    my $pls = "$pdir/$base";
    open(PLS, "<$pls") || die "Failed: $!\n";
    for (<PLS>) {
        print "http://$host/audio/$_";
        #$_ =~ s/\s+$//;
        #$base = basename($_);
    }
    print "\n";

}
