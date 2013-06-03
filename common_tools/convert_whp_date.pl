#!/usr/bin/perl -w
#
#	CONVERT_WHP_DATE:	a Perl subroutine to convert the standard
#				WOCE-style date (MMDDYY) to a more reasonable
#				Y2K+ compatible YYYYMMDD.
#
#	NOTE:	this code only works for the years 1920 to 2019!
#	
#	S. Diggs:	2001.09.19:	initial coding
#------------------->
#
sub convert_whp_date {


	my $incoming_date = shift(@_);
	my $new_year = '';
	
	print "---> INCOMING DATE = |$incoming_date| \n";
	
	#
	#--> convert the date to space separated YY MM DD
	#
	my $old_year = substr($incoming_date ,4,2);
	print "---> OLD YEAR = |$old_year| \n";
	if 	(( $old_year  <= 99 ) and
		 ( $old_year  >= 19 )	)				{	
		 
		$new_year = 1900 + $old_year;
		 	
	}	else							{
	
		$new_year = 2000 + $old_year;
	}
	my $new_date = 	
		$new_year .
		substr($incoming_date, 0,2).
		substr($incoming_date, 2,2);
		
	print STDOUT "---> NEW DATE = $new_date \n";
	my $retval = $new_date;
	
};1
