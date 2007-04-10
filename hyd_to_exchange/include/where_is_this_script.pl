#!/usr/bin/perl

#$this_dir = & where_is_this_script($0); 


sub where_is_this_script {

	my $full_script_name = shift(@_);

	my @dir_names = split ( /\//, $full_script_name);

	my $location = join('/', @dir_names[ (0..($#dir_names-1))]) . '/';
	print STDOUT "The script is $dir_names[$#dir_names] is in $location\n";
}
1;
