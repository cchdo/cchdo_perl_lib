#!/usr/local/bin/perl
#------------------------------------------------------------------------------------
# GET_DECPLACES.PL
#
# Purpose: Takes in an array of numbers and returns the largest decimal place that
# is found.
#
# Params
#	-@array
#
# Returns
#	-$int_number of decimals
#
# J. Ward	2000.7.27	-original coding
#-------------------------------------------------------------------------------------
use strict;

sub get_decplaces
{
	#params
	my $array_ptr = $_[0];

	#vars
	my $max_dec = 0;
 	my $index_dec = 0;
	my $tmp_nodec = 0;
	my $length;
	
	for (my $i = 0; $i <= $#{$array_ptr}; $i++)
	{
		$index_dec = index($array_ptr->[$i], ".");
		if ($index_dec >= 0)
		{
			$tmp_nodec = length(substr($array_ptr->[$i], ($index_dec+1)));
			if ($tmp_nodec > $max_dec) { $max_dec = $tmp_nodec;}
		}
	}
	return $max_dec;

}
1;
