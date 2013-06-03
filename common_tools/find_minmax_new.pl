#!/usr/bin/perl -W
#--------------------------------------------------------------
#	FIND_MINMAX:	find the minimum and maximum value 
#			in a strictly numeric array
#
#	S. Diggs:	2001.11.02:	initial coding
#	S. Diggs:	2002.03.25:	modification to skip -999.0 as a minimum
#					(or maximum) value
# M. Shen:  2009.11.09: Improve performance by only iterating
#                       ONCE. Three loops was incredibly slow.
#-------------------------------------------------------------

sub find_minmax_new {

	my @input_array = @_;
	
	#
	#--> find the minimum and maximum value
	#
	my $min = $input_array[0];
	my $max = $input_array[0];

	foreach my $value (@input_array)	{
    # skip -999.0 as a real value
		if ($value == -999.0)	{
      next;
		}
		if ($value < $min) { 
			$min = $value;
		}
		if ($value > $max)	{
			$max = $value;
		}
	}

	#print STDOUT "Min and Max are: $min / $max \n";
	#print STDOUT "Min and Max are: $min / $max (RETURN TO CONTINUE)\n";
	my @retval = ($min, $max);
}
1;
