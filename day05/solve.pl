#!/usr/bin/perl
# AoC day 05 star 1 - supply stacks

# implement the elves' cargo stapling 
use strict;
use warnings;
use Data::Dumper; # for cheap prettyprint checks.

# create the initial stacks from the top part of the input:
sub dummyinit{ # for getting started without annoying read:
  # example wants enumeration from 1, will not do that with
  # data struct, will adapter that in call transparently then.
  my ($sp) = @_; # stack pointer
  # construct stacks from top to bottom to ease visual checks
  # and file reading later:
  $sp->[0] = [ qw(N Z) ];
  $sp->[1] = [ qw(D C M) ];
  $sp->[2] = [ qw(P) ];
  # using c'tor brackets, see "Make rule 2" from "man perlreftut".
}

sub readinit{ # sooner or later gotta do that annoying reader. later. 
}

# operate on two given stacks:
sub movecrates{
  my ($num,$from,$to)=@_;
  while($num>0){
    my $e=shift(@{$from});
    unshift(@{$to},$e);
    $num--;
  }
}

# list of stacks:
my @stacks;
# will contain ptrs to lists, so we get a LoL.

# read/generate content:
dummyinit(\@stacks);
print Dumper(@stacks)."\n";

# execute the movement commands:
open(FH,"testinput") or die "file fail";
while(<FH>){
  # ok, we know there is only 9 stacks, so one digit as of now:
  if(m/move (\d+) from (\d) to (\d)/){
    my ($num,$from,$to)=($1,$2,$3); # name matches
    print "moving $num from stack $from to stack $to...\n";
    # keep helper simple and explicitly hand over the two stacks,
    # here we also map internal index [0..] to control [1..]:
    movecrates($num,$stacks[$from-1],$stacks[$to-1]); 
    # check state:
    print Dumper(@stacks)."\n";
  }
}
close(FH);
