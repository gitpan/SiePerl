# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1200 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/setNode.al)"
sub setNode
  {
    my $dw = shift ;
    my %args = @_ ;
    my $color = $args{color} ;
    my $nodeId = $args{nodeId} || $dw->getCurrentNodeId ; # optional

    if (defined $dw->{xset}{node})
      {
        my $defc = $dw->cget('-nodeTextColor') || $dw->cget('-nodeColor');
        $dw->itemconfigure($dw->{xset}{node},fill => $defc);
      }

    my $itemId = $dw->{node}{text}{$nodeId} ;
    $dw->{xset}{node} = $itemId ;
    $dw->itemconfigure($itemId, fill => $color) ;

    return $dw->{nodeId}{$itemId} ;
  }


# will call-back sub with node $rev
# end of Tk::TreeGraph::setNode
1;
