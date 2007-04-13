#!/usr/bin/perl
#--->!/usr/local/bin/perl
#---------------------------------------------------------------------------
#	HYD_TO_NETCDF.PL:	
#			a Perl script to read in a WOCE formatted Hydro
#			(bottle) data file and its SUMFILE and write all
#			relevant fields into a NetCDF file.
#
#		INPUTS:		
#
#
#	S. Diggs:	1999.12.09:	initial coding
#	S. Diggs:	2000.07.20:	various changes to include
#					changes to output format for
#					CD2.0
#---------------------------------------------------------------------------
use strict;
#use NetCDF;
#use diagnostics;

my $home_directory = "/admin_home/sdiggs/tools/EXCHANGE_V2/CODE/EXCTD_NETCDF";

require "/admin_home/sdiggs/tools/MERGE/whp_param_fmt.pl";
require "/admin_home/sdiggs/tools/NetCDF/TEST/HYD/get_sumdata.pl";
require "/admin_home/sdiggs/tools/NetCDF/TEST/HYD/combine_sum_hyd_no_print.pl";

#
#--> Get all HYDRO Parameter formats
#
my %param_fmt = &whp_param_fmt;

my (@buffer, @tmp, $i, $j, $k, $l, $x, $y, $sumfile_name, $hydfile_name);
my (@column_heading, @unit_heading, @asterisk);
my ($original_header, @qual_name, %flag_hash, %units_hash);
my (%hyd_hash, %sum_hash, @flagged_param_name);
my $hcount = 0; # number of data lines in the file

#
#--> get input from SUM and HYD files
#
if ($#ARGV < 1)	{
	print STDOUT ("Please enter SUM file name: ");
	chomp($sumfile_name=<STDIN>);
	print STDOUT ("Please enter HYD file name: ");
	chomp($hydfile_name=<STDIN>);
} else		{
	$sumfile_name = shift(@ARGV);
	$hydfile_name = shift(@ARGV);
}

%sum_hash = &get_sumdata($sumfile_name);
open(HYDFILE, $hydfile_name) or 
	die "Cannot open bottle data file ($hydfile_name) for reading!";
chomp(@buffer=<HYDFILE>);
close(HYDFILE);

print STDOUT "Name of output file: ";
chomp(my $output_file =<STDIN>);
	
open(OUTPUT_FILE, "> $output_file") or
	die "Cannot open $output_file for writing (hyd_to_netcdf.pl)";

for ( $i=0 ; $i <= $#buffer ; $i++) {

	@tmp = split (/\s+/, $buffer[$i]);
	print STDOUT join("|", @tmp),"\n";
	if ($tmp[0] eq '')	{
		print STDOUT "1st element is blank, removing...\n";
		shift(@tmp);
		print STDOUT "\t1st element is now $tmp[0]\n";
	}
	
 	# for header line...
 	
	if ($tmp[0] =~ /\*\*\*/)	{
		print STDOUT	"Found header line, stopping at line ",
				$i+1,"\n";
		last;
	}
}

print STDOUT "Last line was $i\n";
$original_header = join("\n", @buffer[0..3]),"\n";
print STDOUT "ORIGINAL HEADER:\n$original_header";

#------------------------------------------------------------------------
#
#--> Get the parameters, including any QUALT fields
#
@column_heading = split(/\s+/, $buffer[$i-2]);
@qual_name = grep(/qualt/ig, @column_heading);

if ($column_heading[0] eq '')	{

	shift(@column_heading);
	print STDOUT "\t1st element is now $column_heading[0]\n";
}
print STDOUT "\tThere are $#column_heading parameters\n";
print STDOUT join(",", @column_heading),"\n";
print STDOUT "\t\tThere are  ( @qual_name ) ",($#qual_name+1),
		" quality flag fields\n";
		
#
#--> Check Param names for existence and spelling
#
print STDOUT "---> Checking param name validity and spelling ...\n";

for ($y=0 ; $y <= $#column_heading ; $y++)	{

	print STDOUT "Checking param\t$column_heading[$y]\t...";
	if (	(!($param_fmt{$column_heading[$y]})) && 
		($param_fmt{$column_heading[$y]} =! /qualt/i )
	    )	{
						
		print STDERR "I don't know param = $column_heading[$y] *** ABORT!\n";
		exit(3);
	}
	print STDOUT "OK\n";
}

print STDOUT "DONE!\n\n";

#
#--> Figure out which param/fields get flags and their units
#
my $asterisk_format  = "a8 " x (($#column_heading - $#qual_name)+2);
print STDOUT "Format is $asterisk_format\n";

#
#--> get the elements of the line (8 chars each)
#
@unit_heading	= unpack ($asterisk_format, $buffer[$i-1]);
foreach my $heading_element (@unit_heading)	{

	$heading_element =~ s/\s+//g; #remove all whitespace surrounding the units
}
@asterisk	= unpack ($asterisk_format, $buffer[$i]);

#
#--> make a hash with all of the params as keys and units as values
#

my $flag_counter = 0;
for ($k=0 ; $k <= ($#column_heading - $#qual_name)+1 ; $k++)	{

	print STDOUT	"\t$column_heading[$k]\t",
			"\t$asterisk[$k]\n";
			
	# changed from single to multiple asterisks (SCD: 2000.07.17)
	if ($asterisk[$k] =~ /\*/)	{
		$flag_hash{$column_heading[$k]} = $flag_counter;
		$flag_counter++;
	}
	$units_hash{$column_heading[$k]} = $unit_heading[$k];
}
#
#--> print out the hash with the units(values) and parameters(keys)
#
print STDOUT "\n-----\n\n";
foreach my $pkey (sort keys %units_hash)	{

	print STDOUT "UNITS:\t$pkey\t=\t$units_hash{$pkey}\n"; 
}

#
#--> make an array of the flagged params in order
#
print "***FLAGGED PARAMS (in order) are:\n";
my $e = 0;
foreach $e (@column_heading)	{

	@flagged_param_name = ( @flagged_param_name, $e)
		if defined($flag_hash{$e});
}
print "@flagged_param_name\n\n";

foreach my $header (@column_heading)	{

	print STDOUT "$header\t=\t$flag_hash{$header}\n"
		if defined($flag_hash{$header});
}

print STDOUT "\n\t***READING DATA***  ";

#
#--> Read the actual data from the buffer
#

for ( $x=($i+1) ; $x <= $#buffer ; $x++)	{

	@tmp = split(/\s+/, $buffer[$x]);
	shift(@tmp);
	#print STDOUT join("+",@tmp),"\n";
	
	for ($l=0; $l <= $#column_heading ; $l++)	{
		$hyd_hash{$column_heading[$l]}[$hcount] = $tmp[$l];
	}
	$hcount++; #update hash counter

}

print STDOUT "... done!\n";

#
#--> Split out flags and make new hash keys ala $param_name."_FLAG_W"
#
my @tmp_flag = ();
my $h = 0;
for ($h = 0 ; $h < $hcount ; $h++)	{

	foreach my $flag_field (@qual_name)	{
		
		printf STDOUT ("%04d:\t%8s\tflag_field\t=\t%20s\n",
				$h,$flag_field, $hyd_hash{$flag_field}[$h])
				if (!($h%500));
		
		@tmp_flag = split(//,$hyd_hash{$flag_field}[$h]);		
		for(my $param = 0; $param <= $#flagged_param_name ; $param++)	{
					
			if ((!($tmp_flag[$param])) && ($hyd_hash{$param}[$h]) )	{	
				print STDERR 
				 "\t***> at scan $hcount : ",
				 "problem! no flag for Param = ",
				  $flagged_param_name[$param],"\n";
				  exit;
			}
			#
			#--> Make an entry into the hash for this flag and
			#--> construct the key name
			#
			$hyd_hash{$flagged_param_name[$param].'_'.$flag_field}[$h]
				= $tmp_flag[$param];
		}
		print STDOUT "--\n" if (!($h%500));
	}
	print STDOUT "\t***\n" if (!($h%500));
}

#
#--> Check to see if there are data for each param or not and report results
#
print STDOUT "\n\t\tChecking for data for each parameter ***\n\n";
my $data_value_flag = 0;
foreach my $column (@column_heading)	{

	print STDOUT "Checking $column values...\t";
	my @data_value = @{$hyd_hash{$column}};
	foreach my $x (@data_value)	{
	
		if ((($x != -9.0) and ($x != -999.0)) ){
		
			print STDOUT "data value = $x\t";
			$data_value_flag++;
			last;
		}
	}
	if ($data_value_flag)	{
		print STDOUT "data for $column ( $data_value_flag )\n";
	} else			{
		print STDOUT "\t *** NO_DATA ***\n-----\n";
	}
	$data_value_flag = 0;	#reset flag for next iteration
}

print STDOUT "SUMFILE hash keys are: \n";
foreach my $xxx (sort keys %sum_hash)	{
	print STDOUT "\t $xxx\n";
}
print STDOUT "HYDFILE hash keys are: \n";
foreach my $xxx (sort keys %hyd_hash)	{
	print STDOUT "\t\t $xxx\n";
}
#-------------------------------------------------------------------
my %combined_hash = &combine_sum_hyd_no_print(\%sum_hash, 
			\%hyd_hash, \@column_heading);
my $test_outputfile = '';
my $params_to_see = '';
my @test_params = ();

print STDOUT "MAIN: Number of elements = $#{$combined_hash{'STNNBR'}}\n";

print STDOUT "Keys are: ", join('|', (sort keys %combined_hash)), "\n",
		"\n printing output file\n";;

#write header
print OUTPUT_FILE join(',', (sort keys %combined_hash)), "\n";

#for ($i=0 ; $i <= $#{$combined_hash{'STNNBR'}} ; $i++)	{
for ($i=0 ; $i <= 10; $i++)	{

	foreach my $final_param (sort keys %combined_hash)	{
	
		print OUTPUT_FILE $combined_hash{$final_param}[$i] . ',';
	}
	print OUTPUT_FILE "\n";
}

&output_netcdf( $buffer[0], \%combined_hash, \%units_hash);

print STDOUT "Done!\n";

#----------------------------------------------------------------
#	OUTPUT_NETCDF:	perl subroutine that Writes
#			a NetCDF file as output from an incoming,
#			all-inclusive hash.
#
#	S. Diggs	2000.07.19:	initial coding and design
#					(derived from my 'sumfile.pl'
#					program)
#
#----------------------------------------------------------------

sub output_netcdf	{

	use NetCDF;

	my %data_hash  = ();
	my %units_hash = ();
	my($i, $j, $k);
	
	my $header	= shift(@_);
	my ($data_ref)	= shift(@_);
	my ($units_ref)	= @_;

	my %data_hash	= %$data_ref;
	my %units_hash	= %$units_ref;
	
	print STDOUT "\n---->\n\tNETCDF module!\n";
	#
	#--> print out the hash with the units(values) and parameters(keys)
	#
	print STDOUT "\n-----\n\n";
	foreach my $pkey (sort keys %units_hash)	{

		print STDOUT "UNITS:\t$pkey\t=\t$units_hash{$pkey}\n"; 
	}
	
	#my $time = gmtime();
	#$time .= " GMT";
	my $time = "S. Diggs: Wed May 17 22:38:17 2000 GMT";
	
	print STDOUT "Data hash (in netcdf routine):\n",
			join('|', (sort keys %data_hash)), "\n";
	#
	#--> Define the hash for each sumfile record
	#       
	#my %record = (	"expo_code"	=> '',	"woce_sect"	=> '',
	#	"stnnbr"	=> 0,	"cast_no"	=> 0,
	#	"cast_type"	=> '',	"date"		=> 0,
	#	"time"		=> 0,	"event_code"	=> '',
	#	"old_lat"	=> 0,	"old_lon"	=> 0,
	#	"nav"		=> '',	"depth"		=> 0,
	#	"above_bottom"	=> 0,	"wire_out"	=> 0,
	#	"max_press"	=> 0,	"no_bottles"	=> 0,
	#	"parameters"	=> '',	"comments"	=> '',
	#);
		
#------------------------------------------------------------------
#--- NETCDF CODE BEGINS HERE...
#
my $expocode	= $data_hash{'EXPOCODE'}[0];
my $string_dimension = 80;

my $ncid	= NetCDF::create("00_hyd_OUTPUT_".$$.".nc", NetCDF::WRITE);

#
#-->Dimension variables
#

my  $dimid	= NetCDF::dimdef($ncid, 'station_data', NetCDF::UNLIMITED);
my $sdimid	= NetCDF::dimdef($ncid, 'string_dimension', $string_dimension);
my @string_dims = ($dimid,$sdimid);

NetCDF::attput($ncid, NetCDF::GLOBAL, "ORIGINAL_HEADER", NetCDF::CHAR,
			$header);
NetCDF::attput($ncid, NetCDF::GLOBAL, "EXPOCODE", NetCDF::CHAR,
			$expocode);
NetCDF::attput($ncid, NetCDF::GLOBAL, "Time_Written", NetCDF::CHAR,
			$time);
			
#--> CHAR type (2 dimensions) MUST HAVE A REF TO A MULTI-DIM ARRAY!		
#--> from .SUM file

my $varid_sect		= NetCDF::vardef($ncid, 'SECT'	, NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_sect, "DESCRIPTION", 
			NetCDF::CHAR,"WOCE SECTION");
my $varid_longitude	= NetCDF::vardef($ncid, 'LONGITUDE', 	NetCDF::FLOAT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_longitude, "UNITS", 
			NetCDF::CHAR,"DECIMAL DEGREES EAST");
my $varid_latitude	= NetCDF::vardef($ncid, 'LATITUDE' , 	NetCDF::FLOAT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_latitude, "UNITS", 
			NetCDF::CHAR,"DECIMAL DEGREES NORTH");
my $varid_date	= NetCDF::vardef($ncid, 'DATE' , 	NetCDF::LONG,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_date, "UNITS", 
			NetCDF::CHAR,"YYYYMMDD (GMT)");			
my $varid_time	= NetCDF::vardef($ncid, 'TIME' ,	NetCDF::CHAR,	\@string_dims);
	my $attid = NetCDF::attput($ncid, $varid_time, "UNITS", 
			NetCDF::CHAR,"HHMM (GMT)");

#-->NUMBERS FROM HYD FILE (single dimension)	
						
my $varid_castno	= NetCDF::vardef($ncid, 'CASTNO' , NetCDF::LONG, $dimid);
	my $attid = NetCDF::attput($ncid, $varid_castno, "DESCRIPTION", 
			NetCDF::CHAR,"CAST NUMBER");				
my $varid_stnnbr	= NetCDF::vardef($ncid, 'STNNBR', NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_stnnbr, "DESCRIPTION", 
			NetCDF::CHAR,"CRUISE STATION NUMBER");
my $varid_btlnbr	= NetCDF::vardef($ncid, 'BTLNBR' , NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_btlnbr, "DESCRIPTION", 
			NetCDF::CHAR,"BOTTLE NUMBER");
	my $attid = NetCDF::attput($ncid, $varid_btlnbr, "MISSING_VALUE", 
			NetCDF::SHORT, -9);
my $varid_sampno	= NetCDF::vardef($ncid, 'SAMPNO', NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_sampno, "DESCRIPTION", 
			NetCDF::CHAR,"SAMPLE NUMBER");									
my $varid_depth	= NetCDF::vardef($ncid, 'BOTTOM_DEPTH' , NetCDF::SHORT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_depth, "UNITS", 
			NetCDF::CHAR,"METERS");
#
#--> make the variable IDs and set atttributes for the data PARAMETERS
#

#--------------------------------------CTDPRS--------------------------------------------
my $string_var = 'CTDPRS';
my $varid_ctdprs = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdprs, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdprs, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);	
#my $string_var = 'CTDPRS_QUALT2';
#my $varid_ctdprs_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
#	my $attid = NetCDF::attput($ncid, $varid_ctdprs_qualt2, "UNITS", 
#		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDTMP--------------------------------------------
my $string_var = 'CTDTMP';
my $varid_ctdtmp = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdtmp, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdtmp, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
#my $string_var = 'CTDTMP_QUALT2';
#my $varid_ctdtmp_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
#	my $attid = NetCDF::attput($ncid, $varid_ctdtmp_qualt2, "UNITS", 
#		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDSAL--------------------------------------------
my $string_var = 'CTDSAL';
my $varid_ctdsal = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdsal, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdsal, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'CTDSAL_QUALT2';
my $varid_ctdsal_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdsal_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDOXY--------------------------------------------
my $string_var = 'CTDOXY';
my $varid_ctdoxy = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'CTDOXY_QUALT2';
my $varid_ctdoxy_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------SALNTY--------------------------------------------
my $string_var = 'SALNTY';
my $varid_salnty = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_salnty, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_salnty, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'SALNTY_QUALT2';
my $varid_salnty_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_salnty_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------OXYGEN--------------------------------------------
my $string_var = 'OXYGEN';
my $varid_oxygen = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_oxygen, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_oxygen, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'OXYGEN_QUALT2';
my $varid_oxygen_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_oxygen_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------SILCAT--------------------------------------------
my $string_var = 'SILCAT';
my $varid_silcat = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_silcat, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_silcat, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'SILCAT_QUALT2';
my $varid_silcat_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_silcat_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------NITRAT--------------------------------------------
my $string_var = 'NITRAT';
my $varid_nitrat = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrat, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_nitrat, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'NITRAT_QUALT2';
my $varid_nitrat_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrat_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------NITRIT--------------------------------------------
my $string_var = 'NITRIT';
my $varid_nitrit = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrit, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_nitrit, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'NITRIT_QUALT2';
my $varid_nitrit_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrit_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------PHSPHT--------------------------------------------
my $string_var = 'PHSPHT';
my $varid_phspht = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_phspht, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_phspht, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'PHSPHT_QUALT2';
my $varid_phspht_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_phspht_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------


	
my @start = (0);
my @count =($#{ $data_hash{'STNNBR'}});	
print "--> COUNT = $#{ $data_hash{'STNNBR'}}\n";
	
# leaving define mode
NetCDF::endef($ncid);

#****************************************************************************
#----------------------------------SECT
print STDOUT "\tDoing SECT\n";
my @sect = @{ $data_hash{'SECT'}};

foreach my $element (@sect)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_sect,	[0,0], [@count,80],	
		\@sect);
		
#----------------------------------LATITUDE
print STDOUT "\tDoing LATITUDE\n";
my @latitude = @{ $data_hash{'LATITUDE'}};
NetCDF::varput($ncid, $varid_latitude,	\@start, \@count,	
		\@latitude);	

#----------------------------------LATITUDE
print STDOUT "\tDoing LONGITUDE\n";
my @longitude = @{ $data_hash{'LONGITUDE'}};
NetCDF::varput($ncid, $varid_longitude,	\@start, \@count,	
		\@longitude);
		
#----------------------------------DATE
print STDOUT "\tDoing DATE\n";
my @date = @{ $data_hash{'DATE'}};
NetCDF::varput($ncid, $varid_date,	\@start, \@count,	
		\@date);
		
#----------------------------------TIME
print STDOUT "\tDoing TIME\n";
my @woce_time = @{ $data_hash{'TIME'}};
foreach my $element (@woce_time)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_time,	[0,0], [@count,80],	
		\@woce_time);
				
#----------------------------------BOTTOM_DEPTH
print STDOUT "\tDoing BOTTOM_DEPTH\n";
my @depth = @{ $data_hash{'DEPTH'}};
NetCDF::varput($ncid, $varid_depth,	\@start, \@count,	
		\@depth);

				
#----------------------------------CASTNO
print STDOUT "\tDoing CASTNO\n";
my @castno = @{ $data_hash{'CASTNO'}};
NetCDF::varput($ncid, $varid_castno,	\@start, \@count,
		\@castno);
		
#----------------------------------STNNBR
print STDOUT "\tDoing STNNBR\n";
my @stnnbr = @{ $data_hash{'STNNBR'}};
foreach my $element (@stnnbr)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_stnnbr,	[0,0], [@count,80],	
		\@stnnbr);

#----------------------------------BTLNBR
print STDOUT "\tDoing BTLNBR\n";
my @btlnbr = @{ $data_hash{'BTLNBR'}};
foreach my $element (@btlnbr)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_btlnbr,	[0,0], [@count,80],	
		\@btlnbr);

#----------------------------------SAMPNO
print STDOUT "\tDoing SAMPNO\n";
my @sampno = @{ $data_hash{'SAMPNO'}};
foreach my $element (@sampno)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_sampno,	[0,0], [@count,80],	
		\@sampno);
		
#****************************************************************************	
#----------------------------------CTDPRS
print STDOUT "\tDoing CTDPRS\n";
my @ctdprs = @{ $data_hash{'CTDPRS'}};
NetCDF::varput($ncid, $varid_ctdprs,	\@start, \@count,
		\@ctdprs);
#my @ctdprs_qualt2 = @{ $data_hash{'CTDPRS_QUALT2'}};
#print "Ready to see CTDPRS_QUALT2?: ";
#my $dummy = <STDIN>;
#print STDOUT join(',', @ctdprs_qualt2),"\n";
#NetCDF::varput($ncid, $varid_ctdprs_qualt2,	\@start, \@count,
#		\@ctdprs_qualt2);			

#----------------------------------CTDTMP
print STDOUT "\tDoing CTDTMP\n";
my @ctdtmp = @{ $data_hash{'CTDTMP'}};
NetCDF::varput($ncid, $varid_ctdtmp,	\@start, \@count,
		\@ctdtmp);
#my @ctdtmp_qualt2 = @{ $data_hash{'CTDTMP_QUALT2'}};
#print "Ready to see CTDTMP_QUALT2?: ";
#my $dummy = <STDIN>;
#print STDOUT join(',', @ctdtmp_qualt2),"\n";
#NetCDF::varput($ncid, $varid_ctdtmp_qualt2,	\@start, \@count,
#		\@ctdtmp_qualt2);

#----------------------------------CTDSAL
print STDOUT "\tDoing CTDSAL\n";
my @ctdsal = @{ $data_hash{'CTDSAL'}};
NetCDF::varput($ncid, $varid_ctdsal,	\@start, \@count,
		\@ctdsal);
my @ctdsal_qualt2 = @{ $data_hash{'CTDSAL_QUALT2'}};
print "Ready to see CTDSAL_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @ctdsal_qualt2),"\n";
NetCDF::varput($ncid, $varid_ctdsal_qualt2,	\@start, \@count,
		\@ctdsal_qualt2);
		
#----------------------------------CTDOXY
print STDOUT "\tDoing CTDOXY\n";
my @ctdoxy = @{ $data_hash{'CTDOXY'}};
NetCDF::varput($ncid, $varid_ctdoxy,	\@start, \@count,
		\@ctdoxy);
my @ctdoxy_qualt2 = @{ $data_hash{'CTDOXY_QUALT2'}};
print "Ready to see CTDOXY_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @ctdoxy_qualt2),"\n";
NetCDF::varput($ncid, $varid_ctdoxy_qualt2,	\@start, \@count,
		\@ctdoxy_qualt2);		

#----------------------------------SALNTY
print STDOUT "\tDoing SALNTY\n";
my @salnty = @{ $data_hash{'SALNTY'}};
NetCDF::varput($ncid, $varid_salnty,	\@start, \@count,
		\@salnty);
my @salnty_qualt2 = @{ $data_hash{'SALNTY_QUALT2'}};
print "Ready to see SALNTY_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @salnty_qualt2),"\n";
NetCDF::varput($ncid, $varid_salnty_qualt2,	\@start, \@count,
		\@salnty_qualt2);

#----------------------------------OXYGEN
print STDOUT "\tDoing OXYGEN\n";
my @oxygen = @{ $data_hash{'OXYGEN'}};
NetCDF::varput($ncid, $varid_oxygen,	\@start, \@count,
		\@oxygen);
my @oxygen_qualt2 = @{ $data_hash{'OXYGEN_QUALT2'}};
print "Ready to see OXYGEN_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @oxygen_qualt2),"\n";
NetCDF::varput($ncid, $varid_oxygen_qualt2,	\@start, \@count,
		\@oxygen_qualt2);

#----------------------------------SILCAT
print STDOUT "\tDoing SILCAT\n";
my @silcat = @{ $data_hash{'SILCAT'}};
NetCDF::varput($ncid, $varid_silcat,	\@start, \@count,
		\@silcat);
my @silcat_qualt2 = @{ $data_hash{'SILCAT_QUALT2'}};
print "Ready to see SILCAT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @silcat_qualt2),"\n";
NetCDF::varput($ncid, $varid_silcat_qualt2,	\@start, \@count,
		\@silcat_qualt2);

#----------------------------------NITRAT
print STDOUT "\tDoing NITRAT\n";
my @nitrat = @{ $data_hash{'NITRAT'}};
NetCDF::varput($ncid, $varid_nitrat,	\@start, \@count,
		\@nitrat);
my @nitrat_qualt2 = @{ $data_hash{'NITRAT_QUALT2'}};
print "Ready to see NITRAT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @nitrat_qualt2),"\n";
NetCDF::varput($ncid, $varid_nitrat_qualt2,	\@start, \@count,
	\@nitrat_qualt2);

#----------------------------------NITRIT
print STDOUT "\tDoing NITRIT\n";
my @nitrit = @{ $data_hash{'NITRIT'}};
NetCDF::varput($ncid, $varid_nitrit,	\@start, \@count,
		\@nitrit);
my @nitrit_qualt2 = @{ $data_hash{'NITRIT_QUALT2'}};
print "Ready to see NITRIT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @nitrit_qualt2),"\n";
NetCDF::varput($ncid, $varid_nitrit_qualt2,	\@start, \@count,
		\@nitrit_qualt2);

#----------------------------------PHSPHT
print STDOUT "\tDoing PHSPHT\n";
my @phspht = @{ $data_hash{'PHSPHT'}};
NetCDF::varput($ncid, $varid_phspht,	\@start, \@count,
		\@phspht);
my @phspht_qualt2 = @{ $data_hash{'PHSPHT_QUALT2'}};
print "Ready to see PHSPHT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @phspht_qualt2),"\n";
NetCDF::varput($ncid, $varid_phspht_qualt2,	\@start, \@count,
		\@phspht_qualt2);

#----------------------------------END NUMERICAL DATA

NetCDF::close($ncid);
}
############################################################
# pad str to correct length

sub padstr
	{
		my( $str, $len ) = @_ ;

		my( $size, $i, $retval ) ;

		$size = length( $str ) ;

		for( $i = $size; $i < $len; $i++ ) {
     			$str .= "\0" ;
			#print "$str,\n" ;
		}
		if( $size > $len ) {
       			 print STDOUT "String length is over ",
       			 	"$len chars long:\n $str\n" ;
        		$str = substr( $str, 0, $len ) ;
        		#exit 0 ;
		}
		$retval = $str ;
}
1;
