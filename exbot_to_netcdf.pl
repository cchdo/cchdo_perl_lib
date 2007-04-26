#!/usr/bin/perl -w
#-----------------------------------------------------------------
# EXCTD_TO_NETCDF:	
#		a Perl script that reads in and decode a WHP-BOTTLE
#		exchange formatted file and places all of the data
#		into a structure ready to be written into a NetCDF file.
#		Taken from read_exctd.pl
#
#
#	S. Diggs:	2001.10.30:	initial coding
#	S. Diggs:	2002.04.15:	changed 'seconds since
#					01-01-1980' to 'minutes
#					since 01-01-1980' to match
#					the time coordinates of the
#					other WOCE DACS.
#-----------------------------------------------------------------

my $code_directory = 
	"/usr/local/cchdo_perl_lib/common_tools/";

require $code_directory . "read_anyfile.pl";
require $code_directory . "find_minmax_new.pl";
require $code_directory . "bot_minmax.pl";
require $code_directory . "woce_calc_minutes.pl";
require $code_directory . "bot_break.pl";
require $code_directory . "write_bot_netcdf.pl";
require $code_directory . "whp_param_info.pl";

my ($input_filename, %input_hash, @input_lines);
my (@original_param_units, @original_header);
my ($number_headers, $number_units, %bot_meta, %bot_data, %bot_units);
my (%bot_min, %bot_max, $i, $k, $j);

if ($ARGV[0])	{
	$input_filename = $ARGV[0];
} else	{
	print STDOUT "Please enter filename: ";
	chomp($input_filename=<STDIN>);
}
#
#--> Construct the the output netcdf base filename
#

#account for relative or absolute pathnames
@tmp_file_array = split(/\//, $input_filename); 
@tmp_file_array = split(/\./, $tmp_file_array[$#tmp_file_array]);
$netcdf_filename = $tmp_file_array[0] . ".nc";
print STDOUT "Output file will be--> $netcdf_filename\n";

#
#--> construct the output file basename for the inventory
#
@tmp_woce_line = split(/\_/, $tmp_file_array[0]);
$this_woce_line = $tmp_woce_line[0];
print STDOUT "This woce line is--> $this_woce_line\n";

%input_hash = &read_anyfile($input_filename);

foreach my $k (sort keys %input_hash)	{
	print STDOUT "key = $k\t value = $input_hash{$k}\n";
}

@input_lines = @{ $input_hash{'FILE_DATA'}};

for ($i=0 ; $i <= $#input_lines ; $i++)	{

	#just get the 1st line and '#' headers
	if ( ($i==0) or ($input_lines[$i] =~ /^#/) )	{
		push(@original_header, $input_lines[$i]);
	} else						{
		last;
	}
}
print STDOUT "\$i = $i\n";
print STDOUT "----\nOG HEADER:\n",
	join("\n ++", @original_header), "\n";

print STDOUT "Getting Parameters at line $i\n";
my @tmpparams = split(/\,/, $input_lines[$i]);
$number_params = $#tmpparams;
print STDOUT "Params are:\n",
		join('|', @tmpparams), "\n--\n";
print STDOUT "Number of parameters is: $number_params\n--\n";
#
@bot_data{ @tmpparams } = "";

#
#--> get the next line (UNITS)
#
$i++;
my $number_of_headers 	= $i;
my $start_data_line	= ($i + 1); # (num of headers + param_line + units_line)

print STDOUT "Starting data at line $start_data_line\n";

print STDOUT "Getting Units at line $i\n";
my @tmpunits = split(/\,/, $input_lines[$i]);
$number_units = $#tmpunits;
print STDOUT "Units are:\n",
		join('|', @tmpunits), "\n--\n";
print STDOUT "Number of units is: $number_units\n--\n";
#

#print STDOUT "Here come the Parameters and units:\n\n";
for (my $k=0 ; $k <= $#tmpparams ; $k++)	{
	
	#print STDOUT "k=$k : $tmpparams[$k]\n";
	$bot_units{$tmpparams[$k]} = $tmpunits[$k];
	if ($bot_units{$tmpparams[$k]})	{
		print STDOUT	"\t-->	$tmpparams[$k]: units ",
			"= $bot_units{$tmpparams[$k]}\n";
	}else				{
		print STDOUT "\t-->	$tmpparams[$k]\n";
	}
}
#
#--> Advance to the next line, start getting data values
#
$i++;
#print STDOUT "\t --> Getting data from $input_file at line $i\n\n";

$report_interval = 500; # report at every $report_interval lines

for	($j=0 ; $j <= ($#input_lines - $i) ; $j++)	{
#for	($j=0 ; $j <= 11 ; $j++)	{

	my @tmpbuf = split(/\,/, $input_lines[($j+$i)]);
	for (my $k=0 ; $k <= $#tmpparams ; $k++)	{
	
		if ($tmpparams[$k] =~ /'+'/){
			print STDOUT "Replacing + sign in $tmpparams[$k] \n";
			$tmpparams[$k] =~ s/'+'/\_/g;
		}
		print STDOUT "k=$k  / line#=\t$j: ",
			"param = $tmpparams[$k] :",
			"value = $tmpbuf[$k]\n"
			if (!($j % $report_interval ));
			
		$bot_data{$tmpparams[$k]}[$j] = $tmpbuf[$k];

	}
}

print STDOUT "Last data line is: $j\n";
#$my_lineno = 100000000;
#while ($my_lineno >= 0 )	{
#
#	print STDOUT "param choices are: ", join('|', @tmpparams), "\n",
#	"Enter line # for examination: ";
#	chomp($my_lineno = <STDIN>);
#	print STDOUT "Enter parameter name: ";
#	chomp($my_parameter_name=<STDIN>);
#	print STDOUT 	"$my_parameter_name at $my_lineno is: ",
#			$bot_data{$my_parameter_name}[$my_lineno], "\n";
#}

#
#--> Make a special list of data-only parameters
#
@noparams = qw (
		
		EXPOCODE	SECT_ID		STNNBR	CASTNO	SAMPNO	
		BTLNBR		DATE	TIME	LATITUDE	
		LONGITUDE	DEPTH	

		);
print STDOUT "Params to remove: @noparams\n";
#@dataparams = @tmpparams;

for ($j=0 ; $j <= $#tmpparams ; $j++)	{

	if 	( 
			(! (grep (/$tmpparams[$j]/, @noparams )))
			and
			( $tmpparams[$j] !~ /flag/i)
	
		)	{
		@dataparams = (@dataparams, $tmpparams[$j]);
	}
}

if ($dataparams[0] =~ /depth/i)	{
	print STDOUT "++>\tRemoving $dataparams[0]\n";
	shift(@dataparams);
}
#
#-> and finally, let's clean up the NO2+NO3 (no '+' signs)
#
#foreach $my_param (@dataparams)	{
#
#	if ($my_param =~ /NO3/i)	{
#		$my_param =~ s/\+/\_/gm;
#	}
#}

#
#--> Calculate the maximum and minimum values
#
#(%bot_min, %bot_max)  = &bot_minmax(\%bot_data, \@dataparams);

print STDOUT "BEFORE NETCDF call: parameters are:\n @dataparams \n\n";

#
#---> Write NetCDF Files
#
&bot_break(		$netcdf_filename,	
			\%bot_data, 
			\%bot_units,
			\@original_header,
			\@tmpparams,
			\@dataparams);


#EXIT
exit;
#--------------------------------------------------#

$i++; #advance to next line / next header / UNITS
#
# ---> EXIT!!!!
#
exit;
print STDOUT "Number of headers = [$number_headers]\n";


print STDOUT "-------\n";
#$ctd_meta{'WOCE_TIME'} =  &woce_calc_minutes( $ctd_meta{'DATE'} . $ctd_meta{'TIME'});
foreach my $k (sort keys %bot_meta)	{

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

my ($ctdsal_min, $ctdsal_max) = &find_minmax( @{$ctd_data{'CTDSAL'}} );
	$ctd_min{'CTDSAL'} = $ctdsal_min;
	$ctd_max{'CTDSAL'} = $ctdsal_max;
	print STDOUT "CTDSAL min and max are --> "
			. $ctd_min{'CTDSAL'} . ' | ' 
			. $ctd_max{'CTDSAL'} . "\n";

my ($ctdoxy_min, $ctdoxy_max) = &find_minmax( @{$ctd_data{'CTDOXY'}} );
	$ctd_min{'CTDOXY'} = $ctdoxy_min;
	$ctd_max{'CTDOXY'} = $ctdoxy_max;
	print STDOUT "CTDOXY min and max are --> "
			. $ctd_min{'CTDOXY'} . ' | ' 
			. $ctd_max{'CTDOXY'} . "\n";				

my ($ctdtmp_min, $ctdtmp_max) = &find_minmax( @{$ctd_data{'CTDTMP'}} );
	$ctd_min{'CTDTMP'} = $ctdtmp_min;
	$ctd_max{'CTDTMP'} = $ctdtmp_max;
	print STDOUT "CTDTMP min and max are --> "
			. $ctd_min{'CTDTMP'} . ' | ' 
			. $ctd_max{'CTDTMP'} . "\n";
			
my ($ctdprs_min, $ctdprs_max) = &find_minmax( @{$ctd_data{'CTDPRS'}} );
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
