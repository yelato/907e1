#!/usr/bin/perl
# Ikiwiki enhanced audio handling plugin
# kev@flujos.org
# Copiado de IkiWiki::Plugin::Img por:
# Christian Mock cm@tahina.priv.at 20061002
package IkiWiki::Plugin::audio;

use warnings;
use strict;
use IkiWiki 3.00;


#my %audiodefaults;

#my ($filename, $pipeline, $source);
my @savetags = ("artist", "title", "genre", "date");
my $urlogg; 
my $urlmp3;

sub import {
	add_underlay("javascript");
	hook(type => "getsetup", id => "audio", call => \&getsetup);
	hook(type => "preprocess", id => "audio", call => \&preprocess, scan => 1);
	hook(type => "format", id => "audio", call => \&format);

#	hook(type => "pagetemplate", id => "audio", call => \&pagetemplate);
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
	my ($audio) = $_[0] =~ /$config{wiki_file_regexp}/; # untaint
	my %params=@_;
	if (! defined $audio) {
		error("bad audio filename");
	}
	add_link($params{page}, $audio);
	add_depends($params{page}, $audio);
	# optimisation: detect scan mode, and avoid generating the image
	if (! defined wantarray) {
		return;
	}
	my $file = bestlink($params{page}, $audio);
	my $srcfile = srcfile($file, 1);
	my $dir = $params{page};
	my $base = IkiWiki::basename($file);
	my $audiolink = $file;
	my ($fileurl, $audiourl);
	if (! $params{preview}) {
		$fileurl=urlto($file, $params{destpage});
		$audiourl=urlto($audiolink, $params{destpage});
	}
	else {
		$fileurl="$config{url}/$file";
		$audiourl="$config{url}/$audiolink";
	}
	if (exists $params{class}) {
		$params{class}.=" audio";
	}
	else {
		$params{class}="audio";
	}

	my $attrs='';
	foreach my $attr (qw{class id}) {
		if (exists $params{$attr}) {
			$attrs.=" $attr=\"$params{$attr}\"";
		}
	}
    my $template = template("audio.tmpl");
	
	$template->param(src => $audio);
	$template->param(class => $params{class});	
	#return $template->output;
    $template = convert($audio, $template);
    $template = get_tags($audio,$template);
    return $template->output;

}

sub convert (@) {
    my $file=shift;
    my $template=shift;
    if ($file =~ /http:\/\//) {
      print "refain from converting online resource";
      return $template;
    }
    
    my @sources = ($file);
        my $cmd;
        my ($base, $in) = split(/\./, $file);

        if ($in =~ m/og(g|a)$/i) {
	    $urlogg = "$base.$in";
	    $template->param(URL_OGG => "$base.$in");
            $template->param(type0 => "audio/ogg");
            $template->param(type1 => "audio/mpeg");
            my $out = "mp3";
            print "$base.$out\n";
	    $template->param(URL_MP3 => "$base.$out");
	    $urlmp3 = "$base.$out";
            $template->param(fallback => "$base.$out");
            my $absfile = "$ENV{HOME}/$config{srcdir}/$base.$out";
            if (!-e $absfile) {
                print "$absfile doesnot exist\n";
                $cmd = "gst-launch-0.10 filesrc location=$base.$in ! vorbisdec ! audioconvert ! lame ! id3mux !  filesink location=$base.$out";
            }
            push(@sources, "$base.$out");
        }
        
        if ($in =~ m/mp3$/i) {
	    $urlmp3 = "$base.$in";
            $template->param(type0 => "audio/mpeg");
            $template->param(type1 => "audio/ogg");
            $template->param(fallback => "$base.$in");
	    $template->param(URL_MP3 => "$base.$in");

            my $out = "oga"; 
	    $template->param(URL_OGG => "$base.$out");
	    $urlogg = "$base.$out";
            if (!-e "$ENV{HOME}/$config{srcdir}$base.$out") {
                $cmd = "gst-launch-0.10 filesrc location=$base.$in ! mad ! audioconvert ! vorbisenc ! oggmux !  filesink location=$base.$out" ;
                push(@sources, "$base.$out");
                }
        }
        #run command
        if ($cmd) { 
            print "gst command: $cmd\n";
            system($cmd);
        }
       $template->param(src0 => $sources[0]);
       $template->param(src1 => $sources[1]);
    return $template;
}

sub get_tags ($) {
#-- list the processes running on your system
    my $file=shift;
    my $template=shift;


    if (!-e $file) {
        if ($file =~ /http:\/\//){
            print "got a hold on $file\n";
            open(MD,"/usr/local/bin/read-metadata.pl $file|") || die "Failed http: $!\n";
        } else {
                print  "Cant get a handle: $!\n";
                print  "Try abs path:\n";
                print "$ENV{HOME}/$config{srcdir}/$file\n";
                $file = "$ENV{HOME}/$config{srcdir}/$file";
                open(MD,"/usr/local/bin/read-metadata.pl $file|") || die "Failed: $!\n";
        }
    } else {
        print "got a hold on $file\n";
        open(MD,"/usr/local/bin/read-metadata.pl $file|") || die "Failed: $!\n";
    }
    #my @tags = ();
    while ( <MD> ) {
       my ( $key, $value ) = split(/:/);
       if ($key && $value) {

            $key =~ s/^\s+//;
            $key =~ s/\s+$//;
            $value =~ s/^\s+//;
            $value =~ s/\s+$//;
            print $key, ":", $value, "\n";
       }else{
          print "[audio] metadata error:  $!"
       
       }
       $template->param($key => $value);
       foreach my $tag (@savetags) {
           if ( $template->param($tag) ) {
               $template->param(tags => "al huevo");
            }
       }
	}
    return $template;
}

sub format (@) {
        my %params=@_;
	my $string=&include_player;
 	$params{content}=~s/(<div class="audio">)/$1$string/;
            $params{content}=include_javascript($params{page}, 1).$params{content};
    return $params{content};
}

sub include_player {

my $string = <<STRING;
  
<script type="text/javascript">
 \$(document).ready(function(){
   \$("#jquery_jplayer").jPlayer({
     ready: function () {
       \$(this).jPlayer("setMedia", {
         mp3: "$urlmp3",
         oga: "$urlogg"
       });
     },
     swfPath: "/jplayer",
     supplied: "mp3, oga",
     cssSelectorAncestor: "#jp_interface" 
   });
 });
</script>

STRING
return $string; 
}

sub include_javascript ($;$) {
    my $page=shift;
    my $absolute=shift;

    return '<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"'.
        '" type="text/javascript" charset="utf-8"></script>'."\n".
        '<script src="'.urlto('ikiwiki/jquery.jplayer.min.js', $page).
        '" type="text/javascript" charset="utf-8"></script>'. "\n" .
	'<link href="'.urlto('jplayer/jplayer.blue.monday.css', $page). 
	'" type="text/css" rel="stylesheet">';
}
1
