# NOTE: Derived from blib/lib/Tk/Web.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Web;

#line 358 "blib/lib/Tk/Web.pm (autosplit into blib/lib/auto/Tk/Web/ShowHTML.al)"
sub ShowHTML
{
 my ($w) = @_;
 $w->TextPopup(HTML => $w->html->as_HTML);
}

# end of Tk::Web::ShowHTML
1;
