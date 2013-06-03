#!/usr/bin/perl
#---------------------------------------------------------------------------
#	WRITE_BOT_NETCDF.PL:	
#
#		a Perl script that takes some input hashes and arrays
#		and writes them out as one NetCDF file per unique
#		STNNBR/CASTNO pair.
#
#	S. Diggs:	2001.10.31:	initial coding
#	S. Diggs:	2002.04.15:	major all-around revisions
#					to comply with the DPC-15
#					and WOCE V3 resolutions for
#					data integration
#	S. Diggs:	2002.08.14	parsed whitespace out of CAST/STN
#	S. Diggs:	2003.05.07	added CARBON params to relevant
#					modules
#	S. Diggs:	2003.10.08	added TALK
#	S. Diggs:	2003.10.22	added SF6
#	S. Diggs:	2004.10.11	changed CTDRAW format to %8.1f
#       M. Shen:        2010-10-11      Move varid declaration for woce_time
#                                       up one scope so it is defined for later
#
#---------------------------------------------------------------------------

sub write_bot_netcdf	{

	use netCDF;
	use diagnostics;
	
	my $netcdf_filebasename	= shift(@_);
	my $bot_data_ref	= shift(@_);
	my $bot_units_ref	= shift(@_);
	my $original_header_ref	= shift(@_);
	my $original_params_ref	= shift(@_);
	my $break_points_ref	= shift(@_);
	my $dataparams_ref	= shift(@_);
	
	#dereference
	
	my %bot_data		= %$bot_data_ref;
	my %bot_units		= %$bot_units_ref;
	my @original_header	= @$original_header_ref;
	my @original_params	= @$original_params_ref;
	my @break_points	= @$break_points_ref;
	my ($begin_pt, $end_pt)	= @break_points;
	
	my @netcdf_parameter_array = @$dataparams_ref;

	$netcdf_bottle = 'BTLNBR';	
	
	my $datalines = $#{$bot_data{'EXPOCODE'}};
	
	print STDOUT "Total number of datalines are: $datalines\n";
	
	#set the creation time	
	my $utc_time = gmtime();
	my $file_write_time = "Diggs EXBOT-to-NetCDF Code v0.1e: " . $utc_time . " GMT";
	
	print STDOUT "Time written = $file_write_time\n";
	print STDOUT "Original header: ", "\n", join("\n", @original_header), "\n";
	print STDOUT "Break points are: ", join(',', @break_points   ), "\n";
	print STDOUT "Parameters are  : ", join(',', @original_params), "\n";
	print STDOUT "filename base   : ", $netcdf_filebasename, "\n";
	
	#
	#-->make unique filename based on STATION/CAST and basename
	#
	my @filename_array = split(/hy1/, $netcdf_filebasename);
	if ($bot_data{'STNNBR'}[$begin_pt] =~ /[a-z]/i)		{
		$station_number_filename = $bot_data{'STNNBR'}[$begin_pt];
		#
		#--> parse whitespace out of STNNBR
		#
		
		$station_number_filename =~ s/\s+//g;
		
	} else							{
		$station_number_filename = sprintf("%05d", $bot_data{'STNNBR'}[$begin_pt]);
	}
	

	my $netcdf_filename =	$filename_array[0] .
				$station_number_filename.
				'_'.
				sprintf("%05d", $bot_data{'CASTNO'}[$end_pt]).
				'_'.
				'hy1.nc';
				
	print STDOUT "NetCDF filename  : ", $netcdf_filename, "\n";
	
	$bot_pressure_dimension = ($end_pt - $begin_pt + 1);
	print "Pressure dimension = $bot_pressure_dimension\n";
	
	print STDOUT "WRITE_BOT_NETCDF module!\n";
	
	
#------------------------------------------------------------------
#--- NETCDF CODE BEGINS HERE...
#
my $expocode	= $bot_data{'EXPOCODE'}[0];
$expocode =~ s/\s+//g;
print STDOUT "Expocode: $expocode\n";
my $string_dimension = 40;

my $ncid	= NetCDF::create($netcdf_filename, NetCDF::WRITE);
use NetCDF;

#
#-->Dimension variables
#

my  $time_id		= NetCDF::dimdef($ncid, 'time', 1);
my  $pressure_id	= NetCDF::dimdef($ncid, 'pressure', $bot_pressure_dimension);
my  $lat_id		= NetCDF::dimdef($ncid, 'latitude', 1);
my  $lon_id		= NetCDF::dimdef($ncid, 'longitude', 1);

my @variable_dims	
		= ($time_id, $depth_id, $lat_id, $lon_id);
		
my $string_id	= NetCDF::dimdef($ncid, 'string_dimension', $string_dimension);
my @string_dims = ($time_id,$sdimid);

#
#--> Global Attributes
#

NetCDF::attput($ncid, NetCDF::GLOBAL, "EXPOCODE", NetCDF::CHAR,
			$expocode);
NetCDF::attput($ncid, NetCDF::GLOBAL, "Conventions", NetCDF::CHAR,
			"COARDS/WOCE");
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_VERSION", NetCDF::CHAR,
			"3.0");

#--> Sometimes, there's no WOCE SECTION associated with a certain STNNBR and CASTNO.
#--> In that case, let the user know that it's an UNKNOWN section (tell the truth)

$bot_data{'SECT_ID'}[$begin_pt] =~ s/\s+//g;	#remove whitespace		
if (length($bot_data{'SECT_ID'}[$begin_pt]) > 2) {

	NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_ID", NetCDF::CHAR,
			$bot_data{'SECT_ID'}[$begin_pt]);
	print STDOUT "Woce Section is: * $bot_data{'SECT_ID'}[$begin_pt] *\n",
			"\t\t--> and length is ",
			length($bot_data{'SECT_ID'}[$begin_pt]), "\n";

} else	{

	NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_ID", NetCDF::CHAR,
			'UNKNOWN');
	print STDOUT "\t\t--> Warning: unknown WOCE Section.\n";
}

NetCDF::attput($ncid, NetCDF::GLOBAL, "DATA_TYPE", NetCDF::CHAR,
			"WOCE BOT");		
			
NetCDF::attput($ncid, NetCDF::GLOBAL, "STATION_NUMBER", NetCDF::CHAR,
			$bot_data{'STNNBR'}[$begin_pt]);			
NetCDF::attput($ncid, NetCDF::GLOBAL, "CAST_NUMBER", NetCDF::CHAR,
			$bot_data{'CASTNO'}[$begin_pt]);
NetCDF::attput($ncid, NetCDF::GLOBAL, "BOTTOM_DEPTH_METERS", NetCDF::LONG,
			$bot_data{'DEPTH'}[$begin_pt]);
#
#--> If there are BTLNBR flags, make them a glogal attribute (array of CSV CHARS)
#
if($bot_data{'BTLNBR_FLAG_W'}[0])	{

	print STDOUT "BTLNBR = ", join(',', (@{$bot_data{'BTLNBR'}}[($begin_pt..$end_pt)])), "\n";
	@transfer_array = (@{$bot_data{'BTLNBR'}}[($begin_pt..$end_pt)]);
	NetCDF::attput($ncid, NetCDF::GLOBAL, "BOTTLE_NUMBERS", NetCDF::CHAR,
			\@transfer_array );
	@transfer_array = (@{$bot_data{'BTLNBR_FLAG_W'}}[($begin_pt..$end_pt)]);		
	NetCDF::attput($ncid, NetCDF::GLOBAL, "BOTTLE_QUALITY_CODES", NetCDF::SHORT,
			\@transfer_array);
		
}
#print STDOUT "RETURN to continue: ";
#$dummy = <STDIN>;
				
NetCDF::attput($ncid, NetCDF::GLOBAL, "Creation_Time", NetCDF::CHAR,
			$file_write_time);	
NetCDF::attput($ncid, NetCDF::GLOBAL, "ORIGINAL_HEADER", NetCDF::CHAR,
			"\n".join("\n",@original_header)."\n" );
			
#WHP Flag Descriptions (suggested by Reiner Schlitzer)  
#Bottles have two sets of flags: One for Bottle Quality, the other for Water Samples	
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_BOTTLE_FLAG_DESCRIPTION", NetCDF::CHAR,
			join(':',
			(':',
'1 = Bottle information unavailable.',
'2 = No problems noted.',
'3 = Leaking.',
'4 = Did not trip correctly.',
'5 = Not reported.',
'6 = Significant discrepancy in measured values between Gerard and Niskin bottles.',
'7 = Unknown problem.',
'8 = Pair did not trip correctly. Note that the Niskin bottle can trip at an unplanned depth while the Gerard trips correctly and vice versa.',
'9 = Samples not drawn from this bottle.',
			"\n",
			)));	
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_WATER_SAMPLE_FLAG_DESCRIPTION", NetCDF::CHAR,
			join(':',
			(':',
'1 = Sample for this measurement was drawn from water bottle but analysis not received.', 
'2 = Acceptable measurement.',
'3 = Questionable measurement.',
'4 = Bad measurement.',
'5 = Not reported.',
'6 = Mean of replicate measurements.',
'7 = Manual chromatographic peak measurement.',
'8 = Irregular digital chromatographic peak integration.',
'9 = Sample not drawn for this measurement from this bottle.',
			"\n",
			)));			
							
#
#--> Variable definitions
#
my $netcdf_longname = '';
my %netcdf_var_id = ();
my %varid_hash = ();
#my @netcdf_parameter_array =	qw(
#				CTDPRS  CTDTMP  CTDSAL  SALNTY  CTDOXY  OXYGEN  
#				SILCAT  NITRAT  NITRIT  PHSPHT  CFC-11  CFC-12  
#				TCARBN  ALKALI  PH  PHTEMP  THETA  
#				);
my %netcdf_param_info = &whp_param_info();
#
#------------>
#

# first, do the bottle numbers and quality codes

#if ($bot_data{$netcdf_bottle}[0])	{
#
#	print STDOUT "Declaring $netcdf_bottle\n";
#	$varid_hash{$netcdf_bottle}	= 
#	NetCDF::vardef($ncid, $netcdf_param_info{$netcdf_bottle}{'LONGNAME'}, 
#					NetCDF::CHAR,	$pressure_id);
#	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle}, "long_name",
#			NetCDF::CHAR,$netcdf_param_info{$netcdf_bottle}{'LONGNAME'});
#	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle}, "C_format", 
#			NetCDF::CHAR,$netcdf_param_info{$netcdf_bottle}{'C_FORMAT'});
#	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle}, "WHPO_Variable_Name", 
#			NetCDF::CHAR,$netcdf_bottle);				
#	print STDOUT "RETURN to continue: ";
#	my $dummy = <STDIN>;
#	
#	# ...and now, the BTLNBR QC codes (if they exist)
#	if (exists ($bot_data{$netcdf_bottle . '_FLAG_W'}[0]))	{
#	
#		print STDOUT "\-->Flags for $netcdf_bottle\n";
#		#
#		#--> OBS_QC_VARIABLE FOR JOA
#		#
#		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle}, "OBS_QC_VARIABLE", 
#			NetCDF::CHAR,$netcdf_param_info{$netcdf_bottle}{'LONGNAME'} . "_QC");
#			
#		$varid_hash{$netcdf_bottle . "_FLAG_W"}	= 
#			NetCDF::vardef($ncid, $netcdf_param_info{$netcdf_bottle}{'LONGNAME'} . '_QC', 
#						NetCDF::SHORT,	
#						$pressure_id);
#		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle . "_FLAG_W"}, 
#				"long_name",	
#				NetCDF::CHAR,
#				$netcdf_param_info{$netcdf_bottle}{'LONGNAME'} . "_QC_flag");
#		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle . "_FLAG_W"}, "units", 
#			NetCDF::CHAR, "woce_flags");
#		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_bottle . "_FLAG_W"}, "C_format", 
#			NetCDF::CHAR,"%1d");
#	}
#	
#}

#
#--> Now, on to the rest of the parameters
#
foreach $my_thing (sort keys %bot_data){
	print STDOUT "\t\t\t --> $my_thing\n";
}
#foreach $netcdf_param (@netcdf_parameter_array)	{
#
#	print STDOUT "\t\t-->Param is +${netcdf_param}+\n";
#}	
#@tmp_param_hash{ @netcdf_parameter_array } = ();
#foreach $my_thing (keys %tmp_param_hash)	{
#
#	print STDOUT "THING = $my_thing\n";
#	if ($my_thing =~ /flag/i)	{
#		print STDOUT "\t\t-->Deleting $my_thing\n";
#		delete $tmp_param_hash{$my_thing};
#	}
#}	
#@netcdf_parameter_array = (sort keys %tmp_param_hash);
#-----------------BEGIN DYNAMIC VARIABLES

foreach $netcdf_param (@netcdf_parameter_array)	{

	if ($netcdf_param =~ /FLAG/i)	{
		print STDOUT "--> Skipping $netcdf_param\n";
		next;
	}
	#
	#--> Calculate the maximum and minimum values
	#
	#print STDOUT "Finding min/max for $netcdf_param\n";
	#my @minmax  = &find_minmax_new(@{$bot_data{$netcdf_param}}[($begin_pt..$end_pt)]);
	#print STDOUT "--> MIN/MAX for $netcdf_param is ", join(':', @minmax), "\n", 
	#		"\t\t -->RETURN to continue: ";
	#my $dummy = <STDIN>;
	
	print STDOUT "\t--> Preparing to write $netcdf_param\n";
	print STDOUT "\t--> \t$netcdf_param_info{$netcdf_param}{'LONGNAME'}\n";

	$varid_hash{$netcdf_param}	= 
		NetCDF::vardef($ncid, $netcdf_param_info{$netcdf_param}{'LONGNAME'}, 
					NetCDF::DOUBLE,	$pressure_id);				
	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "long_name",
			NetCDF::CHAR,$netcdf_param_info{$netcdf_param}{'LONGNAME'});
	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "units", 
			NetCDF::CHAR, lc($bot_units{$netcdf_param}));
	
	#
	#--> Add the attribute positive = down for CTDPRS (pressure)
	#
	if ($netcdf_param =~ /ctdprs/i){
		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "positive", 
				NetCDF::CHAR, "down");	
	}		
	#$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "data_min", 
	#		NetCDF::FLOAT, $bot_min{$netcdf_param});
	#$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "data_max", 
	#		NetCDF::FLOAT, $bot_max{$netcdf_param});
	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "C_format", 
			NetCDF::CHAR,$netcdf_param_info{$netcdf_param}{'C_FORMAT'});
	$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "WHPO_Variable_Name", 
			NetCDF::CHAR,$netcdf_param);
			
	#
	#--> Do the QC flags *IF* they exist for this parameter
	#
	if (exists ($bot_data{$netcdf_param . '_FLAG_W'}[0]))	{
	
		print STDOUT "\-->Flags for $netcdf_param\n";
		#
		#--> OBS_QC_VARIABLE FOR JOA
		#
		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param}, "OBS_QC_VARIABLE", 
			NetCDF::CHAR,$netcdf_param_info{$netcdf_param}{'LONGNAME'} . "_QC");
			
		$varid_hash{$netcdf_param . "_FLAG_W"}	= 
		NetCDF::vardef($ncid, $netcdf_param_info{$netcdf_param}{'LONGNAME'} . '_QC', 
						NetCDF::SHORT,	
						$pressure_id);
		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param . "_FLAG_W"}, 
				"long_name",	
				NetCDF::CHAR,
				$netcdf_param_info{$netcdf_param}{'LONGNAME'} . "_QC_flag");
		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param . "_FLAG_W"}, "units", 
			NetCDF::CHAR, "woce_flags");
		$attid = NetCDF::attput($ncid, $varid_hash{$netcdf_param . "_FLAG_W"}, "C_format", 
			NetCDF::CHAR,"%1d");
	}
	#print STDOUT "Return to continue: ";
	#my $dummy = <STDIN>;
}

#-----------------END DYNAMIC VARIABLES

# TIME 
# If there is no TIME column, assume the time is 0000.
my $column_time = $bot_data{'TIME'}[$begin_pt];
if (!$column_time) {
    $column_time = ' 0000';
}
my $woce_calc_time = &woce_calc_minutes(
    $bot_data{'DATE'}[$begin_pt].$column_time);
my $varid_time	= 
	NetCDF::vardef($ncid, 'time', 	NetCDF::LONG,	$time_id);
	my $attid = NetCDF::attput($ncid, $varid_time, "long_name",
			NetCDF::CHAR,"time");
	$attid = NetCDF::attput($ncid, $varid_time, "units", 
			NetCDF::CHAR,"minutes since 1980-01-01 00:00:00");
	$attid = NetCDF::attput($ncid, $varid_time, "data_min", 
			NetCDF::LONG, $woce_calc_time);
	$attid = NetCDF::attput($ncid, $varid_time, "data_max", 
			NetCDF::LONG, $woce_calc_time);
	$attid = NetCDF::attput($ncid, $varid_time, "C_format", 
			NetCDF::CHAR,"%10d");
#
#---> LATITUDE
#			
my $varid_latitude	= 
	NetCDF::vardef($ncid, 'latitude', 	NetCDF::DOUBLE,	$lat_id);
	$attid = NetCDF::attput($ncid, $varid_latitude, "long_name",
			NetCDF::CHAR,"latitude");
	$attid = NetCDF::attput($ncid, $varid_latitude, "units", 
			NetCDF::CHAR,"degrees_N");
	$attid = NetCDF::attput($ncid, $varid_latitude, "data_min", 
			NetCDF::FLOAT, $bot_data{'LATITUDE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_latitude, "data_max", 
			NetCDF::FLOAT, $bot_data{'LATITUDE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_latitude, "C_format", 
			NetCDF::CHAR,"%9.4f");			
my $varid_longitude	= 
	NetCDF::vardef($ncid, 'longitude', 	NetCDF::DOUBLE,	$lon_id);
	$attid = NetCDF::attput($ncid, $varid_longitude, "long_name",
			NetCDF::CHAR,"longitude");
	$attid = NetCDF::attput($ncid, $varid_longitude, "units", 
			NetCDF::CHAR,"degrees_E");
	$attid = NetCDF::attput($ncid, $varid_longitude, "data_min", 
			NetCDF::FLOAT, $bot_data{'LONGITUDE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_longitude, "data_max", 
			NetCDF::FLOAT, $bot_data{'LONGITUDE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_longitude, "C_format", 
			NetCDF::CHAR,"%9.4f");	
							
my $varid_woce_date	= 
	NetCDF::vardef($ncid, 'woce_date', 	NetCDF::LONG,	$time_id);
	$attid = NetCDF::attput($ncid, $varid_woce_date, "long_name",
			NetCDF::CHAR,"WOCE date");
	$attid = NetCDF::attput($ncid, $varid_woce_date, "units", 
			NetCDF::CHAR,"yyyymmdd UTC");
	$attid = NetCDF::attput($ncid, $varid_woce_date, "data_min", 
			NetCDF::FLOAT, $bot_data{'DATE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_woce_date, "data_max", 
			NetCDF::FLOAT, $bot_data{'DATE'}[$begin_pt]);
	$attid = NetCDF::attput($ncid, $varid_woce_date, "C_format", 
			NetCDF::CHAR,"%8d");
		
my $varid_woce_time = null;
if ($bot_data{'TIME'}[$begin_pt]) {
    $varid_woce_time	= 
      NetCDF::vardef($ncid, 'woce_time', 	NetCDF::LONG,	$time_id);
      $attid = NetCDF::attput($ncid, $varid_woce_time, "long_name",
          NetCDF::CHAR,"WOCE time");
      $attid = NetCDF::attput($ncid, $varid_woce_time, "units", 
          NetCDF::CHAR,"hhmm UTC");
      $attid = NetCDF::attput($ncid, $varid_woce_time, "data_min", 
          NetCDF::FLOAT, $bot_data{'TIME'}[$begin_pt]);
      $attid = NetCDF::attput($ncid, $varid_woce_time, "data_max", 
          NetCDF::FLOAT, $bot_data{'TIME'}[$begin_pt]);
      $attid = NetCDF::attput($ncid, $varid_woce_time, "C_format", 
          NetCDF::CHAR,"%4d");	
}
#
#--> Hydrographic Specific
#
my $varid_station	= 
	NetCDF::vardef($ncid, 'station', NetCDF::CHAR,	$string_id);
	$attid = NetCDF::attput($ncid, $varid_station, "long_name",
			NetCDF::CHAR,"STATION");
	$attid = NetCDF::attput($ncid, $varid_station, "units", 
			NetCDF::CHAR,"unspecified");
	$attid = NetCDF::attput($ncid, $varid_station, "C_format", 
			NetCDF::CHAR,"%s");
my $varid_cast	= 
	NetCDF::vardef($ncid, 'cast', 	NetCDF::CHAR,	$string_id);
	$attid = NetCDF::attput($ncid, $varid_cast, "long_name",
			NetCDF::CHAR,"CAST");
	$attid = NetCDF::attput($ncid, $varid_cast, "units", 
			NetCDF::CHAR,"unspecified");
	$attid = NetCDF::attput($ncid, $varid_cast, "C_format", 
			NetCDF::CHAR,"%s");
#--------------------------------------
#
#--> END VARIABLE DEFINITIONS
#
NetCDF::endef($ncid); 	
	
#
#--> Write Variables
#
my @start 	= (0);
my @single	= (1);
my @string_cnt	= (40);
my @count =($bot_pressure_dimension);
@transfer_array = ();

#----------------------------------ALL PARAMETERS

foreach $netcdf_param (@netcdf_parameter_array)	{
	

	@transfer_array = @{$bot_data{$netcdf_param}}[($begin_pt..$end_pt)];
	#if ($netcdf_param =~ /^nit/i)	{
	#	print STDOUT "\t\t--> Parameter is: $netcdf_param (RETURN to continue): \n";
	#	print STDOUT "Transfer array is: ", join(':', @transfer_array), "\n:";
	#	my $dummy1 = <STDIN>;
	#	
	#}
	print STDOUT "\tDoing ", $netcdf_param_info{$netcdf_param}{'LONGNAME'}, "\n";
	NetCDF::varput($ncid, $varid_hash{$netcdf_param},	\@start, \(@count),	
		 \@transfer_array );	
	#
	#--> write out the Flags for this parameter *IF* they're there
	#
	if 	(exists ($bot_data{$netcdf_param . '_FLAG_W'}[0]))	{	 
		@transfer_array = 
			@{$bot_data{$netcdf_param . '_FLAG_W'}}[($begin_pt..$end_pt)];
		print STDOUT 
			"\tDoing " .$netcdf_param_info{$netcdf_param}{'LONGNAME'} .  
			" FLAGS\n";
		NetCDF::varput($ncid, $varid_hash{$netcdf_param . '_FLAG_W'},
			\@start, \(@count),	
			 \@transfer_array );
	}
}

#----------------------------------TIME
print STDOUT "\tDoing TIME\n";
NetCDF::varput($ncid, $varid_time,	\@start, \@single,	
		$woce_calc_time);
#----------------------------------LATITUDE
print STDOUT "\tDoing LATITUDE\n";
NetCDF::varput($ncid, $varid_latitude,	\@start, \@single,	
		($bot_data{'LATITUDE'}[$begin_pt]));		
#----------------------------------LONGITUDE
print STDOUT "\tDoing LONGITUDE\n";
NetCDF::varput($ncid, $varid_longitude,	\@start, \@single,	
		($bot_data{'LONGITUDE'}[$begin_pt]));
		
#----------------------------------WOCE_DATE
print STDOUT "\tDoing WOCE_DATE\n";
NetCDF::varput($ncid, $varid_woce_date,	\@start, \@single,	
		($bot_data{'DATE'}[$begin_pt]));
		
#----------------------------------WOCE_TIME
if ($bot_data{'TIME'}[$begin_pt]) {
    print STDOUT "\tDoing WOCE_TIME\n";
    NetCDF::varput($ncid, $varid_woce_time,	\@start, \@single,	
        ($bot_data{'TIME'}[$begin_pt]));
} else {
    print STDOUT "\tSkipping WOCE_TIME\n";
}

#----------------------------------STATION
print STDOUT "\tDoing STATION\n";
$bot_data{'STNNBR'}[$begin_pt] 	
	= padstr( $bot_data{'STNNBR'}[$begin_pt], $string_dimension);
my @string_length 	= (length($bot_data{'STNNBR'}[$begin_pt]));
#print STDOUT "STNNBR string length = @string_length ",
#		"-> : |$bot_data{'STNNBR'}[$begin_pt]|\n";
NetCDF::varput($ncid, $varid_station,	\@start, \@string_length,	
		($bot_data{'STNNBR'}[$begin_pt]));		
				
#----------------------------------CAST
print STDOUT "\tDoing CASTNO\n";
$bot_data{'CASTNO'}[$begin_pt]
	= padstr( $bot_data{'CASTNO'}[$begin_pt], $string_dimension);
NetCDF::varput($ncid, $varid_cast,	\@start, \@string_cnt,	
		($bot_data{'CASTNO'}[$begin_pt]));
		
		
		
NetCDF::close($ncid);
return;
}
#-----------------------------------------------------------------------		

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
