# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1017 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/modifyNode.al)"
sub modifyNode
  {
    my $dw = shift ;
    my %args = @_ ;

    my $nodeId = $args{nodeId} || $dw->getCurrentNodeId; # optional
    croak "modifyNode: missing nodeId parameter" 
      unless defined $args{nodeId};

    my $rid = $dw->{node}{rectangle}{$nodeId} ; # retrieve id of rectangle
    my $tid = $dw->{node}{text}{$nodeId} ; 

    croak "modifyNode: unknown nodeId : $nodeId" unless defined $rid ;

    if (defined $args{nodeColor})
      {
        $dw->itemconfigure($rid, -outline => $args{nodeColor}) ;
      }
    
    if (defined $args{text})
      {
        my $text = ref $args{text} ? join("\n",$args{text}) : $args{text};
        chomp $text ;

        $text = $nodeId."\n$text" if $dw->cget('-nodeTag') ;
        my $count = $text ;
        $count =~ s/[^\n]// ;
        
        my $oldText = $dw->itemcget($tid, '-text' ) ;
        $oldText =~ s/[^\n]// ;
        
        if (length($count) > length($oldText))
          {
            croak "modifyNode error: New text is longer than the old one. It will no fit in the node" ;
          }
        
        $dw->itemconfigure($tid, -text => $text) ;
      }
    
    if (defined $args{nodeTextColor})
      {
        $dw->itemconfigure($tid, -fill => $args{nodeTextColor}) ;
      }
    
    if (defined $args{nodeFill})
      {
        $dw->itemconfigure($rid, -fill => $args{nodeFill}) ;
      }
    
  }

# end of Tk::TreeGraph::modifyNode
1;
