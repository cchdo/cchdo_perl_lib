#!/usr/bin/perl
#--------------------------------------------------------------
# HYD_TO_EXCHANGE.PL
#
# PURPOSE:
# This script takes a HYD file and converts it to the 
# improved exchange file format.  The conversion is
# based on varsion 2000.07.18 of the Improved Exchange
# Format manual written by James Swift and edited
# by Stephen Diggs.
#
# The script takes in two arguments, the HYD and SUM
# files, extracts the needed data into a hash using an 
# external procedure.  The data is then checked  for
# known problems and the desired parameters are printed to
# the new exchange file.  The desired parameters are stored in
# an array in hyd_excahnge_params.pl.  The array is in the 
# order  and containts the fields that  were chosen by
# Jim Swift and Sarilee Anderson.
# NOTE: DELC13 was added 
#
# VARIABLES:
#	$hyd_name	-name of the bottle file (.hyd file) 
#	$sum_name	-name of the .hyd file 
#	$output_file	-name of the file that the output will be written to
#			 (created using the patern LINE1{_LINE?}_hyd1.csv)
#	$expocode	-the expocode that is read from the .hyd file
#	%hyd_hash	-the hash that the bottle file data is stored in
#	%sum_hash	-the hash that the .sum file data is stored in
#	$hyd_size	-the number of records in the .hyd file 
#	%format		-the hash that is used to hold the returned value
#			 from exchange_param_format()
#	@exact_headers	-the array used to store the returned value from
#			 hyd_exchange_params.pl
#       @hyd_header     -the array used to store the header values that are 
#			 in both the .hyd file and the @exact_headers
#	$whpo_stamp	-the WHPO timestamp returned whent he function
#			 get_timestamp is called
#	@data_output	-array that holds all of the data for a single line
#			 in its correct exchange format
#	
# FUNCTIONS:
#	-all of the functions called are external
#
# Required files
#	-/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/hyd/hyd_get_hyddata.pl
#	-/home/whpo/jjward/src/tools/PERL/get_decplaces.pl
#	-/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/hyd/hyd_exchange_params.pl
#	-/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/exchange_param_format.pl
#	-/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/get_whpo_timestamp.pl
#	-/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/round_float.pl
#
#	
#	
# J. Ward <jjward@ucsd.edu> --> original coding 
# J. Ward	8.3.2000    --> added check for correct number of cols
#				in hyd file
# J. Ward	2000.8.23   --> added check for NITRAT and no NITRIT
# J. Ward	2000.9.29   --> added more comments and moved all of the
#				local vars to top
#
#      modified 9.29.2000
# Last modified 2006.05.03 (S. Diggs: Linux port to new CCHDO machine)
#---------------------------------------------------------------

#USES
use strict;
#for sysopen THAT SHOULD BE REMOVED SOME DAY
use Fcntl;
#for getting the file mod. dates
use File::stat;
#to convert the mod. dates to readable format
use Time::localtime;

#INCLUDES
require "/home/jjward/src/exchange_format/whp_to_exchange_code/hyd/hyd_get_hyddata.pl";
require "/home/jjward/src/tools/PERL/get_decplaces.pl";
#require "/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/hyd/hyd_exchange_params.pl";
#require "/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/exchange_param_format.pl";
require "/home/jjward/src/exchange_format/whp_to_exchange_code/get_whpo_timestamp.pl";
require "/home/jjward/src/exchange_format/whp_to_exchange_code/round_float.pl";
require "/home/jjward/src/exchange_format/whp_to_exchange_code/hyd/where_is_this_script.pl";
#use lib "/home/bren/perllib";
use lib "/home/jjward/src/exchange_format/whp_to_exchange_code/hyd";
use GetExchangeParams;
use SortExchangeParams;

#vars
my ($hyd_name, $sum_name, $output_file); 
my $expocode;
my %hyd_hash = ();
my %sum_hash = ();
my $hyd_size = 0;
my %format = ();
my @hyd_header = ();
my @exact_headers = ();
my $whpo_stamp;
my @data_output = ();
my $y_n;
my $output_name;
my $mtime_hyd;		#file date/time stamps
my $mtime_sum;		#
my $header;
my @headersNotIncluded = ();
my $copy_date;
my $init;
my $flag_name;
my @cols_removed;

#MAIN BEGIN

#
# Print out the instructions for the conversion program.
#
print  "This program will convert the given HYD and SUM file pair\n";
print  "to a single exchange file.  The file names may be entered\n";
print  "as arguments at the command prompt.  The first file given\n";
print  "must be the HYD file followed by the SUM file.  For example:\n";
print  "\t\thyd_to_exchange.pl test1.hyd test1.sum\n";
print  "\nIf a file format problem exists, the error will be printed\n";
print  "and the program will exit.\n\n";




#
# get the file names 
#
$hyd_name = get_arg(\@ARGV, "HYD");
$sum_name = get_arg(\@ARGV, "SUM");
	
print  "Please enter the date that the files were copied: ";
$copy_date = <STDIN>;
chomp($copy_date);
print  "Please enter your inititals: ";
$init = <STDIN>;
chomp($init);




print  "Reading input from files...\n";

#
# call the function to read in the data and header info from the HYD file
#
($hyd_size) = hyd_get_hyddata($hyd_name,$sum_name, \%hyd_hash);

#
# Check the hyd_hash for NITRAT but no NITRIT 
# (asked by J. Swift to do check)
# ONLY PRINT A WARNING
#
if ((exists($hyd_hash{'NITRAT'})) && (!(exists($hyd_hash{'NITRIT'}))))
{
	print STDOUT "WARNING: NITRAT column but no NITRIT column found in the HYD file\n";
}



print STDOUT "Writing header info to file...\n";

#
# Get the name of the new file.  The naming sceme was created by J. Swift
# and aproved by S. Diggs -> *_hy1.csv where the * is the section names
# seperated by '_'.
# Check to see if the new filename exists, if so ask if it is ok to write
# over the file.  If yes then delete file and open the new file with the 
# same name.
#
$output_name =getOutputName(\%hyd_hash, $hyd_size);
# open the output file
sysopen (OUTPUT, $output_name, O_WRONLY|O_CREAT) or 
	die "Could not open $output_name for writing. \n";




#
# call function to get the WHPO stamp for line 1
#
$whpo_stamp = get_timestamp($init);




#
# Print info at top for tracking data errors
#  [-code that wrote the file
#  [-original hyd file date/time stamp
#  [-original sum file date/time stamp
#
$mtime_hyd = ctime(stat($hyd_name)->mtime);
$mtime_sum = ctime(stat($sum_name)->mtime);
print OUTPUT "BOTTLE,$whpo_stamp\n";
print OUTPUT '#'."code : jjward hyd_to_exchange.pl \n";
print OUTPUT '#'."original files copied from HTML directory: $copy_date\n";
print OUTPUT '#'."original HYD file: $hyd_name   $mtime_hyd\n";
print OUTPUT '#'."original SUM file: $sum_name   $mtime_sum\n";

	
#
# Get the exact params in the correct order for the new format
#

#@exact_headers = exchange_params();
@exact_headers = sortExchangeParams(keys(%{getParams()}));	

#
# go through the array of exact_headers and see if each has data
# in the hash, if the header exists in the hash then place on 
# hyd_header hash.
#
foreach $header(@exact_headers)
{
	if (defined($hyd_hash{$header})) {push(@hyd_header, $header);}
	$flag_name = $header.'_FLAG_W';
	if (defined($hyd_hash{$flag_name})) {push(@hyd_header, $flag_name);}
}


#
# go through and print out the col headers that were left out
#
@headersNotIncluded = getHeadersNotIncluded(\%hyd_hash, \@hyd_header);
# flag used for searching through the array -> equals 1 if found
print STDOUT "The following columns are not going to be included:\n";
print STDOUT "----------------------------------------------------\n";
print STDOUT join("\n", @headersNotIncluded);
print STDOUT "\n----------------------------------------------------\n";
print STDOUT "Writing data to file...\n";
#
# print the header information to file
#
print OUTPUT join(",", @hyd_header),"\n";

#
# print units
#
my @units_output;
foreach $header(@hyd_header)
{
	if (exists($hyd_hash{$header}{'unit'}))
	{
		push(@units_output, $hyd_hash{$header}{'unit'});
	}
	else 
	{
		push(@units_output, '');
	}
}
print OUTPUT join(",", @units_output),"\n";

#
# print data
#

#
# Get the correct format for the columns.  Place the correct format of the 
# data in the array @data_output to be printed at the end of each loop.
#
# The printf format and the precision for each parameter are 
# stored in a hash that is returned by the exchange_param_format()
# function.
#
# NOTE: There are many ways to round numbers.  The function used 
#       below converts the number into an integer and then 
#	rounds >=5 up and <5 down.  The number is then converted back
#	to a float.  The Perl Cookbook suggests rounding using printf or
#	sprintf, but fails to mention that it does not work properly 
#	every time.
#
#%format = exchange_param_format();
%format = %{getParams()};

for (my $i = 0; $i <$hyd_size; $i++)
{
        @data_output = ();
        foreach my $elem (@hyd_header)
        {
                if ($elem =~ /_FLAG_W/)
                {
                        push(@data_output, sprintf("%1d", 
				$hyd_hash{$elem}{'data'}[$i]));
                }
		#
		# Get the precision and the printf format 
		#
                else
                {
			#
			# If the precision != 0 - round the element and 
			# store rounded value back into the hash.
			#
			#if ($format{$elem}{'precision'} != 0)
			my $localPrecision;
			if(($localPrecision = getPrecision(\%format, $elem)) != 0)
			{
				$hyd_hash{$elem}{'data'}[$i] = 
					round_float($hyd_hash{$elem}{'data'}[$i], 
					#$format{$elem}{'precision'});
					$localPrecision);
			}
			
                       	push(@data_output, 
				#sprintf($format{$elem}{'printf'}, 
				sprintf($format{$elem},
				$hyd_hash{$elem}{'data'}[$i]));
			
                }
        }
	# print the formated line of data
        print OUTPUT join(",", @data_output), "\n";
}



# 
# this line is required at end the data lines in all exchange files
#
print OUTPUT "END_DATA\n";

#
# close output and print to user that the operation was completed
#
close(OUTPUT) or 
	die "Could not close output file\n";
print STDOUT "The exchange file was successfuly created: $output_name\n";

##END MAIN




#--------------------------------------------------------
# Used to obtain the file names from either command line
# or input.
#
# ARGS: 
#	0 - pointer to ARGV
#	1 - type of file (ex: HYD)
#
# RETURNS:
#	-the file name
#--------------------------------------------------------
sub get_arg
{
	# params
	my $ARGV_ptr = shift(@_);
 	my $type = shift(@_);

	# local vars
	my $name;

	if ($#{$ARGV_ptr} >= 0)
	{	
		$name = shift(@{$ARGV_ptr});
		chomp($name);
	}
	else 
	{
		#PROMP user for the name
		do {
			print  "Enter the name of the $type file: ";
			$name = <STDIN>;
			chomp($name);

		}until (-e $name);
	}	
	return $name;

}

#--------------------------------------------------------
# Used to obtain an array of headers that are not 
# going to be included in the final data product.  
#
# ARGS: 
#	0 - pointer to data hash
#	1 - pointer to array of elements that are 
#	    to be included
#
# RETURNS:
#	array headers that were in the original 
# 	data but are not in the final data product
#--------------------------------------------------------
sub getHeadersNotIncluded
{
	#args
	my $hash_ptr = shift(@_);
	my $array_ptr = shift(@_);

	#vars
	my $FOUND;	#flag for search
	my $elem;
	my $header;
	my @returnArray = ();
	

	
 	foreach $elem(sort keys %hyd_hash)
	{
		#reset flag
		$FOUND = 0;

		#
		#--> diagnostics added by Diggs: 20010802
		#
		print STDERR "*** $elem\t in original hyd_hash\n";
		

		foreach my $header(@{$array_ptr})
		{
		#
		#--> diagnostics added by Diggs: 20010802
		#
		print STDERR "\t*** $header\t in new hyd_hash\n";
			if ($header eq $elem)
			{
				$FOUND=1;
				last;	
			}
		}
		if ($FOUND == 0)
		{	
			push(@returnArray, $elem);
		}
	}
	return @returnArray; 
}




#-----------------------------------------------------------------------
# Used to obtain the name of the output file.  The name is to include 
# section that is within the data file followed by "_hy1.csv"
# An example:
#	P16A_P17A_hy1.csv
#
# ARGS:
#	0 - pointer to the data hash
#
# RETURNS
#	- string containing the ouput file name
#-----------------------------------------------------------------------
sub getOutputName
{
	#arg
	my $hash_ptr = shift(@_);
	my $size = shift(@_);


	#vars
	my $return_String;
	my %sections = ();
	my $value;
	my $i;
	my $output_name = "";

	#
	# go through the data hash and check the values of the sections
	# keep track of the number of each section for possible use later
	#
	
	for ($i=0; $i < $size; $i++)
	{
		$value = $hash_ptr->{'SECT_ID'}{'data'}[$i];
		if ($value ne '')
		{
			if (!(exists $sections{$value})) 
			{
				$sections{$value} = 1;
			}
			else
			{
				$sections{$value}++;
			}
		}	
	}
	$output_name = join('_', sort keys %sections).'_hy1.csv';

	if (-e $output_name) {
        	print  "Output file $output_name exists, overwrite [y/n]: ";
		do {
	        	$y_n = <STDIN>;
		} until ($y_n =~ /y|n/i);
		if (!($y_n =~ /y/i))
		{
		    die "File was not touched..\n";
		}
		else
		{
		    #delete the file to write over
		    unlink($output_name) or 
			die "Could not write over file: $output_name\n";
		}
	}
	return $output_name;
}
