# expandDir.pm   -   bren   -   07/18/01
#
# This code is property of the UC regents, with a beerware provision for
# the author. 
#
# expandDir.pm is a perl module that expands a directory path in perl in
# the way that most users would expect a shell to expand it. It does '~'
# expansion in the manner that Bash does, with the exception of the "~-/" 
# case, which isnt handled but instead prints an error and returns $FALSE.
#
# The only subroutine is the expandDir() function. This function takes a 
# string as input (the path to expand) and returns a string (the expanded
# path). 
#
# Sample usage:
#    use lib "/home/whpo/bren/perllib/";
#    use ExpandDir;
#
#    my $path = "~danie/foo/"
#    $path = expandDir($path);
#    print($path);
#
# The above sample will print "/home/whpo/danie/foo";

use strict;

my $FALSE = 0;
my $TRUE = 1;

sub expandDir{

    if(!$_[0]){
	    return($FALSE);	
    }

    chomp(my $dirName = $_[0]);

    $dirName =~ s/^(\s*)//;
    $dirName =~ s/(\s*)$//;

    # foo/./bar -> foo/bar
    $dirName =~ s/(\/\.)$//g;
    $dirName =~ s/\/\.\///g;

    # ~/foo -> $HOME/foo
    if(($dirName =~ /^(~\/)/)){ 
	$dirName =~ s/^(~)/$ENV{HOME}\//;
    }
    
    # ~ -> $HOME
    elsif($dirName eq "~"){
	$dirName = $ENV{HOME};
    }

    # . -> (Current dir)
    elsif($dirName eq "."){
	$dirName = $ENV{PWD};
    }

    # ~foo -> (foo's home dir)/
    elsif($dirName =~ /^(~\w+)/){
	my $tmpName = $dirName;
	$tmpName =~ s/^(~)(\w+)(.*)/$2/;
	my @tmpShell = getpwnam($tmpName);
	if($#tmpShell == -1){
	    print(STDERR "User $tmpName not found.\n");
	    return(0);
	}
	$dirName =~ s/^(~\w+)/$tmpShell[7]/;
    }

    # ~+/foo -> (Current dir)/foo
    elsif($dirName =~ /^(~\+\/)/){
	$dirName =~ s/^(~\+\/)/$ENV{PWD}\//;
    }

    # ~-/foo -> (Last dir)/foo
    elsif($dirName =~ /^(~\-\/)/){
    	$dirName =~ s/^(~-\-\/)/$ENV{OLDPWD}/;
    }
    
    # ./foo -> (Current dir)/foo
    elsif($dirName =~ /^(\.\/)/){
	$dirName =~ s/^(\.\/)/$ENV{PWD}\//;
    }

    # deal with ".." appropriately
    if($dirName =~ /\.\./g){
	if($dirName =~ /^(\.\.)/){
	    $dirName = "$ENV{PWD}/".$dirName;
	}
	$dirName =~ s/^\///;
	my @tmpDir = split(/\//, $dirName);
	for(my $i = 0; $i <= $#tmpDir; $i++){
	    if($tmpDir[$i] eq ".."){
		splice(@tmpDir, $i - 1, 2);
		$i -= 2;
	    }
	}

	$dirName = "";
	for(my $i = 0; $i <= $#tmpDir; $i++){
	    $dirName .= "/$tmpDir[$i]";
	}
    }
    
    # return $dirName
    $dirName;
}
