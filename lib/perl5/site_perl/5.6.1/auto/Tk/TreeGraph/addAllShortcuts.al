# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 887 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addAllShortcuts.al)"
sub addAllShortcuts
  {
    my $dw = shift ;

    my $color = $dw->cget('-shortcutColor') || $dw->cget('-foreground');

    my $dx= $dw->cget('-branchSeparation')/2 - 10;
    my $branch_dx= $dw->cget('-branchSeparation');
    my $style = $dw->cget('-shortcutStyle') ;
    
    foreach my $nodeId (keys %{$dw->{shortcutFrom}})
      {
        next unless defined $dw->{node}{rectangle}{$nodeId} ;
	
        foreach my $mNodeId (@{$dw->{shortcutFrom}{$nodeId}})
          {
            next unless defined $dw->{node}{rectangle}{$mNodeId} ;
            # beginning of arrow
            my ($bx, $by) = ($dw->coords($dw->{node}{rectangle}{$nodeId}))[0,3] ;
            # end of arrow
            my ($ex, $ey) =($dw->coords($dw->{node}{rectangle}{$mNodeId}))[0,1] ;
            my @opt = ($bx + $dx, $by); # arrow start
            
            # intermediate points for multi-segment line
            push @opt, ($bx+ $dx + $ex +$dx - $branch_dx)/2, ($by+$ey)/2 
              if $style eq 'spline' ;
            
            push @opt , $ex + $dx, $ey ; # arrow end
            
            push @opt ,qw/-smooth on/ if $style eq 'spline'; # spline mode 
 
            my $itemId = $dw->create
              (
               'line', @opt ,
               -arrow => 'last', 
               -tag => 'scutarrow',
               -fill=>$color
              );
            $dw->{arrow}{start}{$itemId} = $mNodeId ;
            $dw->{arrow}{tip}{$itemId} = $nodeId ;
	  }
      }
  }

## Node functions

# draw a node, return the y coord of the bottom of the node 
#($x does not change)
# end of Tk::TreeGraph::addAllShortcuts
1;
