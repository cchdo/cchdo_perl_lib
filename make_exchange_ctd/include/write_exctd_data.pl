#!/usr/bin/perl -w
#
#	WRITE_EXCTD_DATA:	a Perl subroutine that test-writes a CSV
#				formatted dump of the hash structures
#				for testing purposes.
#	
#	S. Diggs:	2001.09.19:	initial coding
#	S. Diggs:	2001.10.22:	updated code to handle missing
#					data flags for any parameter
#	S. Diggs:	2001.10.23:	THERE IS A BUG IN THIS CODE!
#					(if there are missing values
#					in the column of values, the
#					columns headers are printed anyway,
#					*BUT* the values per line may be omitted.
#					This bug will be fixed in a future version
#					of this software).
#
#	S. Diggs:	2001.11.06:	code now handles non-numeric STNNBRs
#
#------------------->
#
sub write_exctd_data {

use lib '.';
use Whp_Addstamp;
	
	my $header_ref	= shift(@_);
	my $ctd_ref	= shift(@_);
	
	#
	#--> Flag type may be either 'W' for woce or 'I' for IGOSS
	#
	my $flag_type	= shift(@_);
	
	#
	#--> Get code version
	#
	my $software_version = shift(@_);
	
	my $date_stamp	= Whp_Addstamp(); 
	
	#
	#-->
	#
	my @data_column = qw 	(	CTDPRS
					CTDTMP
					CTDSAL
					CTDOXY
				);
	my %ctd_format =	(	'CTDPRS'	=>	"%9.1f",
					'CTDTMP'	=>	"%9.4f",
					'CTDSAL'	=>	"%9.4f",
					'CTDOXY'	=>	"%9.1f",
					'FLAG'		=>	"%1d",
				);
	#
	#--> de-reference the refs (hashes)
	#
	my %header_hash = %$header_ref;
	my %ctd_hash	= %$ctd_ref;
	
	#
	#--> Get the number of data records
	#
	my $num_rec	= $#{ $ctd_hash{'CTDPRS'} };
	
	#foreach my $key (sort keys %header_hash)	{
	#
	#	print STDOUT "\t--> WRITE HASH: $key\t=\t$header_hash{$key}\n";
	#}
	#
	#--> Construct output file name
	#
	
	#--> First, let's get rid of any alpha characters in the STNNBR
	#--> or CASTNO (SCD: 20011023.1533)
	
	#$header_hash{'STNNBR'} =~ s/[a-z]//gi;
	#$header_hash{'CASTNO'} =~ s/[a-z]//gi;
	#print STDOUT "Station number is now: $header_hash{'STNNBR'}\n";
	#print STDOUT "Cast    number is now: $header_hash{'CASTNO'}\n";
	
	
	#if ($header_hash{'STNNBR'} =~ /[a-z]/i)	{
	
		my $output_filename =	lc($header_hash{'SECT'}).'_'.
				sprintf("%s", $header_hash{'STNNBR'}).'_'.
				sprintf("%05d", $header_hash{'CASTNO'}).'_'.
				'ct1.csv';
	#} else					{
	#
	#	my $output_filename =	lc($header_hash{'SECT'}).'_'.
	#			sprintf("%05d", $header_hash{'STNNBR'}).'_'.
	#			sprintf("%05d", $header_hash{'CASTNO'}).'_'.
	#			'ct1.csv';
	#}
	
	print STDOUT	"writing $num_rec records to $output_filename\n";
	
	open(OUTPUT, '>' . $output_filename) or
		die "Cannot open $output_file for writing";
	
	
	#
	#--> Write out the header
	#
	print OUTPUT	"CTD,$date_stamp\n",
			"#Software Version: $software_version\n",
			"#SUMFILE_NAME:     $header_hash{'sum_file_name'}\n",
			"#SUMFILE_MOD_DATE: $header_hash{'sum_file_date'}\n",
			"#CTDFILE_NAME:     $header_hash{'ctd_file_name'}\n",
			"#CTDFILE_MOD_DATE: $header_hash{'ctd_file_create_date'}\n",
			"#DEPTH_TYPE      : $header_hash{'depth_type'}\n",
			"#EVENT_CODE      : $header_hash{'CODE'}\n",
			;
	
	print OUTPUT
			"NUMBER_HEADERS = 10\n",
			"EXPOCODE = "	,$header_hash{'EXPOCODE'},"\n",
			"SECT = "	,$header_hash{'SECT'},"\n";
			
#STNNBR could be non-numeric
			if ($header_hash{'STNNBR'} =~ /[a-z]/i)	{
			
				print OUTPUT	"STNNBR = "	,
				sprintf("%s", $header_hash{'STNNBR'}),
				"\n";	
			} else					{
				print OUTPUT	"STNNBR = "	,
				sprintf("%5d", $header_hash{'STNNBR'}),
				"\n";
			}
				
	print OUTPUT	"CASTNO = "	,
				sprintf("%5d", $header_hash{'CASTNO'}),
				"\n",
			"DATE = "	,$header_hash{'DATE'},"\n",
			"TIME = "	,
				sprintf(" %04d", $header_hash{'TIME'}),
				"\n",
			"LATITUDE = "	,
				sprintf("%9.4f", $header_hash{'LATITUDE'}),
				"\n",
			"LONGITUDE = "	,
				sprintf("%9.4f", $header_hash{'LONGITUDE'}),
				"\n",
			"DEPTH = ",
				sprintf("%5d", $header_hash{'DEPTH'}),
				"\n";

	#
	#--> Write the parameter headers
	#
	foreach my $param_head (@data_column)	{
	
		print OUTPUT 	$param_head . ',' .
				$param_head . '_FLAG_' . $flag_type . ',';
	}
	print OUTPUT "\n";
	
	#
	#--> Write the units headers
	#
	foreach $param_head (@data_column)	{
	
		print OUTPUT 	$ctd_hash{"$param_head" . '_UNITS'} . ',,';		
	}	
	print OUTPUT "\n";
	
	
	#
	#--> Make sure that all parameter fields that *should* have QC values actually
	#--> have them
	#
	foreach $param_head (@data_column)	{
	
		if ($ctd_hash{$param_head . '_FLAG'}[0])	{
			print STDOUT "\t--> " , $param_head . '_FLAG',
					" values are defined\n";
		} else					{
		
			print STDERR "\n\t\t---> ", $param_head . '_FLAG',
					" values do not exist for this profile\n\n";
		}
	}
	
	#--> Finally, write out the data columns in order, only if defined for each
	#--> line (flags and data)
	#
	for (my $i=0 ; $i <= $num_rec ; $i++)	{

		#--> Write out data and flags for (0), usually CTDPRS
		print OUTPUT sprintf ($ctd_format{$data_column[0]}, 
				$ctd_hash{$data_column[0]}[$i]) . ','
			if ($ctd_hash{$data_column[0]}[$i]);
		print OUTPUT sprintf ($ctd_format{'FLAG'},
				$ctd_hash{$data_column[0] . '_FLAG'}[$i]) . ','
			if($ctd_hash{$data_column[0] . '_FLAG'}[$i]);
	
		#--> Write out data and flags for (1), usually CTDTMP
		print OUTPUT sprintf($ctd_format{$data_column[1]}, 
				$ctd_hash{$data_column[1]}[$i]) . ',' 
			if($ctd_hash{$data_column[1]}[$i]);
		print OUTPUT sprintf($ctd_format{'FLAG'}, 
				$ctd_hash{$data_column[1] . '_FLAG'}[$i]) , ','
			if ($ctd_hash{$data_column[1] . '_FLAG'}[$i]);			


		#--> Write out data and flags for (2), usually CTDSAL				
		print OUTPUT sprintf($ctd_format{$data_column[2]}, 
				$ctd_hash{$data_column[2]}[$i]) , ',' 
				if ($ctd_hash{$data_column[2]}[$i]);
		print OUTPUT sprintf($ctd_format{'FLAG'}, 
				$ctd_hash{$data_column[2] . '_FLAG'}[$i]) , ',', 
			if ($ctd_hash{$data_column[2] . '_FLAG'}[$i]);
			
		#--> Write out data and flags for (3), usually CTDOXY	
		print OUTPUT sprintf($ctd_format{$data_column[3]}, 
				$ctd_hash{$data_column[3]}[$i]) , ',' 
			if ($ctd_hash{$data_column[3]}[$i]);	
		print OUTPUT sprintf($ctd_format{'FLAG'}, 
				$ctd_hash{$data_column[3] . '_FLAG'}[$i]) 
			if ($ctd_hash{$data_column[3] . '_FLAG'}[$i]);	
			
	print OUTPUT "\n";
	}
	print OUTPUT "END_DATA\n";
	close(OUTPUT);
}
1;
