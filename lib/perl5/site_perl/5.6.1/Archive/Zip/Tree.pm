# $Revision: 1.2 $
package Archive::Zip::Archive;
use File::Find ();
use Archive::Zip qw(:ERROR_CODES :UTILITY_METHODS);

=head1 NAME

Archive::Zip::Tree -- methods for adding/extracting trees using Archive::Zip

=head1 SYNOPSIS

  use Archive::Zip;
  use Archive::Zip::Tree;
  my $zip = Archive::Zip->new();
  # add all readable files below . as xyz/*
  $zip->addTree( '.', 'xyz', { -r $_[0] } );	
  # add all .c files below /tmp as stuff/*
  $zip->addTreeMatching( '/tmp', 'stuff', '\.c$' );
  # now extract the same files
  $zip->extractTree( 'stuff', '/tmp' );
  $zip->writeToFile('xxx.zip');

=head1 METHODS

=over 4

=item $zip->addTree( $root, $dest [,$pred] )

$root is the root of the tree of files and directories to be added

$dest is the name for the root in the zip file (undef or blank means to use
relative pathnames)

$pred is an optional subroutine reference to select files: it is passed the
name of the prospective file or directory, and if it returns true, the file or
directory will be included.  The default is to add all readable files and
directories.

To use absolute pathnames, just do:

$zip->addTree( $root, $root );

Returns AZ_OK on success.

Note that this will not follow symbolic links to directories.

Note also that this does not check for the validity of filenames.

=back

=cut

sub addTree
{
	my $self = shift;
	my $root = shift or return _error("root arg missing in call to addTree()");
	my $dest = shift || '';
	my $pred = shift || sub { -r $_[0] };
	$root =~ s{\\}{/}g;	# normalize backslashes in case user is misguided
	$root =~ s{([^/])$}{$1/};	# append slash if necessary
	$dest =~ s{([^/])$}{$1/} if $dest;	# append slash if necessary
	my @files;
	File::Find::find( sub { push( @files, $File::Find::name ) }, $root );
	@files = grep( $pred, @files );
	foreach my $fileName ( @files )
	{
		( my $archiveName = $fileName ) =~ s{^\Q$root}{$dest};
		$archiveName =~ s{^\./}{};
		next if $archiveName =~ m{^\.?/?$};	# skip current dir
		my $member = ( -d $fileName )
			? $self->addDirectory( $fileName, $archiveName )
			: $self->addFile( $fileName, $archiveName );
		return _error( "add $fileName failed in addTree()" ) if !$member;
	}
	return AZ_OK;
}

=over 4

=item $zip->addTreeMatching( $root, $dest, $pattern [,$pred] )

$root is the root of the tree of files and directories to be added

$dest is the name for the root in the zip file (undef means to use relative
pathnames)

$pattern is a (non-anchored) regular expression for filenames to match

$pred is an optional subroutine reference to select files: it is passed the
name of the prospective file or directory, and if it returns true, the file or
directory will be included.  The default is to add all readable files and
directories.

To use absolute pathnames, just do:

$zip->addTreeMatching( $root, $root, $pattern );

Returns AZ_OK on success.

Note that this will not follow symbolic links to directories.

=back

=cut

sub addTreeMatching
{
	my $self = shift;
	my $root = shift
		or return _error("root arg missing in call to addTreeMatching()");
	my $dest = shift || '';
	my $pattern = shift
		or return _error("pattern missing in call to addTreeMatching()");
	my $pred = shift || sub { -r shift };
	my $matcher = sub
	{
		my $fileName = shift;
		$fileName =~ m{$pattern} && &$pred( $fileName );
	};
	return $self->addTree( $root, $dest, $matcher );
}

=over 4

=item $zip->extractTree( $root, $dest [,$pred] )

Extracts all the members below a given root. Will
translate that root to a given dest pathname.

=back 

=cut

sub extractTree
{
	my $self = shift;
	my $root = shift
		or return _error("root arg missing in call to extractTree()");
	my $dest = shift || '.';
	$root =~ s{\\}{/}g;	# normalize backslashes in case user is misguided
	$root =~ s{([^/])$}{$1/};	# append slash if necessary
	my @members = $self->membersMatching( "^$root" );
	foreach my $member ( @members )
	{
		my $fileName = $member->fileName(); 
		$fileName =~ s{$root}{$dest};
		my $status = $member->extractToFileNamed( $fileName );
		return $status if $status != AZ_OK;
	}
	return AZ_OK;
}

1;
__END__

=head1 AUTHOR

Ned Konz, perl@bike-nomad.com

=head1 COPYRIGHT

Copyright (c) 2000 Ned Konz. All rights reserved.  This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=head1 SEE ALSO

L<Compress::Zlib>
L<Archive::Zip>

=cut

# vim: ts=4 sw=4 columns=80
