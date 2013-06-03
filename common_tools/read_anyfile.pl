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
# M. Shen: 2010-04-02   Use regexp EOL cleaning rather than rely on chomp.
#
#-----------------------------------------------------------------------

sub read_anyfile	{
use lib "/usr/local/cchdo_perl_lib/common_tools/";
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

  # Instead of chomping a slurp, which doesn't account for CRLF, do a regexp
  # cleaning of the input lines.
  # chomp(@file_stuff = <INPUT_FILE>);
  while (my $line = <INPUT_FILE>) {
    $line =~ s/\s+$//;
    push(@file_stuff, $line);
  }
	close(INPUT_FILE);

	@{ $file_hash{'FILE_DATA'}} = @file_stuff;

	%return_file_stuff = %file_hash;
}
1;
