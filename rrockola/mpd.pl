my $MPC = "/usr/bin/mpc";
my $mpd = Audio::MPD->new;
# turn on for debugging
## for (&get_playlists ) {print $_}

sub get_audio_path
{
    my $query = shift;
    my %query = %$query;
    $string = "find Title $query{title}"; 
    my @pipe = &mpd_cmd($string);
    my $path = shift(@pipe);
}
sub get_playlists 
{        
    my @playlists;
    for ($mpd->collection->all_playlists) 
	{
	    my %playlist;
	    $playlist{NAME} = $_;
	    push(@playlists, \%playlist);
	}
    return @playlists;  
}

sub get_mpd_current_pls
{
    my $string = "playlist"; 
    @pipe = &mpd_cmd($string);
    for (@pipe)
    {
       my %playlist;
       $_ =~ s/\s+$//;
       $playlist_item{ITEM_NAME} = "$_";
       if ( $_ =~ /\.(og(g|a)|mp3)/i ) {
           $base = basename($_); 
           $playlist_item{ITEM_NAME} = "$base";
           if ( $_ =~ /\.og(g|a)/i ) {
              unless ($_ =~ /http\:\/\//){$playlist_item{URL_OGG} = "$_";}
           }
           if ( $_ =~ /\.mp3/i ) {
               unless ($_ =~ /http\:\/\//){$playlist_item{URL_MP3} = "$_";}
           }
       } elsif (/^.*\s-\s.*$/) {
           /^(.*)\s-\s(.*)$/;
           my $artist = $1;
           my $title = $2;
           #print $artist, $title;
           open(PATH, "mpc find Title '$title' |") || die "Failed: $!\n";
           my @lines = <PATH>;
           for (@lines) {
               my $path = $_;
               $path =~ s/^\s+//;
               $path =~ s/\s+$//;
               if (defined $path) {
               if ( $path =~ /\.og(g|a)/i ) {
                   $playlist_item{URL_OGG} = $audio_dir . $path;
               }
               if ( $path =~ /\.mp3/i ) {
                   $playlist_item{URL_MP3} = $audio_dir . $path;
               }
             }
          }
       }else {
		#print "no patern available \n";
		#$print "$_ might be a stream\n";
		my $title = "$_";
    	}
    }
	push(@playlist_items, \%playlist_item);
	return @playlist_items;
}
1;
