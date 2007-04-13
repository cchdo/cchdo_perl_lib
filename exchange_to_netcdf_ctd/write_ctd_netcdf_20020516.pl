#!/usr/bin/perl -w
#--->!/opt/perl/bin/perl5.00503
#--->!/usr/local/bin/perl
#---------------------------------------------------------------------------
#	WRITE_CTD_NETCDF.PL:	
#
#		a Perl script that takes some input hashes and arrays
#		and writes out NetCDF CTD profile files.
#
#
#	S. Diggs:	2001.10.31:	initial coding
#
#	S. Diggs:	2002.04.15:	major all-around revisions
#					to comply with the DPC-15
#					and WOCE V3 resolutions for
#					data integration
#
#	S. Diggs:	2002.04.23:	Version 1.1
#					per my conversation with John
#					John Osborne, I have changed
#					the dimension-name 'depth' to
#					'pressure', gave the char variables
#					CASTNO & STNNBR a length, and 
#					added CASTNO & STNNBR as attributes.
#
#
#---------------------------------------------------------------------------

sub write_ctd_netcdf	{

	use NetCDF;
	
	my $netcdf_filename 	= shift(@_);
	my $ctd_data_ref	= shift(@_);
	my $ctd_meta_ref	= shift(@_);
	my $ctd_units_ref	= shift(@_);
	my $ctd_min_ref		= shift(@_);
	my $ctd_max_ref		= shift(@_);
	my $original_header_ref	= shift(@_);
		
	#deref all references
	my %ctd_data		= %$ctd_data_ref;
	my %ctd_meta		= %$ctd_meta_ref;
	my %ctd_units		= %$ctd_units_ref;
	my %ctd_min		= %$ctd_min_ref;
	my %ctd_max		= %$ctd_max_ref;
	my @original_header	= @$original_header_ref;
	
	#set the creation time	
	my $utc_time = gmtime();
	my $file_write_time = "Diggs Code Version 1.2: " . $utc_time . " GMT";
	#my $file_write_time = "Diggs Code Version 1.1: " . $utc_time . " GMT";
	#my $file_write_time = "Diggs Code Version 1.0: " . $utc_time . " GMT";
	
	print "Time written = $file_write_time\n";

	foreach my $stuff (sort keys %ctd_data)	{
		print "NETCDF: ctd_data $stuff\t=\t$ctd_data{$stuff}\n";
	}
	
	foreach my $stuff (sort keys %ctd_meta)	{
		print "NETCDF: ctd_meta $stuff\t=\t$ctd_meta{$stuff}\n";
	}	
	
	foreach my $stuff (sort keys %ctd_units)	{
		print "NETCDF: ctd_units $stuff\t=\t$ctd_units{$stuff}\n";
	}	
	foreach my $stuff (sort keys %ctd_min)	{
		print "NETCDF: ctd_min $stuff\t=\t$ctd_min{$stuff}\n";
	}	
	foreach my $stuff (sort keys %ctd_max)	{
		print "NETCDF: ctd_max $stuff\t=\t$ctd_max{$stuff}\n";
	}
		
	$ctd_pressure_dimension = $#{$ctd_data{'CTDPRS'}};
	
	print STDOUT "NETCDF module!\n";
	print STDOUT "Writing $netcdf_filename\n";
#------------------------------------------------------------------
#--- NETCDF CODE BEGINS HERE...
#
#my $expocode	= $data_hash{'EXPOCODE'}[0];
my $string_dimension = 40;

my $ncid	= NetCDF::create($netcdf_filename, NetCDF::WRITE);

#
#-->Dimension variables
#

my  $time_id	= NetCDF::dimdef($ncid, 'time', 1);
my  $pressure_id
		= NetCDF::dimdef($ncid, 'pressure', $ctd_pressure_dimension);
my  $lat_id	= NetCDF::dimdef($ncid, 'latitude', 1);
my  $lon_id	= NetCDF::dimdef($ncid, 'longitude', 1);

my @variable_dims	
		= ($time_id, $pressure_id, $lat_id, $lon_id);
		
my $string_id	= NetCDF::dimdef($ncid, 'string_dimension', $string_dimension);
my @string_dims = ($time_id,$sdimid);

#
#--> Global Attributes
#

NetCDF::attput($ncid, NetCDF::GLOBAL, "EXPOCODE", NetCDF::CHAR,
			$ctd_meta{'EXPOCODE'});
NetCDF::attput($ncid, NetCDF::GLOBAL, "Conventions", NetCDF::CHAR,
			"COARDS/WOCE");
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_VERSION", NetCDF::CHAR,
			"3.0");
#&*^#&*^#&*^#*&^#*&#^
#check for SECT_ID vs. SECT (SCD: 20020502)
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_ID", NetCDF::CHAR,
			$ctd_meta{'SECT'});
			
NetCDF::attput($ncid, NetCDF::GLOBAL, "DATA_TYPE", NetCDF::CHAR,
			"WOCE CTD");	
NetCDF::attput($ncid, NetCDF::GLOBAL, "STATION_NUMBER", NetCDF::CHAR,
			$ctd_meta{'STNNBR'});			
NetCDF::attput($ncid, NetCDF::GLOBAL, "CAST_NUMBER", NetCDF::CHAR,
			$ctd_meta{'CASTNO'});
NetCDF::attput($ncid, NetCDF::GLOBAL, "BOTTOM_DEPTH_METERS", NetCDF::LONG,
			$ctd_meta{'DEPTH'});								
NetCDF::attput($ncid, NetCDF::GLOBAL, "Creation_Time", NetCDF::CHAR,
			$file_write_time);	
NetCDF::attput($ncid, NetCDF::GLOBAL, "ORIGINAL_HEADER", NetCDF::CHAR,
			":".join(":",@original_header).":" );
			
#WHP Flag Descriptions (suggested by Reiner Schlitzer)	
NetCDF::attput($ncid, NetCDF::GLOBAL, "WOCE_CTD_FLAG_DESCRIPTION", NetCDF::CHAR,
			join(":",
			(":",
			"1=Not calibrated",
			"2=Acceptable measurement",
			"3=Questionable measurement",
			"4=Bad measurement",
			"5=Not reported",
			"6=Interpolated over >2 dbar interval",
			"7=Despiked",
			"8=Not assigned for CTD data",
			"9=Not sampled",
			":",
			)));					
#
#--> Variable definitions
#
my $varid_time	= 
	NetCDF::vardef($ncid, 'time', 	NetCDF::LONG,	$time_id);
	my $attid = NetCDF::attput($ncid, $varid_longitude, "long_name",
			NetCDF::CHAR,"time");
	$attid = NetCDF::attput($ncid, $varid_time, "units", 
			NetCDF::CHAR,"minutes since 1980-01-01 00:00:00");
	$attid = NetCDF::attput($ncid, $varid_time, "data_min", 
			NetCDF::LONG, $ctd_meta{'WOCE_TIME'});
	$attid = NetCDF::attput($ncid, $varid_time, "data_max", 
			NetCDF::LONG, $ctd_meta{'WOCE_TIME'});
	$attid = NetCDF::attput($ncid, $varid_time, "C_format", 
			NetCDF::CHAR,"%10d");
			
my $varid_pressure	= 
	NetCDF::vardef($ncid, 'pressure', NetCDF::DOUBLE,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_pressure, "long_name",
			NetCDF::CHAR,"pressure");
	$attid = NetCDF::attput($ncid, $varid_pressure, "units", 
			NetCDF::CHAR, lc($ctd_units{'CTDPRS'}));
	$attid = NetCDF::attput($ncid, $varid_pressure, "positive", 
			NetCDF::CHAR, "down");			
	$attid = NetCDF::attput($ncid, $varid_pressure, "data_min", 
			NetCDF::FLOAT, $ctd_min{'CTDPRS'});
	$attid = NetCDF::attput($ncid, $varid_pressure, "data_max", 
			NetCDF::FLOAT, $ctd_max{'CTDPRS'});
	$attid = NetCDF::attput($ncid, $varid_pressure, "C_format", 
			NetCDF::CHAR,"%8.1f");
	$attid = NetCDF::attput($ncid, $varid_pressure, "WHPO_Variable_Name", 
			NetCDF::CHAR,"CTDPRS");
	$attid = NetCDF::attput($ncid, $varid_pressure, "OBS_QC_VARIABLE", 
			NetCDF::CHAR,"pressure_QC");
			
my $varid_pressure_QC	= 
	NetCDF::vardef($ncid, 'pressure_QC', NetCDF::SHORT,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_pressure_QC, "long_name",
			NetCDF::CHAR,"pressure_QC_flag");
	$attid = NetCDF::attput($ncid, $varid_pressure_QC, "units", 
			NetCDF::CHAR, "woce_flags");
	$attid = NetCDF::attput($ncid, $varid_pressure_QC, "C_format", 
			NetCDF::CHAR,"%1d");
#
#--->TEMPERATURE
#
my $varid_temperature	= 
	NetCDF::vardef($ncid, 'temperature', NetCDF::DOUBLE,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_temperature, "long_name",
			NetCDF::CHAR,"temperature");
	$attid = NetCDF::attput($ncid, $varid_temperature, "units", 
			NetCDF::CHAR, lc($ctd_units{'CTDTMP'}));			
	$attid = NetCDF::attput($ncid, $varid_temperature, "data_min", 
			NetCDF::FLOAT, $ctd_min{'CTDTMP'});
	$attid = NetCDF::attput($ncid, $varid_temperature, "data_max", 
			NetCDF::FLOAT, $ctd_max{'CTDTMP'});
	$attid = NetCDF::attput($ncid, $varid_temperature, "C_format", 
			NetCDF::CHAR,"%8.4f");
	$attid = NetCDF::attput($ncid, $varid_temperature, "WHPO_Variable_Name", 
			NetCDF::CHAR,"CTDTMP");
	$attid = NetCDF::attput($ncid, $varid_temperature, "OBS_QC_VARIABLE", 
			NetCDF::CHAR,"temperature_QC");
			
my $varid_temperature_QC	= 
	NetCDF::vardef($ncid, 'temperature_QC', NetCDF::SHORT,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_temperature_QC, "long_name",
			NetCDF::CHAR,"temperature_QC_flag");
	$attid = NetCDF::attput($ncid, $varid_temperature_QC, "units", 
			NetCDF::CHAR, "woce_flags");
	$attid = NetCDF::attput($ncid, $varid_temperature_QC, "C_format", 
			NetCDF::CHAR,"%1d");	
			
#
#--> SALINITY
#		
my $varid_salinity	= 
	NetCDF::vardef($ncid, 'salinity', NetCDF::DOUBLE,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_salinity, "long_name",
			NetCDF::CHAR,"ctd salinity");
	$attid = NetCDF::attput($ncid, $varid_salinity, "units", 
			NetCDF::CHAR, lc($ctd_units{'CTDSAL'}));			
	$attid = NetCDF::attput($ncid, $varid_salinity, "data_min", 
			NetCDF::FLOAT, $ctd_min{'CTDSAL'});
	$attid = NetCDF::attput($ncid, $varid_salinity, "data_max", 
			NetCDF::FLOAT, $ctd_max{'CTDSAL'});
	$attid = NetCDF::attput($ncid, $varid_salinity, "C_format", 
			NetCDF::CHAR,"%8.4f");
	$attid = NetCDF::attput($ncid, $varid_salinity, "WHPO_Variable_Name", 
			NetCDF::CHAR,"CTDSAL");
	$attid = NetCDF::attput($ncid, $varid_salinity, "OBS_QC_VARIABLE", 
			NetCDF::CHAR,"salinity_QC");
			
my $varid_salinity_QC	= 
	NetCDF::vardef($ncid, 'salinity_QC', NetCDF::SHORT,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_salinity_QC, "long_name",
			NetCDF::CHAR,"ctd salinity_QC_flag");
	$attid = NetCDF::attput($ncid, $varid_salinity_QC, "units", 
			NetCDF::CHAR, "woce_flags");
	$attid = NetCDF::attput($ncid, $varid_salinity_QC, "C_format", 
			NetCDF::CHAR,"%1d");
#
#--> OXYGEN
#		
my $varid_oxygen	= 
	NetCDF::vardef($ncid, 'oxygen', NetCDF::DOUBLE,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_oxygen, "long_name",
			NetCDF::CHAR,"ctd oxygen");
	$attid = NetCDF::attput($ncid, $varid_oxygen, "units", 
			NetCDF::CHAR, lc($ctd_units{'CTDOXY'}));			
	$attid = NetCDF::attput($ncid, $varid_oxygen, "data_min", 
			NetCDF::FLOAT, $ctd_min{'CTDOXY'});
	$attid = NetCDF::attput($ncid, $varid_oxygen, "data_max", 
			NetCDF::FLOAT, $ctd_max{'CTDOXY'});
	$attid = NetCDF::attput($ncid, $varid_oxygen, "C_format", 
			NetCDF::CHAR,"%8.1f");
	$attid = NetCDF::attput($ncid, $varid_oxygen, "WHPO_Variable_Name", 
			NetCDF::CHAR,"CTDOXY");
	$attid = NetCDF::attput($ncid, $varid_oxygen, "OBS_QC_VARIABLE", 
			NetCDF::CHAR,"oxygen_QC");

my $varid_oxygen_QC	= 
	NetCDF::vardef($ncid, 'oxygen_QC', NetCDF::SHORT,	
						$pressure_id);
	$attid = NetCDF::attput($ncid, $varid_oxygen_QC, "long_name",
			NetCDF::CHAR,"ctd oxygen_QC_flag");
	$attid = NetCDF::attput($ncid, $varid_oxygen_QC, "units", 
			NetCDF::CHAR, "woce_flags");
	$attid = NetCDF::attput($ncid, $varid_oxygen_QC, "C_format", 
			NetCDF::CHAR,"%1d");

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
			NetCDF::FLOAT, $ctd_meta{'LATITUDE'});
	$attid = NetCDF::attput($ncid, $varid_latitude, "data_max", 
			NetCDF::FLOAT, $ctd_meta{'LATITUDE'});
	$attid = NetCDF::attput($ncid, $varid_latitude, "C_format", 
			NetCDF::CHAR,"%9.4f");			
my $varid_longitude	= 
	NetCDF::vardef($ncid, 'longitude', 	NetCDF::DOUBLE,	$lon_id);
	$attid = NetCDF::attput($ncid, $varid_longitude, "long_name",
			NetCDF::CHAR,"longitude");
	$attid = NetCDF::attput($ncid, $varid_longitude, "units", 
			NetCDF::CHAR,"degrees_E");
	$attid = NetCDF::attput($ncid, $varid_longitude, "data_min", 
			NetCDF::FLOAT, $ctd_meta{'LONGITUDE'});
	$attid = NetCDF::attput($ncid, $varid_longitude, "data_max", 
			NetCDF::FLOAT, $ctd_meta{'LONGITUDE'});
	$attid = NetCDF::attput($ncid, $varid_longitude, "C_format", 
			NetCDF::CHAR,"%9.4f");	
							
my $varid_woce_date	= 
	NetCDF::vardef($ncid, 'woce_date', 	NetCDF::LONG,	$time_id);
	$attid = NetCDF::attput($ncid, $varid_woce_date, "long_name",
			NetCDF::CHAR,"WOCE date");
	$attid = NetCDF::attput($ncid, $varid_woce_date, "units", 
			NetCDF::CHAR,"yyyymmdd UTC");
	$attid = NetCDF::attput($ncid, $varid_woce_date, "data_min", 
			NetCDF::FLOAT, $ctd_meta{'DATE'});
	$attid = NetCDF::attput($ncid, $varid_woce_date, "data_max", 
			NetCDF::FLOAT, $ctd_meta{'DATE'});
	$attid = NetCDF::attput($ncid, $varid_woce_date, "C_format", 
			NetCDF::CHAR,"%8d");
			
my $varid_woce_time	= 
	NetCDF::vardef($ncid, 'woce_time', 	NetCDF::LONG,	$time_id);
	$attid = NetCDF::attput($ncid, $varid_woce_time, "long_name",
			NetCDF::CHAR,"WOCE time");
	$attid = NetCDF::attput($ncid, $varid_woce_time, "units", 
			NetCDF::CHAR,"hhmm UTC");
	$attid = NetCDF::attput($ncid, $varid_woce_time, "data_min", 
			NetCDF::FLOAT, $ctd_meta{'TIME'});
	$attid = NetCDF::attput($ncid, $varid_woce_time, "data_max", 
			NetCDF::FLOAT, $ctd_meta{'TIME'});
	$attid = NetCDF::attput($ncid, $varid_woce_time, "C_format", 
			NetCDF::CHAR,"%4d");
			
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
			
#--> leaving define mode
#
NetCDF::endef($ncid);

#
#--> Write Variables
#
my @start 	= (0);
my @single	= (1);
my @string_cnt	= (40);
my @count =($ctd_pressure_dimension);

#----------------------------------TIME
print STDOUT "\tDoing TIME\n";
NetCDF::varput($ncid, $varid_time,	\@start, \@single,	
		($ctd_meta{'WOCE_TIME'}));

#----------------------------------PRESSURE
my @transfer_array = @{$ctd_data{'CTDPRS'}};
print STDOUT "\tDoing PRESSURE\n";
NetCDF::varput($ncid, $varid_pressure,	\@start, \@count,	
		 \@transfer_array );		 
@transfer_array = @{$ctd_data{'CTDPRS_FLAG_W'}};
print STDOUT "\tDoing PRESSURE FLAGS\n";
NetCDF::varput($ncid, $varid_pressure_QC,	\@start, \@count,	
		 \@transfer_array );
		 
#----------------------------------TEMPERATURE
@transfer_array = @{$ctd_data{'CTDTMP'}};
print STDOUT "\tDoing TEMPERATURE\n";
NetCDF::varput($ncid, $varid_temperature,	\@start, \@count,	
		 \@transfer_array );	 
@transfer_array = @{$ctd_data{'CTDTMP_FLAG_W'}};
print STDOUT "\tDoing TEMPERATURE FLAGS\n";
NetCDF::varput($ncid, $varid_temperature_QC,	\@start, \@count,	
		 \@transfer_array );	
		 	
#----------------------------------SALINITY
@transfer_array = @{$ctd_data{'CTDSAL'}};
print STDOUT "\tDoing CTD SALINITY\n";
NetCDF::varput($ncid, $varid_salinity,	\@start, \@count,	
		 \@transfer_array );	 
@transfer_array = @{$ctd_data{'CTDSAL_FLAG_W'}};
print STDOUT "\tDoing CTD SALINITY FLAGS\n";
NetCDF::varput($ncid, $varid_salinity_QC,	\@start, \@count,	
		 \@transfer_array );
		 
#----------------------------------OXYGEN
@transfer_array = @{$ctd_data{'CTDOXY'}};
print STDOUT "\tDoing CTD OXYGEN\n";
NetCDF::varput($ncid, $varid_oxygen,	\@start, \@count,	
		 \@transfer_array );	 
@transfer_array = @{$ctd_data{'CTDOXY_FLAG_W'}};
print STDOUT "\tDoing CTD OXYGEN FLAGS\n";
NetCDF::varput($ncid, $varid_oxygen_QC,	\@start, \@count,	
		 \@transfer_array );
		 
#----------------------------------LATITUDE
print STDOUT "\tDoing LATITUDE\n";
NetCDF::varput($ncid, $varid_latitude,	\@start, \@single,	
		($ctd_meta{'LATITUDE'}));		
#----------------------------------LONGITUDE
print STDOUT "\tDoing LONGITUDE\n";
NetCDF::varput($ncid, $varid_longitude,	\@start, \@single,	
		($ctd_meta{'LONGITUDE'}));
		
#----------------------------------WOCE_DATE
print STDOUT "\tDoing WOCE_DATE\n";
NetCDF::varput($ncid, $varid_woce_date,	\@start, \@single,	
		($ctd_meta{'DATE'}));
		
#----------------------------------WOCE_TIME
print STDOUT "\tDoing WOCE_TIME\n";
NetCDF::varput($ncid, $varid_woce_time,	\@start, \@single,	
		($ctd_meta{'TIME'}));

#----------------------------------STATION
print STDOUT "\tDoing STATION\n";
$ctd_meta{'STNNBR'} 	= padstr( $ctd_meta{'STNNBR'}, $string_dimension);
my @string_length 	= (length($ctd_meta{'STNNBR'}));
NetCDF::varput($ncid, $varid_station,	\@start, \@string_length,	
		($ctd_meta{'STNNBR'}));		
				
#----------------------------------CAST
print STDOUT "\tDoing CASTNO\n";
$ctd_meta{'CASTNO'} = padstr( $ctd_meta{'CASTNO'}, $string_dimension);
NetCDF::varput($ncid, $varid_cast,	\@start, \@string_cnt,	
		($ctd_meta{'CASTNO'}));
#
#
#--> end NetCDF stuff
#
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
