#! /usr/bin/env perl

;#                                                               
;# COPYRIGHT
;# Copyright (c) 1998-2000 Anthony R Iano-Fletcher.  All rights reserved.  This
;# module is free software; you can redistribute it and/or modify it
;# under the same terms as Perl itself.
;#
;# Please retain my name on any bits taken from this code.
;# This code is supplied as-is - use at your own risk.
;#                                                               
;#			AR Iano-Fletcher.

# This is a X/TK digital clock widget based on strftime.

BEGIN { $^W = 1; }

package Tk::StrfClock;

require 5.001;
use strict;
use Carp;
use POSIX;
use Tk;
use Tk::Label;

use vars qw($VERSION @ISA);

$VERSION	= '1.2';

@ISA = qw (Tk::Derived Tk::Label);

Construct Tk::Widget 'StrfClock';

sub debug {};

sub Populate
{
	debug "args: @_\n";

	my $self = shift;
	$self->SUPER::Populate(@_);

	my %args = %{$_[0]};
	for (keys %args) { debug "$_ '$args{$_}'\n"; };

	# Set up extra configuration
	$self->ConfigSpecs(
		#'-format'	=> ['PASSIVE', 'format','Format', '%I:%M:%S%p, %A, %e %B %Y.'],
		'-format'	=> ['PASSIVE', 'format','Format', '%c'],
		'-update'	=> ['PASSIVE', 'update','Update', 'a'],
		'-advance'	=> ['PASSIVE', 'advance','Advance', 0],	# secs.
	);

	# the string.
	$self->{datetime} = '';
	$self->configure(-textvariable => \$self->{datetime});
}

# DoWhenIdle seems to be replaced by afterIdle in Tk800.018.
sub afterIdle { &DoWhenIdle; }

sub DoWhenIdle
{
	debug "args: @_\n";

	my $self = shift;

	# cancel any previous ticking.
	if (exists($self->{after}))
	{
		debug "cancelling after '$self->{after}'\n";

		# works but produces an odd error.
		#$self->afterCancel($self->{after}) if (exists($self->{after}));

		# work around
		$self->Tk::after('cancel' => $self->{after});

		delete($self->{after});
	}

	$self->tick();
}

# Refresh the time.
sub refresh
{
	debug "args: @_\n";
	my $self = shift;

	# don't do anything unless these are set up.....
	return unless defined($self->cget('-update'));
	return unless defined($self->cget('-format'));

	debug "$self: update is '", $self->cget('-update'), "'\n";
	debug "$self: format is '", $self->cget('-format'), "'\n";

	# Update the date/time string....

	# get the localtime details.
	my @localtime = localtime(time + $self->cget('-advance'));

	# Note: some POSIX::strftime translate %f to a single f.
	# So have to deal with this first. In particular, ActivePerl.

	# deal with %f.....
	my $str	= $self->cget('-format');
	$str	=~ s/%f/&th($localtime[3])/eg;

	debug "$self: format is '$str'\n";

	# finally pass it through strftime.
	$self->{datetime} = POSIX::strftime($str, @localtime);

	@localtime;
}

# Calculate the number of seconds before we need to update.
# Usage: $nap = $C->until(@localtime);
sub until
{
	debug "args: @_\n";

	my $self	= shift;
	my @localtime	= @_;

	my $update	= $self->cget('-update');

	$update = 'a' if (!defined($update) || $update eq '');

	# return the update if its just a number.
	return $update unless ($update =~ /\D/);

	if ($update =~ /^a/i)
	{
		# guess the update.....
		my $fmt	= $self->cget('-format');

		if    ($fmt =~ /%[cST]/)	{ $update = 's';}
		elsif ($fmt =~ /%M/ )		{ $update = 'm';}
		elsif ($fmt =~ /%H/ )		{ $update = 'h';}
		elsif ($fmt =~ /%P/i )		{ $update = 'p';}
		else				{ $update = 'd';}
	}

	if ($update =~ /^s/i)
	{
		# sync every second.
		$update = 1;
	}
	elsif ($update =~ /^m/i)
	{
		# sync on the minute.
		$update = 60 - $localtime[0];
	}
	elsif ($update =~ /^h/i)
	{
		# sync on the hour.
		$update = 3600 - $localtime[0] - 60*$localtime[1];
	}
	elsif ($update =~ /^p/i)
	{
		# sync at midday and midnight.
		$update = 12*3600 - $localtime[0] -
			60*$localtime[1] - 3600*($localtime[2]%12);
	}
	elsif ($update =~ /^d/i)
	{
		# sync at midnight.
		$update = 24*3600 - $localtime[0] - 60*$localtime[1] - 3600*$localtime[2];
	}
	else
	{
		#carp __PACKAGE__ . ": unknown value '$update' for update (resetting to 1 sec).\n";

		$update = 1;
	}

	debug "required nap is $update seconds.\n";

	$update;
}

# Tick every so often and update the label.
# $self->tick().
sub tick
{
	debug "args: @_\n";
	my $self = shift;

	# don't do anything unless these are set up.....
	return unless defined($self->cget('-update'));
	return unless defined($self->cget('-format'));

	# update the date/time string....
	my @localtime = $self->refresh();

	# If update is a letter then sync on a minute, hour or day.
	my $update = $self->until(@localtime);

	return undef unless ($update > 0 );

	# don't forget to tick again....
	$self->{after} = $self->after($update*1000, [ 'tick', $self]);

	debug "after ref '", ref($self->{after}), "'\n";
	debug "$self: updating in $update seconds ($self->{after}).\n";

	$self->{after};
}

# return the correct ending for first (1st), etc..
# This is hardwired and needs to be modified
# for each language.
sub th
{
	debug "args @_\n";

	my $e = shift;

	# eg. first == 1st....
	my $f = "th";
	if    ($e =~ /11$/)	{ $f = "th"; }
	elsif ($e =~ /12$/)	{ $f = "th"; }
	elsif ($e =~ /13$/)	{ $f = "th"; }
	elsif ($e =~ /1$/)	{ $f = "st"; }
	elsif ($e =~ /2$/)	{ $f = "nd"; }
	elsif ($e =~ /3$/)	{ $f = "rd"; }

	$f;
}

# Demonstration application.
sub test
{
	debug __PACKAGE__ . " version $VERSION\n";

	# do some remedial argument parsing.
	if (@_ && ($_[0] eq '-d'))
	{
		shift(@_);

		# set up debugging...
		eval '	sub debug {
			my ($package, $filename, $line,
				$subroutine, $hasargs, $wantargs) = caller(1);
			$line = (caller(0))[2];
	
			print STDERR "$subroutine: ";
	
			if (@_) {print STDERR @_; }
			else    {print "Debug $filename line $line.\n";}
			};
		';
	}

	# Test script
	use Tk;
	use Tk::Menubutton;
	#use Tk::StrfClock;

	my $top=MainWindow->new();
	$top->title(__PACKAGE__ . " version $VERSION");

	# Default arguments.
	my @formats = (
		'%c',
		'%I:%M%p, %A, %e%f %B %Y.',
		'%I:%M%p, %A, %B %e, %Y.',
		'%Y %B %e %T',
		'%Y %B %e %H:%M',
		'%Y %B %e %H%p',
		'%Y %B %e %T',
		'%A %p',
		'%T',
	);
	my @args = ();
	for (@_)
	{
		push (@args, ($_ eq 'test' ) ? @formats : $_);
	}

	# top button frame...
	my $bframe = $top->Frame(
	)->pack(
		-expand	=> 1,
		-fill	=> 'y',
		-side	=> 'top',
		-anchor	=> 'nw',
	);

	my $cframe = $top->Frame(
		#-relief	=> 'sunken',
		#-border	=> 1,
		-background	=> 'white',
	)->pack(
		-expand	=> 1,
		-fill	=> 'both',
		-side	=> 'top',
		-anchor	=> 'nw',
	);

	# primary StrfClock widget.
	my $dt = $cframe->StrfClock(
		-foreground	=> 'blue',
		-background	=> 'white',
	)->pack(
		-anchor	=> 'w',
		-expand	=> 1,
		-fill	=> 'y',
	);

	# take the first argument if its there.
	$dt->configure( -format	=> shift(@args),) if (@args);

	###############################################
	# the File menu button....
	my $file = $bframe->Menubutton(
		-text		=> 'File',
		-tearoff	=> 0,
		-border		=> 0,
		-borderwidth	=> 0,
	)->pack(
		-side		=> 'left'
	);
	$file->configure(
		-activebackground	=> $file->cget('-background'),
	);


	# exit.
	#$file->separator();
	$file->command(
		"-label"	=> 'Exit',
		"-command"	=> sub { exit; },
	);
	###############################################

	# the File menu button....
	my $Format = $bframe->Menubutton(
		-text		=> 'Format',
		-tearoff	=> 0,
		-border		=> 0,
		-borderwidth	=> 0,
	)->pack(
		-side	=> 'left',
	);
	$Format->configure(
		-activebackground	=> $Format->cget('-background'),
	);

	for my $format (@formats)
	{
		$Format->command(
			"-label"	=> $format,
			"-command"	=> [ sub { $_[0]->configure(-format => $_[1]); }, $dt, $format ],
		);
	}


	###############################################
	# The Tk::StrfClock widgets.
	my $upd = '';
	my $adv = 0;
	local ($_);
	for (@args)
	{
		if (/%/)
		{
			$cframe->StrfClock(
				-format	=> $_,
				-update	=> $upd,
				-advance=> $adv,
			)->pack(
				-anchor	=> 'w',
				-expand	=> 1,
				-fill	=> 'y',
			);
		}
		elsif (/^[\+\-]\d+$/)	{ $adv = $_; }
		else 			{ $upd = $_; }
	}

	MainLoop();

	# Only gets here if the window is killed.
	exit;
}

# If we are running this file then run the test function....
&test(@ARGV) if ($0 eq __FILE__);

1;

__END__

=head1 NAME

Tk::StrfClock - a X/TK digital clock widget based on strftime.

=head1 SYNOPSIS

  use Tk::StrfClock;

  $top->StrfClock(
  	-format	=> <strftime format string>,
	-update => [<seconds>|s|m|h|d],
	-advance => [<seconds>],
  );

=head1 DESCRIPTION 

Tk::StrfClock is a digital clock widget, with all the other attributes
of a Tk::Label.

=head1 OPTIONS

=head2 -format => <strftime format string>

	Sets the required date/time format using POSIX strftime format.
	The default is "%I:%M:%S%p, %A, %e %B %Y.".

=head2 -update => <seconds>|s|m|h|d|a

	Sets how often the clock is updated.  If set to the characters
	s, m, h, d or a then the clock is updated exactly on the second,
	minute, hour, day or is automatically guessed.

	The default is 'a'.

=head2 -advance => <seconds>

	Sets the clock fast or slow this many seconds. The default is
	0.

=head2 Other Tk::Label options.

=over 3

=back 

=head1 MINIMAL EXAMPLE

  use Tk;
  use Tk::StrfClock;

  my $top=MainWindow->new();
  $top->StrfClock()->pack();
  MainLoop();

=head1 TESTING

 Run the module itself to start a test program.
 To increase the size of the fond add something like

=over 3

 *StrfClock*font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*

=back

 to your .Xdefaults file.

=cut

