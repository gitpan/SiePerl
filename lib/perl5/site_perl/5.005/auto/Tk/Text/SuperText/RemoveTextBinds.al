# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 504 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/RemoveTextBinds.al)"
# remove default Tk::Text key binds
sub RemoveTextBinds
{
	my ($class,$w) = @_;
	my (@binds) = $w->bind($class);
	
	foreach $b (@binds) {
#=1999/07/11 alexiob@iname.com - Fixed win32 BackSpace bug thanks to Jim Turner
#		$w->bind($class,$b,"");
		$w->bind($class,$b,"") unless ($b =~ /Key-BackSpace/);
	}	
}

# end of Tk::Text::SuperText::RemoveTextBinds
1;
