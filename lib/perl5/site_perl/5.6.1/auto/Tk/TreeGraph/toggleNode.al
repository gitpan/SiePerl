# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1124 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/toggleNode.al)"
sub toggleNode
  {
    my $dw = shift ;
    my %args = @_ ;
    my $color = $args{color} ;
    my $nodeId = $args{nodeId} || $dw->getCurrentNodeId; # optional

    my $rid = $dw->{node}{rectangle}{$nodeId} ; # retrieve id of rectangle

    if (defined $dw->{tset}{node}{$nodeId})
      {
        my $defc = $dw->cget('-nodeColor');
        $dw->itemconfigure($rid, outline => $defc) ; #unselect
        delete $dw->{tset}{node}{$nodeId} ;
      } 
    else
      {
        die "Error no color specified while selecting node\n"
          unless defined $color ;
        $dw->itemconfigure($rid, outline => $color) ;
        $dw->{tset}{node}{$nodeId} = $rid ; # store id of rectangle
      } 

    $dw->idletasks;
    return $nodeId ;
  }

# end of Tk::TreeGraph::toggleNode
1;
