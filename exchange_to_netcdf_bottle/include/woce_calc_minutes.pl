#!/usr/bin/perl -w
#------------------------------------------------------------------------
# WOCE_CALC_MINUTES:	a Perl module to convert a date in the following
#			format:
#				YYYYMMDDHHMM
#			to the number of minutes since 1980-01-01 00:00
#
#	S. Diggs:	20020325:	initial coding
#			
#			20060502:	NEW SYSTEM! (newcchdo)	
#					update all of this code to return
#					minutes based on Time::Parse instead
#					of the obsolete Date::Parse
#
#------------------------------------------------------------------------

sub woce_calc_minutes{

	#use Date::Parse;
	#use Date::Manip;
	#use Date::Format;
	use Time::ParseDate;

	my ($incoming_time, $iyear, $imonth, $iday, $ihour, $imin);
	my ($new_itime, $woce_epoch, $woce_epoch_seconds, $incoming_minutes);
	my ($calc_seconds, $retval);
	
	$incoming_time = shift @_;
	
	#
        #--> parse whitespace out of incoming DATE and TIME
        #
	#$incoming_date =~ s/\s+//g;
	$incoming_time =~ s/\s+//g;

	#turn the date into something reasonable

	$iyear  = substr($incoming_time, 0 , 4);
	$imonth = substr($incoming_time, 4 , 2);
	$iday   = substr($incoming_time, 6 , 2);
	$ihour  = substr($incoming_time, 8, 2);
	$imin   = substr($incoming_time, 10, 2);

	$new_itime = $iyear.'-'.$imonth.'-'.$iday." ".$ihour.':'.$imin;
	print STDOUT "Incoming date ==> $new_itime\n";

	$woce_epoch		= "1980-01-01 00:00";

	##
	##--> str2time returns seconds and must be divided by 60
	##
	#$woce_epoch_minutes	= (str2time($woce_epoch) / 60.0);
	#$incoming_minutes	= (str2time($new_itime) / 60.0);

	#print STDOUT "Woce epoch is: $woce_epoch_minutes\n";
	#print STDOUT "Incoming time: $incoming_minutes\n";


	$calc_seconds		= parsedate($new_itime,  ZONE => $timezone);
	$woce_epoch_seconds	= parsedate($woce_epoch, ZONE => $timezone);
	
	print STDOUT " -> # of sec between $woce_epoch &",
			" $new_itime = $calc_seconds\n";


	$retval = (($calc_seconds - $woce_epoch_seconds)/60);
	#$retval = 123456789;
}
1;
