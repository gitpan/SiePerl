# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 799 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/setArrow.al)"
sub setArrow
  {
    my $dw = shift ;
    my %args = @_ ;
    my $color = $args{color} ;
    
    # reset any selected arrow
    if (defined $dw->{xset}{arrow})
      {
        my $tag = $dw->gettags($dw->{xset}{arrow});
        my $defc = $tag eq 'scutarrow'? 
          $dw->cget('-shortcutColor') :  $dw->cget('-arrowColor');

        $dw->itemconfigure($dw->{xset}{arrow}, -fill => $defc);
      }

    my $itemId = $dw->find('withtag' => 'current');
    $dw->{xset}{arrow} = $itemId ;
    $dw->itemconfigure($itemId, -fill => $color) ;
    my $tipNodeId = $dw->{arrow}{tip}{$itemId} ;
    my $endNodeId = $dw->{arrow}{start}{$itemId} ;

    return (from => $endNodeId, to => $tipNodeId) ;
  }

## Slanted Arrows

# end of Tk::TreeGraph::setArrow
1;
