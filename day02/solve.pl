#!/usr/bin/perl 
# AoC 2022 day 02: the elves' rock-paper-scissors tournament 
# strategy evaluation.
use strict;
use warnings;

# tiny helper to tell the score for me when args are 1.my 2.your pick:
sub score {
  my ($o, $mine)=@_; # mine and o(thers).
  print "other picked $o, me picking $mine, "; 
  # the point values for the symbols:
  my %val=('X'=>1, 'Y'=>2, 'Z'=>3);
  # it seems most readable to encode all logic into dictionaries here
  # instead of doing ascii arithmetics nonsense... ;-)
  # evaluation vector: tells for each enumerated symbol
  # left wins over right. 
  my %wins=('X'=>'C', 'Y'=>'A', 'Z'=>'B');
  # the combinations which end up in a draw:
  my %same=('X'=>'A', 'Y'=>'B', 'Z'=>'C');
  # if both are same, easy exit:
  my $add=$val{$mine}; # init to val for "I lost"... as of now.
  if($same{$mine} eq $o){$add+=3;}
  if($wins{$mine} eq $o){$add+=6;}
  print "my score from that round is $add\n"; 
  return $add;
  # puzzle asks only for my score, not comparison to others.
}

open(FH,"input") or die "file oops. $!";
# main loop over lines in strategy file:
my $mysum=0; 
while(<FH>){
  # each line one round. get this round's choice for me and other:
  # take care, first entry is other's, 2nd is mine...
  if (m/^([A-C]) ([X-Z])$/){
    $mysum += score($1,$2);
  # expect the unexpected:
  } else { die "unexpected line format.\n"; }
}

print "at the end of the tournament, my total score is $mysum\n";
close(FH);

