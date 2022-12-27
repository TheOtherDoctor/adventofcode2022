#!/usr/bin/perl -w
# AoC day 21 star 1

open(INP,"input") or die "filefail";
# either
# dbpl: 5
# or
# cczh: sllz + lgvd
# and aggregate for "root".

# basic naive idea: 
# we might not have to solve equ. systems (so no circular references, 
# but just have to eval expressions.
# then we can loop through the stack and check for
# each expression if we have two numbers, and if yes, calc the
# expr and replace it by the result, and loop on.

my %nums;
my %calc;

while(<INP>){
  chomp();
  if(m/^(\w+):\s+(\S+.*)$/){
    my $who=$1 ;
    my $what=$2 ;
    if($what=~m/(\d+)/){ # there seem to be no negative numbers...
      print "$_ is a plain number, fine.\n";
      $nums{$who}=$what;
    }else{ 
      print "$_ is an expression for the todo stack.\n";
      $calc{$who}=$what;
    }
  }
}
close(INP);
print "got ",scalar(%nums)," known numbers and ",
      scalar(%calc)," expressions to determine.\n\n";

# for each expression, lookup the two referred variables
while(scalar(%calc)){
  foreach my $k (keys(%calc)){
    my $expr=$calc{$k};
    if($expr =~ m/(\w+)\s+\S\s+(\w+)/){
      my $left=$1; my $rght=$2;
      my $numleft=$nums{$left};
      my $numrght=$nums{$rght};
      # actually, this is overly careful, but who cares...
      if(defined($numleft) && defined($numrght)){ 
        print "can eval '$expr' to get value for monkey $k ... ";
        # making the entry an executable expression seems way 
        # easier than parsing the vars:
        $expr =~ s/(\w+)/\$nums\{$1\}/g;
        print "evaluating '$expr' ... ";
        my $res = eval "$expr";
        if(defined($res)){$nums{$k}=$res;}
        print $nums{$k},"\n";
        # remove the expr from calc hash now:
        delete $calc{$k};
      }
    }
  }
  print "re-looping...\n";
}
exit(0);
