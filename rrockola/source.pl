use XML::LibXML::Reader;
use LWP::Simple;
use Encode; 

sub get_source {
    my $browser = LWP::UserAgent->new;
    my $req = HTTP::Request->new(GET => 'http://radio.flujos.org:8000/admin/stats.xml');
    $req->authorization_basic('admin', '6d@#8dfl+!~');

    my $responce = $browser->request($req)->as_string;
    my ($headers, $xml) = split(/\n{2,}/, $responce);
    if ($xml =~ m/localhost/) {
        $xml =~ s/localhost/$host/g;
    }
    my $parser = XML::LibXML->new();
    return $parser->parse_string($xml, {encoding => 'utf-8'});
}

sub parse_source
{
    my $source = $_[0];
    my @radios = ();
    my @songs = ();
    my %seen = ();
    my $count = 0;
    foreach my $mount ($source->findnodes('/icestats/source')) {
        my($desc) = encode('utf-8', $mount->findnodes('./server_description')->to_literal);
        my($stream_name) = encode('utf-8', $mount->findnodes('./server_name')->to_literal);
        my($site_url) = encode('utf-8', $mount->findnodes('./server_url')->to_literal);
        my($song_title) = encode('utf-8', $mount->findnodes('./title')->to_literal);
        my($song_artist) = encode('utf-8', $mount->findnodes('./artist')->to_literal);
    my %row_data;
    my ($url) = $mount->findnodes('./listenurl')->to_literal;
    if ( $url =~ /.og(g|a)/ ) {
	#use a mirror 
        my $mirror = 'r0';
	$url =~ s/^http:\/\/radio\.(flujos\.org):8000\/(.*)/http:\/\/$mirror.$1\/$2/g;
        $row_data{URL_OGG} = $url;
    }
    if ( $url =~ /.mp3/ ) {
	#use a mirror 
        my $mirror = 'r0';
	$url =~ s/^http:\/\/radio\.(flujos\.org):8000\/(.*)/http:\/\/$mirror.$1\/$2/g;
  	$row_data{URL_MP3} = $url;
    }
    $row_data{DESC} = $desc;
    $row_data{STREAM_NAME} = $stream_name;
    $row_data{SITE_URL} = $site_url;
    $row_data{SONG_TITLE} = $song_title;
    $row_data{SONG_ARTIST} = $song_artist;
    # averiguar ruta a cancion actual 
    if ($count % 2) {
        $row_data{ODDEVEN} = "odd";
    } else {
         $row_data{ODDEVEN} = "even";
    }
    $row_data{COUNT} = $count;
    if (!exists($seen{ $desc })){
 	 push(@radios, \%row_data);
	 $seen{$desc} = $desc;
	 $count++;
    } else {
    foreach my $radio (@radios) {
        if ($radio->{DESC} eq $desc) {
            if ( $url =~ /.og(a|g)/ ) {
  	        $radio->{URL_OGG} = $url;
	        $radio->{SONG_TITLE} = $song_title;
		$radio->{SONG_ARTIST} = $song_artist;
            }
  	}
     if ( $url =~ /.mp3/ ) {
  	    $radio->{URL_MP3} = $url;
         }
      }
    }
    }
    undef $song_title; 
    return @radios;
}
1;
