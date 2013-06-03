#!/usr/bin/perl -W
#--------------------------------------------------------------
#	FIND_MINMAX:	find the minimum and maximum value 
#			in a strictly numeric array
#
#	S. Diggs:	2001.11.02:	initial coding
#	S. Diggs:	2002.03.25:	modification to skip
#					-999.0 as a minimum
#					(or maximum) value
#-------------------------------------------------------------

sub find_minmax_new {

	my @input_array = @_;
	my $value=0;
	my @edited_input_array = ();
	
	#
	#--> First, remove all "no data" values from input_array
	#
	for ($i=0 ; $i <= $#input_array ; $i++)	{
		
		if ($input_array[$i] != -999.0)	{
			@edited_input_array = (	@edited_input_array,
						$input_array[$i]);
		}
	}
	#print STDOUT "Length of input_array is ", ($#edited_input_array+1),"\n";
	#print STDOUT "Array = \n",
			join(", ", @edited_input_array), "\n";
	#
	#--> find the minimum value
	#
	my $min = $edited_input_array[0];
	#print STDOUT "\t--> Incumbent min = $min\n";
	#my $min = 0.0;
	foreach $value (@edited_input_array)	{
		if (($value < $min) and ($value =~ /\d/)){ 
		
			$min = $value;
			#print STDOUT "\t\t --> New min is $min\n";
		}
	}
	#
	#--> now, find the max value
	#
	my $max = $edited_input_array[0];
	foreach my $value (@edited_input_array)	{
		if ($value > $max)	{
			$max = $value;
		}
	}
	#print STDOUT "Min and Max are: $min / $max \n";
	#print STDOUT "Min and Max are: $min / $max (RETURN TO CONTINUE)\n";
	#my $dummy=<STDIN>;
	my @retval = ($min, $max);
}
1;
