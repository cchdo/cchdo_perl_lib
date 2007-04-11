#!/usr/bin/perl -w

#sub main_driver_depth	{
#
#	require "read_anyfile.pl";
#	my (%depth_hash, $filename);
#
#	print STDOUT "Input a sumfile name: ";
#	chomp ($filename=<STDIN>);
#	my %hash_buf = &read_anyfile($filename);
#
#	%depth_hash = &get_depth_and_type( @{ $hash_buf{'FILE_DATA'}});
#
#	my @valid_keys = (sort (keys %depth_hash));
#
#	print STDOUT "Valid keys after processing are: @valid_keys \n";
#
#	my $hash_size = $#{ $depth_hash{'DEPTH'} };
#
#	print STDOUT "Hash size is: $hash_size for key = DEPTH\n";
#	print STDOUT "TYPE = $depth_hash{'TYPE'} \n";
#
#	for (my $i=0 ; $i <= $#{ $depth_hash{'DEPTH'} } ; $i++)	{
#
#		print STDOUT " depth(${i}) =\t $depth_hash{'DEPTH'}[$i] \n";
#	}
#
#}

#----------------------------------------------------------------------
#	GET_DEPTH_AND_TYPE:	figures out which depth types are
#				available from the SUMFILE input
#				buffer and uses one (COR, UNC, UNK,
#				in that order).  
#
#				Returns a hash with two keys 'DEPTH'
#				and 'TYPE' defined, where 'DEPTH' has
#				an array of depths for its value.
#				'TYPE' will be returned as either 
#				'COR', 'UNC', or 'UNK'.
#
#	2001.09.21:	S. Diggs	initial coding
#
#
#----------------------------------------------------------------------
sub	get_depth_and_type	{

	my @input_buffer = @_;
	my (@depth_pos, %depth_type, %depth_data);
	my ($last_headerline, $dtype);
	
	#
	#---> Search for # of headers
	#
	for (	$last_headerline=0 ; 
		$last_headerline <=$#input_buffer ; 
		$last_headerline++)	{
	
		print STDOUT "Searching through header line # ", 
			$last_headerline+1, "\n";
		
		if ($input_buffer[$last_headerline] =~ /^-----/g)	{
			#found end of headers
			print STDOUT "Stopping at header line ", 
				++$last_headerline, "\n";
			last;
		}
	}
	
	#
	#--> Search backwards for DEPTH headers
	#
	#print STDOUT "Last header line is $last_headerline\n";
	my @depth_headers = grep(/depth/ig, 
			split(/\s+/, $input_buffer[$last_headerline-2]));

	my $last_pos = 0;
	for (my $i=0 ; $i <= $#depth_headers ; $i++)	{
	
		if ($i) { $last_pos = $depth_pos[$i-1] + 1; }
		$depth_pos[$i]  = index($input_buffer[$last_headerline-2],
					'DEPTH', $last_pos);
					
	}
	print STDOUT "Depth headers are: @depth_headers --> @depth_pos \n";
	
	#
	#--> Determine the DEPTH types we have by grabbing the words
	#--> COR or UNC
	#
	
	#
	#--> back up one line and search based on where we found 
	#the word(s)'DEPTH'
	#
	
	my $depth_type_line = $input_buffer[$last_headerline-3];
	
	print STDOUT "Search line: ",
			"--> $depth_type_line\n";
	for (my $i=0 ; $i <= $#depth_pos ; $i++)	{
	
		my $dtype = substr($depth_type_line, $depth_pos[$i], 5);
		$dtype =~ s/\s+//g;
		$depth_type{$dtype} = $depth_pos[$i];
	}
	foreach my $p	(sort keys %depth_type)	{
	
		print STDOUT "Depth_Key = $p start = $depth_type{$p} \n";
	}
	
	#
	#--> Now, determine the DEPTH columns we'll use (if we have a choice)
	#
	
	if (grep (/cor/i, (keys %depth_type)))		{
				
		print "Using CORRECTED DEPTH\n";
		%depth_data = &extract_depth_vals(	$last_headerline,
							$depth_type{'COR'},
							@input_buffer);
		$depth_data{'TYPE'} = 'COR';
		
	} elsif	(grep (/unc/i, (keys %depth_type)))	{
	
		print "Using UNCORRECTED DEPTH\n";
		%depth_data = &extract_depth_vals(	$last_headerline,
							$depth_type{'UNC'},
							@input_buffer);
		
		$depth_data{'TYPE'} =  'UNC';
	
	} else					{
		# default case						

		print "Using UNKNOWN DEPTH\n";
		%depth_data = &extract_depth_vals(	$last_headerline,
							$depth_pos[0],
							@input_buffer);
		$depth_data{'TYPE'} = 'UNK';
	}
	
	my %return_hash = %depth_data;
}

#---------------------------------------------------------------------
#	EXTRACT_DEPTH_VALS:	extracts the indicated DEPTH values
#				from the input buffer (the contents of
#				a WOCE formatted SUMFILE).
#
#	S. Diggs:	2001.09.21:	initial coding
#
#---------------------------------------------------------------------
sub extract_depth_vals	{

	my $number_of_headers = shift @_;
	my $start_position = shift @_;
	my @data_buffer = @_;
	
	my %depth_hash = ();
	
	print STDOUT "\t --> Start position = $start_position , ",
			"total # of lines = $#data_buffer \n",
			"\t --> Number of headers is $number_of_headers\n";
	
	my $unpack_format = " A".$start_position . " A5";
	for (my $i=0 ; $i  <= ($#data_buffer - $number_of_headers) ; $i++)	{
	
	
		my ($tmp_spaces, 
		$tmp_depth_val) 
			= unpack($unpack_format, 
				$data_buffer[($i + $number_of_headers)]);

		$tmp_depth_val =~ s/\s+//g;
		
		#if ( !($tmp_depth_val) or
		#	($tmp_depth_val < 0)) { $tmp_depth_val = -999; }
		
		if ( ($tmp_depth_val =~ /'----'/) or !($tmp_depth_val) or
			($tmp_depth_val < 0)) { $tmp_depth_val = -999; }		
		
		$depth_hash{'DEPTH'}[$i] = $tmp_depth_val;
		
		print STDOUT sprintf("%04d",$i) ."\t DEPTH = ",
			$depth_hash{'DEPTH'}[$i] . "\n" if (!($i%50));
	}
	
	
	my %retval = %depth_hash;
}



1;
