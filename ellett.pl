#!/usr/bin/perl

# code to translate Ellett line data to Linux/Unix-type ASCII
#
# S. Diggs: 2006.01.15
#

my $new_filename = $ARGV[0];

#print STDOUT "OLD Filename is --> $ARGV[0] \n";
$new_filename =~ s/\.csv/_new\.csv/g;
#$new_filename = uc($new_filename);

print STDOUT "New Filename is --> $new_filename \n";

open(MY_OUTPUT, ">" . $new_filename) or
	die "Cannot open $new_filename for writing";
	
chomp (my @buffer = <>);
foreach my $line (@buffer) {

	$line =~ s/\015/\n/g;
	print MY_OUTPUT $line, "\n";
}
