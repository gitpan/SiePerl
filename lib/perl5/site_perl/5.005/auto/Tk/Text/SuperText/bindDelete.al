# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 531 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/bindDelete.al)"
# delete all event binds,specified event bind
sub bindDelete
{
	my ($w,$event,@triggers) = @_;
	
	if(!$event) {
		# delete all events binds
		my ($e);
		
		foreach $e (%{$w->DefaultEvents}) {
			$w->eventDelete($e);
		}
		return;
	}
	$w->eventDelete($event,@triggers);
}

# end of Tk::Text::SuperText::bindDelete
1;
