# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 683 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/checkOverlay.al)"
sub checkOverlay
  {
    my $dw = shift ;
    my $y = shift ;

    my $c= $dw->{column}{$dw->{currentBranch}};

    #print "checking branch $dw->{currentBranch} col $c for y $y\n";

    return 0 unless defined $dw->{limit}[$c];
    #print "limit for col $c is $dw->{limit}[$c]\n";
    return 0 unless $y > $dw->{limit}[$c]; 

    my $old_c = $c ;
    # must move the branch
    while (defined $dw->{limit}[$c] and $y > $dw->{limit}[$c])
      {
        $c++ ;
      }

    #print "must move from column $old_c to $c\n";

    my $b=$dw->{currentBranch} ;
    my $dx = $dw->cget('-branchSeparation')*($c-$old_c) ;

    # shift the whole branch
    $dw->move($dw->{currentBranch},$dx,0) ; 

    # shift the tip of the arrow
    my @coord = $dw->coords("arrow".$dw->{currentBranch}) ;
    $coord[2]+= $dx ;
    $dw->coords("arrow".$dw->{currentBranch}, @coord) ; 

    # set the new limits to the bottom of the node from where the branch 
    # starts
    foreach my $idx ($old_c .. $c - 1)
      {
        #print "auto setting limit for col $idx at $coord[1]\n";
        $dw->{limit}[$idx] = $coord[1] ;
      }
    
    # update the cache the new column occupied by this branch 
    $dw->{next_limit} = [ $c,  $coord[1] ];

    # update current column
    $dw->{column}{$dw->{currentBranch}} = $c;
    
    $dw->checkOverlay($y) ;
  }

## Arrow functions

# add a an arrow for a regular revision, return the new $$yr at the bottom of
# the arrow
# end of Tk::TreeGraph::checkOverlay
1;
