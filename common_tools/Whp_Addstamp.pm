#!/usr/bin/perl -w
#----------------------------------------------------------------------
#
#	WHP_ADDSTAMP:	a Perl subroutine that will change/add the 
#			WHP date stamp to the header of a changed file.
#
#	S. Diggs:	1999.03.25	initial coding
#	S. Diggs:	2000.09.28	added Stacey Anfuso
#	S. Diggs:	2001.09.20	corrected Dave Muus's initials
#	S. Diggs:	2001.09.20	added Karla Uribe
#	S. Diggs:	2001.09.24	took out leading space in stamp
#	S. Diggs:	2001.09.24	converted to perl module
#	J. Fields:	2007.06.11	Checking for input line.  
#					Fixing Dave's error on mac server.
#	S. Diggs:	2009.06.01	Added Carolina Berys (CBG)
#	myshen:		2010-12-07	Convert to use login_initials.conf
#----------------------------------------------------------------------

use strict;
use File::Spec;
use Cwd 'realpath';

use Whp_Stamp;

# Look for the login_initials.conf in the same directory as this source file.
my ($trash, $dir);
($trash, $dir, $trash) = File::Spec->splitpath(
			     realpath(File::Spec->rel2abs(__FILE__)));
my $config_file = File::Spec->catpath('', $dir, "login_initials.conf");
my %LOGIN_TO_INITIALS = ();
open CONFIG, "<$config_file" or die $!;
while (<CONFIG>) {
	my $line = $_;
	next if $line =~ /^#/;
	my ($login, $initials) = split(/\s/, $line);
	$LOGIN_TO_INITIALS{$login} = $initials;
}

sub prompt_for_initials {
	#print "I don't know you, please enter your initials: ";
	#chomp($initials = uc(<STDIN>));
	return 'SCD';
}

sub get_initials_for_login {
	my $login_name = getlogin();
	print STDOUT "You are: $login_name\n";

	my $initials = "";
	if (exists($LOGIN_TO_INITIALS{$login_name})) {
		$initials = $LOGIN_TO_INITIALS{$login_name};
	} else {
		$initials = prompt_for_initials();
	}
	print STDOUT "Your initials are: $initials\n";
	$initials;
}

sub Whp_Addstamp {
	# Create WHP stamp for logged in user
	# Args:
	#       line (optional) - if provided the subroutine will return the
	#                         same with the new stamp substituted in for
	#                         the old.
	# Return:
	#       line with new stamp substitued in or new stamp
	my $new_stamp = &whpstamp().get_initials_for_login();
	
	my $line = $_[0];
	if ($line and $line =~ s/([19|20]\d+WHPO\w+)/$new_stamp/) {
		return $line;
	} else {
		return $new_stamp;
	}
}
1;
