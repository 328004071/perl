#perl
use strict;
use warnings;
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
=pod
my $file = shift;
open INPUT, $file or die "can't find the file$!";
open OUT, ">IN_score";

my $n = 1;
while(<INPUT>) {
	chomp $_;
	if ($n % 2 == 0) {
		$n++;
		print OUT "\t".$_."\n";
		next;
	}
	print OUT $_;
	$n++;
}

close INPUT;
close OUT;
=cut

my $ESE = shift;
my $IN = shift;

open INPUT,$ESE;
open IN,$IN;

my @file = <IN>;
open OUT, ">"."$ESE"."_"."$IN";

while (my $ele = <INPUT>) {
	chomp $ele;
	print $ele."\n";
	foreach my $seq (@file) {
		chomp $seq;
		print $seq."\n";
		my @lines = split /\s+/, $seq;
		if ($ele eq $lines[0]) {
			print OUT $seq."\n";
		}
	}
}
close INPUT;
close IN;

