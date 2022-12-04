#!/usr/bin/perl 
# AoC day 03 puzzle 2: group-of-three rucksack common badge
use strict;
use warnings;

# item/char common to three given strings:
sub getcommon3{
  my ($s1,$s2,$s3)=@_;
  # pattern match simple: try for each char in string 1:
  for my $c (split(//,$s1)){
    # exists in string 2?
    my $f2=index($s2,$c); # results in -1 if nomatch.
    if ($f2>=0){ 
      # also in string 3?
      my $f3=index($s3,$c); # results in -1 if nomatch.
      if ($f3>=0){ 
        return $c; }
    }
  }
  # we are given that there is exactly one duplex item per rucksack:
  die "assert violated, no common item.";
}

# prio mapping helper:
sub getprio{
  my ($c)=@_;
  my $n=ord($c);
  if($c=~m/[a-z]/){return $n-ord("a")+1;}
  if($c=~m/[A-Z]/){return $n-ord("A")+27;}
  die "ERR: strange char.";
}

# optional testing:
if (1==2){
my $d1=getcommon3("abcd","AbCD","xyzb"); print "d1 --> $d1\n";
my $d2=getcommon3("abcd","ABcD","abcD"); print "d2 --> $d2\n";
my $t1=getprio("d"); print "d --> $t1\n";
my $t2=getprio("E"); print "E --> $t2\n";
}

# main: 
my $priosum=0; # this will be the final result.
# open file and read line by line:
open(FH,"input") or die "filefail.\n";
while(<FH>){
  chomp(); my $s1=$_;
  # pick two more to have the group of three
  my $s2=<FH>; chomp($s2);
  my $s3=<FH>; chomp($s3);
  # find the item (character) which is in all these 3 rucksacks,
  # no matter which compartment:
  my $dupchar=getcommon3($s1,$s2,$s3);
  print "dupchar=$dupchar; ";
  # increase prio sum with the the prioscore for this item/char:
  $priosum += getprio($dupchar);
  print "priosum now $priosum.\n";
}
close(FH);
print "overall sum of item prios is $priosum\n";
exit(0);
