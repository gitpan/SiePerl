# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 737 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addDirectArrow.al)"
sub addDirectArrow
  {
    my $dw = shift ;
    my %args = @_ ;
    my $nodeId = $args{from} ;
    my $lowerNodeId =  $args{to} ;

    $dw->{after}{$nodeId}=1;
    my $branch_dx= $dw->cget('-branchSeparation');
    my $c = $dw->{column}{$dw->{currentBranch}} ;
    my $x = $branch_dx * $c + $dw->{tree_start} + $branch_dx/2 - 10 ;
    my $old_y = $dw->{y};

    $dw->BackTrace("addDirectArrow: unknown 'from' nodeId: $nodeId\n")
      unless defined $dw->{node}{rectangle}{$nodeId};
    
    my $y = $old_y + $dw->cget('-arrowDeltaY') ; # give length of arrow

    my $defc = $dw->cget('-arrowColor'); 
    my $itemId = $dw->create
      ('line', $x, $old_y, $x, $y , 
       -fill => $defc, 
       -tags => ["arrow",$dw->{currentBranch}],
       -arrow =>'last'); 

    $dw->{arrow}{start}{$itemId} = $nodeId ; 
    $dw->{arrow}{tip}{$itemId} = $lowerNodeId ; 

    $dw->{y} = $y ;
  }

 # will call-back sub with ($start_nodeId,$tip_nodeId) nodeId 
# end of Tk::TreeGraph::addDirectArrow
1;
