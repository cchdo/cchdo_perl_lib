#!/usr/bin/perl -w
#-----------------------------------------------------------------------
#
# Sumfile and ctd translation code: S. Diggs: 2001.09.25
#
# MODIFICATIONS:
# S. Diggs: 		2001.10.23:	revised coding for version 1.0a
# S. Diggs: 		2001.10.23:	remove alpha characters in
#					"write_exctd_data". (v1.0b)
# S. Diggs:		2001.11.06:	updated mod_date code (v1.0c)
# S. Diggs:		2001.11.06:	changed Select_Depth2.pm (v1.0d)
# S. Diggs:		2001.11.06:	now handles non-numeric STNNBRs
#					(v1.0e)
# S. Diggs:		2001.12.19:	problems with 0.0 (lat/lon) in
#					Exchange_Sum_Parse.pm, fixed.
#					(v1.0f)
#
# S. Diggs:		2001.12.27:	fixed bug in depth selection.
#					Now, this code uses Select_Depth3
#					(v1.0g)
# S. Diggs:		2005.04.21:	(v1.0h) for RHEL 3 (Linux)
# S. Diggs:		2006.05.03:	(v1.0i) for UBUNTU (Linux)
# S. Diggs:		2006.08.10:	(v1.1) for UBUNTU/Linux with
# 					corrected paths
#
#------------------------------------------------------------------------
my $software_version = "CTD_Exchange_Encode_v1.1(CCHDO/Diggs)";

print STDERR "This software version is: $software_version\n\n";

my $basedir = "/admin_home/sdiggs/tools/EXCHANGE_V2/CODE/";
@INC =  ($basedir , @INC);

#print STDERR '@INC: ' , "\n", join("\n", @INC) , "\n\n";

#
#--> Load Libraries
#
####use lib $basedir;
#use Exchange_Sum_Parse;
#use Select_Depth2;
#use Whp_Stamp;
#use Get_File_Info;

require $basedir . "Exchange_Sum_Parse.pm";
require $basedir . "Select_Depth3.pm";
require $basedir . "Whp_Stamp.pm";
require $basedir . "Get_File_Info.pm";
require $basedir . "read_anyfile.pl";
require $basedir . "convert_whp_date.pl";
require $basedir . "decode_whp_ctd.pl";
require $basedir . "decode_wctd_vals.pl";
require $basedir . "assign_wctd_flags.pl";
require $basedir . "write_exctd_data.pl";
require $basedir . "get_depth_and_type.pl";
require $basedir . "tag.pl";


my $sumfile_name;
my $tmp_names;

my (%final_meta_hash, %temp_meta_hash);

print STDERR "Sumfile name: ";
chomp($sumfile_name=<STDIN>);


my ($sum_hash_ref , $depth_hash_ref, $sumfile_mod_date) 
			= Exchange_Sum_Parse($sumfile_name);

my %sum_hash	= %$sum_hash_ref;
my %depth_hash	= %$depth_hash_ref;


#
#--> transfer depths and other information to sumfile hash
#
$sum_hash{'MOD_DATE'} = $sumfile_mod_date;
$sum_hash{'DEPTH_TYPE'} = $depth_hash{'TYPE'};

#foreach my $ku	(sort keys %sum_hash)	{
#
#	print STDOUT "SUM_HASH: $ku = \t$sum_hash{$ku}[1]\n";
#}

@{$sum_hash{'DEPTH'}}	= @{$depth_hash{'DEPTH'}};
@{$sum_hash{'DEPTH'}}	= @{$depth_hash{'DEPTH'}};

#
#--> Report the information gleaned from the SUMFILE
#
print STDOUT "Sumfile modification date is: $sumfile_mod_date\n";
#foreach my $x (sort keys %sum_hash)	{
#
#	print STDOUT "SUMFILE:\tkey=\t${x}\tval=$sum_hash{$x}\n";
#}
print STDOUT "\n---------\n";

#--> based on the information from the CTD datafile, find the 
#--> corresponding lat/lon/time/code/date/ in the SUMFILE hash

print STDERR "CTD filename: ";
chomp($tmp_names=<STDIN>);

my @file_list = split(/\s/, $tmp_names);

my @ctdfile_names = <@file_list>;

#
#-----------------> BEGIN: MULTIPLE FILE PROCESSING LOOP
#

foreach my $ctd_loop_filename (@ctdfile_names)	{

	my ($ctd_header_ref, $ctd_data_ref) 
		= &decode_whp_ctd($ctd_loop_filename);

	my %ctd_data	= %$ctd_data_ref;
	my %ctd_header	= %$ctd_header_ref;

	$ctd_header{'depth_type'}    = $depth_hash{'TYPE'};
	$ctd_header{'sum_file_date'} = $sumfile_mod_date;
	$ctd_header{'sum_file_name'} = $sumfile_name;
	$ctd_header{'ctd_file_name'} = $ctd_loop_filename;



	my $match_line_count = 0;
	for (my $s=0 ; 	$s <= $#{$sum_hash{'CASTNO'}} ; $s++)	{

		#print STDOUT "--> \t\tCTD STNNBR FOR MATCH = +",
		#		$ctd_header{'stnnbr'}, "+\n";
		#print STDOUT "--> \t\tSUM STNNBR FOR MATCH = +",
		#		$sum_hash{'stnnbr'}, "+\n";
		if 
	 	  (
			($ctd_header{'stnnbr'} eq $sum_hash{'STNNBR'}[$s])
			and
			($ctd_header{'castno'} eq $sum_hash{'CASTNO'}[$s])
		   )							
		 # or							
	 	 #(
		 #	($sum_hash{'STNNBR'}[$s] eq $ctd_header{'stnnbr'})
		 #	and
		 #	($sum_hash{'CASTNO'}[$s] eq $ctd_header{'castno'})
		 #  ))							
									{

			print STDOUT "\tMatch at: $s\n",
				"\t\tSUM stnnbr = $sum_hash{'STNNBR'}[$s]\n",
				"\t\tCTD stnnbr = $ctd_header{'stnnbr'}\n",
				"\t\tSUM castno = $sum_hash{'CASTNO'}[$s]\n",
				"\t\tCTD castno = $ctd_header{'castno'}\n";

			#--> transfer all matches to temp_meta for depth selection

			$temp_meta_hash{'CASTNO'}[$match_line_count] 
				= $sum_hash{'CASTNO'}[$s];
			$temp_meta_hash{'CODE'}[$match_line_count] 
				= $sum_hash{'CODE'}[$s];
			$temp_meta_hash{'DATE'}[$match_line_count] 
				= $sum_hash{'DATE'}[$s];
			$temp_meta_hash{'DEPTH'}[$match_line_count] 
				= $sum_hash{'DEPTH'}[$s];
			$temp_meta_hash{'EXPOCODE'}[$match_line_count] 
				= $sum_hash{'EXPOCODE'}[$s];
			$temp_meta_hash{'LATITUDE'}[$match_line_count] 
				= $sum_hash{'LATITUDE'}[$s];
			$temp_meta_hash{'LONGITUDE'}[$match_line_count] 
				= $sum_hash{'LONGITUDE'}[$s];
			$temp_meta_hash{'SECT'}[$match_line_count] 
				= $sum_hash{'SECT'}[$s];
			$temp_meta_hash{'STNNBR'}[$match_line_count] 
				= $sum_hash{'STNNBR'}[$s];
			$temp_meta_hash{'TIME'}[$match_line_count] 
				= $sum_hash{'TIME'}[$s];
		
			$match_line_count++;
		}
	}

	if ($match_line_count)	{

		%final_meta_hash = Select_Depth2(%temp_meta_hash);
		print STDOUT "Here's our sumfile data: \n";
			foreach my $x (sort keys %final_meta_hash)	{
		
				print STDOUT "\t$x =\t$final_meta_hash{$x}\n";
			}
	} else			{
		print STDERR	"No match between CTD and SUMFILE (stop!)\n\n";
		exit(1);
	}

	foreach my $key ( keys %final_meta_hash )	{
		$ctd_header{$key} = $final_meta_hash{$key};
	}
	print STDOUT "From the final CTD header meta hash: \n";
	foreach my $x (sort keys %ctd_header)	{		
		print STDOUT "CTD META\t$x =\t$ctd_header{$x}\n";
	}	
	print STDOUT 'From the final CTD *DATA* hash: ',"\n";
	foreach my $x (sort keys %ctd_data)	{	
		print STDOUT "CTD DATA\t$x =\t$ctd_data{$x}\n";
	}

	&write_exctd_data(\%ctd_header, \%ctd_data, 'W', $software_version);
}
#
#------------------------> END LOOP
#
