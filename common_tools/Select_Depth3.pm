#!/usr/bin/perl -w
#-----------------------------------------------------------------------
#	SELECT_DEPTH:	A perl module that makes the tough decision
#			whether to use BO, EN, or BE (in that order)
#			as far as lat/lon/depth/time/data are concerned.
#
#				
#
#	2001.09.23:	S. Diggs:	initial coding
#	2001.10.09:	S. Diggs:	changed depth selection algorithm
#	2001.11.06:	S. Diggs:	accounted for -999 depth (v2)
#	2001.12.27:	S. Diggs:	corrected bug in depth selection (v3)
#-----------------------------------------------------------------------

sub Select_Depth2	{

		my %sub_hash		= @_;
		my %meta_hash		= ();

		my $size_of_hash 	= $#{ $sub_hash{'CASTNO'}};
		
		print STDOUT "Grabbed ", ($size_of_hash+1), " entries\n";
		
		my @event_codes = ();
		for (my $i=0 ; $i <= $size_of_hash ; $i++)	{
		
			push (@event_codes, $sub_hash{'CODE'}[$i]);
		}

		print STDOUT "Event Codes at station are: @event_codes\n";
		
		#
		#--> Now, loop through the entries and make a selection in the
		#--> following order: BE, BO, EN
		#
		for( my $entry=0 ; $entry <= $size_of_hash ; $entry++)	{
		
			#
			#--> only use valid depths
			#
			if (
				($sub_hash{'DEPTH'}[$entry] >= 0 )
				and
				($sub_hash{'DEPTH'}[$entry] != -999 )
			   )	{
			
				print STDOUT "Depth for ",
					$sub_hash{'CASTNO'}[$entry], ", ",
					$sub_hash{'STNNBR'}[$entry], ", ",
					$sub_hash{'CODE'}[$entry], ", ",
					" is ", $sub_hash{'DEPTH'}[$entry],
					"\n",
					;
					
				#
				#---> Select in order: BO then BE then EN
				#	
				if ($sub_hash{'CODE'}[$entry] =~ /bo/i)	{
					foreach $h (keys %sub_hash)	{
					  $meta_hash{$h} = $sub_hash{$h}[$entry];
					}
					print STDOUT "\t-->Using ",
						$sub_hash{'CODE'}[$entry],
						" with depth = ",
						$sub_hash{'DEPTH'}[$entry],
						"\n",
						;
					last; #no need to look further
				}elsif ($sub_hash{'CODE'}[$entry] =~ /be/i)	{
					foreach $h (keys %sub_hash)	{
					  $meta_hash{$h} = $sub_hash{$h}[$entry];
					}
					print STDOUT "\t-->Using ",
						$sub_hash{'CODE'}[$entry],
						" with depth = ",
						$sub_hash{'DEPTH'}[$entry],
						"\n",
						;
					next; #may need to look for 'BO' event
				} else	{
					foreach $h (keys %sub_hash)	{
					  $meta_hash{$h} = $sub_hash{$h}[$entry];
					}
					print STDOUT "\t-->Using ",
						$sub_hash{'CODE'}[$entry],
						" with depth = ",
						$sub_hash{'DEPTH'}[$entry],
						"\n",
						;
				}
				
			}
			

		}

		#--> Return the only entry we've found
		
		my %return_hash = %meta_hash;
}
1;
