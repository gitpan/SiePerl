# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1222 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/nodeBind.al)"
sub nodeBind
  {
    my $dw = shift ;
    my %args = @_ ;
    my $color = $args{color} ;
    my $button = $args{button} ;
    my $callback = $args{command} ;

    $dw->bind
      (
       'node', $button => sub 
       {
         my $id = $dw->setNode(color => $color) ;
         $dw->idletasks;
         &$callback(on => 'node', nodeId => $id) ;
       });

  }

## Popup menu commands

# will call-back sub with ($start_nodeId,$tip_nodeId) node Ids
# end of Tk::TreeGraph::nodeBind
1;
