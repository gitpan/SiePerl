# NOTE: Derived from blib/lib/Tk/Web.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Web;

#line 435 "blib/lib/Tk/Web.pm (autosplit into blib/lib/auto/Tk/Web/Forward.al)"
sub Forward
{
 my ($w) = @_;
 if (@{$w->{FORWARD}})
  {
   unshift(@{$w->{BACK}},$w->context);
   $w->context(shift(@{$w->{FORWARD}}));
  }
 $w->break;
}

1;
# end of Tk::Web::Forward
