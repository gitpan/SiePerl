# NOTE: Derived from blib/lib/Tk/Web.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Web;

#line 342 "blib/lib/Tk/Web.pm (autosplit into blib/lib/auto/Tk/Web/TextPopup.al)"
sub TextPopup
{
 my ($w,$kind,$text) = @_;
 my $t   = $w->MainWindow->Toplevel;
 my $url = $w->url;
 $t->title("$kind : ".$url->as_string);
 my $tx = $t->Scrolled('Text',-wrap => 'none')->pack(-expand => 1, -fill => 'both');
 $tx->insert('end',$text);
}

# end of Tk::Web::TextPopup
1;
