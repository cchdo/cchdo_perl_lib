#!/usr/bin/perl -w
#--->!/opt/perl/bin/perl5.00503
#--->!/usr/local/bin/perl
#---------------------------------------------------------------------------
#	WRITE_CTD_NETCDF.PL:	
#			a Perl script that takes some input hashes and arrays
#			and writes out NetCDF CTD profile files.
#			
#
#		INPUTS:		
#
#
#	S. Diggs:	2001.10.31:	initial coding
#
#
#
#---------------------------------------------------------------------------

sub write_ctd_netcdf	{

	#use NetCDF;

	my %data_hash  = ();
	my %units_hash = ();
	my($i, $j, $k);
	
	my $header	= shift(@_);
	my ($data_ref)	= shift(@_);
	my ($units_ref)	= @_;

	my %data_hash	= %$data_ref;
	my %units_hash	= %$units_ref;
	
	print STDOUT "\n---->\n\tNETCDF module!\n";
	#
	#--> print out the hash with the units(values) and parameters(keys)
	#
	print STDOUT "\n-----\n\n";
	foreach my $pkey (sort keys %units_hash)	{

		print STDOUT "UNITS:\t$pkey\t=\t$units_hash{$pkey}\n"; 
	}
	
	#my $time = gmtime();
	#$time .= " GMT";
	my $time = "S. Diggs: Wed April 15 22:38:17 2002 GMT";
	
	print STDOUT "Data hash (in netcdf routine):\n",
			join('|', (sort keys %data_hash)), "\n";
	#
	#--> Define the hash for each sumfile record
	#       
	#my %record = (	"expo_code"	=> '',	"woce_sect"	=> '',
	#	"stnnbr"	=> 0,	"cast_no"	=> 0,
	#	"cast_type"	=> '',	"date"		=> 0,
	#	"time"		=> 0,	"event_code"	=> '',
	#	"old_lat"	=> 0,	"old_lon"	=> 0,
	#	"nav"		=> '',	"depth"		=> 0,
	#	"above_bottom"	=> 0,	"wire_out"	=> 0,
	#	"max_press"	=> 0,	"no_bottles"	=> 0,
	#	"parameters"	=> '',	"comments"	=> '',
	#);
		
#------------------------------------------------------------------
#--- NETCDF CODE BEGINS HERE...
#
my $expocode	= $data_hash{'EXPOCODE'}[0];
my $string_dimension = 80;

my $ncid	= NetCDF::create("00_hyd_OUTPUT_".$$.".nc", NetCDF::WRITE);

#
#-->Dimension variables
#

my  $dimid	= NetCDF::dimdef($ncid, 'station_data', NetCDF::UNLIMITED);
my $sdimid	= NetCDF::dimdef($ncid, 'string_dimension', $string_dimension);
my @string_dims = ($dimid,$sdimid);

NetCDF::attput($ncid, NetCDF::GLOBAL, "ORIGINAL_HEADER", NetCDF::CHAR,
			$header);
NetCDF::attput($ncid, NetCDF::GLOBAL, "EXPOCODE", NetCDF::CHAR,
			$expocode);
NetCDF::attput($ncid, NetCDF::GLOBAL, "Time_Written", NetCDF::CHAR,
			$time);
			
#--> CHAR type (2 dimensions) MUST HAVE A REF TO A MULTI-DIM ARRAY!		
#--> from .SUM file

my $varid_sect		= NetCDF::vardef($ncid, 'SECT'	, NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_sect, "DESCRIPTION", 
			NetCDF::CHAR,"WOCE SECTION");
my $varid_longitude	= NetCDF::vardef($ncid, 'LONGITUDE', 	NetCDF::FLOAT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_longitude, "UNITS", 
			NetCDF::CHAR,"DECIMAL DEGREES EAST");
my $varid_latitude	= NetCDF::vardef($ncid, 'LATITUDE' , 	NetCDF::FLOAT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_latitude, "UNITS", 
			NetCDF::CHAR,"DECIMAL DEGREES NORTH");
my $varid_date	= NetCDF::vardef($ncid, 'DATE' , 	NetCDF::LONG,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_date, "UNITS", 
			NetCDF::CHAR,"YYYYMMDD (GMT)");			
my $varid_time	= NetCDF::vardef($ncid, 'TIME' ,	NetCDF::CHAR,	\@string_dims);
	my $attid = NetCDF::attput($ncid, $varid_time, "UNITS", 
			NetCDF::CHAR,"HHMM (GMT)");

#-->NUMBERS FROM HYD FILE (single dimension)	
						
my $varid_castno	= NetCDF::vardef($ncid, 'CASTNO' , NetCDF::LONG, $dimid);
	my $attid = NetCDF::attput($ncid, $varid_castno, "DESCRIPTION", 
			NetCDF::CHAR,"CAST NUMBER");				
my $varid_stnnbr	= NetCDF::vardef($ncid, 'STNNBR', NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_stnnbr, "DESCRIPTION", 
			NetCDF::CHAR,"CRUISE STATION NUMBER");
my $varid_btlnbr	= NetCDF::vardef($ncid, 'BTLNBR' , NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_btlnbr, "DESCRIPTION", 
			NetCDF::CHAR,"BOTTLE NUMBER");
	my $attid = NetCDF::attput($ncid, $varid_btlnbr, "MISSING_VALUE", 
			NetCDF::SHORT, -9);
my $varid_sampno	= NetCDF::vardef($ncid, 'SAMPNO', NetCDF::CHAR, \@string_dims );
	my $attid = NetCDF::attput($ncid, $varid_sampno, "DESCRIPTION", 
			NetCDF::CHAR,"SAMPLE NUMBER");									
my $varid_depth	= NetCDF::vardef($ncid, 'BOTTOM_DEPTH' , NetCDF::SHORT,	$dimid);
	my $attid = NetCDF::attput($ncid, $varid_depth, "UNITS", 
			NetCDF::CHAR,"METERS");
#
#--> make the variable IDs and set atttributes for the data PARAMETERS
#

#--------------------------------------CTDPRS--------------------------------------------
my $string_var = 'CTDPRS';
my $varid_ctdprs = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdprs, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdprs, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);	
#my $string_var = 'CTDPRS_QUALT2';
#my $varid_ctdprs_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
#	my $attid = NetCDF::attput($ncid, $varid_ctdprs_qualt2, "UNITS", 
#		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDTMP--------------------------------------------
my $string_var = 'CTDTMP';
my $varid_ctdtmp = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdtmp, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdtmp, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
#my $string_var = 'CTDTMP_QUALT2';
#my $varid_ctdtmp_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
#	my $attid = NetCDF::attput($ncid, $varid_ctdtmp_qualt2, "UNITS", 
#		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDSAL--------------------------------------------
my $string_var = 'CTDSAL';
my $varid_ctdsal = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdsal, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdsal, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'CTDSAL_QUALT2';
my $varid_ctdsal_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdsal_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------CTDOXY--------------------------------------------
my $string_var = 'CTDOXY';
my $varid_ctdoxy = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'CTDOXY_QUALT2';
my $varid_ctdoxy_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_ctdoxy_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------SALNTY--------------------------------------------
my $string_var = 'SALNTY';
my $varid_salnty = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_salnty, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_salnty, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'SALNTY_QUALT2';
my $varid_salnty_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_salnty_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------OXYGEN--------------------------------------------
my $string_var = 'OXYGEN';
my $varid_oxygen = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_oxygen, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_oxygen, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'OXYGEN_QUALT2';
my $varid_oxygen_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_oxygen_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------SILCAT--------------------------------------------
my $string_var = 'SILCAT';
my $varid_silcat = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_silcat, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_silcat, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'SILCAT_QUALT2';
my $varid_silcat_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_silcat_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------NITRAT--------------------------------------------
my $string_var = 'NITRAT';
my $varid_nitrat = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrat, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_nitrat, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'NITRAT_QUALT2';
my $varid_nitrat_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrat_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------NITRIT--------------------------------------------
my $string_var = 'NITRIT';
my $varid_nitrit = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrit, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_nitrit, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'NITRIT_QUALT2';
my $varid_nitrit_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_nitrit_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------

#--------------------------------------PHSPHT--------------------------------------------
my $string_var = 'PHSPHT';
my $varid_phspht = NetCDF::vardef($ncid,  $string_var, NetCDF::FLOAT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_phspht, "UNITS", 
		NetCDF::CHAR, "$units_hash{$string_var}");
	my $attid = NetCDF::attput($ncid, $varid_phspht, "MISSING_VALUE", 
		NetCDF::FLOAT, -9.0);		
my $string_var = 'PHSPHT_QUALT2';
my $varid_phspht_qualt2 = NetCDF::vardef($ncid,  $string_var, NetCDF::SHORT,$dimid);
	my $attid = NetCDF::attput($ncid, $varid_phspht_qualt2, "UNITS", 
		NetCDF::CHAR, "WOCE quality flag");
#----------------------------------------------------------------------------------------


	
my @start = (0);
my @count =($#{ $data_hash{'STNNBR'}});	
print "--> COUNT = $#{ $data_hash{'STNNBR'}}\n";
	
# leaving define mode
NetCDF::endef($ncid);

#****************************************************************************
#----------------------------------SECT
print STDOUT "\tDoing SECT\n";
my @sect = @{ $data_hash{'SECT'}};

foreach my $element (@sect)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_sect,	[0,0], [@count,80],	
		\@sect);
		
#----------------------------------LATITUDE
print STDOUT "\tDoing LATITUDE\n";
my @latitude = @{ $data_hash{'LATITUDE'}};
NetCDF::varput($ncid, $varid_latitude,	\@start, \@count,	
		\@latitude);	

#----------------------------------LATITUDE
print STDOUT "\tDoing LONGITUDE\n";
my @longitude = @{ $data_hash{'LONGITUDE'}};
NetCDF::varput($ncid, $varid_longitude,	\@start, \@count,	
		\@longitude);
		
#----------------------------------DATE
print STDOUT "\tDoing DATE\n";
my @date = @{ $data_hash{'DATE'}};
NetCDF::varput($ncid, $varid_date,	\@start, \@count,	
		\@date);
		
#----------------------------------TIME
print STDOUT "\tDoing TIME\n";
my @woce_time = @{ $data_hash{'TIME'}};
foreach my $element (@woce_time)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_time,	[0,0], [@count,80],	
		\@woce_time);
				
#----------------------------------BOTTOM_DEPTH
print STDOUT "\tDoing BOTTOM_DEPTH\n";
my @depth = @{ $data_hash{'DEPTH'}};
NetCDF::varput($ncid, $varid_depth,	\@start, \@count,	
		\@depth);

				
#----------------------------------CASTNO
print STDOUT "\tDoing CASTNO\n";
my @castno = @{ $data_hash{'CASTNO'}};
NetCDF::varput($ncid, $varid_castno,	\@start, \@count,
		\@castno);
		
#----------------------------------STNNBR
print STDOUT "\tDoing STNNBR\n";
my @stnnbr = @{ $data_hash{'STNNBR'}};
foreach my $element (@stnnbr)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_stnnbr,	[0,0], [@count,80],	
		\@stnnbr);

#----------------------------------BTLNBR
print STDOUT "\tDoing BTLNBR\n";
my @btlnbr = @{ $data_hash{'BTLNBR'}};
foreach my $element (@btlnbr)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_btlnbr,	[0,0], [@count,80],	
		\@btlnbr);

#----------------------------------SAMPNO
print STDOUT "\tDoing SAMPNO\n";
my @sampno = @{ $data_hash{'SAMPNO'}};
foreach my $element (@sampno)	{
	$element = padstr( $element, $string_dimension);
}
NetCDF::varput($ncid, $varid_sampno,	[0,0], [@count,80],	
		\@sampno);
		
#****************************************************************************	
#----------------------------------CTDPRS
print STDOUT "\tDoing CTDPRS\n";
my @ctdprs = @{ $data_hash{'CTDPRS'}};
NetCDF::varput($ncid, $varid_ctdprs,	\@start, \@count,
		\@ctdprs);
#my @ctdprs_qualt2 = @{ $data_hash{'CTDPRS_QUALT2'}};
#print "Ready to see CTDPRS_QUALT2?: ";
#my $dummy = <STDIN>;
#print STDOUT join(',', @ctdprs_qualt2),"\n";
#NetCDF::varput($ncid, $varid_ctdprs_qualt2,	\@start, \@count,
#		\@ctdprs_qualt2);			

#----------------------------------CTDTMP
print STDOUT "\tDoing CTDTMP\n";
my @ctdtmp = @{ $data_hash{'CTDTMP'}};
NetCDF::varput($ncid, $varid_ctdtmp,	\@start, \@count,
		\@ctdtmp);
#my @ctdtmp_qualt2 = @{ $data_hash{'CTDTMP_QUALT2'}};
#print "Ready to see CTDTMP_QUALT2?: ";
#my $dummy = <STDIN>;
#print STDOUT join(',', @ctdtmp_qualt2),"\n";
#NetCDF::varput($ncid, $varid_ctdtmp_qualt2,	\@start, \@count,
#		\@ctdtmp_qualt2);

#----------------------------------CTDSAL
print STDOUT "\tDoing CTDSAL\n";
my @ctdsal = @{ $data_hash{'CTDSAL'}};
NetCDF::varput($ncid, $varid_ctdsal,	\@start, \@count,
		\@ctdsal);
my @ctdsal_qualt2 = @{ $data_hash{'CTDSAL_QUALT2'}};
print "Ready to see CTDSAL_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @ctdsal_qualt2),"\n";
NetCDF::varput($ncid, $varid_ctdsal_qualt2,	\@start, \@count,
		\@ctdsal_qualt2);
		
#----------------------------------CTDOXY
print STDOUT "\tDoing CTDOXY\n";
my @ctdoxy = @{ $data_hash{'CTDOXY'}};
NetCDF::varput($ncid, $varid_ctdoxy,	\@start, \@count,
		\@ctdoxy);
my @ctdoxy_qualt2 = @{ $data_hash{'CTDOXY_QUALT2'}};
print "Ready to see CTDOXY_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @ctdoxy_qualt2),"\n";
NetCDF::varput($ncid, $varid_ctdoxy_qualt2,	\@start, \@count,
		\@ctdoxy_qualt2);		

#----------------------------------SALNTY
print STDOUT "\tDoing SALNTY\n";
my @salnty = @{ $data_hash{'SALNTY'}};
NetCDF::varput($ncid, $varid_salnty,	\@start, \@count,
		\@salnty);
my @salnty_qualt2 = @{ $data_hash{'SALNTY_QUALT2'}};
print "Ready to see SALNTY_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @salnty_qualt2),"\n";
NetCDF::varput($ncid, $varid_salnty_qualt2,	\@start, \@count,
		\@salnty_qualt2);

#----------------------------------OXYGEN
print STDOUT "\tDoing OXYGEN\n";
my @oxygen = @{ $data_hash{'OXYGEN'}};
NetCDF::varput($ncid, $varid_oxygen,	\@start, \@count,
		\@oxygen);
my @oxygen_qualt2 = @{ $data_hash{'OXYGEN_QUALT2'}};
print "Ready to see OXYGEN_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @oxygen_qualt2),"\n";
NetCDF::varput($ncid, $varid_oxygen_qualt2,	\@start, \@count,
		\@oxygen_qualt2);

#----------------------------------SILCAT
print STDOUT "\tDoing SILCAT\n";
my @silcat = @{ $data_hash{'SILCAT'}};
NetCDF::varput($ncid, $varid_silcat,	\@start, \@count,
		\@silcat);
my @silcat_qualt2 = @{ $data_hash{'SILCAT_QUALT2'}};
print "Ready to see SILCAT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @silcat_qualt2),"\n";
NetCDF::varput($ncid, $varid_silcat_qualt2,	\@start, \@count,
		\@silcat_qualt2);

#----------------------------------NITRAT
print STDOUT "\tDoing NITRAT\n";
my @nitrat = @{ $data_hash{'NITRAT'}};
NetCDF::varput($ncid, $varid_nitrat,	\@start, \@count,
		\@nitrat);
my @nitrat_qualt2 = @{ $data_hash{'NITRAT_QUALT2'}};
print "Ready to see NITRAT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @nitrat_qualt2),"\n";
NetCDF::varput($ncid, $varid_nitrat_qualt2,	\@start, \@count,
	\@nitrat_qualt2);

#----------------------------------NITRIT
print STDOUT "\tDoing NITRIT\n";
my @nitrit = @{ $data_hash{'NITRIT'}};
NetCDF::varput($ncid, $varid_nitrit,	\@start, \@count,
		\@nitrit);
my @nitrit_qualt2 = @{ $data_hash{'NITRIT_QUALT2'}};
print "Ready to see NITRIT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @nitrit_qualt2),"\n";
NetCDF::varput($ncid, $varid_nitrit_qualt2,	\@start, \@count,
		\@nitrit_qualt2);

#----------------------------------PHSPHT
print STDOUT "\tDoing PHSPHT\n";
my @phspht = @{ $data_hash{'PHSPHT'}};
NetCDF::varput($ncid, $varid_phspht,	\@start, \@count,
		\@phspht);
my @phspht_qualt2 = @{ $data_hash{'PHSPHT_QUALT2'}};
print "Ready to see PHSPHT_QUALT2?: ";
my $dummy = <STDIN>;
print STDOUT join(',', @phspht_qualt2),"\n";
NetCDF::varput($ncid, $varid_phspht_qualt2,	\@start, \@count,
		\@phspht_qualt2);

#----------------------------------END NUMERICAL DATA

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
