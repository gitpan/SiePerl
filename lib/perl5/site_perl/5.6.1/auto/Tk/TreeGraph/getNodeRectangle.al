# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1151 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/getNodeRectangle.al)"
sub getNodeRectangle
  {
    my $dw = shift ;
    my %args = @_ ;
    my $nodeId = $args{nodeId} || $dw->getCurrentNodeId; # optional
    return $dw->{node}{rectangle}{$nodeId} ;
  }

# end of Tk::TreeGraph::getNodeRectangle
1;
