# GetExchangeParams.pm	-  bren  -  08/13/01
#
# (updated by S. Diggs to work under RHE-Linux: 2005.05.11)
# M. Shen (2008-08-01)	Modified to handle exchangeParams.txt
#			containing parameters ordered in the way they are to
#			be displayed.
#
# This code is property of the UC regents, with a beerware provision for
# the author.
#
# GetExchangeParams.pm is a perl module that contains functions to deal with
# the current parameters for the exchange format located in:
# /usr/local/hyd_working/exchangeParams.txt
#
# There are two public functions.

use strict;

my $FALSE = 0;
my $TRUE  = 1;

sub trim ($) {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

#------------------------------------------------------------------------------
# public
#------------------------------------------------------------------------------

# getParams() takes no argumengts, but returns
# a hash. The keys of the hash are the current accepted parameters for exchange
# format. The values stored at those keys are the format precisions.

sub getParams {
    my %paramHash;
    my @paramArray;

    open( PARAMFILE, "/usr/local/cchdo_perl_lib/hyd_cdom/exchangeParams.txt" )
      or die("Can't find exchangeParams.txt -> $!");

    chomp( my @params = <PARAMFILE> );
    close(PARAMFILE);

    # parse parameter,format line ignoring comments and emtpy lines
    foreach my $param (@params) {
        unless ( ( $param =~ /\s/ ) || ( $param =~ /^\#/ ) ) {
            my @tmp = split( ',', $param );
            $tmp[0] = trim( $tmp[0] );
            $tmp[1] = trim( $tmp[1] );

            $paramHash{ $tmp[0] } = $tmp[1];
            push( @paramArray, $tmp[0] );
        }
    }

    return ( \@paramArray, \%paramHash );
}

# getPrecision() takes two argument. First, it takes a referance to the hash
# that was passed back from getParams(). The second input is a string which is
# the name of the parameter that you want the decimal precision of. The
# function then returns the decimal precision.

sub getPrecision {
    if ( $#_ != 1 ) {
        return ($FALSE);
    }
    else {
        my %paramHash = $_[0];
        my $param     = $_[1];

        my $precision = $paramHash{$param};

        print $precision;

        $precision = trim($precision);
        $precision =~ s/^%//;
        $precision =~ s/\w$//;

        if ( $precision =~ /\./ ) {
            my @tmp = split( /\./, $precision );
            $precision = $tmp[1];
        }
        else {
            $precision = 0;
        }

        return $precision;
    }
}
