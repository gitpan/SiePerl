package Astro::Misc;
use strict;

=head1 NAME

Astro::Misc - Miscellaneous astronomical routines

=head1 SYNOPSIS

    use Astro::Misc;

    $U = calc_U($flux, $dist, $freq);
    ($dist1, $dist2)= kindist($ra, $dec, $vel, $epoch, $model);

=head1 DESCRIPTION

Astro::Misc contains an assorted set Perl routines for doing various
astronomical calculations.

=head1 AUTHOR

Chris Phillips  phillips@jive.nfra.nl

=head1 FUNCTIONS

=cut


BEGIN {
  use Exporter ();
  use vars qw($VERSION @ISA @EXPORT @EXPORT_OK @EXPORT_FAIL
              $Temp $parsecAU $au2km $G $c );
  $VERSION = '1.00';
  @ISA = qw(Exporter);

  @EXPORT      = qw( read_possm calc_U calc_Nl lum2spectral 
                     Nl2spectral kindist );
  @EXPORT_OK   = qw ( $Temp read_lovas );
  @EXPORT_FAIL = qw ( a model_1 model_2 );

  use Carp;
  use POSIX qw( asin );

  use Astro::Time qw( $PI );
  use Astro::Coord qw( coord_convert );
}

$parsecAU = 206265;        # The length of one parsec in AU
$au2km = 149.59787066e6;   # Number of km in one AU
$G = 6.67e-11;             # Gravitational constant
$c = 2.99792458e5;         # speed of light in km/s

$Temp = 1e4;  # Electron temperature

=item B<read_possm>

 Read_possm interprets the output file from the AIPS POSSM task.
 the task may be called repeatably if there is more than one POSSM
 output in the file. The file must be open before calling
 read_possm, using the FileHandle module. The data from the possm
 plot is returned in a hash. Some of the header values are returned
 as scalar values while the actual plot values are returned as
 references to arrays. The scalar values returned are:
   SOURCE, DATE, BANDWIDTH, TYPE (='A&P'||'R&I')
 The array references are: CHANNEL,
   VELOCITY, FREQUENCY, AMPLITUDE, PHASE, ANTENNA
 The global variable $Astro::Misc:oldpossm (default=0) controls whether
 old or new style possm plots are read.  For oldpossm=1, one of
 VELOCITY or FREQUENCY will be a reference to an empty list (but the
 hash value IS defined).

 Usage:    use FileHandle
           my $fh = FileHandle->new();
           my %ahash = ();
           open($fh, 'possmfile');
           read_possm($fh, %ahash);

 Returns:  0 on success (but not hit eof)
           1 on success (and hit eof)
           2 on premature eof

 Examples of hash usage:
      $hash{SOURCE}         # Source name
      @{$hash{VELOCITY}}    # Array of velocity values
      ${$hash{PHASE}}[4]    # The fifth phase value

=cut


sub read_possm ($\%) {

  my($fh, $hashref) = @_;

  # Initialise the hash ref

  $$hashref{CHANNEL} = [()];
  $$hashref{VELOCITY} = [()];
  $$hashref{FREQUENCY} = [()];
  $$hashref{AMPLITUDE} = [()];
  $$hashref{PHASE} = [()];
  $$hashref{ANTENNA} = [()];

  my $eof = 1;
  # Read the header section
  while (<$fh>) {
    if (/^Source:\s*(\S*)/) {  
      $$hashref{SOURCE} = $1;
    } elsif (/^OBS\. DATE: (\S+)/) {
      $$hashref{DATE} = $1;
    } elsif (/^Bw \(\S+\):\s+(\S+)/) {
      $$hashref{BANDWIDTH} = $1;
    } elsif (/^Antenna\s#\s+\d+\s+name:\s+(\S+)/) {
      push @{$$hashref{ANTENNA}}, $1;
    } elsif (/^DATA/) {
      $eof = 0;
      last;
    }
  }

  return 2 if $eof;

  #Skip until find data
  $eof = 1;
  my $velocity = 0;
  while (<$fh>) {
    if ($astro::oldpossm) {
      if (/Channel.*IF.*(Velocity|Frequency).*(Ampl|Real).*(Phase|Imag)/) {
	$velocity = 1 if ($1 eq 'Velocity');
	if ($2 eq 'Ampl') {
	  $$hashref{TYPE} = 'A&P';
	} else {
	  $$hashref{TYPE} = 'R&I';
	}
	$eof = 0;
	last;
      }
    } else {
      if (/Channel.*IF.*Frequency.*Velocity.*(Ampl|Real).*(Phase|Imag)/) {
	$eof = 0;
	if ($1 eq 'Ampl') {
	  $$hashref{TYPE} = 'A&P';
	} else {
	  $$hashref{TYPE} = 'R&I';
	}
	last;
      }
    }
  }

  croak "$0: premature EOF" if $eof;

  # Read the data in
  $eof = 1;
  my $n = 0;
  while (<$fh>) {
    if ($astro::oldpossm && /\s*(\d+)\s+           # Channel
	     \d+\s+                                # IF
	    ([-+]?\d+\.\d*(?:[Ee][\-+]\d+)?)\s+    # Velocity Frequency
	    ([-+]?\d+\.\d*(?:[Ee][\-+]\d+)?)\s+    # Amplitude
	    ([-+]?\d+\.\d*)                        # Phase
	    /x) {

      $n++;
      push(@{$$hashref{CHANNEL}},$1);
      if ($velocity) {
	push(@{$$hashref{VELOCITY}},$2);
      } else {
	push(@{$$hashref{FREQUENCY}},$2);
      }
      push(@{$$hashref{AMPLITUDE}},$3);
      push(@{$$hashref{PHASE}},$4);
    } elsif (/\s*(\d+)\s+                          # Channel
	     \d+\s+                                # IF
	     (\d+\.\d*(?:[Ee][\-+]\d+)?)\s+        # Frequency
	     ([-+]?\d+\.\d*(?:[Ee][\-+]\d+)?)\s+   # Velocity
	     ([-+]?\d+\.\d*(?:[Ee][\-+]\d+)?)\s+   # Amplitude - Real
	     ([-+]?\d+\.\d*)                       # Phase - Imag
		 /x) {

      $n++;
      push(@{$$hashref{CHANNEL}},$1);
      push(@{$$hashref{FREQUENCY}},$2);
      push(@{$$hashref{VELOCITY}},$3);
      push(@{$$hashref{AMPLITUDE}},$4);
      push(@{$$hashref{PHASE}},$5);
    } elsif (/\s*\d+.*FLAGGED/) {

    } elsif (/Header/) {  #Next plot
      $eof = 0;
      last;
    } else {
      print STDERR '** ';
      print STDERR;
    }
  }

  croak "$0: No Data read\n" if ($n == 0);

  return $eof;

}

=item B<read_lovas>

 Read_lovas read the Lovas "Recommended Rest Frequencies for Observed
 Interstellar Molecular Microwave Transitions - 1991 Revision"
 (J. Phys. Chem. Ref. Data, 21, 181-272, 1992). Alpha quality!!

   my @lovas = read_lovas($fname);
   my @lovas = read_lovas($fname, $minfreq, $maxfreq);

=cut

# Probably does not work !!!
sub read_lovas ($;$$) {
  warn 'Using Beta routine';
  my($fname, $min, $max) = @_;

  if (!open(LOVAS, $fname)) {
    carp "Could not open $fname: $!\n";
    return undef;
  }

  my ($freq, $calc, $uncert, $molecule, $form, $tsys, $source, $telescope, $ref);
  my @lovas = ();

  while (<LOVAS>) {
    chomp;

    $freq = substr $_, 1, 16;
    $molecule = substr $_, 18, 11;
    $form = substr $_, 29, 28;
    $c = substr $_, 57, 1;  # Could be either formulae or Tsys
    $tsys = substr $_, 58, 7;
    $source = substr $_, 65, 15;
    $telescope = substr $_, 81, 12;
    $ref = substr $_, 94;

    # Clean up the strings

    $freq =~ s/^\s+//;
    $freq =~ s/\s+$//;
    $molecule =~ s/^\s+//;
    $molecule =~ s/\s+$//;
    $source =~ s/^\s+//;
    $source =~ s/\s+$//;
    $telescope =~ s/^\s+//;
    $telescope =~ s/\s+$//;
    $ref =~ s/^\s+//;
    $ref =~ s/\s+$//;

    # Work out the contended column 57;
    if ($c ne ' ') {

      my ($s1) = $tsys =~ /^(\s+)/;
      my ($s2) = $form =~ /(\s+)$/;
      # Assign column 57 to the field with the "nearest"  non-blank (preference 
      # to Tsys).
      if (!defined $s1) {
	$tsys = "$c$tsys";
      } elsif (!defined $s2) {
	$form .= $c;
      }	elsif (length($s2) > length($s1)) {
	$tsys = "$c$tsys";
      } else {
	$form .= $c;
      }
    }

    $form =~ s/^\s+//;
    $form =~ s/\s+$//;
    $tsys =~ s/^\s+//;
    $tsys =~ s/\s+$//;

    # Clean up unidentified molecules
    if ($molecule eq 'unidentifie') {
      $molecule .= $form;
      $form = '';
    }

    if ($freq =~ /(.*)\*$/) {
      my $oldfreq = $freq;
      $freq = $1;
      $calc = 1;
      $freq =~ s/\s+$//;
      print "Using $oldfreq -> \"$freq\"\n";
    } else {
      $calc = 0;
    }

    if ($freq =~ /([^\s\*\(]*[\d\.])\s*(\*)?\s*(\(\s*\d+\))?/) {
      my $oldfreq = $freq;
      $freq = $1;
      if (defined $2) {
	$calc = $2;
      } else {
	$calc = ' ';
      }
      if (defined $3) {
	$uncert = $3;
      } else {
	$uncert = '';
      }

      #warn "Used $oldfreq-> $freq:$calc:$uncert\n";
    } else {
      warn "***Failed to parse $freq\n";
    }

    next if (defined $min && $freq<$min);
    next if (defined $max && $freq>$max);

    push @lovas, [$freq, $calc, $uncert, $molecule, $form, $tsys, $source, 
		  $telescope, $ref];

  }
  close(LOVAS);

  return @lovas;
}

# Used internally for calc_U
sub a ($) {
  my $freq = shift;

  my $a = 0.336 * $freq**0.1 * $Temp**-0.15
    * (log(4.995e-2/$freq) + 1.5*log($Temp));

  return($a);
}

=item B<calc_U>

  $U = calc_U($flux, $dist, $freq);

 Calculate U (Excitation Parameter) for an UCHII region
 Based on Eqn 8 in Schraml and Mezger, 1969
   $flux        Integrated Source Flux Density (Jy)
   $dist        Distance to source (kpc)
   $freq        Frequency of observation
 Note:
  Uses the global variable $Astro::Misc::temp for electron temperature
  Default is 10000K

=cut

sub calc_U ($$$) {

  my ($flux, $dist, $freq) = @_;

  my $U = 4.5526 * ($freq**0.1 / a($freq) * $Temp**0.35
		    * $flux * $dist**2)**(1/3);
  return ($U);
}

=item B<calc_Nl>

  $Nl = calc_Nl($U);

 Calculate the Lyman continuum photon flux given U, the Excitation
 Parameter for an UCHII region
   $U is the Excitation Parameter (from calc_U)

=cut

sub calc_Nl ($) {

  my ($U) = @_;

  my $Nl = ($U * 1.0976 / 2.01e-19)**3 * (3.43e-13);

  return ($Nl);
}

my @speclist = ('O4', 'O5', 'O5.5', 'O6', 'O6.5', 'O7', 'O7.5', 'O8', 
		'O8.5', 'O9', 'O9.5', 'B0', 'B0.5', 'B1', 'B2', 'B3');
my @lumlist = (6.11, 5.83, 5.60, 5.40, 5.17, 5.00, 4.92, 4.81,
	       4.73, 4.66, 4.58, 4.40, 4.04, 3.72, 3.46, 3.02);
my @Nllist = (49.93, 49.62, 49.36, 49.08, 49.82, 48.62, 48.51, 48.35, 48.21,
	      48.08, 47.84, 47.36, 46.23, 45.29, 44.65, 43.69);

die '@lumlist, @speclist and @Nlist must be the same size'
    if (scalar(@lumlist) != scalar(@speclist) 
	|| scalar(@lumlist) != scalar(@Nllist));

=item B<lum2spectral>

  $spectral_type = lum2spectral($luminosity);

 Calculate the spectral type of a ZAMS star from its luminosity
 Based on Panagia, 1973, ApJ, 78, 929.
   $luminosity   Star luminosity (normalised to Lsun)
 Returns undef if luminosity is out of range (O4 - B3)

=cut

sub lum2spectral ($) {

  my ($lum) = @_;
  $lum = log10($lum);

  my $n = scalar (@speclist);

  if ($lum > $lumlist[0]) {
    return ">$speclist[0]";
  } elsif ($lum < $lumlist[$n-1]) {
    return "<$speclist[$n-1]";
  };

  my $i = 1;

  # Find the closest pair
  while ($lum < $lumlist[$i]) {
    $i++;
  }
  # Return the closest one
  if ($lumlist[$i-1]-$lum > $lum - $lumlist[$i]) {
    return $speclist[$i];
  } else {
    return $speclist[$i-1];
  }
}

=item B<Nl2spectral>

  $spectral = Nl2spectral($Nl);

 Calculate the spectral type of a ZAMS star from its flux of
 Lyman Continuum Photons (Nl)
 Based on Panagia, 1973, ApJ, 78, 929
   $Nl     Flux of Lyman Continuum Photons
 Returns undef if luminosity is out of range (O4 - B3)

=cut

sub Nl2spectral ($) {

  my ($Nl) = @_;
  $Nl = log10($Nl);

  my $n = scalar (@speclist);

  if ($Nl > $Nllist[0]) {
    return ">$speclist[0]";
  } elsif ($Nl < $Nllist[$n-1]) {
    return "<$speclist[$n-1]";
  };

  my $i = 1;
  
  # Find the closest pair
  while ($Nl < $Nllist[$i]) {
    $i++;
  }
  # Return the closest one
  if ($Nllist[$i-1]-$Nl > $Nl - $Nllist[$i]) {
    return $speclist[$i];
  } else {
    return $speclist[$i-1];
  }
}


=item B<kindist>

  ($dist1, $dist2)= kindist($ra, $dec, $vel, $epoch, $model);

 Calculate the kinematic distance to an object
   $dist1, $dist2  Near/Far distance (kpc)
   $ra             RA of object (turns)
   $dec            Dec of object (turns)
   $vel            LSR Velocity (km/s)
   $epoch          Epoch of coords (J2000/J/B1950/B)
   $model          Model to use (1 or 2)

 Note:
  Model 1 is based on Brand and Blitz, 1993, A&A, 275, 67-90.
  Model 2 has unknown origin.

=cut

sub kindist ($$$$$) {

  my ($ra, $dec, $vel, $epoch, $model) = @_;
  my ($l, $b, $dist1, $dist2, $psi, $phi, $phid, $psid);
  $l = 0.0;
  $b = 0.0;

  if (($epoch eq 'J2000') || ($epoch eq 'J')) {
    ($ra, $dec) = fk5dk4($ra, $dec);
  }
  ($l, $b) = fk4gal($ra, $dec);
  $l *= 2.0*$PI;
  $b *= 2.0*$PI;

  croak "\$model must equal 1 or 2\n"
    if ($model != 1 && $model != 2) ;

  my $Ro = 8.5;
  my $THETAo = 220;
  my $R = 0.0004;
  my $Wo = $THETAo/$Ro;
  my $W = $vel/($Ro * sin($l)) + $Wo;

  my ($sampW);
  my $eps = 9999999.0;
  while ($eps > 0.1) {
    $R += 0.1;
    if ($model == 1) {
      $sampW = model_1($R);
    } else {
      $sampW = model_2($R);
    }
    $eps = abs($W - $sampW)/$W;
    if ($R > 5.0*$Ro) {
      print STDERR "Could not find within limits.\n";
      $eps = 0.0;
    }
  }
  $R = $R - 0.5;
  $R = 0.0 if ($R < 0.0);
  $eps = 9999999.0;
  while ($eps > 0.0001) {
    $R +=  0.0001;
    if ($model == 1) {
      $sampW = model_1($R);
    } else {
      $sampW =  model_2($R);
    }
    $eps = abs($W - $sampW)/$W;
    if ($R > 5.0*$Ro) {
      print STDERR "Could not find within limits.\n";
      $eps = 0.0;
    }
  }

  if ( sin($l) * $Ro/$R  > 1.0) {
    $psi = $PI/2; 
  } elsif ( sin($l)*$Ro/$R  < -1.0) {
    $psi = -$PI/2;
  } else {
    $psi = asin(sin($l)*$Ro/$R);
  }
  $phi = $PI - $psi - $l;

  if (sin($l) == 0.0) {
    $dist1 = 0.0;
    $dist2 = 0.0;
  } else {
    $dist1 = abs($R*sin($phi)/sin($l));
    $psid = $PI - $psi;
    $phid = $PI - $psid - $l;
    $dist2 = abs($R*sin($phid)/sin($l));
  }

  if ($dist1 <= $dist2) {
    return($dist1, $dist2);
  } else {
    return($dist2, $dist1);
  }
}

sub  model_1 ($) {
# Model from Brand and Blitz, 1993, A&A, 275, 67-90
  my ($R) = @_;

  my $Ro = 8.5;
  my $THETAo = 220;
  my $q = 1.00767;
  my $rr = 0.0394;
  my $s = 0.00712;
  # my $s = 0.00698;
  # my $q = 1.0074;
  # my $rr = 0.0382;

  return  (($q*($R/$Ro)**$rr + $s)*$THETAo/$R);
}

sub model_2 ($) {
  my ($R) = @_;

  my $Ro = 8.5;
  my $THETAo = 220;
  my @A = (0.0, +3069.81, -15809.8, +43980.1, -68287.3, 
	   +54904.0, -17731.0);
  my @B = (+325.0912, -248.1467, +231.87099, -110.73531, 
	   +25.073006, -2.110625);
  my @C = (-2342.6564, +2507.60391, -1024.068760, +224.562732, 
	   -28.4080026, +2.0697271, -0.08050808, +0.00129348);
  my $D0 = 234.88;

  my $term1 = 0.0;
  my ($i);
  
  if ($R <= 0.09*$Ro) {
    for ($i = 0; $i < 7; $i++) {
      $term1 = $term1 + $A[$i]*$R**$i;
    }
  } elsif ((0.09*$Ro < $R) && ($R <= 0.45*$Ro)) {
    for ($i = 0; $i < 6; $i++) {
      $term1 = $term1 + $B[$i]*$R**$i;
    }
  } elsif (((0.45*$Ro) <  $R) && ($R <= (1.6*$Ro))) {
    for ($i = 0; $i < 8; $i++) {
      $term1 = $term1 + $C[$i]*$R**$i;
    }
  }	elsif ((1.6*$Ro) < $R) {
    $term1 = $D0;
  } else {
    die "model_2 inconsistent\n";
  }

  return ($term1/$R);
}

1;

__END__

