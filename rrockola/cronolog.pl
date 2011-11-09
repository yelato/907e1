#!/usr/bin/perl 
use warnings; 
use strict;
use Config::Crontab;
use Calendar::Schedule;
 
my $ct = new Config::Crontab; $ct->read;
my $switch = $ARGV[0];
my $datetime = $ARGV[1];
my $playlist = $ARGV[2];

# mpd-cron [add|rm] 'etime' playlist

#if ($ARGV[0] eq 'add' ) {&cron_add($datetime, $playlist)};
#if ($ARGV[0] eq 'rm' ) {&cron_rm($datetime, $playlist)};
#if ($ARGV[0] eq 'dump' ) {&cron_dump_all};
#if ($ARGV[0] eq 'find' ) {&cron_find(ARGV[1])};

sub cron_add {
  my ($datetime, $playlist) = @_;
  my $block = new Config::Crontab::Block;
  $block->last( new Config::Crontab::Event( -datetime  => $datetime,
                                            -command => "/usr/local/bin/mpd-sched $playlist" ) );
  $ct->last($block);
  $ct->write;
}

sub cron_rm {
  my ($datetime, $playlist) = @_;
  my ($event) = $ct->select(-datetime  => $datetime,
                            -command => "/usr/local/bin/mpd-sched $playlist" );
  $ct->remove( $event ); 
  $ct->write;
}
sub cron_find {
    # returns list of times when a show plays
    my $playlist = shift;
    my @showtimes;
    for my $event ( $ct->select( -type => 'event', -command_re => $playlist ))
    {
 	my %show;
        my $min = $event->minute;
        if (length($min) == 1) {$min = "0" . $min}
        my $hour = $event->hour;
        if (length($hour) == 1) {$hour = "0" . $hour}
        $show{MINUTE} = $min;
        $show{HOUR} = $hour;
        #$show{DOM} = $event->dom;
        my $dow = $event->dow;
        if ($dow =~ /^.*-.*$/) {
            my ($fstr,$lstr); 
 	    $dow =~ /^(.*)-(.*)$/;
            if ($1 eq 0 ) {$fstr = 'Domingo'}
            if ($1 eq 1 ) {$fstr = 'Lunes'}
            if ($1 eq 2 ) {$fstr = 'Martes'}
            if ($1 eq 3 ) {$fstr = 'Miercoles'}
            if ($1 eq 4 ) {$fstr = 'Jueves'}
            if ($1 eq 5 ) {$fstr = 'Viernes'}
            if ($1 eq 6 ) {$fstr = 'Sabado'}
            if ($2 eq 0 ) {$lstr = 'Domingo'}
            if ($2 eq 1 ) {$lstr = 'Lunes'}
            if ($2 eq 2 ) {$lstr = 'Martes'}
            if ($2 eq 3 ) {$lstr = 'Miercoles'}
            if ($2 eq 4 ) {$lstr = 'Jueves'}
            if ($2 eq 5 ) {$lstr = 'Viernes'}
            if ($2 eq 6 ) {$lstr = 'Sabado'}
            $show{FDOW} = $fstr;
            $show{LDOW} = $lstr;

	} else {
            if ($dow eq 0 ) {$dow = 'Domingo'}
            if ($dow eq 1 ) {$dow = 'Lunes'}
            if ($dow eq 2 ) {$dow = 'Martes'}
            if ($dow eq 3 ) {$dow = 'Miercoles'}
            if ($dow eq 4 ) {$dow = 'Jueves'}
            if ($dow eq 5 ) {$dow = 'Viernes'}
            if ($dow eq 6 ) {$dow = 'Sabado'}
            $show{DOW} = $dow;
	}
        my $day = $event->day;
	push(@showtimes, \%show);
    }
    return @showtimes; 
}

sub cron_get_current {
   my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
   my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
    my @events = $ct->select(-type =>'event',
			     -hour =>$hour);
    for my $event (@events) {
	my ($cmd, $playlist) =  split(' ', $event->command);
	    if ($event->dow =~ /-/) {
	        $event->dow =~ /(.*)-(.*)/;
	        for my $day (@days[$1..$2])
	        {
               	    if ($day eq $days[$dayOfWeek]) {
			return $playlist; 
	            }
		}
	    } else {
		if ($event->dow eq $dayOfWeek){
		     return $playlist;
		} 
    	    } 
	}
}
sub cron_dump_all {
    my ($min, $hour, $day, $cmd, $playlist);
    my @programs;
    for my $event ( $ct->select(-type =>'event') ) {
        my %program;
        $min = $event->minute;
        if (length($min) == 1) {$min = "0" . $min}
        $hour = $event->hour;
        $day = $event->hour;
        my $command = $event->command;
        my $clock =  $event->hour . ":" .  $min;
	($cmd, $playlist) =  split(' ', $command);
        $program{PROGRAM} = $playlist;
    }
}
sub make_barra {
    my $cgi = shift;
    my %cgi = %$cgi;
    my @dow = qw(Sun Mon Tue Wed Thu Fri Sat);
    my $TTable = Calendar::Schedule->new();
    $TTable->{'ColLabel'} = "%A";
    my @events = $ct->select;
    for my $event (@events) {
        my $command = $event->command;
        my ($cmd, $playlist) =  split(' ', $command);
	    my $start = $event->hour; 
  	    my $end = $start + 1;
            my $hour = "$start-$end";
        if ($event->dow =~ /-/) {
	    $event->dow =~ /(.*)-(.*)/;
	    for my $day(@dow[$1..$2])
	    {
                my $str = join(" ", $day, $hour, $playlist);
	        $TTable->add_entry($str);
	    }

	} else {
	    my $str;
            my $dow = $dow[$event->dow];
            if (defined $playlist && $playlist ne '') {
                 $str = join(" ", $dow, $hour, $playlist);
            }else {
                 $str = join(" ", $dow, $hour);
	    }
	    $TTable->add_entry($str);
	}
    }
    print $cgi->start_html(
	-title=>'rockola.flujos.org',
        -style=>'style.css',
	-lang=>'es-MX'
        );
    my $url = $cgi->url;
    print $cgi->a({-href=>"$url"}, $cgi->h1("rockola.flujos.org"));
    print $cgi->p("Barra de Transmissiones *");
    print $TTable->generate_table(); 
    print $cgi->p("* cuando no haya programa listada, la programación esta automatizado de manera dinamica");
    print $cgi->end_html;
}
sub time_remap {
  my $str = shift;
  return split(/ /, $str);
}
1;
