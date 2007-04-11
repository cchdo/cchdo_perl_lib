#!/usr/bin/perl -w

#-----------------------------------------------------------------------
#	GET_FILE_INFO:	A perl module that returns information
#			about a given file by name:  Returns a hash
#			with the following fields:
#				
#				Date_Created
#				Date_Last_Accessed
#				Date_Last_Modified
#				File_UID
#				File_GID
#				File_Size_Bytes
#
#
#	2001.09.23:	S. Diggs:	initial coding
#-----------------------------------------------------------------------

sub Get_File_Info	{

		my $filename = shift @_;
		print STDOUT "Filename is $filename\n";
		my %file_hash = ();


        	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        	$atime,$mtime,$ctime,$blksize,$blocks)       
        		= lstat $filename;



                $file_hash{'Date_Created'}	= localtime($ctime);
                $file_hash{'Date_Last_Accessed'}= localtime($atime);
		$file_hash{'Date_Last_Modified'}= localtime($mtime);
		$file_hash{'File_UID'}		= getpwuid($uid);
		$file_hash{'File_GID'}		= getgrgid($gid);
		$file_hash{'File_Size_Bytes'}	= $size;		
		#$file_hash{'File_Mode'}		= $mode;

		foreach my $file_thing (sort keys %file_hash)	{

			print
			"FILE_HASH:\t$file_thing\t=\t$file_hash{$file_thing}\n";
		}
		my %return_hash = %file_hash;
}
1;
