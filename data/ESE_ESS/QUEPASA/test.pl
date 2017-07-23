#perl
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
use strict;
use warnings;

my $ESE = shift;
my $IN = shift;

open INPUT,$ESE;
open IN,$IN;

my @file = <IN>;
open OUT, ">"."$ESE"."_"."$IN";

while (my $ele = <INPUT>) {
	chomp $ele;
	my @ele_l = split /\s+/, $ele;
	#print $ele."\n";
	foreach my $seq (@file) {
		chomp $seq;
		#print $seq."\n";
		my @lines = split /\s+/, $seq;
		if ($ele_l[0] eq $lines[0]) {
			print OUT $lines[0]."\t".$lines[3]."\n";
		}
	}
}
close INPUT;
close IN;

