require 'cronolog.pl';

my $mpd = Audio::MPD->new;
sub get_playlist_items 
{  
    use File::Basename;
    my $method = shift;      
    #print $method;      
    my @playlist_items;
    if ($method ne 'mpc') 
    {
	my $path = "/var/lib/mpd/playlists";
	my $rl = "$path/$method";
        open(PLS, "<$rl") || die "Failed: $!\n";
        for (<PLS>) 
        {
	    my %playlist;
	    $_ =~ s/\s+$//;
	    $base = basename($_); 
	    $playlist{ITEM_NAME} = $base;
            if ( $_ =~ /\.og(g|a)/i ) {
	        $playlist{URL_OGG} = $_;
	    }
            if ( $_ =~ /\.mp3/i ) {
	        $playlist{URL_MP3} = $_;
	    }   
	    push(@playlist_items, \%playlist);
        } 
	return @playlist_items;
    }else {

        my @items = $mpd->playlist->as_items;
	for (@items) 
	{
	    my %playlist_item;
            my $str = encode('utf-8', $_->as_string); 
	    #$_ =~ s/\s+$//;
	    $playlist_item{ITEM_NAME} = "$str";
		$file = encode('utf-8', $_->file); 
	        #$playlist_item{ITEM_NAME} = "$base";
                if ( $file =~ /\.og(g|a)/i ) {
	           unless ($_ =~ /http\:\/\//){$playlist_item{URL_OGG} = "audio/$file";}
		}
                if ( $file =~ /\.mp3/i ) {
	            unless ($_ =~ /http\:\/\//){$playlist_item{URL_MP3} = "audio/$file";}
	       }

    push(@playlist_items, \%playlist_item);
	}
    return @playlist_items;  
    }
}

sub make_playlist
{
    my $cgi = shift;
    my %cgi = %$cgi;
    my $template = HTML::Template->new(filename => 'playlist.tmpl');
    my @playlist_items = &get_playlist_items($cgi->param('playlist'));
    my $playlist = $cgi->param('playlist');
    $playlist =~ s/(.*)\.m3u/$1/;
    my @showtimes = &cron_find($playlist);
    $template->param(PLAYLIST=>$cgi->param('playlist'));
    $template->param(PLAYLIST_ITEMS => \@playlist_items);
    $template->param(SHOWTIMES=> \@showtimes);
    $template->param(SONG_TITLE=> $cgi->param('title'));
    $template->param(SONG_ARTIST=> $cgi->param('artist'));
    print $template->output;
}
1;
