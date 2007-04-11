#!/usr/bin/perl
#
#	WHPSTAMP.PL:	a Perl subroutine that returns a WHP-defined
#			date stamp used to identify modified bottle
#			a SUM files.  
#
#			(see Programming w/ Perl Modules pp 77-78)
#
#
#	S. Diggs:	1999.02.01:	initial coding and design
#
#------------------------------------------------------------------------

sub whpstamp	{
	use Date::Format;

	#
	#--> Define a template date = YYYYMMDD
	#
	$template = "%Y%m%d";
	$stamp = time2str($template, time).'WHPOSIO';
}
1;
