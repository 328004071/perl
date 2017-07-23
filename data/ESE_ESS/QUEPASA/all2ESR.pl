#!/bin/perl
#
#use strict;
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
use warnings;

my $file1 = shift;
my $file2 = shift;
my $file3 = shift;

open INPUT1, $file1 or die "no the file1";
open INPUT2, $file2 or die "no the file2";
open INPUT3, $file3 or die "no the file3";

my @all = <INPUT1>;
my @ESE = <INPUT2>;
my @ESS = <INPUT3>;

close INPUT1;
close INPUT2;
close INPUT3;

open OUT1, ">QUEPASA_ESE";
open OUT2, ">QUEPASA_ESS";
open OUT3, ">QUEPASA_rest";

for(my $i = 0; $i < @all; $i++){
	my $flag = 0;
	chomp $all[$i];
	my @all_line = split(/\s+/, $all[$i]);

	for(my $j = 0; $j < @ESE; $j++){
		chomp $ESE[$j];
		if($all_line[0] eq $ESE[$j]){
			print OUT1 $all_line[0]."\t".$all_line[1]."\n";
			$flag = 1;
			break;
		}
	}
	
	if($flag != 1){
		for(my $j = 0; $j < @ESS; $j++){
			chomp $ESS[$j];
			if($all_line[0] eq $ESS[$j]){
				print OUT2 $all_line[0]."\t".$all_line[1]."\n";
				$flag = 1;
				break;
			}
		}
	}
	
	if($flag !=1){
		print OUT3 $all_line[0]."\t".$all_line[1]."\n";
	}

}
close OUT1;
close OUT2;
close OUT3;
