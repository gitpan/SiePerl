# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 517 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/bindDefault.al)"
# bind default keys with default events 
sub bindDefault
{
	my $w = shift;
	my $events = $w->DefaultEvents;
	
	foreach my $e (keys %$events) {
		$w->eventAdd("<<$e>>",@{$$events{$e}});
		$w->bind($w,"<<$e>>",lcfirst($e));
	}
#+1999/07/11 alexiob@iname.com - Fixed win32 BackSpace bug thanks to Jim Turner
	$w->bind("<Key-BackSpace>", sub {Tk->break;});
}

# end of Tk::Text::SuperText::bindDefault
1;
