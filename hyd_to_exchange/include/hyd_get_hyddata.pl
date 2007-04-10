#!/usr/bin/perl

#USES
use Fcntl;
use strict;

#CONSTANTS
use constant DEBUG => 0;

#INCLUDES
#require "/home/whpo/jjward/src/exchange_format/whp_to_exchange_code/exchange_get_sumdata.pl";
require "/home/jjward/src/exchange_format/whp_to_exchange_code/exchange_get_sumdata.pl";




#----------------------------------------------------------------
# sub hyd_get_hyddata($filename)
#
# Takes a hyd filename, sum filename, and pointer to the data
# hash.  Calls the sub to read in the sum data.    
# reads in the data from the bottle file and combines the data
# from the sum and bottle files into one large hash.  The hash 
# is then sorted and stored into the pointer hash.  
#
# required files:
#	-/home/whpo/jward/src/exchange_format/whp_to_exchange_code/exchange_get_sumdata.pl
#
# params: (0,1,2)
#	0- $hyd file name
#	1- $sum file name
#	2- $hyd_hash pointer
#		- double nested hash {col_name}-> {unit}
#					       -> {data}
#
# returns: (0,1)
#	0- $no_records
#
# J. Ward	2000.7.28	-original coding
# J. Ward	2000.7.31	-made the hash a double nested hash
# 				to hold the units within the hash
# J. Ward	2000.8.29	-changed sort for station no to 
#				be in the SUM file order
# J. Ward	2000.8.30	-updated to newest exchange format
#				rules..if the time is not in the sum
#				record then the value is set to -999
# J. Ward	2000.9.11	-added foreach to go through the column
#				names and change O18/O16 to O18O16 and
#				FCO2 to PCO2
# J. Ward	2000.10.3	-added the check for -9 values in 
#				the DELC14 or DELHE3 columns..the
#				conversion to -999 takes place and 
#				the user is notified if there are -9 values
#				else the data just copied and formated
#
# NOTE: The bottle files are expected to have unique cast numbers
# 	throughout the file.
#----------------------------------------------------------------
sub hyd_get_hyddata 
{
	
	#params
	my $file_name = shift @_;
	my $sum_file_name = shift @_;
	my $hyd_hash_ptr = shift @_;

	#local vars
	my @buffer = ();
	my @col_name = ();
	my @units = ();
	my $ret_expocode;
	my $num_records = 0;
	my (@cols, $col_no, $line_no);
	my @qual_tags = ();
	my @tmp = ();
	my $er_col;
	my $num_qualt = 0;		
	my $asterisk_format;
	my @asterisk = ();
	my ($stn_no, $cast_no, $press);
	my %tmp_hash;
	my %sum_hash;
	my $qualt_name;
	my @stn_no_order = ();
	my ($loc_DELC14, $loc_DELHE3);
	my %col_loc;
	my $press_loc;
  	my $num_header_lines = 0;	
	my @line = ();


	#
	# open hyd file and place into a buffer
	#
	@buffer = create_file_buffer($file_name);
	

	# 
	# get the sum file information as a hash
	#
	%sum_hash = get_sumdata($sum_file_name, \@stn_no_order);
  		


	##
	# grab the header information
	##
	($ret_expocode, $num_header_lines) = get_header_info(\@buffer, \@col_name);
	





	#
	# create a hash that contains the column names as keys 
	# and the location as an element
	#
	%col_loc = ();
	for (my $i = 0; $i <= $#col_name; $i++)
	{
		$col_loc{$col_name[$i]} = $i;		
	}



	#
	# check for a CTDPRS column, if one does not exist then
	# exit and print error
	#
	if (exists $col_loc{'CTDPRS'}) 
	{
		$press_loc = $col_loc{'CTDPRS'};							
	}
	elsif (exists $col_loc{'CTDRAW'})
	{
		$press_loc = $col_loc{'CTDRAW'};	
	}
	else
	{
		print STDOUT "Error: No CTDPRS column exists to sort by.\n";
		die "Could not continue conversion.\n";
	}

	
	
	
	#
	# get rid of quality field names from the col_name array
	# keep track of number of qualt fields for future use
	#
       	while ($col_name[$#col_name] =~ /QUALT/)
	{
		pop(@col_name); 
		$num_qualt++;
	}
	if ($num_qualt < 1)
	{
		print STDOUT "No quality code fields found in HYD file!\n";
		die "Could not continue conversion.\n";
	}

	$asterisk_format = "a8" x ($#col_name+1);

	#
	#get the units and figure out which params have flags	
	#
	@units = unpack ($asterisk_format, shift(@buffer));
	$num_header_lines++;
        @asterisk = unpack ($asterisk_format, shift(@buffer));
	$num_header_lines++;

	##DEBUG
	#print STDOUT "UNIT AND FLAGS:\n";
	#print STDOUT join("|", @col_name),"\n";
	#print STDOUT join("|", @units),"\n";
	#print STDOUT join("|", @asterisk),"\n";
	##

	#
	# put the units into the hyd hash
	#
	for (my $col = 0; $col <= $#col_name; $col++)
	{ 
		#
		# remove trailing and leading white space in units, this
		# is due to the fact that unpack was used and not split
		# by white (must be done this way due to spaces in units)
		#
		$units[$col] =~ s/^\s+//;
		$units[$col] =~ s/\s+$//;
	 	if ($units[$col] =~ /UMOL\/L/)
		{
			my $er_col = $col+1;
		 	print STDOUT "WARNING: UMOL/L unit found on col $er_col of .HYD file\n";
		 }


		$hyd_hash_ptr->{$col_name[$col]}{'unit'} = $units[$col];
	}

 	#
	# check the format of the data in the hyd file
	# (check that the number of cols are the same 
	# throughtout)
	# calls function -> local -> check_hyd_file()
	#
	if (check_hyd_file(\@buffer, $num_header_lines))
	{
		die "Could not continue conversion.\n";
	}

	#
	# set the number of records to return to the 
	# last index of the buffer+1
	#
	$num_records = $#buffer+1;

	# vars used in for loop
	my @qualt_flags_1 = ();
	my @qualt_flags_2 = ();
	my $qualt_count;
	my $i;
	my $buffer_length = @buffer;
	my %sum_data = ();
	my ($stn_no, $cast_no);
	my $sum_cast_no;
	my @cast_problem = ();
	#my @other_cast_no = ();
	my $rec_no;
	# flags used to specify if the -9.x values should be 
	# converted to -999.x values or not
	my $CONVERT_DELC14 = 0;
	my $CONVERT_DELHE3 = 0;

	###
	# Added 2000.9.29 by JWard
	#
	# check the value of DELC14 and DELHE3 for the
	# missing values of -9 
	#
	# The assumptions made (because assumptions must be made) 
	# here are:
	#	-if no -999 and a good amount(more than two) 
	#	 of -9 values are found then the missing 
	#	 values are -9
	#	-if at least one -999 value is found then
	#	 the missing values are -999
	#
	if (exists $col_loc{'DELC14'})
	{
		$loc_DELC14 = $col_loc{'DELC14'};		
	}else {
		$loc_DELC14 = -1;
	}

	if (exists $col_loc{'DELHE3'})
	{
		$loc_DELHE3 = $col_loc{'DELHE3'};
	} else {
		$loc_DELHE3 = -1;
	}



	# go through the data and check values of
	# DELC14 and DELHE3
	my $num_DELHE3_9 = 0;
	my $num_DELC14_9 = 0;
	my $num_DELHE3_999 = 0;
	my $num_DELC14_999 = 0;
   	for ($rec_no=0 ; $rec_no < $buffer_length; $rec_no++)   
	{			
		@tmp = split(/\s+/, $buffer[$rec_no]);
		if ($tmp[0] eq '') {shift(@tmp);}

		if ($loc_DELC14 != -1)
		{
			if ($tmp[$loc_DELC14] == -9.0) {$num_DELC14_9++;}
			elsif ($tmp[$loc_DELC14] == -999.0) {$num_DELC14_999++;}
		}
		if ($loc_DELHE3 != -1)
		{
			if ($tmp[$loc_DELHE3] == -9.0) {$num_DELHE3_9++;}
			elsif ($tmp[$loc_DELHE3] == -999.0) {$num_DELHE3_999++;}
		}
	}

	if (($num_DELC14_999 == 0) && ($num_DELC14_9 > 1))
	{
		# set flag for conversion;
		$CONVERT_DELC14 = 1;
		print STDOUT "NOTE: -9.x values in DELC14 were converted to -999.x\n";
	}
	else { $CONVERT_DELC14 = 0; }

	if (($num_DELHE3_999 == 0) && ($num_DELHE3_9 > 1))
	{
		# set flag for conversion;
		$CONVERT_DELHE3 = 1;
		print STDOUT "NOTE: -9.x values in DELHE3 were converted to -999.x\n";

	}
	else { $CONVERT_DELHE3 = 0; }






	#
	# create the data hash..it involves building a hash that has a 
	# set of keys for the station , cast , pressure , record number , 
	# and col name.  The reason for this is to quickly sort the large
	# amount of data using three elements.  The record number is there
	# for the case that there is more than one record for the same depth.
	#
	# The hash structure is shown below:
	# {station} -> {cast} -> {CTDPRES} -> {RECNO} -> {col name}
	#
	# The reason for this is the files have to be in order of station
	# number -> each station has to be in order of cast -> each cast has
	# to be in order of pressure -> and if there are multiple of records
	# at the same station,cast,CTDPRES then the records must stay in the
	# order that they were in in the bottle file thus RECNO must be 
	# used...AHHHH  
	# (sorting format request by J. Swift)
	#
	for ($rec_no=0 ; $rec_no < $buffer_length; $rec_no++)	{
		@tmp = split(/\s+/, shift(@buffer));
		$num_header_lines++;
		if (!($tmp[0])) { shift(@tmp); }


		
		$stn_no = $tmp[0];
		$cast_no = $tmp[1];
		$press = $tmp[$press_loc];
		
				
		

		if (!(defined($sum_hash{$stn_no}{$cast_no})))
		{
			push(@cast_problem, "STN: $stn_no CAST:$cast_no");
		}
		$sum_cast_no = $cast_no;

		##
		# added 2000.8.24 - Did not know that the expocode can change 
		# 		    throughout the sum file..problem is fixed
		#		    and each record in the sum file has its own
		#		    exppocode
		#
		$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'EXPOCODE'} = 
			$sum_hash{$stn_no}{$sum_cast_no}{'EXPOCODE'};

		$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'SECT_ID'} = 
			$sum_hash{$stn_no}{$sum_cast_no}{'SECT_ID'};

			
		$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'DATE'} =
				$sum_hash{$stn_no}{$sum_cast_no}{'DATE'};
	
		###
		# 2000.8.30 -	Jim asked that the TIME field be set to -999 if
		#		it is not present.  The change is noted in the 
		#		most recent version of the exchange format and
		#		is handled below
		if ( $sum_hash{$stn_no}{$sum_cast_no}{'TIME'} ne '')
		{
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'TIME'} =
				$sum_hash{$stn_no}{$sum_cast_no}{'TIME'};
		}
		else
		{
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'TIME'} = '-999';
		}


		#
		# get the bottom depth..check for cor. depth then unc. depth..
		# if none exist then set to -999
		#
		if ((defined($sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_C'})) &&
		( $sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_C'} != 0))
		{
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'DEPTH'} =
				$sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_C'};
		} 
		elsif ((defined($sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_U'})) &&
		( $sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_U'} != 0))
		{
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'DEPTH'} =
				$sum_hash{$stn_no}{$sum_cast_no}{'DEPTH_U'};
		}
		else
		{
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'DEPTH'} = '-999';
		}


		# 
		# get the LONGITUDE and LATITUDE
		#
		$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'LONGITUDE'} =
			$sum_hash{$stn_no}{$sum_cast_no}{'LONGITUDE'};

		$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{'LATITUDE'} =
			$sum_hash{$stn_no}{$sum_cast_no}{'LATITUDE'};


		

		#
		# grab the quality columns
		#
		if ($num_qualt == 2)
		{
			@qualt_flags_2 = split(//, pop(@tmp));
		}
		@qualt_flags_1 = split(//, pop(@tmp));





		#
		# Grab all of the data values from the bottle file.  
		# The rule is, if there is  a -9 value then set to -999.x.
		#
		$qualt_count = 0;
		for ($i=0 ; $i <= $#col_name ; $i++)	
		{
			#
			# change from -9 to -999 => see exchange format 
			# Note that the values for 'missing data' in DELC14
			# and DELHE3 should be -999.x in the original WOES
			# format..but in many cases the values are given as
			# -9.x which can legaly be a measured value..in that 
			# case all -9.x values found are to be considered
			# 'missing values'..this brings in a problem that, 
			# DELHE3 and DELC14 columns should have -9.x values
			# changed to -999.x in some cases and not converted in
			# other cases.
			#
			# The case of -9.x used to represent 'missing values'
			# in DELHE3 and DELC14 need to be displayed to the user
			# for the record.  This is done above
			#



			# CASE1: Convert any data column that is not DELHE3
			if (($i != $loc_DELC14) && ($i != $loc_DELHE3))
			{
				# convert
				if ($tmp[$i] == -9.0) {$tmp[$i] = -999.0;}
			}
			# CASE2: Convert the DELC14 column if flag is set
			elsif (($i == $loc_DELC14) && ($CONVERT_DELC14 == 1))
			{
				# convert
				if ($tmp[$i] == -9.0) {$tmp[$i] = -999.0;}
			}
			# CASE3: Convert the DELC14 column if the flag is set
			elsif (($i == $loc_DELHE3) && ($CONVERT_DELHE3 == 1))
			{
				# convert
				if ($tmp[$i] == -9.0) {$tmp[$i] = -999.0;}
			}
			$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$col_name[$i]} =
				$tmp[$i];

			#if a quality flag is associated with it
			if ($asterisk[$i] =~ /\*\*\*/)
			{
				if (!(defined($qualt_flags_1[$qualt_count])) ||
				(($num_qualt == 2) && (!(defined($qualt_flags_2[$qualt_count])))))
				{
					print STDOUT "The bottle file does not have the correct number of flags.\n";
					die "Could not continue conversion.\n";
				}

				$qualt_name = "$col_name[$i]".'_FLAG_W';

				if ($num_qualt == 2)
				{
					if (($qualt_flags_2[$qualt_count] == 1)&&
						($qualt_flags_1[$qualt_count] != 1))
					{
						$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$qualt_name} = 
							$qualt_flags_1[$qualt_count];
					}
					else
					{
						$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$qualt_name} = 
							$qualt_flags_2[$qualt_count];
					}
				}
				else
				{
					$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$qualt_name} =
						$qualt_flags_1[$qualt_count];
				}
				$qualt_count++; 
			}#end if		
		}#end for columns
	}#end for


	if ($#cast_problem >= 0)
	{
		print "No sum data was found for:\n";
		print join("\n", @cast_problem);
		print "\n";
		die "Could not continue conversion.\n";
	}


		

	#
	# sort into final format, sort in numerical order (station is
	# sorted by alpha comparison)
	# station->cast->pressure->recno 
	#
	my $counter = 0;
	my $rec_no;
	my $elem;
	foreach $stn_no (@stn_no_order)
	{
		if (exists($tmp_hash{$stn_no}))
		{
		foreach $cast_no (sort {$a <=> $b} keys(%{$tmp_hash{$stn_no}}))
		{
			foreach $press (sort {$a <=> $b} keys(%{$tmp_hash{$stn_no}{$cast_no}}))
		 	{
				#print STDERR "STN: $stn_no CAST: $cast_no PRES: $press\n";
				foreach $rec_no ( sort {$a <=> $b} keys(%{$tmp_hash{$stn_no}{$cast_no}{$press}}))
				{
					foreach $elem ( keys %{$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}} )
					{
						#print STDERR $elem.':'.$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$elem}.",";
						$hyd_hash_ptr->{$elem}{'data'}[$counter] = 
							$tmp_hash{$stn_no}{$cast_no}{$press}{$rec_no}{$elem};		
					}
					$counter++;
					#print STDERR "\n";
				}

			}
		}
		}#end if
	}
	# get rid of $tmp_hash
	undef (%tmp_hash);

	return ($num_records); 
}





#--------------------------------------------------------------------
# sub create_file_buffer($file_name)
#
# 	Opens the file and places text into an array.
#
# 	Parameters
#		- $file_name - name of file to open and read in
#
#	Returns
#		- @buffer
#--------------------------------------------------------------------
sub create_file_buffer
{

	#params
	my $file_name = shift(@_);
	my @buffer = ();

	sysopen (HYD_FILE, $file_name, O_RDONLY) or 
		die "Could not open $file_name for reading. \n";
	@buffer = <HYD_FILE>;
	close(HYD_FILE);
	chomp(@buffer);
	return @buffer;
}



	
#--------------------------------------------------------------------
# sub get_header_info($file_name)
#
# 	Obtains the header information from the file and corrects/
#	changes names of headers in order to convert to excahnge.
#
# 	Parameters
#		- $buffer_ptr  - pointer to the buffer array
#		- $col_name_ptr  - pointer to array of col names 
#	Returns
#		- @buffer
#--------------------------------------------------------------------
sub get_header_info
{
	# params
	my $buffer_ptr = shift(@_);
	my $col_name_ptr = shift(@_);

	# local vars
	my $ret_expocode;
	my $num_header_lines;
	my @col_name;
	my @line;


	#
	#Get expocode
	#
	@line = split(/\s+/, shift(@{$buffer_ptr}));
	$num_header_lines++;
	if ($line[0] eq '')  {shift(@line);}
	$ret_expocode = $line[1];
	#
	# replace any '/' char with '_' inexpocode
	#
	$ret_expocode =~ s/\//\_/;


	#get col names	
	@col_name = split(/\s+/, shift(@{$buffer_ptr}));
	$num_header_lines++;
	if ($col_name[0] eq '')   { shift(@col_name);} #get rid of null element

	#
	# Go through the headers and change any fields that are needed to change
	# FCO2 = PCO2 -> change any FCO2 to PCO2
	# PC02 = PCO2 -> if a zero is used an not the letter 'O', change to 'O' 
	# O18/O16     -> change to O18O16 due to the name in the exchange format
	#	      -> if zero is used and not the letter 'O', change to 'O'
	#
	foreach my $elem (@col_name)
	{
		if (($elem eq 'FCO2')||($elem eq 'FC02')||($elem eq 'PC02'))
		{
			print STDOUT "NOTE: $elem changed to PCO2 in the conversion\n";
			$elem = 'PCO2';
		}
		elsif (($elem eq 'O18/O16')||($elem eq '018/016'))
		{
			$elem = 'O18O16';
		}
	}

	@{$col_name_ptr} = @col_name;
	return ($ret_expocode, $num_header_lines);
}

#--------------------------------------------------------------------
# sub check_hyd_file(@buffer_ptr)
# S. Diggs mod. by J. Ward
#
# 	Checks the number of columns to see if they are the
# 	same throughout, they should be!
#
# 	Parameters
#		- @buffer_ptr - pointer to file buffer (arrray)
#		- $num_headers - number of header lines that were removed
#
#	Returns
#		- 0 - file is ok
#		- 1 - file is bad
#--------------------------------------------------------------------
sub check_hyd_file
{
	#param
	my $buffer_ptr = shift(@_);
	my $num_headers = shift(@_);

	#vars
	my ($x , $old_num_fields, @tmp);
	my $ret_stat = 0;
	my $exact_line = 0;

	@tmp = split(/\s+/, $buffer_ptr->[0]);
	if ($tmp[0] eq '')
	{
		shift(@tmp);
	}
	$old_num_fields = $#tmp;
	for ($x=1 ; $x <=  $#{$buffer_ptr} ; $x++)     {

        	@tmp = split /\s+/,$buffer_ptr->[$x];
		if ($tmp[0] eq '')
		{
			shift(@tmp);
		}
        	if (($#tmp != $old_num_fields) && ($x > 4))     {
			$exact_line = $x + $num_headers;
			print STDOUT "HYD file problem line: $exact_line\n"; 
			$ret_stat = 1;
        	}
	}
	return $ret_stat;
}
1;

