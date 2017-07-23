#perl
use warnings;
use strict;
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
my $name = shift;
my @file = @ARGV;
my @labels = ("1","0");

open OUT,">$name"."_ROC_QUEPASA_file";
print OUT "score"."\t"."label"."\n";

for (my $i = 0; $i < @file; $i++) {
	open INPUT,$file[$i] or die "can't find the file!$!";
	while (<INPUT>) {
		chomp $_;
		#print $_."\n";
		my @line = split /\s+/, $_;
		print OUT $line[-1]."\t".$labels[$i]."\n";
	}
	close INPUT;
}
close OUT;
