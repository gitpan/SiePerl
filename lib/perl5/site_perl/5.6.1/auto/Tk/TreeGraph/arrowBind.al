# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 769 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/arrowBind.al)"
sub arrowBind 
  { 
    my $dw = shift ; 
    my %args = @_ ; 
    my $button = $args{button} ; 
    my $color = $args{color} ; 
    my $callback = $args{command} ;

    # bind button <1> on arrows to display history information
    $dw->bind
      (
       'arrow', $button => sub 
       {
         my @ids = $dw->setArrow(color => $color) ;
         $dw->idletasks;
         &$callback(on => 'arrow', @ids) ;
       });

    $dw->bind
      (
       'scutarrow', $button => sub 
       {
         my @ids = $dw->setArrow(color => $color) ;
         $dw->idletasks;
         &$callback(on => 'arrow',@ids) ;
       });
  }

# will return with ($start_revision,$tip_revison) rev numbers
# setArrow
# end of Tk::TreeGraph::arrowBind
1;
