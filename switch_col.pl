#!/usr/bin/perl

#	reformat new ODF WOCE-CTD files so that the NUMBER_OBS
# 	is on the end to comply with the official format
#
#	S. Diggs: 2007.08.13 (initial coding)
#	S. Diggs: 2007.08.16 (fixed extra blank space at EOL)

my %data_hash = ();

my @cmd_line_args = @ARGV;
#my $output_file = $cmd_line_args[0] . '_' . "REFORMAT" . "_$$";
my $output_file = $cmd_line_args[0] . '_' . "REFORMAT";
print STDERR "Output file is $output_file\n +++ \n";

open (OUTPUT, '>' . $output_file) or
	die "Cannot open output file in this directory";

chomp (my @buffer = <>);

#---
@dummy = split(/\s+/,$buffer[3]);
$format =  "%8s";
$format x= $#dummy;
$format .= "%s\n";  #last column(s) has(have) flags
print STDOUT "Format is: $format\n";

# --- OUTPUT FILE ---

for (my $i=0 ; $i <= 2; $i++)	{

	print STDOUT "$buffer[$i]\n";
	print OUTPUT "$buffer[$i]\n";
}
my @tmp = ();
for (my $j=3 ; $j <= $#buffer ; $j++ )	{

	# if $j=5, it's the asterisk line for param/flag 
	if ($j != 5)	{
		@tmp = split(/\s+/,$buffer[$j]);
	}
	else		{
		#print STDERR "--> Asterisk row @ line $j \n";
		my $asterisk_format = " a8";
		$asterisk_format x= ($#tmp+1);
		#print STDERR "--> Asterisk format = $asterisk_format \n--\n"; 
		my @asterisk_line = unpack($asterisk_format, $buffer[$j]);
		$string_of_8spaces = ('        ');
			# add a dummy element to the front index[0]
		unshift (@asterisk_line, $string_of_8spaces ); 
		print STDERR "Asterisk line = ", 
				join('|', @asterisk_line), 
				" $#asterisk_line \n";
		@tmp = @asterisk_line;
	}

	printf OUTPUT ($format, 
	 ($tmp[1], 
	  $tmp[2],
	  $tmp[3],
  	  $tmp[4],		
  	  $tmp[6],		
  	  $tmp[7],		
  	  $tmp[5],		
  	  $tmp[8])		
		);	
}

close (OUTPUT);
