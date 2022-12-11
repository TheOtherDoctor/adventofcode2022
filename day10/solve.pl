#!/usr/bin/perl

# AoC day 10 star 1 - Cathode-Ray Tube
# tr
use strict;
use warnings;

my $sigstrsum=0; # signal strength norm sum, the final report value.
my @prtcycs=qw(20 60 100 140 180 220);
my $cyc=0; # we are at _end_ of cycle cyc.
my $x=1;# current signal level.

# check if current $cyc is output cycle:
sub testout{
  my(@c) = @_;
  if(grep(/^$cyc$/,@prtcycs)){  
    my $score=$cyc*$x;
    $sigstrsum+=$score;
    print "\nend of cycle $cyc: x=$x so score is $score -> sum=$sigstrsum\n";
  }   
}

# one straight loop, read cmd after cmd and directly exec.
open(FH,"input") or die "filefail.";
while(<FH>){
  chomp();
  if(m/noop/){$cyc++; testout(); next;}
  if(m/addx ([-\d]+)/){$cyc++; testout(); $cyc++; testout(); $x+=$1;  }
  if($cyc<10){ print "end of cycle $cyc: x=$x\n";} 
}
close(FH);
print "at the end, scoresum is $sigstrsum\n";
