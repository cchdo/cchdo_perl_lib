#!/usr/bin/perl
#--------------------------------------------------------------
#	FIND_MINMAX:	find the minimum and maximum value 
#			in a strictly numeric array
#
#	S. Diggs:	2001.11.02:	initial coding
#	S. Diggs:	2002.03.25:	modification to skip
#					-999.0 as a minimum
#					(or maximum) value
#-------------------------------------------------------------

sub find_minmax {

	my @input_array = @_;
	my $value=0;

	#
	#--> find the minimum value
	#
	my $min = $input_array[0];
	#my $min = 0.0;
	foreach $value (@input_array)	{
		if (($value < $min) && ($value != -999.0))	{
			$min = $value;
		}
	}
	
	#
	#--> now, find the max value
	#
	$value=0;
	#my $max = $input_array[0];
	my $max = 0.0;
	foreach my $value (@input_array)	{
		if (($value > $max) && ($value != -999.0))	{
			$max = $value;
		}
	}

	my @retval = ($min, $max);
}
1;
