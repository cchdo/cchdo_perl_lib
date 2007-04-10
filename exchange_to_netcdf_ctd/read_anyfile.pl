#!/usr/bin/perl -w
#-----------------------------------------------------------------------
#
#	READ_ANYFILE:	a quick-hack Perl script to read in any file.
#			returns an array with each 'chomped' line being
#			one array element.
#
#	S. Diggs:	2001.07.17	initial coding
#	S. Diggs:	2002.04.16	changed path in 'lib' for 
#					supporting files
#
#-----------------------------------------------------------------------

sub read_anyfile	{
use lib "/admin_home/sdiggs/tools/EXCHANGE_V2/CODE/EXCTD_NETCDF/";
use Get_File_Info;



	my @file_stuff = ();
	my @return_file_stuff = ();
	my ($filename) = shift (@_);

	print STDOUT "Opening $filename\n";


	if ( ! (-e $filename))	{
		die "$filename does not exist!\n";
		#return ( ("$filename does not exist") );
	}
	
	#
	#--> Get file information (modification date, size, etc.)
	#
	my %file_hash = Get_File_Info($filename);
	
	#
	#--> Get actual file data, one line per array element
	#
	open(INPUT_FILE, $filename) or
		die "Cannot open $filename for reading";

	chomp(@file_stuff = <INPUT_FILE>);
	close(INPUT_FILE);
	@{ $file_hash{'FILE_DATA'}} = @file_stuff;

	%return_file_stuff = %file_hash;
}
1;
