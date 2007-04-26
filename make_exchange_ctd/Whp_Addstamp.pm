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
#----------------------------------------------------------------------

sub Whp_Addstamp	{

	#use lib '.';
	#use Whp_Stamp;

	my($return_value) = '';
	my($line) = $_[0];

	print "SUB: $line\n\n";

	#
	#--> all known logins that would be using this code
	#
	%login_id  = 	(
	
		'cyril'		=>	'GCA',	'danie'		=>	'DMB',
		'dave'		=>	'DAM',	'heidi'		=>	'HLB',
		'jkappa'	=>	'JXK',	'jswift'	=>	'JHS',
		'sarilee'	=>	'SA',	'sdiggs'	=>	'SCD',
		'stacey'	=>	'SRA',	'karla'		=>	'KJU',
		'jrweir'	=>	'JRW',	'root'		=>	'SCD',	
			);

	$login_name = getlogin();
	print "You are: $login_name\n";

	if($login_id{$login_name})	{
		$initials = $login_id{$login_name};
	} else				{
		#print "I don't know you, please enter your initials: ";
		#chomp($initials = uc(<STDIN>));
		$initials = 'SCD';
	}

	print STDOUT "Your initials are: $initials\n";
	$new_stamp = &whpstamp().$initials;
	
	$num_match = 0;
	$num_match = $line =~ s/([19|20]\d+WHPO\w+)/$new_stamp/
			if ($line);
	
	#.. if we found a match...
	if ($1) {print $1."\n";}
	else	{
		$line .= $new_stamp;
	}
	$return_value = $line;
}
1;


	
