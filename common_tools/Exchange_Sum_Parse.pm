#!/usr/bin/perl

#use strict;

sub Exchange_Sum_Parse	{

#require 'read_anyfile.pl';

############################################################################
#  EXCHANGE_SUM_PARSE:  a PERL subroutine to parse a given WOCE sumfile
#			into a hash that can be manipulated by exchange
#			main code.
#
#			Program accepts one sumfile as argument:
#			- selects corrected bottom depth when present 
#			(otherwise uses uncorrected or unlabeled depth 
#			given, and informs user of which depth is getting 
#			used) or fills depth hash parameter with -9 for 
#			no depth. 
#			-converts WOCE sumfile lat/lon into degrees and 
#			decimal degrees with +/- for hemispheres. 
#			-converts WOCE sumfile date of mmddyy to 
#			yyyymmdd. 
#			-while also checking for non-numeric
#			stations and filling these with an "X" (this is
#			a Diggs' holdover and should be discussed as to
#			it's relevance in exchange file generation and 
#			removed if necessary).
#
#  Danie B. Kinkdade:	2001.07.25	Initial coding.
#
# additions by bren:
# code no longer prints to STDOUT. It only does error reporting to STDERR but
# doesn't print any diagnostic info anymore. Also, the module now returns an
# array with two elements. The first element is a referance to the parsed
# sumfile in hash format. the second element is a string that is the type
# of depth that was found (either "COR DEPTH", "UNC DEPTH", or "UNKNOWN").
# 
# M. Brendan Mills:	2001.09.18:	added range checking for longitude 
#					and latitude.  also code fills in 
#					depth, lat, lon, and nav with unknown 
#					values if non existent.
#
# S. Diggs:		2001.09.24:	numerous cosmetic and functional
#					changes.
#
# S. Diggs:		2001.11.06:	code now accepts non-numeric station
#					numbers.  Still gives warning.
#
# S. Diggs:		2001.12.19:	changed logic for parsing LAT/LONs.
#					Bren/Danie had it doing boolean logic
#					for the existence of the positions.
#					That failed with 0. Lats or 0. Lons
#					Changed code to strictly check for the
#					existence of a numeric CHARACTER.
#					
############################################################################

	my ($filename, %data_hash, $num_data_lines, %final_hash);
	my (@fixed_field) = (	qw	(EXPOCODE SECT STNNBR CASTNO TYPE 
					DATE TIME CODE LATITUDE LONGITUDE 
					NAV DEPTH ) );

	if($#_ != 0){
		die("usage is: exchange_sum_parse(\"<argument>\")");
	}
	$filename = $_[0];

#
#Sending file name to subroutine where work is done:
#
	my @returnArray = &get_sumdata($filename);

	$num_data_lines = $#{$data_hash{$fixed_field[0]}};

	@returnArray;

#--------------------------------------------------------------------
#SUBROUTINE BEGINS HERE:
#--------------------------------------------------------------------
#	GET_SUMDATA.PL:	a Perl subroutine that reads in the flexible
#			WOCE summary file format and returns a fixed 
#			field output file with the most of data
#			in a fixed format.
#
#	
#	D. Bartolacci:	2001.07.19  Canabalized from S. Diggs (1999.12.21)
#			heavily modified.
#--------------------------------------------------------------------
	sub get_sumdata	{
	
	#require "get_depth_and_type.pl";
	#
	#initialize/declare important players:
	#
		my ($filename) = shift(@_);
		my (%sum_hash, $i, $j, $k, $num_headline);
		my (@sumbuf, @head_name);
		my($uncdepthpos, $cordepthpos, $depthpos, $unkdepth_header);

		my (@fixed_field) = qw (EXPOCODE SECT STNNBR CASTNO TYPE DATE TIME CODE);
		my(@position)	= qw(LATITUDE LONGITUDE NAV);

		my $original_depth_header;
#
#Opening file passes from main:
#	
#		open(INPUT, $filename) or
#			die "Cannot open SUMFILE=${filename} for reading";
#		chomp(@sumbuf=<INPUT>);
#		close(INPUT);

		my %full_sumfile_hash = &read_anyfile($filename);
		@sumbuf = @{ $full_sumfile_hash{'FILE_DATA'} };	
		
		print STDOUT "1st 6 lines:\n",
				join("\n", @sumbuf[(0..5)]), "\n\n";	

#
#--> Find where last header line is, and how many header lines are in file
#
		for ($num_headline=0 ; $num_headline < $#sumbuf ; $num_headline++) {
			if (grep(/-------/, $sumbuf[$num_headline]))	{
				last;
			}
		}

		@head_name = split (/\s+/, $sumbuf[$num_headline-1]);

#----------------------------------------------------------------
#working on depth parameter:  finding if depth is reported, and
#if reported depths are corrected, uncorrected, or perhaps both
#were supplied.  if both depths are supplied, use corrected where
#reported.  If only one depth is supplied report which it is.
#----------------------------------------------------------------
#
#check to see how many depth fields (columns) there are:
#

		#
		#--> SCD: 2001.09.25: New routine to get depth and type
		#
		my %sum_depth_hash = &get_depth_and_type(@sumbuf);

#
#splitting up parameter data by white space:
#

		for ($i=0 ; $i < ($#sumbuf - $num_headline); $i++)	{

			my @tmp = split(/\s+/,$sumbuf[$i+$num_headline+1]);	

			for ($j=0 ; $j <= $#fixed_field ; $j++)	{
#
#watch out for non-numeric station numbers:
#
				if (	($fixed_field[$j] =~ /stnnbr/i) &&
						($tmp[$j] !~ /^\d/))	{

					#$sum_hash{$fixed_field[$j]}[$i] = 'X';
					print STDERR 
						"**WARNING: non-numeric STNNBR at $i**\n",
						"\tDUMP: fixed_field = $fixed_field[$j]\n",
						"\tDUMP: tmp[j] = $tmp[$j]\n";
						
					#next;
				}

				$sum_hash{$fixed_field[$j]}[$i] = $tmp[$j];
			}

#
#Grabbing lat/lon and converting them to decimal degrees
#and converting E or W hemisphere to +/-:
#

			if (($tmp[8] ne '')&& ($tmp[9] ne '')){
			
				$sum_hash{'LATITUDE'}[$i] = ($tmp[8] + ($tmp[9]/60.));
				if($tmp[10]){
					if ($tmp[10] =~ /s/i) { $sum_hash{'LATITUDE'}[$i] *= -1.0;}
			}  
				
					
# do range checks
				if((($sum_hash{'LATITUDE'}[$i] > 90) || 
							($sum_hash{'LATITUDE'}[$i] < -90))
						&& ($sum_hash{'LATITUDE'}[$i] != -999)){

# if problem found, ask for guidance from the user.
FOO: 					print(STDERR "Bad latitude value of \"".
							($sum_hash{'LATITUDE'}[$i]).
							"\" found on line #".
							($i+$num_headline+1).
							"\nContinue? [y]es|[n]o: ");
					chomp(my $continue = <STDIN>);
					if($continue =~ /^n/){
						die("$!");
					}
					elsif($continue =~ /^y/){
						$sum_hash{'LATITUDE'}[$i] = -999.;
					}
					else{goto(FOO);}
				}

			}else{$sum_hash{'LATITUDE'}[$i] = -999.;}

# same for longitude
			if (($tmp[11] ne '')&& ($tmp[12] ne '')){
				$sum_hash{'LONGITUDE'}[$i] = ($tmp[11] + ($tmp[12]/60.));
				if($tmp[13]){
					if ($tmp[13] =~ /w/i) { $sum_hash{'LONGITUDE'}[$i] *= -1.0;}
			}  else			{
			
				print STDERR "Problems with LONGITUDES at ",
						"STN ",
						
				"\n";
			}

				if((($sum_hash{'LONGITUDE'}[$i] > 180) || 
							($sum_hash{'LONGITUDE'}[$i] < -180))
						&& ($sum_hash{'LONGITUDE'}[$i] != -999)){
BAR: 					print(STDERR "Bad latitude value of \"".
							($sum_hash{'LONGITUDE'}[$i]).
							"\" found on line #".
							($i+$num_headline+1).
							"\nContinue? [y]es|[n]o: ");
					chomp(my $continue = <STDIN>);
					if($continue =~ /^n/){
						die("$!");
					}
					elsif($continue =~ /^y/){
						$sum_hash{'LONGITUDE'}[$i] = -999.;
					}
					else{goto(BAR);}
				}
			}else{$sum_hash{'LONGITUDE'}[$i] = -999.;}

			if($tmp[14]){
				$sum_hash{'NAV'}[$i]	= $tmp[14];
			}else{$sum_hash{'NAV'}[$i] = "UNK";}


#
#Writing correct depth field into hash depending on
#whether none, one or two fields were found in file:
#
#			if($no_of_depth_fields == 0){
#				$sum_hash{'DEPTH'}[$i] = -9;
#			}
#			elsif($no_of_depth_fields == 1 ) {
#				if($tmp[15]){
#					$sum_hash{'DEPTH'}[$i] = $tmp[15];
#				}
#				else{$sum_hash{'DEPTH'}[$i] = -999.;}
#			} 
#			else
#			{
#				my($temp_cordepth) = 
#					substr($sumbuf[$i+$num_headline+1], ($cordepthpos-2), 7);
#
#				$sum_hash{'DEPTH'}[$i] = $temp_cordepth;
#			}			
#
#
#Reformatting the date into "yyyymmdd":
#
			#
			#--> Quick hack fix for year 2000 bug in WOCE format
			#
			my $sub_year_date = substr($sum_hash{'DATE'}[$i],4,2);
			if ($sub_year_date < 20)	{
			
				#print STDOUT "\t $sub_year_date :",
				#	"PRE 1920 or after year 2000 data!\n";
				$woce_century = 2000;
			} else				{
				#print STDOUT "($sub_year_date : data assumed to be 1900 + year)\n";
				$woce_century = 1900;
			}
			$sum_hash{'DATE'}[$i]	=
				($woce_century + $sub_year_date) .
				sprintf("%02d",substr($sum_hash{'DATE'}[$i],0,2)).
				sprintf("%02d",substr($sum_hash{'DATE'}[$i],2,2));
		}

		my @headerArray = qw(
				EXPOCODE
				SECT
				STNNBR
				CASTNO
				TYPE
				DATE
				TIME
				CODE
				LATITUDE
				LONGITUDE
				NAV
				DEPTH
				    );

		foreach my $header (@headerArray){
			if(!$sum_hash{"$header"}){	
				$sum_hash{"$header"} = "UNKNOWN";
			}
		}
		#
		#--> print out what we think the ORIGINAL DEPTH HEADER IS
		#--> (S. Diggs: 2001.09.21)
		#
		#print STDERR "IN subroutine: original depth header is: ",
		#		$original_depth_header, "\n";
		
		#my @returnArray = (\%sum_hash, $original_depth_header);
		my @returnArray = (\%sum_hash, \%sum_depth_hash, 
				$full_sumfile_hash{'Date_Last_Modified'});
	}
}
1;
