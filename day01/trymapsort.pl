#!/usr/bin/perl -w
# proto snipped to show how to sort such that the index is preserved.

my @vals=( 1245, 4367, 9463, 2038, 7401);

# sort the list and keep info on orig position via hash:
my %hash = map { $_ => $vals[$_] } (0 .. @vals-1);

# intermed check output:
print "orig list:\n";
foreach my $k (sort(keys(%hash))){
	print "$k -> $hash{$k}\n";
}

# now we can sort the index with the values as criterion:
my @IdxAsc = sort { $hash{$a} <=> $hash{$b} } keys(%hash);

print "list sorted by value ascending:\n";
foreach my $k (@IdxAsc){
        print "$k -> $hash{$k}\n";
}


