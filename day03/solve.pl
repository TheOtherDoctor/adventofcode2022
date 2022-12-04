#!/usr/bin/perl 
# AoC day 03 puzzle 2: group-of-three rucksack common badge
use strict;
use warnings;

# item/char common to two given strings:
sub getcommon2{
  my ($s1,$s2)=@_;
  # pattern match simple:
  for my $c (split(//,$s1)){
    my $f=index($s2,$c); # results in -1 if nomatch.
    if ($f>=0){ return $c; }
  }
  # we are given that there is exactly one duplex item per rucksack:
  die "assert violated, no duplex item.";
}

# find duplicate helper:
sub getduplex{
  my ($str)=@_;
  # split the string into two halves:
  my $lenhalf=length($str)/2;
  if(length($str)%2==1){ die "pack items not a even"; }
  my $s1=substr($str,0,$lenhalf);
  my $s2=substr($str,$lenhalf,$lenhalf);
  print "for '$str': len/2 = $lenhalf; ";
  return getcommon2($s1,$s2);
}

# prio mapping helper:
sub getprio{
  my ($c)=@_;
  my $n=ord($c);
  if($c=~m/[a-z]/){return $n-ord("a")+1;}
  if($c=~m/[A-Z]/){return $n-ord("A")+27;}
  die "ERR: strange char.";
}

# testing:
if (1==2){
my $d1=getduplex("abcdAbCD"); print "d1 --> $d1\n";
my $d2=getduplex("abcdABcD"); print "d2 --> $d2\n";
my $t1=getprio("d"); print "d --> $t1\n";
my $t2=getprio("E"); print "E --> $t2\n";
}
#my $t3=getprio("?");
#print "? --> $t3\n"; # dies.

# this will be the final result:
my $priosum=0;
# open file and read line by line:
open(FH,"input") or die "filefail.\n";
while(<FH>){
  chomp();
  # find the item (character) which is in both the lower 
  # and the upper halb of this sack:
  my $dupchar=getduplex($_);
  print "dupchar=$dupchar; ";
  # increase prio sum with the the prioscore for this item/char:
  $priosum += getprio($dupchar);
  print "priosum now $priosum.\n";
}
close(FH);
print "overall sum of item prios is $priosum\n";
exit(0);
