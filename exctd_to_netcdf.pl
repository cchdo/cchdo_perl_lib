#!/usr/bin/perl -w
#-----------------------------------------------------------------
# EXCTD_TO_NETCDF:	
#		a Perl script that reads in and decode a WHP-CTD
#		exchange formatted file and places all of the data
#		into a structure ready to be written into a NetCDF file.
#		Taken from read_exctd.pl
#
#
#	S. Diggs:	2001.10.30:	initial coding
#
#	S. Diggs:	2002.04.15:	changed 'seconds since
#					01-01-1980' to 'minutes
#					since 01-01-1980' to match
#					the time coordinates of the
#					other WOCE DACS.
#
#	S. Diggs:	2002.05.08	changed the output filenames
#					from *ct1* to *ctd*.
#	Diggs/Shen	2009.10.23	numerous changes to get this
#					code to work on new cchdo system
#					new code  include dirs, find_minmax
# Shen 2010-06-21 Encapsulate the convert subroutine and call it on incoming
#                 file globs.
#-----------------------------------------------------------------

my $code_directory =  "/usr/local/cchdo_perl_lib/common_tools/";
#my $code_directory = "/usr/local/cchdo_perl_lib/exchange_to_netcdf_ctd/";
#my $code_directory = "/Users/sdiggs/tools/EXCHANGE_V2/CODE/READ_EXCTD/";

require $code_directory . "read_anyfile.pl";
require $code_directory . "find_minmax_new.pl";
require $code_directory . "woce_calc_minutes.pl";
require $code_directory . "write_ctd_netcdf.pl";
#require $code_directory . "woce_calc_seconds.pl";

sub convert_exctd_to_netcdf {
  my ($input_filename, %input_hash, @input_lines);
  my (@original_param_units, @original_param_names);
  my ($number_headers, %ctd_meta, %ctd_data, %ctd_units);
  my (%ctd_min, %ctd_max);

  $input_filename = $_;
  
  #
  #--> Construct the the output netcdf filename
  #
  
  #account for relative or absolute pathnames
  @tmp_file_array = split(/\//, $input_filename); 
  @tmp_file_array = split(/\./, $tmp_file_array[$#tmp_file_array]);
  $netcdf_filename = $tmp_file_array[0] . ".nc";
  
  #
  #--> Change output filenames to *ctd* (NOT *ct1*) 
  #--> J. Weir and S.Diggs: 20020508
  #
  $netcdf_filename =~ s/ct1/ctd/g; 
  
  print STDOUT "Output file will be--> $netcdf_filename\n";
  
  #
  #--> open the temporary output file for the inventory
  #
  @tmp_woce_line = split(/\_/, $tmp_file_array[0]);
  $this_woce_line = $tmp_woce_line[0];
  print STDOUT "This woce line is--> $this_woce_line\n";
  # paused here removed --> $dummy =<STDIN>;
  
  
  %input_hash = &read_anyfile($input_filename);
  
  foreach my $k (sort keys %input_hash)	{
  	print STDOUT "key = $k\t value = $input_hash{$k}\n";
  }
  
  @input_lines = @{ $input_hash{'FILE_DATA'}};
  
  for ($i=0 ; $i <= $#input_lines ; $i++)	{
  
  	#just get the 1st line and '#' headers
  	if ( ($i==0) or ($input_lines[$i] =~ /^#/) )	{
  		push(@original_param_names, $input_lines[$i]);
  	} else						{
  		last;
  	}
  }
  print STDOUT "\$i = $i\n";
  print STDOUT "----\n",join("\n ++", @original_param_names), "\n";
  
  #assume that the next header tells how many more lines there are
  print STDOUT "-------\n";
  if ($input_lines[$i] =~ /^NUMBER_HEADERS/i)	{
  
  	print STDOUT "DECODING: $input_lines[$i]\n";
  	my @tmpnum = split(/=/, $input_lines[$i]);
  	$number_headers = $tmpnum[$#tmpnum];
  	$number_headers =~ s/\s+//g; #strip whitespace, if any
  	$i++; #advance to next line / next header
  } else					{
  	die "ERROR: header problems in $input_filename at line $i";
  }
  
  print STDOUT "Number of headers = [$number_headers]\n";
  
  # now get the headers that matter
  print STDOUT "-------\n";
  for ($j = $i ; $j <= ($number_headers + $i - 2) ; $j++)	{
  	#print STDOUT "$input_lines[$j]\n"; 
  	my @tmpmeta = split(/=/, $input_lines[$j]);
  	my $tmpmeta_scalar_name = $tmpmeta[0];
  	my $tmpmeta_scalar_val  = $tmpmeta[$#tmpmeta];
  	$tmpmeta_scalar_name =~ s/\s+//g; #strip whitespace, if any
  	$tmpmeta_scalar_val  =~ s/\s+//g; #strip whitespace, if any
  	$ctd_meta{$tmpmeta_scalar_name} = $tmpmeta_scalar_val;
  }
  print STDOUT "-------\n";
  #$ctd_meta{'WOCE_TIME'} =  &woce_calc_seconds( $ctd_meta{'DATE'} . $ctd_meta{'TIME'});
  $ctd_meta{'WOCE_TIME'} =  &woce_calc_minutes( $ctd_meta{'DATE'} . $ctd_meta{'TIME'});
  foreach my $k (sort keys %ctd_meta)	{
  
  	print STDOUT "\t--> META key = $k,\tValue = $ctd_meta{$k}\n";
  }
  
  # the next two lines *should* be the parameter names
  my @tmpparams = split(/\,/, $input_lines[$j]);
  $j++;
  my @tmpunits  = split(/\,/, $input_lines[$j]);
  $j++;
  #foreach my $params (@tmpparams)	{
  #	print STDOUT "Param: $params\n";
  #}
  #foreach my $units (@tmpunits)	{
  #	print STDOUT "Units: $units\n";
  #}
  
  #
  #--> Construct the CTD params hash
  #
  for (my $p=0 ; $p <= $#tmpparams ; $p++)	{
  
  	$ctd_units{$tmpparams[$p]} = $tmpunits[$p] 
  		if ($tmpunits[$p] =~ /\w/);
  }
  
  print STDOUT "---\n", "Params and Units are:\n";
  foreach my $p (sort keys %ctd_units) {
  
  	print STDOUT "\tParam =\t$p\tValue =\t$ctd_units{$p}\n";
  }
  
  $count = 0;
  foreach $line (@input_lines[($j..$#input_lines)])	{
  
  	if ($line =~ /END_DATA/i)	{
  		last;
  	}
  	my @tmpdata = split(/\,/, $line);
  	#shift(@tmpdata);
  	for(my $p=0 ; $p <= $#tmpparams ; $p++)	{
  
  		if ($count==0)	{
  			print "at 0: \n";
  		print "\t\ttmpparam = $tmpparams[$p] | val = $tmpdata[$p]\n";
  			#my $dummy = <STDIN>
  		}
  		$ctd_data{$tmpparams[$p]}[$count] = $tmpdata[$p];
  	}
  	$count++;
  }
  my $number_of_obs =  $#{ $ctd_data{$tmpparams[0]}};
  print STDOUT "Number of data obs is:$number_of_obs \n";
  foreach my $z (sort keys %ctd_data)	{
  
  	print STDOUT "CTD_DATA:\t$z\n";
  	print STDOUT "\t", join("\n", 
  		@{$ctd_data{$z}}[$number_of_obs-5 .. $number_of_obs]), "\n";
  }
  
  my ($ctdsal_min, $ctdsal_max) = &find_minmax_new( @{$ctd_data{'CTDSAL'}} );
  	$ctd_min{'CTDSAL'} = $ctdsal_min;
  	$ctd_max{'CTDSAL'} = $ctdsal_max;
  	print STDOUT "CTDSAL min and max are --> "
  			. $ctd_min{'CTDSAL'} . ' | ' 
  			. $ctd_max{'CTDSAL'} . "\n";
  
  my ($ctdoxy_min, $ctdoxy_max) = &find_minmax_new( @{$ctd_data{'CTDOXY'}} );
  	$ctd_min{'CTDOXY'} = $ctdoxy_min;
  	$ctd_max{'CTDOXY'} = $ctdoxy_max;
  	print STDOUT "CTDOXY min and max are --> "
  			. $ctd_min{'CTDOXY'} . ' | ' 
  			. $ctd_max{'CTDOXY'} . "\n";				
  
  my ($ctdtmp_min, $ctdtmp_max) = &find_minmax_new( @{$ctd_data{'CTDTMP'}} );
  	$ctd_min{'CTDTMP'} = $ctdtmp_min;
  	$ctd_max{'CTDTMP'} = $ctdtmp_max;
  	print STDOUT "CTDTMP min and max are --> "
  			. $ctd_min{'CTDTMP'} . ' | ' 
  			. $ctd_max{'CTDTMP'} . "\n";
  			
  my ($ctdprs_min, $ctdprs_max) = &find_minmax_new( @{$ctd_data{'CTDPRS'}} );
  	$ctd_min{'CTDPRS'} = $ctdprs_min;
  	$ctd_max{'CTDPRS'} = $ctdprs_max;
  	print STDOUT "CTDPRS min and max are --> "
  			. $ctd_min{'CTDPRS'} . ' | ' 
  			. $ctd_max{'CTDPRS'} . "\n";
  
  # Finish up with inventory information
  
  @inv_headers = qw(	cd_name
  					file_path
  					file_compressed_name
  					file_name
  					woce_date_min
  					woce_date_max
  					latitude_min
  					latitude_max
  					longitude_westmost
  					longitude_eastmost
  					pressure_min
  					pressure_max
  					EXPOCODE
  					temperature_min
  					temperature_max
  					salinity_min
  					salinity_max
  					WOCE_ID
  					DATA_TYPE
  					WOCE_TIME
  					STNNBR
  					CASTNO
  					MINUTES
  					 );
  					
  $inventory_filename = $this_woce_line ."_inv.txt";
  
  if (!(-e $inventory_filename))	{	
  	open(INVENTORY, ">" . $inventory_filename) or 
  		die "Cannot open $inventory_filename for initial writing";
  	print INVENTORY join("\t", @inv_headers) . "\n";
  } else						{
  	open(INVENTORY, ">>" . $inventory_filename) or 
  		die "Cannot open $inventory_filename for appending";
  }
  
  #
  #--> Write NetCDF file
  #
  print STDOUT "--> Writing NetCDF file: $netcdf_filename \n";
  
  &write_ctd_netcdf($netcdf_filename,	\%ctd_data, 
  					\%ctd_meta,
  					\%ctd_units,
  					\%ctd_min,
  					\%ctd_max,
  					\@original_param_names);
  
  #
  #--> Write to the inventory file (if it exists)
  #
  print INVENTORY join("\t", (	
  				
  				"WHP",
  				"<pathname>", 
  				"<zip_archive_name>",	
  				$netcdf_filename,	
  				$ctd_meta{'DATE'},
  				$ctd_meta{'DATE'},				
  				$ctd_meta{'LATITUDE'},
  				$ctd_meta{'LATITUDE'},
  				$ctd_meta{'LONGITUDE'},
  				$ctd_meta{'LONGITUDE'},
  				$ctdprs_min,
  				$ctdprs_max,
  				$ctd_meta{'EXPOCODE'},
  				$ctdtmp_min,
  				$ctdtmp_max,
  				$ctdsal_min,
  				$ctdsal_max,
  				$ctd_meta{'SECT'},		
  				"CTD",						
  				sprintf("%04i", $ctd_meta{'TIME'}),
  				$ctd_meta{'STNNBR'},
  				$ctd_meta{'CASTNO'},
  				$ctd_meta{'WOCE_TIME'},
  				)) ."\n";
  				
  close(INVENTORY);
}

# Get files to convert from the user.
my @files = [];
if ($#ARGV > 1) {
    @files = @ARGV;
} else {
    print STDOUT "Please enter a glob matching files: ";
    @files = glob(<STDIN>);
}

# Convert each file!
foreach (@files) {
    convert_exctd_to_netcdf($_);
}
