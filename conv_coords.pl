#!/usr/local/bin/perl
#-----------------------------------------------------------------------
# CONV_COORDS.PL
#
# Converts the long and lat fields in WHPO sum files into
# correct format for Improved Exchange Format.  The format
# returned is SDD.ddd -> S = sign (blank for positive)
#
# Parameters
#	- degree part
#	- minute part
#	- direction
#
# Returns
#	- $result : the coords in SDD.ddd format
#
# J. Ward - original coding 7-17-2000
#-----------------------------------------------------------------------

sub conv_coords
{
	#constant
	use constant DIV => 60.0;
	

	
	# params
	my $degree_part = $_[0];
	my $min_part = $_[1];
	my $direction = $_[2];

	
	
	# variables
	my $result;
	my $dec_result;
	
	
	
	if ($M_part > DIV)
	{
		return;  #return error
	}
	else
	{
		$dec_result = ($min_part/DIV);
		if ($direction =~ /[w]|[e]/i)
		{
			$result = ($degree_part+$dec_result);
			if ($direction =~ /[w]/i)
			{	$result *= -1.0; } 
			$result = sprintf( "%9.4f", $result);
		}
		else 
		{
			$result = ($degree_part+$dec_result);
			if ($direction =~ /[s]/i)
			{	$result *= -1.0; }
			$result = sprintf( "%8.4f", $result);
		
		}	

	}
	return $result;
}
1;	
