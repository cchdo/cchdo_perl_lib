#!/usr/bin/perl
#
#------------------------------------------------------------------
#	BOT_MINMAX:	find the minimum and maximum value 
#			for appropriate bottle parameters.
#
#	S. Diggs:	2002.04.30:	initial coding and design
#------------------------------------------------------------------

sub bot_minmax {

	my (%bot_max, %bot_min, @retval);

	my $bot_data_ref	= shift(@_);
	my $tmpparams		= shift(@_);
		
	#dereferencing
	my %bot_data		= %$bot_data_ref;
	my @tmpparams		= @$tmpparams;

	foreach my $mm_param (@tmpparams){

		if (
			($mm_param =~	/expocode/i)	or
			($mm_param =~	/sect_id/i)	or
			($mm_param =~	/stnnbr/i)	or
			($mm_param =~	/castno/i)	or
			($mm_param =~	/sampno/i)	or
			($mm_param =~	/btlnbr/i)	or
			($mm_param =~	/date/i)	or
			($mm_param =~	/time/i)	or
			($mm_param =~	/itude/i)	or		
			($mm_param =~	/depth/i)	or
			($mm_param =~	/flag/i)	
			
			)	{
		
			print STDOUT "Skipping min/max calculation ",
						"for $mm_param\n";
		
		} else	{
	
			print STDOUT "calculating mins/maxs for $mm_param\n";
			print STDOUT "Data are: ", 
					join('|', @{$bot_data{$mm_param}} ), "\n";
		
			($bot_min{$mm_param}, $bot_max{$mm_param}) 
				= &find_minmax_new( @{$bot_data{$mm_param}} );

			print STDOUT "$mm_param min and max are --> "
					. $bot_min{$mm_param} . ' | ' 
					. $bot_max{$mm_param} . "\n";
		}
		#----> TEMPORARY EXIT
		print STDOUT "Exiting in bot_minmax.pl...\n";
		exit;
		@retval = ();
	}
}
1;
