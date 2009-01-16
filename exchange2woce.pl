#!/usr/bin/perl -w

#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#
#XXX                                             XXX#
#XXX     Abandon hope all ye who enter here!     XXX#
#XXX                                             XXX#
#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#XXX#

use strict;
use lib "/usr/local/cchdo_perl_lib/bren/perllib/";
#use lib "/home/whpo/bren/perllib/";
use ExpandDir;
use ParseExchange;
use SortExchangeParams;
use Format;
if($#ARGV != 1){
	die("usage -> exchange2woce.pl exchangeFile /dir/for/output/\n");
}
my $exchangeFile = expandDir($ARGV[0]);
my $outDir = expandDir($ARGV[1]);
if(!$exchangeFile || !$outDir){
	die("$!\n");
}
@_ = split(/\//, $exchangeFile);
my $cruiseName = $_[$#_];
$cruiseName =~ s/(.*)\_(.*)/$1/;
my $sumName = $cruiseName."su.txt";
my $hydName = $cruiseName."hy.txt";
my @checkOutDir = `ls $outDir`;

foreach my $entry (@checkOutDir){
	chomp($entry);
	if($entry eq $sumName){
		print(STDERR "$entry already exists in $outDir\n");
		print(STDERR "overwrite? (y|n): ");
		chomp(my $reply = <STDIN>);
		if(($reply !~ /y/i) && ($reply !~ /yes/i)){
			die("\n");
		}
	}
	if($entry eq $hydName){
		print(STDERR "$entry already exists in $outDir\n");
		print(STDERR "overwrite? (y|n): ");
		chomp(my $reply = <STDIN>);
		if(($reply !~ /y/i) && ($reply !~ /yes/i)){	
			die("\n");
		}
	}
}

$sumName = $outDir.'/'.$sumName;
$hydName = $outDir.'/'.$hydName;

#********************************************************************************
# get data to mangle
#********************************************************************************
my %inHash = %{parseExchange($exchangeFile)};
my @key = keys(%inHash);
my @bottleExchange = @{$inHash{$key[0]}};

	for(my $i = 0; $i <= $#bottleExchange; $i++){
		if(($bottleExchange[$i][0] =~ /^(\#)/) 
				|| ($bottleExchange[$i][0] =~ /^(BOTTLE)/)
				||($bottleExchange[$i][0] =~ /(END_DATA)$/)
		  ){
			splice(@bottleExchange, $i, 1);
			$i--;
		}
	}

my @header;
my %qcHash;
for(my $i = 0; $i <= $#{$bottleExchange[0]}; $i++){
	$header[$i] = $bottleExchange[0][$i];
	if($bottleExchange[0][$i] =~ /(_FLAG_W)$/){
		my $tmp = $bottleExchange[0][$i];
		$tmp =~ s/(_FLAG_W)$//;
		$qcHash{$tmp} = 1;
	}
}
foreach my $key (@header){
	if($qcHash{$key}){
		$qcHash{$key}++;
	}	
}

splice(@bottleExchange, 0, 1);
my %dataHash;
my @tmpBottleExchange;
for(my $i = 0; $i <= $#bottleExchange; $i++){
	for(my $j = 0; $j <= $#{$bottleExchange[$i]}; $j++){
		$bottleExchange[$i][$j] =~ s/\s//g;
		$tmpBottleExchange[$j][$i] = $bottleExchange[$i][$j];
	}
}
for(my $i = 0; $i <= $#tmpBottleExchange; $i++){
	$dataHash{$header[$i]}
	= \@{$tmpBottleExchange[$i]};
}
my @typeArray;
for(my $i = 0; $i <= $#{$dataHash{EXPOCODE}}; $i++){
	$typeArray[$i] = "ROS";
}
$dataHash{TYPE} = \@typeArray;

#********************************************************************************
# hyd file generation
#********************************************************************************
my @hydHeaders = qw(STNNBR CASTNO SAMPNO BTLNBR CTDPRS CTDTMP CTDSAL CTDOXY 
		SALNTY OXYGEN SILCAT NITRAT NITRIT NO2+NO3 PHSPHT CFC-11 CFC-12 
		CFC113 CCL4 TRITUM HELIUM DELHE3 DELC14 DELC13 NEON O18O16 TCARBN 
		PCO2 ALKALI PH QUALT1);
open(HYDFILE, ">$hydName") or die("$!");
my %param_fmt = whp_param_fmt();	
my $unitsDone = 0;
my $unitsString;
my $qcString;
for(my $i = 0; $i <= $#{$dataHash{EXPOCODE}}; $i++){
	foreach my $key (@hydHeaders){
		if(!$i && $key eq "QUALT1"){
			printf(HYDFILE "%16s", $key);
			$qcString .= "               *";
		}
		elsif(!$i && $dataHash{$key}){
			printf(HYDFILE "%8s", $key);
			$unitsString .= sprintf("%8s", $dataHash{$key}[$i]);

			if($qcHash{$key} && $qcHash{$key} == 2){
				$qcString .= "********";
			}
			else{
				$qcString .= "        ";
			}
		}
		else{
			if($i == 1 && !$unitsDone){
				print(HYDFILE "$unitsString\n");
				$unitsDone = 1;
				print(HYDFILE "$qcString\n");
				$qcString = "";
			}
			if($key eq "QUALT1"){
				printf(HYDFILE "%16s", $qcString); 
				$qcString = "";
			}
			if($dataHash{$key}){
				if($qcHash{$key} && $qcHash{$key} == 2){
					my $tmp = $key."_FLAG_W";
					$qcString .= ${$dataHash{$tmp}}[$i];
				}
				if( ${$dataHash{$key}}[$i] == -999 
						&& $key ne "DELHE3" 
						&& $key ne "DELC14" 
						&& $key ne "DELC13" 
				  ){
					${$dataHash{$key}}[$i] = "-9.0";
				}
				printf(HYDFILE "$param_fmt{$key}", ${$dataHash{$key}}[$i]);
			}
		}
	}
	print(HYDFILE "\n");
}

#******************************************************************************** 
# sum file generation
#********************************************************************************
my @sumHeaders = qw(EXPOCODE SECT_ID STNNBR CASTNO TYPE DATE TIME LATITUDE 
		LONGITUDE DEPTH);

foreach my $key (@sumHeaders){
	if($dataHash{$key}){
		if($key eq "EXPOCODE"){
			splice(@{$dataHash{$key}}, 0, 0, "SHIP/CRS", "EXPOCODE");
		}
		elsif($key eq "SECT_ID"){
			splice(@{$dataHash{$key}}, 0, 0, "WOCE", "SECT");
		}
		elsif($key eq "TIME"){
			splice(@{$dataHash{$key}}, 0, 0, "UTC", "TIME");
		}
		elsif($key eq "LATITUDE"){
			splice(@{$dataHash{$key}}, 0, 0, "", "LATITUDE");
		}
		elsif($key eq "LONGITUDE"){
			splice(@{$dataHash{$key}}, 0, 0, "", "LONGITUDE");
		}
		elsif($key eq "DEPTH"){
			splice(@{$dataHash{$key}}, 0, 0, "", "DEPTH");
		}
		elsif($key eq "TYPE"){
			splice(@{$dataHash{$key}}, 0, 0, "CAST", "TYPE");
		}
		else{splice(@{$dataHash{$key}}, 0, 0, "", "$key");
		}
	}
}

open(SUMFILE, ">$sumName") or die("$!");

my %sumFormat = (
		'EXPOCODE' => "%-13s",
		'SECT_ID' => " %-5s",
		'STNNBR' => " %6s",
		'CASTNO' => "    %3d",
		'TYPE' => "  %5s",
		'DATE' => " %-6.6d",
		'TIME' => " %4.4d",
		'CODE' => "   %2s",
		'LATITUDE' => [" %-2d", " %05.2f", " %-1s"],
		'LONGITUDE' => [" %3d", " %05.2f", " %-1s"],
		'NAV' => " %3s",
		'DEPTH' => " %5d"
		);

my %sumHeadFormat = (
		'EXPOCODE' => "%-13s",
		'SECT_ID' => " %-5s",
		'STNNBR' => " %5s",
		'CASTNO' => "%7s",
		'TYPE' => "  %5s",
		'DATE' => " %-6.6s",
		'TIME' => " %4.4s",
		'CODE' => "   %2s",
		'LATITUDE' => " %-10s",#[" %-2d", " %-5.2f", " %-1s"],
		'LONGITUDE' => " %-10s",#[" %-3d", " %-5.2f", " %-1s"],
		'NAV' => " %3s",
		'DEPTH' => "  %5.5s"
		    );

sub convertPosition{
	my @posArray = split(/\./, $_[0]);
	$posArray[1] = (".".$posArray[1]) * 60;
	my @tmp;
	if($_[1] eq "LATITUDE"){
		$posArray[2] = "N";
		if($posArray[0] < 0){
			$posArray[0] *= -1;
			$posArray[2] = "S";
		}
		for(my $i = 0; $i < 3; $i++){
			$tmp[$i] = sprintf("${$sumFormat{$_[1]}}[$i]", $posArray[$i]);
		}
	}

	if($_[1] eq "LONGITUDE"){
		$posArray[2] = "E";
		if($posArray[0] < 0){
			$posArray[0] *= -1;
			$posArray[2] = "W";
		}
		for(my $i = 0; $i < 3; $i++){
			$tmp[$i] = sprintf("${$sumFormat{$_[1]}}[$i]", $posArray[$i]);
		}
	}
	my $return = $tmp[0].$tmp[1].$tmp[2];
}
sub convertDate{
	my @t = split(//, $_[0]);
	return($t[4].$t[5].$t[6].$t[7].$t[2].$t[3]);
}
my $tmpDone = 0;
my @sumOut;
for(my $i = 0; $i <= $#{$dataHash{EXPOCODE}}; $i++){
	foreach my $key (@sumHeaders){
		if($i == 0){
			if($key eq "TYPE"){
				#print(SUMFILE " ");
				$sumOut[$i] .= " ";
			}
#printf(SUMFILE "$sumHeadFormat{$key}", $dataHash{$key}[$i]);
			$sumOut[$i] .= sprintf("$sumHeadFormat{$key}", $dataHash{$key}[$i]);
		}
		elsif($i == 1){
#printf(SUMFILE "$sumHeadFormat{$key}", $dataHash{$key}[$i]);
			$sumOut[$i] .= sprintf("$sumHeadFormat{$key}", $dataHash{$key}[$i]);
		}
		elsif($i == 2){
			if(!$tmpDone){
#print(SUMFILE "---------------------------------------------------------------------------------");
				$sumOut[$i] .= "---------------------------------------------------------------------------------";
				$tmpDone = 1;
			}
		}
		else{
			if($key eq "LATITUDE"){
#print(SUMFILE convertPosition(${$dataHash{$key}}[$i], 
#			"LATITUDE")
#    );
				$sumOut[$i] .= convertPosition(${$dataHash{$key}}[$i], "LATITUDE");
			}
			elsif($key eq "LONGITUDE"){
#print(SUMFILE convertPosition(${$dataHash{$key}}[$i], 
#			"LONGITUDE")
#     );
				$sumOut[$i] .= convertPosition(${$dataHash{$key}}[$i], "LONGITUDE");
			}
			elsif(defined(${$dataHash{$key}}[$i]) && $i > 2){
				if($key eq "DATE"){
					$dataHash{$key}[$i] = convertDate($dataHash{$key}[$i]);	
				}
#printf(SUMFILE "$sumFormat{$key}", ${$dataHash{$key}}[$i]);
				$sumOut[$i] .= sprintf("$sumFormat{$key}", ${$dataHash{$key}}[$i]);
			}
		}
	}
#print(SUMFILE "\n");
	$sumOut[$i] .= "\n";
}

for(my $i = 1; $i <= $#sumOut; $i++){
	if($sumOut[$i] ne $sumOut[$i - 1]){
		print(SUMFILE $sumOut[$i]);	
	}
}

