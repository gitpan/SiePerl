# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1177 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/getCurrentNodeId.al)"
sub getCurrentNodeId
  {
    my $dw = shift ;

    my $selected = $dw->find('withtag' => 'current');
        
    unless (defined $selected)
      {
        $dw->bell ;
        return undef ;
      }
        
    unless (defined $selected)
      {
        $dw->bell ; $dw->bell ; # twice for debug ...
        return undef ;
      }

    return $dw->{nodeId}{$selected} ;
  }

# set node either from passed nodeId or from the mouse pointer
# when a node is set, only the text is highlighted
# end of Tk::TreeGraph::getCurrentNodeId
1;
