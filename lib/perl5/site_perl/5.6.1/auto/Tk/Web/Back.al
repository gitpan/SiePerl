# NOTE: Derived from blib/lib/Tk/Web.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Web;

#line 424 "blib/lib/Tk/Web.pm (autosplit into blib/lib/auto/Tk/Web/Back.al)"
sub Back
{
 my ($w) = @_;
 if (@{$w->{BACK}})
  {
   unshift(@{$w->{FORWARD}},$w->context);
   $w->context(pop(@{$w->{BACK}}));
  }
 $w->break;
}

# end of Tk::Web::Back
1;
