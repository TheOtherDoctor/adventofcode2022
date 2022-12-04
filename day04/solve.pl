#!/usr/bin/perl
# AoC2022 day 04 - camp cleanup - puzzle star 1
# count the pairs of region overlaps.
use strict;
use warnings;

# return 1 when point is within range,
# with r0 being smaller than r1.
sub ptInRange{
  my ($p,$r0,$r1)=@_;
  return ( ($p>=$r0) && ($p<=$r1) );
}

# counter:
my $numembed=0; # fully covered ranges
# loop over file
open(FH,"input") or die "filefail.\n";
while(<FH>){
  chomp();
  print "$_ --> ";
  my ($a0,$a1,$b0,$b1);
  # all-in-one regex match:
  if(m/(\d+)-(\d+),(\d+)-(\d+)/){ # expected format
    ($a0,$a1,$b0,$b1)=($1,$2,$3,$4); # alias matches
    # full coverage == boths b's in range a or both a's in range b:
    my $embeds=0; # flag (both conds can apply, do not count twice...)
    if( (ptInRange($b0, $a0,$a1) && ptInRange($b1, $a0,$a1)) ){ $embeds=1; print "left covers right. "; }
    if( (ptInRange($a0, $b0,$b1) && ptInRange($a1, $b0,$b1)) ){ $embeds=1; print "right covers left. "; }
    $numembed+=$embeds;
  }else{ # no regex match:
    die "table format oops.";
  }
  print "\n";
  # silently assuming that format is always "min(a)-max(a),min(b)-max(b)"...
  # and never like "max(a)-min(a),..."
} 
close(FH);
print "overall count of fully embedded ranges in pairs = $numembed.\n";
