#!/usr/local/bin/perl
#----------------------------------------------------------
# CONV_DATE.PL
#
# Chanes the date from WOES format of MMDDYY to  the format
# for Improved Exchange Format of  YYYYMMDD
#
# Params:
#	- $_[0] : date to convert
#
# Returns:
#	- $result_date : date in YYYYMMDD format
#
# J. Ward	2000.7.17	original coding
#-----------------------------------------------------------

sub conv_date
{
	# one param
	my $input_date = $_[0];


	my (@date_MDY);
	my $result_date;

	# if the year is not correct length then return error
	if (length($input_date) != 6)
	{
		return;
	}

	#
	# break up the date into parts
	#
	@date_MDY =  unpack("A2 A2 A2", $input_date);
	
	#expect that anything below 20 for the year is 
	#in the 2000's and anything above 20 is int the 
	#1900's
	if ($date_MDY[2] > 20)
	{	
		$result_date = sprintf("19%2s%2s%2s", 
			$date_MDY[2], $date_MDY[0], $date_MDY[1]);
	}
	else
	{
		$result_date = sprintf("20%2s%2s%2s", 
			$date_MDY[2], $date_MDY[0], $date_MDY[1]);
	}
	
	return $result_date;	
}#end sub
1;
