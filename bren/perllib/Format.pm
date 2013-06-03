#!/usr/local/bin/perl
#
#	WHP_PARAM_FMT.PL:	a Perl script to load the proper formats 
#				for all known WHP parameters.
#
#	S. Diggs:	1999.03.12	initial coding and design
#
#------------------------------------------------------------------------
#

sub whp_param_fmt	{

	my(%param_fmt);
	
	#--> Define the parameter formats
	#
	%param_fmt = 	
		(
		'STNNBR'=>"%8s",	'CASTNO' =>"     %3d",
		'SAMPNO' =>" %7s",	'BTLNBR' =>" %7s",
		'CTDRAW' =>" %7s",	'CTDPRS' =>"%8.1f",	
		'CTDTMP' =>"%8.4f",	'CTDSAL' =>"%8.4f",
		'CTDOXY' =>"%8.1f",	'THETA'  =>"%8.4f",	
		'SALNTY' =>"%8.4f",	'OXYGEN' =>"%8.1f",
		'SILCAT' =>"%8.2f",	'NITRAT' =>"%8.2f",
		'NO2+NO3'=>"%8.2f",	
		'NITRIT' =>"%8.2f",	'PHSPHT' =>"%8.2f",
		'CFC-11' =>"%8.3f",	'CFC-12' =>"%8.3f",	
		'CF11ER' =>"%8.3f",
		'CF12ER' =>"%8.3f",
		'CFC113' =>"%8.3f",	'CFC-113'=>"%8.3f",
		'C113ER' =>"%8.3f",	'CF113ER'=>"%8.3f",
		'CCL4'   =>"%8.3f",	'CCL4ER' =>"%8.3f",
		'REVPRS' =>"%8.1f",	'REVTMP' =>"%8.3f",
		'TRITUM' =>"%8.3f",
		'HELIUM' =>"%8.4f",	
		'DELHE'  =>"%8.2f",	'DELC14' =>"%8.1f",
		'DELHER' =>"%8.3f",	'DELHE3' =>"%8.2f",
		'DELC13' =>"%8.1f",	'ARGON'  =>"%8.2f",	
		'NEON'   =>"%8.3f",	'O18/O16'=>"%8.2f",
		'O16/O16'=>"%8.2f",
		'TRITER' =>"%8.3f",	'HELIER' =>"%8.4f",	
		'DELHER' =>"%8.2f",	'C14ERR' =>"%8.1f",
		'C13ERR' =>"%8.1f",	'NEONER' =>"%8.3f",
		'TCARBN' =>"%8.1f",	'ALKALI' =>"%8.1f",	
		'PCO2'   =>"%8.1f",	'FCO2'   =>"%8.1f",
		'TCO2'   =>"%8.1f",	'TCO2TMP'=>"%8.2f",	
		'PCO2TMP'=>"%8.2f",	'FCO2TMP'=>"%8.2f",
		'PH'     =>"%8.4f",	'PHTEMP' =>"%8.2f",
		'KR-85'  =>"%8.2f",	'AR-39'  =>"%8.1f",
		'RA-228' =>"%8.2f",	'RA-226' =>"%8.2f",
		'SR-90'  =>"%8.2f",	'CS-137' =>"%8.2f",
		'IODATE' =>"%8.3f",	'IODIDE' =>"%8.3f",
		'NH4'    =>"%8.3f",	'CH4'    =>"%8.2f",
		'DON'    =>"%8.1f",	'N2O'    =>"%8.2f",
		'CHLORA' =>"%8.2f",	'PPHYTN' =>"%8.2f",
		'BEDFORT'=>"%8s",	'MCHFRM' =>"%8.3f",
		
		# French parameters
		'AZOTE'	 =>"%8.1f", 	'OXYNIT' =>"%8.2f",
		'CHLA'   =>"%8.2f", 	'PHAEO'  =>"%8.2f",
		'METHAN' =>"%8.2f",

		'QUALT1' =>" ",		'QUALT2' =>" ",
		);
# removed from list: SCD 2001.08.03	'TRITIUM'=>"%8.3f",
		%return_hash = %param_fmt;
}
1;
		
