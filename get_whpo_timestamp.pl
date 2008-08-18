#!/usr/local/bin/perl
#-------------------------------------------------------------------------------------------
# get_timestamp()
# get_timestamp($initials)
#
# PURPOSE:
# Function takes in the users initials or will ask for them if no imput was given 
# and creates a WHPO format timestamp that is placed at the top of files for 
# tracking.
#
# PARAMS: 
#	- 0: (OPTIONAL) $intitials - the initials of the person updating the file
#
# RETURNS:
#	- the WHPO timestamp as a string
# 
#-------------------------------------------------------------------------------------------
use Time::localtime;

sub get_timestamp
{
	my $initials;
	my $inst = 'SIO';
	my $div = 'WHP';
	my $time = localtime;
	
	#
	# checks to see if the intitials are passed in..if they
	# are not then ask for them
	#
	if (defined(@_[0]))
	{
		$initials = shift(@_);
	}
	else
	{
		 print STDOUT "Please enter your initials: ";
		 chomp($initials = <STDIN>);
	}

	my ($day, $month, $year) = ($time->mday, $time->mon, $time->year);
	
	$day = sprintf("%02d", $day);
	$month  = sprintf("%02d", $month+1);
	$year = sprintf("%04d", $year+1900);
	

	return $year.$month.$day.$div.$inst.$initials;

}
1;
