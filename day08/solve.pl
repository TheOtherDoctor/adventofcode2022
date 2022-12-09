#!/usr/bin/perl
# AoC day 08 star 1 - treetop visibility

use strict;
use warnings;
use Data::Dumper; # for cheap prettyprint checks.

# strict rationale of concept: There is only one central operation,
# namely looking along a height vector in one direction, standing at
# one position of the vector. Prefetch all viewability evaluations.
# For each position, grab the two associated vectors for it and pick
# the result for all directions." 

my $INFILE="input";

# read map matrix from file:
# returns results by filling the list given per pointer
sub readinit{ 
  my $sp=(); # new empty array for the raw strings
  open(FH,"$INFILE") or die "file fail";
  print "input dump:\n";
  my $i=0;
  while(<FH>){
    print $_;
    chomp();
    push(@{$sp},$_); # or "$sp->[$i]=$_" ?
    $i++;
  } 
  close(FH);
  return $sp;
}

# traverse given string from beginning to end and tell for each
# position if it is visible from the beginning ("left") end or not.
# sets a "1" if position is visible, and a "0" if not.
sub lookout{
  my ($s)=@_; # one string to be eval'd
  my $maxyet=-1;  # "0" is a valid tree height.
  my $a=""; # return this. init empty.
  for my $c (split(//,$s)){ 
    my $v=($c>$maxyet) ? 1 : 0; # view yes or no.
    if($v){$maxyet=$c;} # new max
    $a = $a.$v;
  }
  # print orig height numbers and visibility conclusion aligned to check:
  #print "DBG lookout:\n$s\n$a\n";
  return $a;
}

# create the grid of viewability in each direction (NSWE)
sub makecompass{
  my ($ps) = @_; # ptr to string list
  my %views = ( # views
    west => [], # c'tors for one list each direction
    east => [],
    north => [],
    south => [],
  );
#  print "DBG: struct init:\n",Dumper(%views);
  # copy the raw rows for view from west (="left").
  for my $hs (@{$ps}){ # "horizontal strings"
    # the function to create the viewability vector is agnostic
    # working purely in 1d:
    push(@{$views{west}},lookout($hs));
    # revert to get other view dir:
    my $rs=reverse $hs;
    push(@{$views{east}},lookout($rs));
  }
  # now we have the rows, and the west-east views are prefetched.
  # also need transposed for norst-south views:
  my $nv=length($ps->[0]); # number of vertical view vectors to build
  for my $i (0..($nv-1)){
    my $vs=""; # "vertical strings"
    for my $hs (@{$ps}){ # "horizontal strings"
      $vs=$vs.substr($hs,$i,1); # slice
    }
    push(@{$views{north}},lookout($vs));
    my $rv=reverse $vs;
    push(@{$views{south}},lookout($rv));
  }
  
  print "DBG: viewdirs content done:\n",Dumper(%views);
  
  return \%views;
}

# based on prefetched views, tell if queried pos is visible.
# 1 means visible, 0 invisible.
# assumes square matrix.
sub evalViewable{
  my ($pviews,$ih,$iv)=@_;
  # the horz views:
  my $wv=$pviews->{west}->[$iv];
  if(substr($wv,$ih,1)=="1"){return 1;} # early exit.
  my $mi=length($wv)-1; # max index in any dir.
  my $ev=$pviews->{east}->[$iv];
  if(substr($ev,$mi-$ih,1)=="1"){return 1;}
  # the vert views:
  my $nv=$pviews->{north}->[$ih];
  if(substr($nv,$iv,1)=="1"){return 1;} # early exit.
  my $sv=$pviews->{south}->[$ih];
  if(substr($sv,$mi-$iv,1)=="1"){return 1;}
  # if no direction made it, return invisible:
  return 0; 
}

# scratchpad for sub testing:
sub dummytests{
  my $dummy="3137032551265303233154931539";
  lookout($dummy);
  my $rd=reverse $dummy;
  lookout($rd);
}

# main code:

#TRY#dummytests();

# list of stacks:
my @stacks;
# will contain ptrs to lists, so we get a LoL.

# read file 
my $pstrings;
$pstrings = readinit();
# dimension of forest matrix
my $nhorz=length($pstrings->[0]); # num trees in horz=east/west direction
my $nvert=scalar(@{$pstrings}); # num trees in vert=north/south direction
print "dimension westeast=$nhorz northsouth=$nvert\n";
if($nhorz != $nvert){ die "surprise! a non square matrix. enter the regime of the untested...\n"; }
my $mi=$nhorz-1; # maxindex. 

# build directional viewability maps:
my $pviews;
$pviews = makecompass($pstrings);

my $ntrees=0;
# loop over the generated visual direction vector strings and eval
# at each position (i.e. all vert with all horz, details do not matter).
print "final combined visibility map:\n";
for my $iv (0..$mi){
  for my $ih (0..$mi){
    my $see=evalViewable($pviews,$ih,$iv);
    $ntrees += $see;
    print "$see";
    #DBG# print "sent h=$ih v=$iv --> see=$see\n";
  }
  print "\n";
}

print "final report: there are $ntrees trees visible from outside the grid.\n"; 
