# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1068 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/flashNode.al)"
sub flashNode
  {
    my $dw = shift ;
    my %args = @_ ;

    my $nodeId = $args{nodeId} || $dw->getCurrentNodeId; # optional
    croak "modifyNode: missing nodeId parameter" 
      unless defined $args{nodeId};

    my $rid = $dw->{node}{rectangle}{$nodeId} ; # retrieve id of rectangle
    my $tid = $dw->{node}{text}{$nodeId} ; 

    croak "modifyNode: unknown nodeId : $nodeId" unless defined $rid ;

    if (defined $dw -> {node}{flash} and 
        defined $dw -> {node}{flash}{$nodeId} and 
        $dw -> {node}{flash}{$nodeId})
      {
        $dw -> {node}{flash}{$nodeId} = 0;
        return ;
      }
    
    my $time = $args{time} || 500 ;
    $dw -> {node}{flash}{$nodeId} = 1 ;

    my $oldNodeColor = $dw->itemcget($rid, '-outline') ;
    my $oldNodeTextColor = $dw->itemcget($tid, '-fill') ;
    my $oldNodeFill = $dw->itemcget($rid, '-fill') ;

    my $newNodeColor = $args{nodeColor} || $oldNodeColor ;
    my $newNodeTextColor = $args{nodeTextColor} || $oldNodeTextColor ;
    my $newNodeFill = $args{nodeFill} || $oldNodeFill ;

    my ($on,$off) ;

    $on = sub 
      {
        $dw->itemconfigure($rid, -outline => $newNodeColor) ;
        $dw->itemconfigure($tid, -fill =>    $newNodeTextColor) ;
        $dw->itemconfigure($rid, -fill =>    $newNodeFill) ;
        $dw->after($time,$off) ; # always call off
      };

    $off = sub 
      {
        $dw->itemconfigure($rid, -outline => $oldNodeColor) ;
        $dw->itemconfigure($tid, -fill =>    $oldNodeTextColor) ;
        $dw->itemconfigure($rid, -fill =>    $oldNodeFill) ;
        $dw->after($time,$on) if $dw -> {node}{flash}{$nodeId} ;
      };

    &$on ;
  }

# will return with node Id
# when toggling a node, only the rectangle is highlighted
# end of Tk::TreeGraph::flashNode
1;
