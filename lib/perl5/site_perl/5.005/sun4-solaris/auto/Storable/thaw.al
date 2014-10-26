# NOTE: Derived from blib/lib/Storable.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Storable;

#line 227 "blib/lib/Storable.pm (autosplit into blib/lib/auto/Storable/thaw.al)"
#
# thaw
#
# Recreate objects in memory from an existing frozen image created
# by freeze.  If the frozen image passed is undef, return undef.
#
sub thaw {
	my ($frozen) = @_;
	return undef unless defined $frozen;
	my $self;
	my $da = $@;							# Could be from exception handler
	eval { $self = mretrieve($frozen) };	# Call C routine
	croak $@ if $@ =~ s/\.?\n$/,/;
	$@ = $da;
	return $self;
}

1;
# end of Storable::thaw
