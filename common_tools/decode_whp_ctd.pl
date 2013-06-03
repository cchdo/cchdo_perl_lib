#!/usr/bin/perl -w
#
#	DECODE_WHP_CTD:	a Perl script that will decode a WHPO (WOCE)
#			formatted CTD file.  Returns a multi-dimensional
#			hash containing all relevant data in order to 
#			write a CTD-Exchange formatted file.
#
#	S. Diggs:	2001.06.04:	initial coding
#------------------->
#
sub decode_whp_ctd {

#my $basedir = "/home/whpo/sdiggs/tools/EXCHANGE_V2/CODE/";
#require $basedir . "read_anyfile.pl";
#require $basedir . "convert_whp_date.pl";
#require $basedir . "decode_wctd_vals.pl";
#require $basedir . "assign_wctd_flags.pl";
#require $basedir . "write_exctd_data.pl";
#require $basedir . "tag.pl";

my $filename = $_[0];

my %header_data = ();
my %ctd_data = ();

my %file_hash = &read_anyfile($filename);

#
#--> Die if the read returns nothing (meaning: problem!)
#
if ( !(keys %file_hash))	{
	die "Problem with file: $filename\n";
}

#
#--> Get the meta-information about the input CTD file
#
$header_data{'ctd_file_copy_date'} = $file_hash{'Date_Last_Modified'};
$header_data{'ctd_file_create_date'} = $file_hash{'Date_Created'};

my @file_contents = @{ $file_hash{'FILE_DATA'} };

#---> parse the header
my @header_line1 = split (/\s+/, $file_contents[0]);

	$header_data{'expocode_tag'}	= $header_line1[0];
	$header_data{'expocode'}	= $header_line1[1];
	$header_data{'whpid_tag'}	= $header_line1[2];
	$header_data{'whpid'}		= $header_line1[3];
	$header_data{'date_tag'}	= $header_line1[4];

	#-> date *MUST be the last 6 characters of that line
	#-> Also, dates must not have whitespace in them (0s only)

	$header_data{'date'}	= substr($file_contents[0], 
				(length($file_contents[0])-6), 6);
	$header_data{'date'} =~ s/\s/0/g;
	
	#
	#--> Convert the date
	#
	$header_data{'date'} = &convert_whp_date($header_data{'date'});
	
	#foreach my $header1 (sort keys %header_data)	{
	#
	#	print STDOUT "Key =\t$header1\n",
	#			"\tValue =\t$header_data{$header1}\n";
	#}
	#print STDOUT "Hit RETURN to continue: \n--------\n";
	#my $dummy = <STDIN>;

my @header_line2 = split (/\s+/, $file_contents[1]);

	$header_data{'stnnbr_tag'}	= $header_line2[0];
	$header_data{'stnnbr'}		= $header_line2[1];
	$header_data{'castno_tag'}	= $header_line2[2];
	$header_data{'castno'}		= $header_line2[3];
	$header_data{'norec_tag'}	= $header_line2[4] . 
						$header_line2[5];
	$header_data{'norec'}		= $header_line2[6];

	foreach my $header2 (sort keys %header_data)	{
	
		print STDOUT "Key =\t$header2\n",
				"\tValue =\t$header_data{$header2}\n";
	}
	#print STDOUT "Hit RETURN to continue: ";
	#my $dummy = <STDIN>;
	
my @header_line3 = split (/\s+/, $file_contents[2]);

	$header_data{'instr_tag'}	= $header_line3[0] . " " .
						$header_line3[1];
	$header_data{'instr'}		= $header_line3[2];
	$header_data{'sampling_tag'}	= $header_line3[3] . " " . 
						$header_line3[4];
	$header_data{'sampling'}	= $header_line3[5] .
						$header_line3[6]; 

	#foreach my $header3 (sort keys %header_data)	{
	#
	#	print STDOUT "Key =\t$header2\n",
	#			"\tValue =\t$header_data{$header2}\n";
	#}
	#print STDOUT "Hit RETURN to continue: ";
	#my $dummy = <STDIN>;
	
my @header_line4 = split (/\s+/, $file_contents[3]);

	# first data header line, get rid of the blank element 
	shift(@header_line4);
	
	my @param_heading = @header_line4;
	foreach my $p_head	(@header_line4)	{
	
		$header_data{$p_head} = '';
	}
	
	#foreach my $header_all (sort keys %header_data)	{
	#
	#	print STDOUT "Key =\t$header_all\n",
	#			"\tValue =\t$header_data{$header_all}\n";
	#}
	
my @header_line5 = split (/\s+/, $file_contents[4]);

	# first data header line, get rid of the blank element 
	shift(@header_line5);
	
	my @units_heading = @header_line5;
	print "LAST ELEMENT OF UNITS is $units_heading[$#units_heading] \n";
	if ($units_heading[$#units_heading] =~ /\*/) {
		my $trash_var = pop(@units_heading);
	}
	foreach my $u_head	(@units_heading)	{
	
		$header_data{$u_head} = '';
	}
	
	foreach my $header_all (sort keys %header_data)	{
	
		print STDOUT "Key =\t$header_all\n",
				"\tValue =\t$header_data{$header_all}\n";
	}	
	
	
	
	
#----------------	
print STDOUT "Reading in data values...\n";
%ctd_data = &decode_wctd_vals(	\@file_contents, 
				\@param_heading,
				\@units_heading);

	foreach my $junk ( sort keys %ctd_data)	{
	
		if (($junk =~ /flag_order/i) or
			($junk =~ /units/i))	{
		
			print STDOUT "Single Key ",
	 		"is:\t$junk ",
		 	" and value is: ",
	 		$ctd_data{$junk}, "\n";
		} else			{
	 		print STDOUT "Key at ",
	 		( $#{ $ctd_data{'CTDPRS'} } ), 
	 		" is:\t$junk ",
		 	" and value is: ",
	 		$ctd_data{$junk}[( $#{ $ctd_data{'CTDPRS'} })], 
	 		"\n";
	 	}		
	}


#&write_exctd_data(\%header_data, \%ctd_data, 'W');
	
@return_refs = (\%header_data, \%ctd_data);

}
1;
