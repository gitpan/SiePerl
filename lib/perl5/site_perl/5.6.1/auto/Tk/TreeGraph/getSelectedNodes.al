# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1159 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/getSelectedNodes.al)"
sub getSelectedNodes
  {
    my $dw = shift ;
    return keys %{$dw->{tset}{node}} ;
  }

# end of Tk::TreeGraph::getSelectedNodes
1;
