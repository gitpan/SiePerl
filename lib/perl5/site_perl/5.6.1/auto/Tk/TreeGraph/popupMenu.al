# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1255 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/popupMenu.al)"
sub popupMenu
  {
    my $dw = shift ;
    my %args = @_ ;
    my $on = delete $args{on} ;

    my $menu = $dw-> Menu; 
    foreach (keys %{$dw->{command}{$on}})
      {
        my $s = $dw->{command}{$on}{$_};
        $menu -> add 
          (
           'command',
           '-label' => $_, 
           '-command' => sub {&$s(%args) ;}
          );
      }

    $menu->Popup(-popover => 'cursor', -popanchor => 'nw');
  }

1;
# end of Tk::TreeGraph::popupMenu
