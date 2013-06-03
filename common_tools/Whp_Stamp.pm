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
#	S. Diggs:	2009.08.25:	updated code to insert string
#					'CCHDO' instead 'WHPO'
#
#------------------------------------------------------------------------

sub whpstamp	{
	use Date::Format;

	#
	#--> Define a template date = YYYYMMDD
	#
	$template = "%Y%m%d";
	#$stamp = time2str($template, time).'WHPOSIO';
	$stamp = time2str($template, time).'CCHDOSIO';
}
1;
