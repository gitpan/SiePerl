# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1165 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/unselectAllNodes.al)"
sub unselectAllNodes
  {
    my $dw = shift ;

    my $defc = $dw->cget('-nodeColor');
    foreach (values %{$dw->{tset}{node}})
      {
        $dw->itemconfigure($_, outline => $defc) ; #unselect
      }
    delete $dw->{tset}{node} ;
  }

# end of Tk::TreeGraph::unselectAllNodes
1;
