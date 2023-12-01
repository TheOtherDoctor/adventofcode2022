#!/usr/bin/perl
# AoC day 05 star 1 - supply stacks

# implement the elves' cargo stapling 
use strict;
use warnings;
use Data::Dumper; # for cheap prettyprint checks.

my $INFILE="input";

# create the initial stacks from the top part of the input:
# takes given stack as call arg.
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

# sub-helper to decompose one init line into colblocks to push onto stacks
sub line2stacks{
  my ($line,$sp) = @_; # stack pointer
  # eat this/each line colblock by colblock:
  my $idx=0; # stacknum to target.
  while($_){
    if(s/^(...)//){ # grab/remove first 3 chars, always true
      my $snip=$1;
      if($snip=~m/^\[([A-Z])\]/){ # something to push
        my $char=$1;
        push(@{$sp->[$idx]},$char); # push it... operating on top
      }
    }else{ die "logic error."; }
    # if there is something left, advance a field: 
    if($_){ 
      s/^ //; # remove the separator space 
      $idx++; # and incr. index
    }
  } # (while content left in line)
}

# read initial stack setup from file:
# note that there are trailing spaces to make all lines full length.
# takes given stack as call arg, and filename from global,
# so same call as dummy above.
sub readinit{ 
  my ($sp) = @_; # stack pointer
  open(FH,"$INFILE") or die "file fail";
  my $fline=0;
  while(<FH>){
    print "read init content line ".$fline++." ...\n";
    chomp();
    if(m/^ 1   2/){close(FH); return;}
    # got a data line, transfer into stacks:
    line2stacks($_,$sp);
  } # (while lines in file)
  die "failed to find init header end in input.";
  # no good end here.
}

# operate on two given stacks, with CrateMover9000:
sub movecrates{
  my ($num,$from,$to)=@_;
  while($num>0){
    my $e=shift(@{$from});
    unshift(@{$to},$e);
    $num--;
  }
}

# the CrateMover9001, keeping the moving pack in order:
sub movecrates2{
  my ($num,$from,$to)=@_;
  my @movepack=();
  while($num>0){
    my $e=shift(@{$from});
    # push from bottom into a fresh empty pack keeps the order:
    push(@movepack,$e);
    $num--;
  }
  # bring the movepack back into the orig order
  unshift(@{$to},@movepack);
}

# write the string of top items as report:
sub report{
  my($stacks)=@_;
  my $report="";
  foreach my $s (@{$stacks}){
    my $topitem=shift(@{$s}); 
    unshift(@{$s},$topitem); # no RO function should leave it crippled. ;-)
    $report=$report.$topitem;
  }
  print "$report\n";
}

# list of stacks:
my @stacks;
# will contain ptrs to lists, so we get a LoL.

# read/generate content:
readinit(\@stacks);
print Dumper(@stacks)."\n";

# execute the movement commands:
open(FH,"$INFILE") or die "file fail";
while(<FH>){
  # ok, we know there is only 9 stacks, so one digit as of now:
  if(m/move (\d+) from (\d) to (\d)/){
    my ($num,$from,$to)=($1,$2,$3); # name matches
    print "moving $num from stack $from to stack $to...\n";
    # keep helper simple and explicitly hand over the two stacks,
    # here we also map internal index [0..] to control [1..]:
    movecrates2($num,$stacks[$from-1],$stacks[$to-1]); 
    # check state:
    print Dumper(@stacks)."\n";
    # report compressed result:
  }
}
print "final report: "; 
report(\@stacks);
close(FH);
