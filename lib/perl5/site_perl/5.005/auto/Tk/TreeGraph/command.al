# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 1244 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/command.al)"
sub command
  {
    my $dw = shift ;
    my %args = @_ ;
    my $on = $args{on};
    my $label = $args{label} ;
    my $sub = $args{command} ;
    
    $dw->{command}{$on}{$label} = $sub ;
  }

# end of Tk::TreeGraph::command
1;
