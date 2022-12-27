#!/usr/bin/perl -w
# AoC day 21 star 2

open(INP,"input") or die "filefail";
# either
# dbpl: 5
# or
# cczh: sllz + lgvd
# and aggregate for "root".

# basic naive idea: 
# we might not have to solve equ. systems (so no circular references, 
# but just have to eval expressions).
# then we can loop through the stack and check for
# each expression if we have two numbers, and if yes, calc the
# expr and replace it by the result, and loop on.

my %rdnums;
my %rdcalc;

while(<INP>){
  chomp();
  if(m/^(\w+):\s+(\S+.*)$/){
    my $who=$1 ;
    my $what=$2 ;
    if($what=~m/(\d+)/){ # there seem to be no negative numbers...
      print "$_ is a plain number, fine.\n";
      $rdnums{$who}=$what;
    }else{ 
      print "$_ is an expression for the todo stack.\n";
      $rdcalc{$who}=$what;
    }
  }
}
close(INP);
print "got ",scalar(%rdnums)," known numbers and ",
      scalar(%rdcalc)," expressions to determine.\n\n";

# redefined humn number:
my $humanerror=0;
my $humn=0;
# try a brute bisection search, check if good enough.

while(1){
  
  my %calc=%rdcalc; # fresh clone 
  my %nums=%rdnums; # fresh clone 

  print "humn shouts $humn now...\n";
  $nums{humn}=$humn; 
  delete($calc{humn}); 

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
#          print "can eval '$expr' to get value for monkey $k ... ";
          # making the entry an executable expression seems way 
          # easier than parsing the vars:
          $expr =~ s/(\w+)/\$nums\{$1\}/g;
#          print "evaluating '$expr' ... ";
          my $res = eval "$expr";
          if(defined($res)){$nums{$k}=$res;}
#          print $nums{$k},"\n";
          # remove the expr from calc hash now:
          delete $calc{$k};
          # redefined task for root monkey:
          if($k eq "root"){
            print "root monkey compares $numleft and $numrght ... ";
            if(abs($numleft - $numrght)<0.1){
              print "gotcha! humn==$humn was the right approach.\n";
              exit(0);
            }else{
              print "no match. humn==$humn was NOT the right shout... error=";
              $humanerror=$numleft-$numrght;
              print $humanerror,"\n";
              # stops anyway now since %calc is empty.
            }
          }
        }
      }
    }
#    print "re-looping...\n";
  }
  print "\n\n  humn==$humn was not a match. here we go again...\n";
  
  $humn=int($humn+abs($humanerror/16)+1); # not precise, but good enough ;-)

} # while forever to try new start values.

exit(0);
