# randomString.pm   -   bren   -   07/18/01
#
# This code is property of the UC regents, with a beerware provision for
# the author. 
#
# randomString.pm is a perl module that generates a random string of 
# alphabetic characters of arbitrary length. The string generated is only
# as random as the perl rand() function. This function is handy for 
# generating random filenames with no real chance of namespace collisions. 
# The reason it uses only alpha characters is that some programs (matlab) 
# don't like the files that they deal with to have filenames that begin 
# with numbers or non-alphanumerics.
#
# The only subroutine is the getRandomString(). It takes an int as an 
# argument which represents the length of the string to generate. It returns
# a string which is the random string. 
#
# Sample usage:
#    use lib "/home/whpo/bren/perllib/";
#    use RandomString;
#
#    my $RANDOM = getRandomString(40);
#    print($RANDOM);
#
# The above sample will print "uuZmPhuVGsdSmgGVfDYMyofolQOCHspocYyaOZlw",
# or something similar.

use strict;

my $FALSE = 0;
my $TRUE = 1;

sub getRandomString{
    my @result;
    my $result;

    my $counter = 0;

    if(!$_[0]){
	    return($FALSE);
    }
    if($_[0] =~ /\D+/g){
	print(STDERR "randomString.pm failed: $_[0] not a number.\n");
	return($FALSE);
    }

    while($counter < $_[0]){
	my $random = rand();
	$random *= 52;
	if($random < 26){
	    $random += 65;
	}
	else{
	    $random += 71;
	}
	$result[$counter++] = chr($random);
    }

    for(my $i = 0; $i <= $#result; $i++){
	$result .= $result[$i];
    }

    $result;
}

sub getRandomAllChars{
	my @result;
    my $result;

    my $counter = 0;

    if(!$_[0]){
	    return($FALSE);
    }
    if($_[0] =~ /\D+/g){
	print(STDERR "randomString.pm failed: $_[0] not a number.\n");
	return($FALSE);
    }

    while($counter < $_[0]){
	my $random = rand();
	$random *= 94;
	$random += 33;
	
	
	$result[$counter++] = chr($random);
    }

    for(my $i = 0; $i <= $#result; $i++){
	$result .= $result[$i];
    }

    $result;
}
