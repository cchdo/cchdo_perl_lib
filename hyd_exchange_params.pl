#-----------------------------------------------------------------------------
# HYD_EXCHANGE_PARAMS.PL
#
# Contains an array of all of the header values in order for the improved
# exchange format bottle files.
#
# J. Ward	2000.8.3	--> original coding
# J. Ward	2000.8.15	--> added DELC13
# S. Diggs	20020724	--> added O18-O16 and O18_O16
# S. Diggs	20030501	--> added from Alex Kozyr: 
#					STHETA, FCO220C, FCO2IN, TOC, and TON 
# S. Diggs	20030926	--> added TALK
# S. Diggs	20040707	--> added ALUMIN (aluminum)
# S. Diggs	20041101	--> added I129 and I129ER (iodine 129)
# S. Diggs	20041111	--> changed I129 (iodine 129) to I-129
# S. Diggs	20050511	--> updated pathnames for Linux port
#
#----------------------------------------------------------------------------
sub exchange_params
{
	return qw(
	EXPOCODE 
	SECT_ID 
	STNNBR 
	CASTNO 
	SAMPNO 
	BTLNBR 
	DATE 
	TIME 
	LATITUDE 
	LONGITUDE 
	DEPTH 
	CTDPRS 
	CTDTMP 
	CTDSAL 
	SALNTY 
	CTDOXY 
	OXYGEN 
	SILCAT 
	NITRAT 
	NITRIT 
	NO2+NO3 
	PHSPHT 
	CFC-11 
	CFC-12 
	CFC113 
	CCL4 
	TRITUM 
	HELIUM 
	DELHE3 
	DELC14 
	DELC13
	NEON
	O18O16 
	O18-O16 
	TCARBN 
	PCO2 
	ALKALI 
	PH
	STHETA
	FCO220C
	FCO2IN
	TOC
	TON
	TALK
	ALUMIN
	I-129
	I129ER
	 );

}
1;
