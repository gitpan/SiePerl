# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 877 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addShortcutInfo.al)"
sub addShortcutInfo
  {
    my $dw = shift ;
    my %args = @_ ;
    my $nodeId = $args{from} ;
    my $mNodeId = $args{to} ;

    push( @{$dw->{shortcutFrom}{$nodeId}}, $mNodeId );
  }

# end of Tk::TreeGraph::addShortcutInfo
1;
