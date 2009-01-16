# ParseExchange.pm - bren 08/02/01
#
# This code is owned by the UC REGENTS, with a beer-ware provision for
# the author. (If you found this code useful, buy me a beer).
#
# ParseExchange.pm is a perl module that parses exchange files (both ctd
# or bottle, zipped or unzipped.
# 
# parseExchangeZip() is the function that parses ziped exchange files. It
# takes as an argument the name of the zip file to open and parse. It returns
# a referance to a hash. Each key of the hash is the name of an exchange file.
# Each $key leads to an array. Each element of the array represents one line of
# the file. Each element of the array is an array itself, whose elements are 
# the contents of the line as parsed by ','. 
#
# parseExchange() is the same as parseExchangeZip() with the exception that it
# works on individual files. parseExchange() takes as an argument the name of
# the file, and returns the same type of hash referance.

use strict;
use lib "/home/bren/perllib/";
use ExpandDir;
use ZipHash;

my $FALSE = 0;
my $TRUE = 1;

############################################################################
# private functions 
#
# These functions are executable code stored in a scalar. This forces them 
# to be scoped lexically, allowing for only the local code to execute them.
# They are not callable from the outside world.
############################################################################

# $parseDirSUB() dumps a file to an array. It takes as an argument the name
# of the file, and returns a referance to the array.
my $parseDirSUB = sub{
	my $path = expandDir($_[0]);
	if(!open(BOTTLE, "$path")){
		print(STDERR "Unable to open $path: $!");
		return($FALSE);
	}
	chomp(my @bottleArray = <BOTTLE>);
	close(BOTTLE);
	\@bottleArray;
};

# $parseHashSUB() takes the generic hash returned by zipToHash() (located in
# ZipHash.pm) and parses each line into an array (parsed by ','). It takes as
# an argument a referance to the hash and returns a referance to the hash.
my $parseHashSUB = sub{
	my %hashToParse = %{$_[0]};
	foreach my $key (sort(keys %hashToParse)){
		for(my $i = 0; $i <= $#{$hashToParse{$key}}; $i++){
			my @tmpi;
			if(($hashToParse{$key}[$i] !~ /^\#/) && ($hashToParse{$key}[$i] !~ /^(BOTTLE)/)){
				@tmpi = split(/,/, $hashToParse{$key}[$i]);
				$hashToParse{$key}[$i] = \@tmpi;
			}
			else{
				@tmpi = $hashToParse{$key}[$i];
				$hashToParse{$key}[$i] = \@tmpi;
			}
		}
	}

	\%hashToParse;
};


############################################################################
# public functions
#
# These are callable by the outside world. They are described in the header
# comments for this file.
############################################################################
sub parseExchangeZip{
	if(!$_[0]){
		return($FALSE);
	}
	my %ctdInHash = %{zipToHash(expandDir($_[0]))};
	%ctdInHash = %{(\%ctdInHash)->$parseHashSUB()};
	
	\%ctdInHash;
}

sub parseExchange{
	if(!$_[0]){
		return($FALSE);
	}
	my %bottleInHash;
	my @tmpPathArray = split(/\//, $_[0]);
	$bottleInHash{$tmpPathArray[$#tmpPathArray]} = $_[0]->$parseDirSUB();
	%bottleInHash =  %{(\%bottleInHash)->$parseHashSUB()};

	\%bottleInHash;
}
