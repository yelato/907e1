#!/usr/bin/perl
# Ikiwiki playlist handling plugin
# kev@flujos.org

# uso: [!playlist playlists/shostakovich.m3u class=float_left]

package IkiWiki::Plugin::playlist;

use warnings;
use strict;
use IkiWiki 3.00;

my @savetags = ("artist", "title", "genre", "date");
my $urlogg; 
my $urlmp3;

# llamamos a los `hooks` de ikiwiki de procesamiento del plugin
sub import {
	# underlay = ficheros estaticos incluidos en el wiki
	add_underlay("javascript");
	# opicones de configuracion para el plugin 
	hook(type => "getsetup", id => "playlist", call => \&getsetup);
	# la mayor parte de la logica del plugin, que devuelva salida de la plantilla
	hook(type => "preprocess", id => "playlist", call => \&preprocess, scan => 1);
        # rutina que nos permita modificar toma la html saliendo de la platilla 
	hook(type => "format", id => "playlist", call => \&format);
}

sub getsetup () {
	return
		plugin => {
			safe => 1,
			rebuild => undef,
			section => "widget",
		},
}

sub preprocess (@) {
	my ($pls) = $_[0] =~ /$config{wiki_file_regexp}/; # untaint
	# paremetros de cgi
	my %params=@_;
	if (! defined $pls) {
		# devuelva error si no hay un audio	
		error("[playlist] fichero erroneo");
	}
	add_link($params{page}, $pls);
	add_depends($params{page}, $pls);
	# optimisacion: detectar modo escanear y no generar el playlist 
	if (! defined wantarray) {
		return;
	}

	#obtener una ruta hacia el audio
	my $file = bestlink($params{page}, $pls); 
	my $srcfile = srcfile($file, 1);
	my $dir = $params{page};
	my $base = IkiWiki::basename($file);
	my $plslink = $file;
	my ($fileurl, $plsurl);
	if (! $params{preview}) {
		$fileurl=urlto($file, $params{destpage});
		$plsurl=urlto($plslink, $params{destpage});
	}
	else {
		$fileurl="$config{url}/$file";
		$audiourl="$config{url}/$plslink";
	}

 	# agregar el css 'class' `audio`
	if (exists $params{class}) {
		$params{class}.=" playlist";
	}
	else {
		$params{class}="playlist";
	}

	my $attrs='';
	foreach my $attr (qw{class id}) {
		if (exists $params{$attr}) {
			$attrs.=" $attr=\"$params{$attr}\"";
		}
	}
    my $template = template("playlist.tmpl");
    $template->param(src => $pls); 
    # el usuario final puede difinir su proprio `class`	
    $template->param(class => $params{class});
    $template = &make_playlist(%params, $template);
    return $template->output;

}

sub format (@) {
    # parsea y modifica salida html de `preprocess`
    my %params=@_;
    # rutina que formatea el `player`
    my $string=&include_player; 
    # $params{content} contiene el html como producido por la platilla arriba
    # buscamos el un div de `audio` y agregamos el reproductor dentro del div
    $params{content}=~s/(<div class="playlist">)/$1$string/;
    # incluir el javascript
    $params{content}=include_javascript($params{page}, 1).$params{content};
    return $params{content};
}

sub include_player {
    # nuestra reproductor de audio
my $string = <<STRING;
  testing 123  

STRING
return $string; 
}

sub include_javascript ($;$) {
    # javascript necesario para el funcionamiento del plugin
    my $page=shift;
    my $absolute=shift;

    return '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"'.
        '" type="text/javascript" charset="utf-8"></script>'."\n".
        '<script src="'.urlto('ikiwiki/jquery.jplayer.min.js', $page).
        '" type="text/javascript" charset="utf-8"></script>'. "\n" .
	'<link href="'.urlto('jplayer/jplayer.blue.monday.css', $page). 
	'" type="text/css" rel="stylesheet">';
}
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
	my $mpd = Audio::MPD->new;
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
    # this needs to hook into ikikiwiki, cgi
    my $cgi = shift;
    my %cgi = %$cgi;
    my $template = shift;
    my @playlist_items = &get_playlist_items($cgi->param('playlist'));
    my $playlist = $cgi->param('playlist');
    $playlist =~ s/(.*)\.m3u/$1/;
    #my @showtimes = &cron_find($playlist);
    $template->param(PLAYLIST=>$cgi->param('playlist'));
    $template->param(PLAYLIST_ITEMS => \@playlist_items);
    $template->param(SHOWTIMES=> \@showtimes);
    $template->param(SONG_TITLE=> $cgi->param('title'));
    $template->param(SONG_ARTIST=> $cgi->param('artist'));
    return $template;
}
1
