#!/bin/csh
#
# --> Perl code to run multiple instances of the CTD to Exchange
# --> program (make_exctd.pl)
# S. Diggs
#

set code = /usr/local/bin/make_exctd.pl
echo -n "Enter SUMfile name: "
set sumfile = $<

foreach input_file (*.ctd)
echo $input_file
$code << EOI
$sumfile
$input_file
EOI
end
