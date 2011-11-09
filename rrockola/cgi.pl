sub check_cgi 
{
    if (defined $ENV{REQUEST_URI} && $ENV{REQUEST_URI} ne '')     {
        return 1;
    }
}

sub get_cgi_query 
{
    #get cgi form data
    if (length ($ENV{'QUERY_STRING'}) > 0){
        my %query;
        my $buffer = $ENV{'QUERY_STRING'};
        my @pairs = split(/&/, $buffer);
        foreach my $pair (@pairs) {
            (my $name, my $value) = split(/=/, $pair);
            $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
            $query{$name} = $value;
        }
        return %query;
    }
}
1;
