# NOTE: Derived from blib/lib/Tk/Web.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Web;

#line 352 "blib/lib/Tk/Web.pm (autosplit into blib/lib/auto/Tk/Web/ShowSource.al)"
sub ShowSource
{
 my ($w) = @_;
 $w->TextPopup(Source => $w->html->{'_source_'});
}

# end of Tk::Web::ShowSource
1;
