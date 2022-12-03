#!/usr/bin/perl 
# AoC 2022 day 02: the elves' rock-paper-scissors tournament 
# strategy evaluation, updated strategy paper (=puzzlepart2).
use strict;
use warnings;

# tiny helper to tell the score for me when args are 1.my 2.goal:
sub score {
  my ($o, $must)=@_; # must-result-in and o(therspick).
  my $mine; # to be filled with my pick
  my %goal=('X'=>'me losing', 'Y'=>'draw', 'Z'=>'me winning'); # meanings for log.
  print "other picked $o, it shall end $goal{$must}, "; 

  # it seems most readable to encode all logic into dictionaries here
  # instead of doing ascii arithmetics nonsense... ;-)
  # evaluation vector: tells for each enumerated symbol
  # val wins over key, $wins('A')=='B' means B wins over A. 
  my %wins=('A'=>'B', 'B'=>'C', 'C'=>'A');
  my %lose = reverse (%wins); # losing is opposite of winning. ;-)

  # can/will calc score right away:
  my $add=0;
  # the point values for the symbols:
  my %val=('A'=>1, # Rock
           'B'=>2, # Paper
           'C'=>3  # Scissors
          );
  # note that it is actually not asked to document what
  # to pick to fulfill the goal, but the scoring rule
  # needs that. ;-)
  # X -> I (shall) lose:
  if($must eq 'X'){ $mine=$lose{$o}; $add=$val{$mine}; } 
  # Y -> shall be a draw:
  if($must eq 'Y'){ $mine=$o; $add=$val{$mine}+3; } 
  # Z -> I shall win: 
  if($must eq 'Z'){ $mine=$wins{$o}; $add=$val{$mine}+6; } 
  # see what we got:
  print "so I picked $mine, scoring $add this round.\n";

  return $add;
  # note: puzzle asks only for my score, not comparison to others.
}

open(FH,"input") or die "file oops. $!";
# main loop over lines in strategy file:
my $mysum=0; 
while(<FH>){
  # each line one round. get this round's choice for me and other:
  # take care, first entry is other's, 2nd is my role/goal...
  if (m/^([A-C]) ([X-Z])$/){
    $mysum += score($1,$2);
  # expect the unexpected:
  } else { die "unexpected line format.\n"; }
}

print "at the end of the tournament, my total score is $mysum\n";
close(FH);

