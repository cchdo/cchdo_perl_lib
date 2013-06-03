#!/usr/bin/perl
@all_params		=
		qw(EXPOCODE	SECT_ID	STNNBR	CASTNO	SAMPNO
			BTLNBR	BTLNBR_FLAG_W	DATE	TIME	
			LATITUDE	LONGITUDE	DEPTH	
			CTDPRS	CTDTMP	CTDSAL	CTDSAL_FLAG_W	
			SALNTY	SALNTY_FLAG_W	OXYGEN	OXYGEN_FLAG_W	
			SILCAT	SILCAT_FLAG_W	NITRAT	NITRAT_FLAG_W	
			PHSPHT	PHSPHT_FLAG_W);

@non_data_params	=
		qw(EXPOCODE	SECT_ID	STNNBR	
		CASTNO	SAMPNO	BTLNBR	BTLNBR_FLAG_W	
		DATE	TIME	LATITUDE	LONGITUDE	
		DEPTH);
		
foreach my $data_param	(@all_params)	{

	foreach $non_data_thing (@non_data_params)	{
	
		if ($data_param =~ $non_data_thing)	{
		
			print STDOUT "Removing $data_param from data ",
					"parameter array : ",
					" ( $non_data_thing ) \n";
		}
	}
}
