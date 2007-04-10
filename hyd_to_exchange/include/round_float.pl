#!/usr/bin/perl
use strict;

#------------------------------------------------------------------------
# Interface to the function round..can specify precision and the
# number to be rounded.
#
# params:
#	0 - $num --> number to be rounded
#	1 - $precision --> precision to round to
#
# returns:
#	-number rounded to correct precision 
#
# S. Diggs & J. J. Ward: 2000.08.08
#-----------------------------------------------------------------------



sub round_float
{
	my $num = shift(@_);
	my $precision = shift(@_);

	#print STDOUT "Enter a number to be rounded: ";
	#chomp($num=<STDIN>);

	#print STDOUT "Enter a precision: ";
	#chomp($precision=<STDIN>);

	$precision = 10**($precision);


	return (round( $num * $precision ) / $precision);
}






#--------------------------------------------------------------
# round (from the book "Mastering Algorithms w/ Perl" : pp474
# S. Diggs & J. J. Ward: 2000.08.08
#-------------------------------------------------------------
sub round       {

        ( $_[0] > 0 ) ?  int $_[0] + 0.5 : int $_[0] - 0.5;
}
1;

