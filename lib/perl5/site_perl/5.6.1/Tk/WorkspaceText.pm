package Tk::WorkspaceText;
my $RCSRevKey = '$Revision: 0.50 $';
$RCSRevKey =~ /Revision: (.*?) /;
$VERSION=$1;

require Exporter;
use Tk qw(Ev);
use Tk::TextUndo;

Construct Tk::Widget 'WorkspaceText';
use base qw(Tk::TextUndo);
#
# Bound in Tk::Text.pm
#
sub InsertKeypress {
  my ($w,$char)=@_;
  $w -> SUPER::InsertKeypress($char);
  $w -> {modified} = '1' if (defined $char && $char ne '');
}

sub Insert
{
  my $w = shift;
  my $string = shift;
 $w -> SUPER::Insert($string);
 $w -> {modified} = '1';
}

sub Delete {
 my ($w) = @_;
 $w -> SUPER::Delete;
 $w -> {modified} = '1';
}

sub Backspace {
 my ($w) = @_;
 $w -> SUPER::Backspace;
 $w -> {modified} = '1';
}

sub clipboardColumnCut {
 my ($w) = @_;
 $w-> Column_Copy_or_Cut(1);
 $w -> {modified} = '1';
}

sub clipboardColumnPaste {
 my ($w) = @_;
 $w -> SUPER::clipboardColumnPaste;
 $w -> {modified} = '1';
}

sub ClassInit {
 my ($class,$mw) = @_;
 $class->SUPER::ClassInit($mw);
 $Tk::prevPos = undef;
 return $class;
}

sub Populate {
  my ($w, $args) = @_;
  $w -> SUPER::Populate($args);
  $w -> {modified} = '';
  return $w;
}

1;
