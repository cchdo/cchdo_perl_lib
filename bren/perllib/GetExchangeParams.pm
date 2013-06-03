# GetExchangeParams.pm	-  bren  -  08/13/01
#
# (updated by S. Diggs to work under RHE-Linux: 2005.05.11)
#
# This code is property of the UC regents, with a beerware provision for
# the author. 
#
# GetExchangeParams.pm is a perl modules that contains functions to deal with 
# the current parameters for the exchange format located in:
# /home/whpo/jjward/src/exchange_format/whp_to_exchange_code/exchangeParams.txt
#
# There are two public functions. getParams() takes no argumengts, but returns
# a hash. The keys of the hash are the current accepted parameters for exchange
# format. The values stored at those keys are the format precisions.
#
# getPrecision() takes two argument. First, it takes a referance to the hash 
# that was passed back from getParams(). The second input is a string which is 
# the name of the parameter that you want the decimal precision of. The 
# function then returns the decimal precision.

use strict;

my $FALSE = 0;
my $TRUE = 1;

###############################################################################
# private function - not callable by the outside world. Just strips off leading
# and trailing whitespace.
###############################################################################
my $cleanStringSUB = sub{
	$_ = $_[0];
	s/^(\s*)//;
	s/(\s*)$//;
	$_;
};

###############################################################################
# public functions 
###############################################################################
sub getParams{
	my %paramHash;

	open(PARAMFILE, "/home/jjward/src/exchange_format/whp_to_exchange_code/exchangeParams.txt") 
		or die("Can't find exchangeParams.txt -> $!");

	chomp(my @params = <PARAMFILE>);
	close(PARAMFILE);

	foreach my $param (@params){

# ignore comments or empty lines.
		if(($param !~ /\S/) || ($param =~ /^\#/)){}
		else{
			my @tmp = split(/,/, $param);
			$tmp[0] = $tmp[0]->$cleanStringSUB();
			$tmp[1] = $tmp[1]->$cleanStringSUB();

			$paramHash{$tmp[0]} = $tmp[1];
		}
	}

# return ref to %paramHash
	\%paramHash;
}

sub getPrecision{
	if($#_ != 1){
		return($FALSE);
		{

			my %paramHash = %{$_[0]};
			my $param = $_[1];

			my $precision = $paramHash{$param};

			$precision = $precision->$cleanStringSUB();
			$precision =~ s/^%//;
			$precision =~ s/\w$//;

			if($precision =~ /\./){
				my @tmp = split(/\./, $precision);
				$precision = $tmp[1];
			}
			else{
				$precision = 0;
			}

			$precision;
		}
	}
}
