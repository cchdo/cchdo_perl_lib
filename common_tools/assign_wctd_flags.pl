#!/usr/bin/perl -w
#
#	ASSIGN_WCTD_FLAGS:	a Perl script that will assign the  
#				WHPO (WOCE) CTD file flags to the.  
#				multi-dimensional hash containing 
#				CTDPRS, CTDSAL, etc. 
#
#	S. Diggs:	2001.09.10:	initial coding
#------------------->
#
#
sub assign_wctd_flags {

	my $data_hash_ref = shift(@_);
	my $parameter_ref = shift(@_);
	
	my %data_hash	= %$data_hash_ref;
	my @params	= @$parameter_ref;	
	
	print STDOUT "\t --> Assigning QUALT flags...\n";
	
	#
	#--> 
	#
	for (my $i=0 ; $i <= $#{ $data_hash{'CTDPRS'} } ; $i++)	{
	
	
		my @tflags = split(//, $data_hash{'QUALT1'}[$i]);
		if (!($i % 100)) {print STDERR "$i\t", join('|', @tflags), "\n";}
		
		#--> $#params -1 because QUALT words *are* flags!
		
		for ( my $j=0; $j <= ($#params - 1) ; $j++ )	{
		#for ( my $j=0; $j <= ($#params) ; $j++ )	{

			if (!($i % 100)) {print STDERR "\t--> Assigning flags for $params[$j]\n";}
		
		  $data_hash{$params[$j] . '_FLAG'}[$i] = 
			$tflags[ ( $data_hash{ $params[$j].'_FLAG_ORDER'} ) ]
		  if (exists ($data_hash{ $params[$j].'_FLAG_ORDER'}));
		}
		
	}
	
	foreach my $kkey (sort keys %data_hash)	{
	
		print STDOUT "\t\tKey\t=\t$kkey\t",
				"Value\t=\t$data_hash{$kkey}\n";
	}
	my %return_hash = %data_hash;
}
1;
