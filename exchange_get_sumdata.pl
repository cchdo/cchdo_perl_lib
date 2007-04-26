#!/usr/local/bin/perl
##############################
#  EXCHANGE_GET_SUMDATA.PL
#
# 	Procedures:
#		-get_sumdata($filename)
#			->this procedure can be used to read in 
#			WOES formated sum files given the data 
#			header is in the correct format
#
#	Notes:
#		-all code is contained within the one procedure, 
#		 no "main" function code exists
##############################


#--------------------------------------------------------------------------
#	get_sumdata($filename) 
#	Reads in the sum file for the hyd data files.  (CHANGED: Only the ROS 
#       type of code BO,BE, and EN are returned.)
#
#	params:
#		-$filename --> name of the SUM file 
#
#	returns:
#		-%final_sum_hash --> the sum data as a hash
#
#	required files:
#		-/home/whpo/jjward/src/tools/PERL/conv_date.pl
#		-/home/whpo/jjward/src/tools/PERL/conv_lat_lon.pl
#
#
#	J. Ward		2000.7.26	-modified so that only ROS type
#					 are read in
#	J. Ward		2000.8.1	-modified so that only BE,BO,EN 
#					 code are read in
#	J. Ward		2000.8.23	-modified so that the procedure
#					 can handle files that have been 
#					 changed through running 
#					 fix_sum_data.pl -> now handles
#					 '?' as blank entry
#	J. Ward		2000.8.29	-modified so that the stations
#					 are returned as an array in the
#					 order that they were removed from
#					 the sum file
#					++-
#	J. Ward		2000.10.23	-modified to return data for all 
#					 types of casts (even LVS)
#	J. Ward		2000.11.8	-removed last change (only returns
#					 CTD|ROS casts)
#	J. Ward		2000.12.8	-added LVS casts to the data 
#					 returned
#--------------------------------------------------------------------------

#USES
use strict;
use Fcntl;

#CONSTANTS
use constant DEBUG => 0;

#INCLUDES
require "/usr/local/cchdo_perl_lib/conv_date.pl";
require "/usr/local/cchdo_perl_lib/conv_coords.pl";


sub get_sumdata	{
	# flag
	my $RET_STN = 0;

	# params
	my $filename = shift(@_);
	my $stn_ptr = shift(@_);

	if (defined($stn_ptr))
	{
		$RET_STN = 1;
	}

	
	# local vars
	my @sumbuf = ();
	my (%sum_hash, $i, $j, $k, $num_headline);
	my $code;
	my @head_name;
	my (@fixed_field)= 
		qw (EXPOCODE SECT STNNBR CASTNO TYPE DATE TIME CODE );
	my @position = qw(LATITUDE LONGITUDE NAV);
	my %final_sum_data_hash;	
	my $stn_no;
	my $cast_no;

	sysopen (INPUT, $filename, O_RDONLY) or	
		die "Cannot open $filename for reading.\n";
	chomp(@sumbuf=<INPUT>);
	close(INPUT);

	
	#
	# Find out how many header lines are in this file
	#
	for ($num_headline=0 ; $num_headline < $#sumbuf ; $num_headline++) {
		if (grep(/-------/, $sumbuf[$num_headline]))	{
			last;
		}
	}
	
	@head_name = split (/\s+/, $sumbuf[$num_headline-1]);
	if ($head_name[0] eq '') { shift(@head_name);}

	if (DEBUG) {print STDOUT "Headers are : ", join("|", @head_name), "\n";}
	
	my $navpos =   index($sumbuf[$num_headline-1], 'DEPTH');

	#
	# get the second DEPTH field if there is one, else -1
	#
	my $navpos_2 = index($sumbuf[$num_headline-1], 'DEPTH', ($navpos+5));  
	my @stations = ();


	#
	# check that the number of columns up to the depth column are the same
	# amount..the file can not be read unless all of the columns up to the 
	# depth are filled in
	# -use fix_sum_file.pl to fill in any empty column values with '?'
	#
	my $no_cols;
	my @line;
	for ($i =($num_headline+1); $i <= $#sumbuf; $i++)
	{
		@line = split(/\s+/,substr($sumbuf[$i], 0, ($navpos-1)));
		if ($line[0] eq '')
		{
			shift(@line);
		}

		if ($i == ($num_headline+1))
		{
			$no_cols = $#line;
		}
		else
		{
			if ($#line != $no_cols)
			{
				die "There are missing column values in the sum file at line $i.\n";
			}
		}
	}

	for ($i=($num_headline+1) ; $i <= $#sumbuf; $i++)	{
		my @tmp = split(/\s+/,$sumbuf[$i]);	
		if ($tmp[0] eq '') { shift(@tmp); }


		$code = $tmp[7];
		$stn_no = $tmp[2];
		$cast_no = $tmp[3];
		#print "ST: $stn_no CST:$cast_no COD:$code\n";

		#
		# Assuming that the stations are all grouped together
		# if the station is not equal to the last station in the
		# array then the station is placed on the array
		#
		if (($RET_STN == 1) && ($stn_ptr->[$#{$stn_ptr}] ne $stn_no))
		{
			push(@{$stn_ptr}, $stn_no);
		}


		if (DEBUG) {print STDOUT "CAST: $tmp[3] STN: $tmp[2] TYPE: $tmp[4] CODE: $tmp[7]\n";}

		# added "BOT" to the cast types on 081301 - bren
		if (($tmp[4] =~ /BOT|ROS|CTD|LVS/) && ($code =~ /BE|BO|EN|UN|DE|MR|RE/))
		{
			if (DEBUG) {print "$stn_no $cast_no $code\n";}

			$sum_hash{$stn_no}{$cast_no}{'EXPOCODE'}{$code} = $tmp[0];
			$sum_hash{$stn_no}{$cast_no}{'SECT_ID'}{$code} = $tmp[1];
			if (DEBUG) {print "CAST: $cast_no STATION: $stn_no  SECT: $tmp[1]\n";}

			for (my $j=5 ; $j <= $#fixed_field ; $j++)	{
			        if ($j==7){ next;}
				$sum_hash{$stn_no}{$cast_no}{$fixed_field[$j]}{$code} = $tmp[$j];
			}


			if (($tmp[8] ne '?') && ($tmp[9] ne '?') && ($tmp[10] ne '?'))
			{
				unless($sum_hash{$stn_no}{$cast_no}{'LATITUDE'}{$code} = 
					conv_coords($tmp[8],$tmp[9],$tmp[10]))
					{print STDOUT "WARNING: Bad position value on sum data line $i.\n";}

			}
			else 
			{
				$sum_hash{$stn_no}{$cast_no}{'LATITUDE'}{$code} = '';
			}
	

			if (($tmp[11] ne '?') && ($tmp[12] ne '?') && ($tmp[13] ne '?'))
			{
				unless($sum_hash{$stn_no}{$cast_no}{'LONGITUDE'}{$code} = 
					conv_coords($tmp[11], $tmp[12], $tmp[13]))
					{print STDOUT "WARNING: Bad position value on sum data line $i.\n";}
			}
			else
			{
				$sum_hash{$stn_no}{$cast_no}{'LONGITUDE'}{$code} = '';
			}
		
		
		

			#
			# Check if there is a corrected depth value
			#
			my $tmp_depth =  substr($sumbuf[$i], $navpos, 5);
			my $tmp_depth_cor = -1;
			if ($navpos_2 != -1)
			{
				$tmp_depth_cor = substr($sumbuf[$i], $navpos_2, 5);
			} 
			if ($tmp_depth_cor > 0) {
				$sum_hash{$stn_no}{$cast_no}{'DEPTH_C'}{$code} =  $tmp_depth_cor;
			}
			else {
				$sum_hash{$stn_no}{$cast_no}{'DEPTH_C'}{$code} = '';
			}
			if ($tmp_depth > 0) {
				$sum_hash{$stn_no}{$cast_no}{'DEPTH_U'}{$code} = $tmp_depth;
			}
			else {
				$sum_hash{$stn_no}{$cast_no}{'DEPTH_U'}{$code} = '';
			}

			#
			# Fix the date, change to YYYYMMDD format 
			#
			if ($sum_hash{$stn_no}{$cast_no}{'DATE'}{$code} ne '?')
			{
				$sum_hash{$stn_no}{$cast_no}{'DATE'}{$code} = 
					conv_date($sum_hash{$stn_no}{$cast_no}{'DATE'}{$code});
			}
	
		}
		

	}
	

	#
	# go through the quad nested hash and turn into final triple nested hash (only include one type per cast)
	# %hash{stn_key}{cast_key}{col_name}{type} => %hash{stn_key}{cast_key}{col_name}
	#
        my $cast_key;
	my $header_key;


	foreach my $stn_key(keys %sum_hash)
	{
		foreach $cast_key(keys %{$sum_hash{$stn_key}})
		{
			foreach $header_key(keys %{$sum_hash{$stn_key}{$cast_key}})
			{
				
				# 
				# get the data from one of the three codes (BO,BE,EN...) in that 
				# priority order..the first available data is taken.  If none of the
				# above is availabel then the data is taken from another code, else
				# is set to blank if no other code is 
				#
				if (($sum_hash{$stn_key}{$cast_key}{$header_key}{'BO'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'BO'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} = 
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'BO'};
				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'BE'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'BE'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =  
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'BE'};

				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'EN'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'EN'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'EN'};
				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'UN'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'UN'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'UN'};
				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'DE'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'DE'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'DE'};
				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'MR'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'MR'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'MR'};
				}
				elsif (($sum_hash{$stn_key}{$cast_key}{$header_key}{'RE'} ne '') &&
					($sum_hash{$stn_key}{$cast_key}{$header_key}{'RE'} ne '?'))
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =
						$sum_hash{$stn_key}{$cast_key}{$header_key}{'RE'};
				}
				else
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} = '';
				}

				#
				# if the item in the EXPOCODE then replace any '/' with '_'
				#
				if ($header_key eq 'EXPOCODE')
				{
					$final_sum_data_hash{$stn_key}{$cast_key}{$header_key} =~ s/\//\_/;
				}
				if (DEBUG) {
					print STDOUT "ST: $stn_key CST: $cast_key ITEM: $header_key  ";
					print STDOUT $final_sum_data_hash{$stn_key}{$cast_key}{$header_key}."\n";
				}
			}##end header foreach

		}##end cast foreach
	}##end station foreach

	

	#
	# return the final three dimensional hash 
	#
	return %final_sum_data_hash;
}
1;

