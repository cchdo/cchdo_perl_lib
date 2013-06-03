# Module Parameters
#
# Blame
# Matt Shen 	2009-04-20
# Matt Shen 	2010-05-03 Added debugging code. Add aliases into top-level param
#                        namespace.
#

package Parameters;

use strict;
use DBI;

# Fetch the parameter descriptions
my $dbh = DBI->connect(
  'DBI:mysql:database=cchdo:host=h2o.ucsd.edu',
	'cchdo_web', '((hd0hydr0d@t@')
	or die $DBI::errstr;

my $sth = $dbh->prepare('SELECT * from parameter_descriptions')
	  or die "Couldn't prepare statement: ".$dbh->errstr;
$sth->execute();

# WOCE name -> (descriptor -> value)
our %descriptions = ();

while (my ($id, $parameter, $fullname, $descrip, $units, $range, $alias,
	         $group, $mnemonic, $fmt, $rubyfmt, $private) =
	         $sth->fetchrow_array()) {

	# Do some parameter tweaking to comply with requirements
	my $woce = $parameter || 'UNKNOWN';
	my $format = $rubyfmt || '9.4f';

	# Use param name instead of null and spaces to underscores. This does
	# not preclude duplicate names.
	my $netcdfname = $fullname || $woce;
	$netcdfname =~ s/^\s+//;
	$netcdfname =~ s/\s+$//;
	$netcdfname =~ s/\s+/_/g;
	$netcdfname =~ s/\W/_/g;
	$netcdfname = lc $netcdfname;

	my %descrip = (
	  'fullname' => $fullname,
	  'LONGNAME' => $netcdfname,
	  'description' => $descrip,
	  'units' => $mnemonic,
	  'range' => $range,
	  'aliases' => $alias,
	  'F_FORMAT' => $fmt,
	  'C_FORMAT' => '%'.$format,
	  'format' => $format,
	  'private' => $private
	);
	$descriptions{$woce} = \%descrip;

  # Also link aliases to the same description
  if ($alias) {
      for my $a (split(',', $alias)) {
        $descriptions{$a} = \%descrip;
      }
  }
}
warn "Problem retrieving parameter descriptions ", $sth->errstr(),
	"\n" if $sth->err();

$dbh->disconnect;

my $DEBUG = 0;
if ($DEBUG) {
  for my $param (sort keys %descriptions) {
    print STDERR "$param: \n";
    my $hash_ptr = $descriptions{$param};
    my %hash = %$hash_ptr;
    for my $key (sort keys %hash) {
      print STDERR "  $key: $hash{$key}\n";
    }
  }
}

1; # Loaded Parameters
