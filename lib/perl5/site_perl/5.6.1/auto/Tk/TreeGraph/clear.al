# NOTE: Derived from blib/lib/Tk/TreeGraph.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::TreeGraph;

#line 656 "blib/lib/Tk/TreeGraph.pm (autosplit into blib/lib/auto/Tk/TreeGraph/clear.al)"
## data structures (i.e $dw->{...})

# arrow -> start -> hash : key is arrow widget id, 
#                          value is node Id where the arrow starts
# arrow -> tip   -> hash : key is arrow widget id, 
#                          value is node Id where the arrow ends

# node -> text      : text widget ref
# node -> rectangle : rectangle widget ref

# nodeId->hash ref: key is text or rectangle widget id, value: nodeId

# tset -> hash ref : (toggle set) key is nodeId set by the user, value is
#                    the rectangle widget id

# xset -> arrow: (eXclusive set) : arrow widget id of the arrow set by the user
# xset -> node : (eXclusive set) : nodeId of the node set by the user

# shortcutFrom -> hash : key is the nodeId of the start of the shortcut,
#                        value is the nodeId of the end of the shortcut

## General functions

sub clear
  {
    my $dw = shift ;
    
    foreach (qw/arrow node nodeId tset xset shortcutFrom x y 
             tree_start after limit column next_limit/)
      {
        delete $dw->{$_};
      }

    $dw->delete('all');

    $dw->{currentBranch} = 'b000';
    $dw->{column}{$dw->{currentBranch}} = 0;
  }

# end of Tk::TreeGraph::clear
1;
