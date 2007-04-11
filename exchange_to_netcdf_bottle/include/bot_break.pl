#!/usr/bin/perl
#---------------------------------------------------------------------------
#	BOT_BREAK.PL:	
#
#		a Perl script that takes some input hashes and arrays
#		and breaks up the data as one cast/stn
#		per file.  Calls write_bot_netcdf.pl
#
#
#	S. Diggs:	2001.10.31:	initial coding
#	S. Diggs:	2002.04.15:	major all-around revisions
#					to comply with the DPC-15
#					and WOCE V3 resolutions for
#					data integration
#---------------------------------------------------------------------------

sub bot_break	{

	#use NetCDF;
	
	my $netcdf_filebasename	= shift(@_);
	my $bot_data_ref	= shift(@_);
	my $bot_units_ref	= shift(@_);
	my $original_header_ref	= shift(@_);
	my $original_params_ref	= shift(@_);
	my $data_params_ref	= shift(@_);
	#dereference
	
	my %bot_data		= %$bot_data_ref;
	my %bot_units		= %$bot_units_ref;
	my @original_header	= @$original_header_ref;
	my @original_params	= @$original_params_ref;
	my @dataparams		= @$data_params_ref;		
	
	my $datalines = $#{$bot_data{'EXPOCODE'}};
	
	print STDOUT "Number of datalines is: $datalines\n";
	
	#set the creation time	
	#my $utc_time = gmtime();
	#my $file_write_time = "Diggs Code Version 1.0b: " . $utc_time . " GMT";
	#print STDOUT "Time written = $file_write_time\n";
	#print STDOUT "Original header:\n", join("\n", @original_header), "\n";

	#foreach my $stuff (sort keys %bot_data)	{
	#	print STDOUT "BOT_BREAK: bot_data $stuff\t=\t$bot_data{$stuff}\n";
	#}	
	#
	#foreach $stuff (sort keys %bot_units)	{
	#	print STDOUT "BOT_BREAK: bot_units $stuff\t=\t$bot_units{$stuff}\n";
	#}	
	#foreach $stuff (@original_header)	{
	#	print STDOUT "BOT_BREAK: orig_headers --> $stuff\n";
	#}
	#foreach $stuff (@original_params)	{
	#	print STDOUT "BOT_BREAK: orig_params --> $stuff\n";
	#}	
	
	print STDOUT "BOT_BREAK module!\n";

	#
	#-->INITIALIZE
	#
	
	#assign CASTNOs if there aren't any (make them all '1')
	if ( ! ($bot_data{'CASTNO'}[0] )) {
	
		print STDOUT "-->\t",
				"No CASTNOs, I'll make them all '1' ...\n";
		for (my $j=0 ; $j <= $datalines ; $j++)	{
			$bot_data{'CASTNO'}[$j] = 1;
		}

	}
	my $old_castno= $bot_data{'CASTNO'}[0];
	my $old_stnnbr= $bot_data{'STNNBR'}[0];
	my $break_point = 0;
	
	for (my $i=0; $i <= $datalines; $i++)	{
	
		if	(
			( $bot_data{'STNNBR'}[$i]  eq $old_stnnbr) and
			( $bot_data{'CASTNO'}[$i]  == $old_castno)
			){
					
				# SAME CAST and/or STNNBR pair
				$old_stnnbr	= $bot_data{'STNNBR'}[$i];
				$old_castno	= $bot_data{'CASTNO'}[$i];

		} else	{
				#NEW STNNBR/CASTNO PAIR!
				
				if ($bot_data{'STNNBR'}[$i] eq $old_stnnbr)	{
					print STDOUT "OLD STATION/NEW CAST\n";
				}
					print STDOUT "\t---> NO MATCH: ",
							"New file at: $i\n";
					$old_stnnbr	= $bot_data{'STNNBR'}[$i];
					$old_castno	= $bot_data{'CASTNO'}[$i];

					#
					#--> set the upper and lower limits of the arrays to subsection
					#--> the data arrays. 
					#
					
					my @break_points = ($break_point, ($i-1));
					print STDOUT "Section is: @break_points\n";
				@tmp_array = 
					@{$bot_data{'BTLNBR'}}[($break_points[0]..$break_points[1])];
					print STDOUT "Here are the bottle numbers: @tmp_array \n";
				@tmp_array = 
					@{$bot_data{'CTDSAL'}}[($break_points[0]..$break_points[1])];
					print STDOUT "Here are the CTD Salinities: @tmp_array \n";					
					#print STDOUT "Return to continue: ";
					##my $dummy = <STDIN>;

					#call netcdf writing module
					print STDOUT "Writing NetCDF file...\n";
					&write_bot_netcdf (	$netcdf_filebasename,
								\%bot_data,
								\%bot_units,
								\@original_header,
								\@original_params,								
								\@break_points,
								\@dataparams);
					
					# Set new break point for next cast/stn mismatch
					$break_point = $i;

		}
	
	}
}
1;

