# zipHash.pm - bren - 07/09/01
#
# This code is owned by the UC REGENTS, with a beer-ware provision for
# the author. (If you found this code useful, buy me a beer).
#
# ZipHash.pm is a perl module that contains the subroutines zipToHash()
# and hashToZip(). This perl module is useful for opening and parsing a zip
# file. It can also take a data structure (of a specific type) and construct 
# the respective files and zip them.
#
# zipToHash() takes as an argument the name of the zip file you want
# to extract. It then returns a hash where each key 
# is the name of an extracted file. Each entry in the hash is a referance 
# to an array. The array is the file contents (each line is an element of 
# the array.) If the zip file cant be found, then the code returns 0 after 
# dumping an error to STDERR.
#
# hashToZip() takes the same data structure as returned in zipToHash() and
# drops it to files that it then zips up. It takes a *referance* to the 
# incomming hash as the first argument, the name of the zip file to create
# as the second argument, and returns the success value of the zip 
# opperation.

# usage:
# 	use lib "/home/whpo/bren/perllib";
# 	use ZipHash;
# 	
#	%returnHash = zipToHash($nameOfZipFile);
#       hashToZip(\%hashOfFileData, $nameOfNewZipFile);

use strict;
use POSIX;
use lib "/home/bren/perllib";
use RandomString;
use ExpandDir;

my $FALSE = 0;
my $TRUE = 1;

sub zipToHash{
    chomp(my $zipFile = $_[0]);
    
    if(! ($zipFile = expandDir($zipFile))){
	print(STDERR "Unable to expand $zipFile: $!");
	return(0);
    }

    if(!open(ZIPIN, "unzip -c $zipFile |")){
	print(STDERR "Can't open $zipFile: $!\n");
	return($FALSE);
    }

    my @totalZips = <ZIPIN>;
    close(ZIPIN);
 
    chomp(@totalZips);
    
    my $currentKey;
    my %returnHash;
    my $counter;
    for(my $i = 0; $i <= $#totalZips; $i++){
	
	if($totalZips[$i] =~ /^(Archive)/){}
	elsif($totalZips[$i] =~ /^(\s*.inflating)/){
	    $totalZips[$i] =~ s/^(\s*)//;
	    my @tmp = split(/\s/,$totalZips[$i]);
	    $currentKey = $tmp[1];
	    $counter = 0;
	}
	elsif(($totalZips[$i] !~ /\S/) && (($#totalZips == $i) 
				|| ($totalZips[$i + 1] 
					=~  /^(\s*.inflating)/))){}
	elsif($currentKey){
	    $returnHash{$currentKey}[$counter++] = $totalZips[$i];
	}
    }

    %returnHash;
}

sub hashToZip{
    my $RANDOM = getRandomString(23);
    my %inHash = %{$_[0]};

    my $destFile = $_[1]; 
    if($destFile !~ /\//){
	$destFile = "./".$destFile;
    }
    $destFile = expandDir($destFile);
    
    `mkdir /tmp/$RANDOM`;
    foreach my $key (sort(keys %inHash)){
	if(!open(OUTFILE, "> /tmp/$RANDOM/$key")){
	    print(STDERR "Unable to write /tmp/$RANDOM/$key :$!");
	    `rm -rf /tmp/$RANDOM`;
	    return(0);
	}

	for(my $i = 0; $i <= $#{$inHash{$key}}; $i++){
	    print(OUTFILE "$inHash{$key}[$i]\n");
	}
	close(OUTFILE);
    }

    `cd /tmp/$RANDOM; zip $destFile *; cd ..; rm -rf $RANDOM`;
}
