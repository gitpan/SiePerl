# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 826 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addSlantedArrow.al)"
sub addSlantedArrow
  {
    my $dw = shift ;
    my %args = @_ ;
    my $nodeId = $args{from} ;
    my $branch =  $args{to} ;
    my $y = $dw->{y} ;

    $dw->BackTrace("AddSlantedArrow: unknown 'from' nodeId: $nodeId\n")
      unless defined $dw->{node}{rectangle}{$nodeId};

    my $nodeBranch = $dw -> {node}{branch}{$nodeId};
    my $old_c = $dw->{column}{$nodeBranch} ;
    my ($old_x, $old_y) = ($dw->coords($dw->{node}{rectangle}{$nodeId}))[0,3];

    $y = $old_y + $dw->cget('-arrowDeltaY') ; # give length of arrow

    # create the new branch on the next column
    $dw->{currentBranch}++;
    $dw->{column}{$dw->{currentBranch}} = $old_c + 1 ;

    my $branch_dx= $dw->cget('-branchSeparation');
    my $x = $branch_dx * ($old_c+1) + $dw->{tree_start}  ;

    my $defc = $dw->cget('-arrowColor');
    my $itemId = $dw->create('line', 
                             $old_x + $branch_dx/2 - 10, $old_y, 
                             $x + $branch_dx/2 - 10, $y,
                             -fill => $defc,
                             -tags => ["arrow","arrow".$dw->{currentBranch}],
                             -arrow =>'last'); 

    $dw->{arrow}{start}{$itemId} = $nodeId ;
    $dw->{arrow}{tip}{$itemId} = $branch ;

    if (defined $dw->{next_limit})
      {
        my ($c,$l) = @{$dw->{next_limit}};
        #print "setting limit for col $c at $l\n";
        $dw->{limit}[$c] =  $l ;
      }
    
    # cache the limit for that we don't limit the drawing of this branch
    #print "setting next limit for col ",$old_c+1, " at $old_y\n";
    $dw->{next_limit} = [ $old_c + 1,  $old_y ];

    $dw->{y} = $y ;
  }

## Short Cut Arrows 

# end of Tk::TreeGraph::addSlantedArrow
1;
