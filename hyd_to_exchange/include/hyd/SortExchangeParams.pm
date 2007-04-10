# SortExchangeParams.pm  -  bren  -  08/13/01
#
#	modified by S. Diggs (2004.03.01) to include:
#	CTDRAW
#	THETA
#
# This code is property of the UC regents, with a beerware provision for
# the author. 
#
# SortExchangeParams.pm is a perl module with a function that takes an array
# as an argument and returns an array which is a sorted version of the input.
# This is supposed to be like the built in sort() function in perl, but this
# code sorts the array by an oceanographic standard. This function was designed
# to be called on an array of exchange file parameters and return them in the
# order that an oceanographer would expect.

use strict;

my $FALSE = 0;
my $TRUE = 1;

sub sortExchangeParams{
	if(! @_){
		return($FALSE);
	}
	my @arrayToOrder = @_;
	my @orderedArray;
	my @templateArray = qw(
	EXPOCODE 
	SECT_ID 
	STNNBR 
	CASTNO 
	SAMPNO 
	BTLNBR 
	DATE 
	TIME 
	LATITUDE 
	LONGITUDE 
	DEPTH 
	CTDRAW
	CTDPRS 
	CTDTMP 
	CTDSAL 
	SALNTY 
	CTDOXY 
	THETA
	OXYGEN 
	SILCAT 
	NITRAT 
	NITRIT 
	NO2+NO3 
	PHSPHT 
	CFC-11 
	CFC-12 
	CFC113 
	CCL4 
	TRITUM 
	HELIUM 
	DELHE3 
	DELC14 
	DELC13
	NEON
	O18O16 
	TCARBN 
	PCO2 
	ALKALI 
	PH);
	
	my $count = 0;
	for(my $i = 0; $i <= $#templateArray; $i++){
		for(my $j = 0; $j <= $#arrayToOrder; $j++){
			if($templateArray[$i] eq $arrayToOrder[$j]){
				$orderedArray[$count++] = $templateArray[$i];
				splice(@arrayToOrder, $j, 1);
				last;
			}
		}
	}
	
	# any elements not in the above list are entered here, at the end, in
	# no particular order.
	foreach my $element (@arrayToOrder){
		$orderedArray[$count++] = $element;
	}

	@orderedArray;
}
