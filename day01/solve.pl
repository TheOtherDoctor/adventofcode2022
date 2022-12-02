#!/usr/bin/perl -w
# TheOtherDoctor's code snips for AdventOfCode 2022.
#
# in my timezone the AoC release time is 6AM. 
# So I will never ever make it to the leaderboard, but
# do things late in my evening.
#
# day 01: sum up the elves' travel pack calories. 

use strict; # force me to declare variables.
use warnings; # I can stand the feedback.

# slurp the file into one string, including all newlines etc:
#  note: using a do expression (no loop!) to create the subcontext 
#  for the local modifier, and hand out the content elegant
#  as sideeffect, as the value of the last statement in the block
#  becomes value of the do { } expr, and thus the RHS for the assignment.
my $filedoc = do {
    local $/ = undef; # no line separator character in this block
    open my $f, "<", "input" or die "file oops. $!";
    <$f>; # single read 
};
# create top level list by splitting at blank lines:
# we assume each elf has at least one thingy.
my @tll=split(/\n\n/,$filedoc);
# for each item in the list, 
my $c=0; # counter helps debug.
my @elfsums; # sums will go into this list.
foreach my $elfpack (@tll){
  # create an executable expression
  # by replacing linebreaks by "+" ...
  $elfpack =~ s/\n/+/g;
  print "elf #$c: $elfpack --> ";
  # ...and exec the string code to sum up the items:
  my $elfsum = eval $elfpack;
  print "$elfsum\n";
  push(@elfsums,$elfsum);
  # if we'd be interested at the pos/key of the picked
  # values, we'd better construct a hash here, say
  # $elfsums{$c}=$elfsum;
  $c++;
}

# sort the list, get value and index of biggest:
my @ess=reverse sort(@elfsums);
my $elfmax=$ess[0];
print "puzzle 1: elf with most food brings $elfmax\n";

# out of bonus curiosity:
# which elf is the one with the max packe? 
# account for it might be multiple with same amount.
# iterate over indices and check for each if the entry is the 
# found max number.
my @fatelves = grep { $elfsums[$_] eq $elfmax } (0 .. @elfsums-1);
print "that is carried by elf at index ";
foreach my $idx (@fatelves) { print "$idx "; }
print " (counting from 0)\n";

# puzzle part two: 
# total amount carried by the top three elves:
my $top3 = $ess[0]+$ess[1]+$ess[2];
print "puzzle 2: the three elves with most carry together $top3.\n";
