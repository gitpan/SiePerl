# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 672 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/addLabel.al)"
sub addLabel
  {
    my $dw = shift ;
    my %args = @_ ;
    my $text = $args{text} ;
    
    my $defc = $dw->cget('-labelColor') ;
    $dw->create('text', '7c' , 5 , -anchor => 'n' , -fill => $defc,
                               -text=> $text, -justify => 'center') ;
  }

# end of Tk::TreeGraph::addLabel
1;
