# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 935 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addNode.al)"
sub addNode
  {
    my $dw = shift ;
    my %args = @_ ;
    my $nodeId = $args{nodeId} ;
    my $text = ref $args{text} ? join("\n",@{$args{text}}) : $args{text} ;
    chomp $text;

    #print "Drawing node $nodeId\n";
    my $after = $args{after};
    if (defined $after)
      {
        if (ref($after) eq 'ARRAY')
          {
            # re-start another tree
            ($dw->{tree_start},$dw->{y}) = @$after;
          }
        elsif (defined $dw->{after}{$after})
          {
            $dw->addSlantedArrow('from' => $after, to => $nodeId);
          }
        else
          {
            $dw->addDirectArrow('from' => $after, to => $nodeId);
          }
      }
    
    # initialiaztion
    $dw->{tree_start}=$dw->cget('-x_start') unless defined $dw->{tree_start};
    
    # compute text to draw
    $text = "$nodeId\n". $text if $dw->cget('-nodeTag') ;

    # first compute y coord 
    my $oldy = $dw->{y} || $dw->cget('-y_start');
    my $y = $oldy + 5 ; # give some breathing space 

    # then compute the x coordinate
    my $branch_dx= $dw->cget('-branchSeparation');
    my $c = $dw->{column}{$dw->{currentBranch}} ;
    my $x = $branch_dx * $c + $dw->{tree_start}  ;

    # compute y coord
    # draw node text
    my $defc = $args{nodeTextColor} || $args{-nodeTextColor} 
      || $dw->cget('-nodeTextColor');

    my $tid = $dw->create('text', $x + $branch_dx/2 - 10, $oldy + 5, 
                          -text => $text,  -fill => $defc,
                          qw/-justify center -anchor n -width 12c/,
                          -tags => ['node', $dw->{currentBranch}]) ;

    # compute y according to the text drawn
    my @box = $dw->bbox($tid) ;
    $y = $box[3] + 5 ;

    # draw node rectangle
    $defc = $args{nodeColor} || $args{-nodeColor} || $dw->cget('-nodeColor');
    my $bgc = $args{nodeFill} || $args{-nodeFill} 
      || $dw->cget('-nodeFill');
    my $rid = $dw->create('rectangle',
                          $x , $oldy,
                          $x + $branch_dx   - 20 , $y,
                          -outline => $defc, -width => 2 , -fill => $bgc ,
                          -tags => ['node', $dw->{currentBranch}]
                        ) ;
    
    $dw->raise($tid,$rid); # the text is hidden below if forgotten

    # check if we have not drawn over something
    $dw->checkOverlay($y);

    $dw -> {nodeId}{$tid}=$nodeId ; 
    $dw -> {nodeId}{$rid}=$nodeId ; # also stored
    $dw -> {node}{text}{$nodeId}=$tid ;
    $dw -> {node}{rectangle}{$nodeId}=$rid ;
    $dw -> {node}{branch}{$nodeId}= $dw->{currentBranch} ;

    $dw->{x} = $x;
    $dw->{y} = $y ;
  }

# end of Tk::TreeGraph::addNode
1;
