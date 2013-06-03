#!/usr/bin/perl -w
#
#	DECODE_WCTD_VALS:	a Perl script that will decode 
#				WHPO (WOCE) CTD file data values.  
#				Returns a multi-dimensional
#				hash containing CTDPRS, CTDSAL, etc. 
#
#	S. Diggs:	2001.09.10:	initial coding
#------------------->
#
#
sub decode_wctd_vals {

	my $num_header_lines = 6;
	my %val_hash = ();
	my $p_name = 0;
	
	my $orig_file_ref	= shift(@_);
	my $param_head_ref	= shift(@_);
	my $units_head_ref	= shift(@_);
	
	my @orig_file		= @$orig_file_ref;
	my @param_header	= @$param_head_ref;	
	my @units_header	= @$units_head_ref;	

	#DECODE
	print STDERR " ------> PARAM_HEADERS are: @param_header \n";
	
	#--> add the params/units (1 to 1) to the new hash
	# changed what was '4' to '6' (SCD: 2007.08.08)	

	for(my $i=0 ; $i <= 6 ; $i++)	{
		$val_hash{ $param_header[$i] . '_UNITS' } =
			$units_header[$i];	
	}	
		
	#
	#--> figure out which flags go with what columns
	#
	my $a_field_format = ' a8' x 7;
	@asterisk = unpack($a_field_format, $orig_file[5]);
	
	#print STDOUT "Asterisks are: \n";
	#foreach my $a (@asterisk)	{
	#	print STDOUT "\t$a\n";
	#}
	#--> now, add the flag order to the new hash
	# changed what was '4' to '6' (SCD: 2007.08.08)	
	
	for(my $i=0 ; $i <= 6 ; $i++)	{
	
		print STDOUT "\tasterisk $i = $asterisk[$i]\n";
		if ( $asterisk[$i] =~ /\*\*\*/)	{
			$val_hash{ $param_header[$i] . '_FLAG_ORDER' } 
				= $i;
		#DECODE
		print STDERR "\t -> assigning $param_header[$i] . '_FLAG_ORDER' . \n";
		}	
	}	
	foreach my $k (sort keys %val_hash)	{
		print STDOUT "Key = $k\t Value = $val_hash{$k} \n";
	}
	#print STDERR "Continue: ";
	#my $dummy = <STDIN>;	
	
	#
	#--> read in the data values, line by line
	#
	for (my $line = $num_header_lines ; $line <= $#orig_file ; $line++)	{
	
		my @tmp = split(/\s+/, $orig_file[$line] );
		shift(@tmp); #get rid of 1st, blank element
		
		for($p_name=0 ;  $p_name <= $#param_header ; $p_name++){
		 
		 #
		 #--> test for valid NO_DATA values
		 #
		   if ($tmp[$p_name] < -8)	{
		 
		 	# change value to -999
		 	$val_hash{$param_header[$p_name]}[($line - $num_header_lines)]
		 		= -999.0;
		   } else				{
		 	$val_hash{$param_header[$p_name]}[($line - $num_header_lines)]
		 		= $tmp[$p_name];
		   }
		}
	}
	
	#--> decode the flags and assign them properly
	%val_hash = &assign_wctd_flags(\%val_hash, \@param_header);	
	
	foreach my $junk ( sort keys %val_hash)	{
	
		if (($junk =~ /flag_order/i) or
			($junk =~ /units/i))	{
		
			print STDOUT "Single Key ",
	 		"is:\t$junk ",
		 	" and value is: ",
	 		$val_hash{$junk}, "\n";
		} else			{
	 		print STDOUT "Key at ",
	 		( $#{ $val_hash{'CTDPRS'} } ), 
	 		" is:\t$junk ",
		 	" and value is: ",
	 		$val_hash{$junk}[( $#{ $val_hash{'CTDPRS'} })], 
	 		"\n";
	 	}		
	}
	print STDOUT "\n-----\n";

	
	%return_hash = %val_hash;
}
1;
