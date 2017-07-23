#perl

use strict;
use warnings;
#use Encode;
use Algorithm::Prefixspan_1;
#use Prefixspan_1;

my $file1;
my $file2;
my $test;
my $minsupport;

my $clean = "yes";
my $screenshow = "yes";
my $sfno = 0;
my $seqlen;
my $na;
my $ng;
my $nc;
my $nt;

#my $nowtime1 = &getTime();

while(@ARGV){
	my $arg = shift @ARGV;
	if($arg =~ /-file1/){ $file1 = shift @ARGV; }
    elsif($arg =~ /-file2/){ $file2 = shift @ARGV; }
    elsif($arg =~ /-test/){ $test = shift @ARGV; }
    elsif($arg =~ /-minsup/){ $minsupport = shift @ARGV; }
    elsif($arg =~ /-h/){ &help(); }
    elsif($arg =~ /-clean/){ $clean = shift @ARGV;}
    elsif($arg =~ /-screenshow/){ $screenshow = shift @ARGV; }
    elsif($arg =~ /-SFno/){ $sfno = shift @ARGV; }
 }

&check_parameter();

&run($file1, $file2, $test, $test."-score-result");


 ###########################################
 # check_parameter() checks the parameter setting
 sub check_parameter(){

   open FILE1, $file1 or die "do not find file1:$!\n";
   open FILE2, $file2 or die "do not find file2:$!\n";
   open TEST, $test or die "do not find test file:$!\n";

   my @data1 = <FILE1>;
   my @data2 = <FILE2>;
   my @data3 = <TEST>;

   my $seqlen1;
   my $seqlen2;
   my $seqlen3;

   my $type1="little";
   my $type2="little";
   my $type3="little";

   for(my $i=0;$i<scalar(@data1)-1;$i++ ){
       chomp $data1[$i];
       chomp $data1[$i+1];
       $seqlen1 = length($data1[$i]);
       if(length($data1[$i]) != length($data1[$i+1])){
           die "In ".($i+2)."-th line, found a element in file1 with different length! Check it!\n";
       }
       if ($data1[$i] =~ /[^acgtACGT]/ or $data1[$i+1] =~ /[^acgtACGT]/ ){
           print "Check ".($i+1)."-th line in file1!\n";
           die "This program just only handles Single Nucleotide a c g t or A C G T.\n";
       }

       my $temp = compare($data1[$i], $data1[$i+1],$seqlen1);
       if ($temp eq "little"){ $type1 = "little"; }
       elsif ($temp eq "capital"){ $type1 = "capital"; }
       elsif ($temp eq "wrong"){
       	           die "check ".($i+1)."-th line in file2, the elements should share the same character type  (actg OR ACTG)!\n";
           die "check ".($i+1)."-th line in file1, the elements should share the same character type  (actg OR ACTG)!\n";
       }

   }

   for(my $i=0;$i<scalar(@data2)-1;$i++ ){
       chomp $data2[$i];
       chomp $data2[$i+1];
       $seqlen2 = length($data2[$i]);
       if(length($data2[$i]) != length($data2[$i+1])){
           die "In ".($i+2)."-th line,found a element in file2 with different length! Chenck it!\n";
       }
       if ($data2[$i] =~ /[^acgtACGT]/ or $data2[$i+1] =~ /[^acgtACGT]/ ){
           print "Check ".($i+1)."-th line in file2!\n";
           die "This program just only handles Single Nucleotide a c g t or A C G T.\n";
       }

       my $temp = compare($data2[$i], $data2[$i+1],$seqlen2);
       if ($temp eq "little"){ $type2 = "little"; }
       elsif ($temp eq "capital"){ $type2 = "capital"; }
       elsif ($temp eq "wrong"){
           die "check ".($i+1)."-th line in file2, the elements should share the same character type  (actg OR ACTG)!\n";
       }

   }

   for(my $i=0;$i<scalar(@data3)-1; $i++ ){
       chomp $data3[$i];
       chomp $data3[$i+1];
       $seqlen3 = length($data3[$i]);
       if(length($data3[$i]) != length($data3[$i+1])){
           die "In ".($i+2)."-th line, found a element in test file with different length! Check it!\n";
       }
       if ($data3[$i] =~ /[^acgtACGT]/ or $data3[$i+1] =~ /[^acgtACGT]/ ){
           print "Check ".($i+1)."-th line in test file!\n";
           die "This program just only handles Single Nucleotide a c g t or A C G T.\n";
       }
       my $temp = compare($data3[$i], $data3[$i+1],$seqlen3);
       if ($temp eq "little"){ $type3 = "little"; }
       elsif ($temp eq "capital"){ $type3 = "capital"; }
       elsif ($temp eq "wrong"){
           die "check ".($i+1)."-th line in test file, the elements should share the same character type  (actg OR ACTG)!\n";
       }
   }

   if($seqlen1==$seqlen2 && $seqlen1==$seqlen3){}
   else {
       die "The elements in file1, file2 and test file should share the same length! Check them!\n";
   }

   if($type1 eq $type2 and $type1 eq $type3){}
   else {
       die "The characters in file1, file2 and test file shoud share the same type!\n";
   }

   $seqlen = $seqlen1;

   if($type1 eq "little"){
         $na = "a";
         $nc = "c";
         $ng = "g";
         $nt = "t";
   }
   elsif($type1 eq "capital"){
         $na = "A";
         $nc = "C";
         $ng = "G";
         $nt = "T";
   }

   if($minsupport =~ /[^0-9.]/){
      die "the minsup must be a positive decimal! The suggested minsup is 0.05!\n";
   }

   if($sfno =~ /[^1-9]/){
       die "SFno argument must be a positive nature number!\n";
   }

   if($minsupport>=1 or $minsupport <=0){
      die "the minsup must be a positive decimal! The suggested minsup is 0.05\n";
   }

   if($clean eq "yes" or $clean eq "no"){}
   else {
       die "clean argument must be 'yes' or 'no'!\n";
   }

   if($screenshow eq "yes" or $screenshow eq "no"){}
   else {
       die "screenshow argument must be 'yes' or 'no'!\n";
   }

   close FILE1;
   close FILE2;
   close TEST;
 }

 ##########################################
 # compare() check whether two line share the same character type
 sub compare($$$){
     my $str1 = shift;
     my $str2 = shift;
     my $len = shift;

     my $test1=0;
     my $test2=0;
     my $test3=0;
     my $test4=0;

     for (my $ti=0;$ti<$len;$ti++){
          if (substr($str1,$ti,1) =~ /[acgt]/){ $test1 = $test1 +1; }
          if (substr($str2,$ti,1) =~ /[acgt]/){ $test2 = $test2 +1; }
          if (substr($str1,$ti,1) =~ /[ACGT]/){ $test3 = $test3 +1; }
          if (substr($str2,$ti,1) =~ /[ACGT]/){ $test4 = $test4 +1; }
     }
     if($test1 == $len && $test2 == $len){ return "little";}
     if($test3 == $len && $test4 == $len){ return "capital";}
     else {
           return "wrong";
       }
 }
 ###########################################
 # help() presents help for this program
 sub help(){
  print "\n";
  print "This program will calculate class1-score and class2-score for each fragment in the test file ";
  print  "based on the file1(class1) ans file2(class2) that conatin the signal nucleotide framents ";
  print  "with the same length. These scores can be used to measure which class the unknown fragment belogn to.\n\n";
  print "useful arguments:\n";
  print "-help help for how to run shift_pattern.pl\n";
  #print "-clean values('yes' or 'no'), whether delete the media result files from current directiroy.\n";
  #print "-screenshow values('yes' or 'no'), whenther screen output for the some result.\n";
  print "-SFno which kind of sequential features will be used to claculate the score.\n\n";

  print "obligatory arguments:\n";
  print "-file1 the first file that contains some signal nucleotides fragments labeled Class1.\n";
  print "-file2 the second file that contains some signal nucleotides fragments labeled Class2.\n ";
  print "-test the test file that contain some signal nucleotides fragments.";
  print "-minsup the minimal support that will be used to mining the sequential features from file1 and file2.\n\n";
  print "Example:\n\n";
  print "perl SF.pl -file1 RESCUE-ESE -file2 Fas-hex2-ESS -test 4096-hexamers -clean yes -screenshow yes -SFno 2\n\n";
  print "The above command will generate sequential features regular expression files from RESCUE-ESE and Fas-hex2-ESS,";
  print " then calculate ESE-score and ESS-score for each hexamer in test file 4096-hexamers based on the sequential features containing 2 signal nucleotides, ";
  print "during which the media result ";
  print "files will be deleted from the current directiroy and some results will be outputed to the screen\n";

  exit;
 }


#my $file1 = shift;
#my $minsup = shift;
#my $seqlen = shift;
#my $sfno = shift;

#&run($file1);

#########################################################
# run() main
sub run($$$$) {
	my $file1 = shift;
	my $file2 = shift;
	my $file3 = shift;
	my $result = shift;

	my @input;
	my @species;

	$input[0] = $file1;
	$species[0] = "Class1";
	$input[1] =$file2;
	$species[1] = "Class2";

	generate_sp(\@input,\@species);
	#$kind."-regular-expression-".$minsupport."-".$sfno."SF"
	my $rgc1 = $species[0]."-regular-expression-".$minsupport."-".$sfno."SF";
	my $rgc2 = $species[1]."-regular-expression-".$minsupport."-".$sfno."SF";
	calscore($file3, $rgc1, $rgc2, $result."-based-".$minsupport."-".$sfno."SF")
		
}

###############################################################################
# calscore() calculates the class1-score and class2-score for the test file
# based on the sequential features from file1 and file2
sub calscore($$$$$$) {
	#my $file1 = shift;
	#my $file2 = shift;
	my $file3 = shift;
	my $rgc1 = shift;
	my $rgc2 = shift;
	my $result = shift;

	#open DATA1, $file1;
	#open DATA2, $file2;
	open TEST, $file3;
	open RGC1, $rgc1;
	open RGC2, $rgc2;
	open RESULT, ">".$result;

	my @rgc1 = <RGC1>;
	my @rgc2 = <RGC2>;
	close RGC1;
	close RGC2;

	print RESULT "element\tclass1-score\tclass2-score\ttendency-ratio\n";

	foreach my $line1(<TEST>) {
		chomp $line1;
		my $count1 = 0;
		foreach my $line2(@rgc1) {
			my @ta = split(/\s+/, $line2);
			my $a = $ta[0];
			if ($line1 =~ /$a/i) {
				$count1 += calsupcount($line1, $line2);
			}
		}
		my $count2 = 0;
		foreach my $line2(@rgc2) {
			my @ta = split(/\s+/, $line2);
			my $a = $ta[0];
			if ($line1 =~ /$a/i) {
				$count2 += calsupcount($line1, $line2);
			}
		}
			
		if ($count1 < 0.000000001) {
			$count1 = 0.000000001;
		}

		if ($count2 < 0.000000001) {
			$count2 = 0.000000001;
		}

		$count1 = sprintf "%.9f", $count1;
		$count2 = sprintf "%.9f", $count2;
		print RESULT $line1."\t".$count1."\t".$count2."\t".(($count1-$count2)/($count1+$count2))."\n";
	}

	close TEST;
	close RESULT;
}

###############################################################################
# calsupcount() calculates the score for one fragment and one sequential
# feature regular expression
sub calsupcount ($$) {
	my $stra = shift;
	my $line = shift;

	my ($regexp, $sup, $lockednumber, $nulcount) = split(/\s+/,$line);
	$_ = $stra;
	my @itemset = /$regexp/; #测试集灵活位置
	my $len = length($itemset[0]);
	my $nitemset;#后向灵活碱基
	for (my $i = 1; $i < @itemset; $i++) {
		$nitemset = join("", $itemset[$i]);
	}
	
	my $su_pr = 1.0; 
	my @sitloct = split(/;/, $nulcount);
	my $sit = 0;#前向灵活位置数目
	foreach (my $i = 0; $i < @sitloct; $i++) {
		my @item = split(/=>/, $sitloct[$i]);
		if($item[0] > 0) {
			$sit = $i;
			last;
		}else {
			if ($len != 0 && $len-$i > 0) {
				my $aa = substr($itemset[0], $len-$i-1, 1);				
				my @a = split(/\s+/, $item[1]);
				for(my $j = 0; $j <@a; $j++) {
					my @b = split(/:/, $a[$j]);
					if ( $aa eq $b[0]) {
						$su_pr *= $b[1];#如果保守位置匹配成功,但是灵活位置没有一个匹配上的怎么办
					}
				}
			}
		}
	}
	my $len1 = length($nitemset);
	my $k = 0;
	foreach (my $i = $sit; $i < @sitloct; $i++) {
		my @item = split(/=>/, $sitloct[$i]);
		last if ($len1 <= $k);
		my $aa = substr($nitemset, $k, 1);
		$k++;
		my @a =split(/\s+/, $item[1]);
		for(my $j = 0; $j <@a; $j++) {
			my @b = split(/:/, $a[$j]);
			if( $aa eq $b[0]) {
				$su_pr *= $b[1];
			}
		}
		
	}
	#$su_pr = 0 if ($su_pr == 1);
	$su_pr *= $sup;
	return $su_pr;
}


###############################################################################
# generate_sp() mines the sequential features from file1 and file2
# and then generate the regular expression file
sub generate_sp($$){
	my $input = shift;
	my $species = shift;

	#my @rang;

	for(my $p = 0; $p < 2; $p++) {
		my $fileinput = $input->[$p];
		my $kind = $species->[$p];
		
		#my $sf;
		open INPUT,$fileinput or die "no the file:$!\n";
		open OUT,">".$kind."-transfered";
	
		my @tdata = <INPUT>;
		my $minsup = int(scalar(@tdata)*$minsupport+0.5);

		foreach my $line(@tdata) {
			for (my $k = 0; $k < $seqlen; $k++) {
				print OUT substr($line, $k, 1)."\t";
			}
			print OUT "\n";
		}
		close INPUT;
		close OUT;
	
		open INPUT, $kind."-transfered" or die "no the file:$!\n";
		open OUT,">".$kind."-transfered-FS";	
		my $data;
		my $n;
		while (<INPUT>) {
			chomp $_;
			$data->[$n++] = $_;
		}
		close INPUT;
#查找频繁序列
		my $prefixspan = Algorithm::Prefixspan_1->new(data => $data,);
		$prefixspan->{'minsup'} = $minsup;
		$prefixspan->{'len'} = $sfno;
		my $pattern = $prefixspan->run;
		
		foreach my $key (keys %{$pattern}) {
			print "frequential pattern:".$key."=>".$pattern->{$key}."\n";
			print OUT $key."\t".$pattern->{$key}."\n";
		} 
		close OUT;

		my $sp;
# 存储候选 shift pattern
# 搜索空间巨大
		foreach my $key (keys %{$pattern}) {
			#print $key.":\n";
			for (my $i = 0; $i < @$data; $i++) {
				chomp $data->[$i];
				#print "pattern  vs  sequence\n";
				my $sp_p = shift_pattern($key, $data->[$i]); 
			# 返回每条序列产生的候选shift pattern
				foreach my $key1 (keys %{$sp_p}) {
					#print $key1."=>".$sp_p->{$key1}."\n";
					$sp->{$key1}++;	
				# 每种sequential pattern 对应shift pattern支持度计数						
				}
			}	
		}
		open OUT,">".$kind."-shift_pattren-result"."-".$minsupport."-".$sfno."SF";
		foreach my $key (keys %{$sp}) {
			#print $key."=>".$sp->{$key}."\n";
			if ($sp->{$key} > $minsup-1){
				print $key."=>".$sp->{$key}."\n";
				print OUT $key."\t".$sp->{$key}."\n";
			}
		}
		close OUT;

#缺点:一个序列可能存在多个模式,这里没有考虑周全.

		open INPUT,$kind."-shift_pattren-result"."-".$minsupport."-".$sfno."SF" or die "not find the file1:$!\n";
		#open INPUT1, $file1 or die "not find the file! #!\n";
		#@tdata origin
		#@data tr
		open OUT, ">".$kind."-regular-expression-".$minsupport."-".$sfno."SF";
		my @sp = <INPUT>;
		close INPUT;
		for (my $k = 0; $k < @sp; $k++) {
			chomp $k;
			my @sp_line = split("\t", $sp[$k]);	
			my $pro_mat;	
			foreach my $sequence (@tdata) {
				chomp $sequence;
				$_ = $sequence;
				my @itemst = /$sp_line[0]/;
				my $n = 1;
				for (my $i = 0; $i<@itemst; $i++) {
					my $len = length($itemst[$i]);
					if($len != 0) {
						if ( $i == 0) {
							for (my $j = 0; $j < $len; $j++) {
								my $item = substr($itemst[$i], $j, 1);
								$pro_mat->{$j-$len}{$item} ++;
							}
						}else {
							for (my $j = 0; $j < $len; $j ++ ) {
								my $item = substr($itemst[$i], $j, 1);
								$pro_mat->{$n}{$item} ++;
								$n++;					
							}
						}
					}
				}
			}
			print OUT $sp_line[0]."\t".$sp_line[-1]/@tdata."\t".$sfno."\t";
			#print $sp_line[0]."\t".$sp_line[-1]/@tdata."\t".$sfno."\t";
			foreach my $key1(sort keys %$pro_mat) {
				my $sum = 0.0;			
				foreach my $key2(sort keys %{$pro_mat->{$key1}}) {
					$sum += $pro_mat->{$key1}{$key2};
				}
				print OUT $key1."=>";
				#print $key1."=>";
				foreach my $key2(sort keys %{$pro_mat->{$key1}}) {
				
					print OUT $key2.":".$pro_mat->{$key1}{$key2}/$sum."\t";
					#print $key2.":".$pro_mat->{$key1}{$key2}/$sum."\t";
				}
				print OUT ";";
			}
			print OUT "\n";
			#print "\n";
		}
		close OUT;		
	}
}

##############################################################################
# shift_pattern() and backtrack() gernerates the sequential features ---shift pattern 
sub shift_pattern($$) {
	my $seq_pa = shift;
	my $sequence = shift;
	my $sp_p;

	my @seq_pa_list = split /\s+/, $seq_pa;
	my @sequence_list = split /\s+/, $sequence;
	open OUT,">shift_pattern_part";
	my $fileout = *OUT;
	backtrack(\@seq_pa_list,\@sequence_list,0,0,"",$fileout);
	close OUT;
	
	open INPUT,"shift_pattern_part" or die "not find the file:$!\n";
	while (<INPUT>) {
		chomp $_;
		$sp_p->{$_} = 1;	
	}
	close INPUT;

	return $sp_p;
}

sub backtrack($$$$$$) {
	my $seq_pa = shift;
	my $sequence = shift;
	my $i = shift;
	my $j = shift;
	my $prefix = shift;
	my $fileout = shift;
	my $prefixc = $prefix;	
	
	if ($i >= $sfno) {# 叶节点 
		$prefix = join "([AGCT]*)", ($prefix,"");
		#print $prefix."...\n";
		print $fileout $prefix."\n";
	}else {#层搜索
		my $k = $j;		
		for (; $k < @$sequence;) {
			if ($seq_pa->[$i] eq $sequence->[$k] ) {
				if ($prefix eq "") {
					$prefix = join "([AGCT]*)", ($prefix, $seq_pa->[$i]);			
				}else {
					my $g = $k - $j;
					if ($g == 0) {
						$prefix = join "", ($prefix,$seq_pa->[$i]);
					} else {
						$prefix = join "([AGCT]{".$g."})", ($prefix,$seq_pa->[$i]);
					}		
				}
				$i++;
				$k++;
				&backtrack($seq_pa,$sequence,$i,$k,$prefix,$fileout);
				$i--;
				$prefix = $prefixc;
			}else {
				$k++;
			}		
		}		
	}
}











