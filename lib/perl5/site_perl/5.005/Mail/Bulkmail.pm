package Mail::Bulkmail;


#Copyright (c) 1999 James A Thomason III (jim3@psynet.net). All rights reserved.
#This program is free software; you can redistribute it and/or
#modify it under the same terms as Perl itself.


$VERSION = "1.11";

use Socket;

use 5.004;

#Let's make up some defaults:
$def_From		= 'Postmaster';
$def_Smtp		= 'your.smtp.com';	#<--Set this variable.  Important!
$def_Port 		= '25';
$def_Tries		= '5';
$def_Subject	= "(no subject)";
$def_Precedence = "list";
$def_No_errors	= 0;
$def_Duplicates	= 0;


#Don't mess with these unless you have a damn good reason.

{
	my $i = 0;
	foreach ($From, $_name, $Message, $iMessage, $Subject, $Map,
				$bulk, $LIST, $BAD, $GOOD, $ERROR, $BANNED,
				$Smtp, $Domain, $Port, $Tries, $Precedence,
				$connected,
				$Tz, $Date,
				$No_errors,$error,$Duplicates,$headers,$fmdl,$hfm){$_ = $i++};
};
			
#default generating methods

sub _def_From 		{return $def_From};

sub _def_Precedence {return $def_Precedence};

sub _def_Tz {

	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
	($gmin, $ghour, $gsdst) = (gmtime(time))[1,2, -1];

	$hour = "0" . $hour if $hour < 10;
	$mon  = "0" . $mon  if $mon < 10;
	($diffhour = sprintf("%03d", $hour - $ghour)) =~ s/^0/\+/;

	return $diffhour . sprintf("%02d", $min - $gmin);

};

sub _def_Date{

	my ($self) 	= shift;
	
	my @months 	= qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @days 	= qw(Sun Mon Tue Wed Thu Fri Sat);
	
	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
	
	$hour = "0" . $hour if $hour < 10;
	$min  = "0" . $min  if $min < 10;
	$sec  = "0" . $sec if $sec < 10;
	$year += 1900;		#RFC 1123 dates are 4 digit!
	
	return "$days[$wday], $mday $months[$mon] $year $hour:$min:$sec " . $self->Tz;
	
};

#/defaults

#validation methods
			#setting No_errors = 1 from within your object or $def_No_errors = 1 will bypass all validation checks
			#this is not recommended, but to each his own.
			
sub _valid_Tz{

	my ($Tz) = @_;
	
	#Accept only RFC 822 compliant timezones
	return 1 if $Tz && $Tz =~ m{
						(^[+-]\d\d\d\d$)			#+/- hour hour minute minute
								|
						(^([ECMP][SD]|(U|GM))T$)	#it can be a North American time, or Universal/GM time
								|
						(^[A-Za-z]$)				#or it can be a single ASCII alphabetic character
						}x;
};

sub _valid_Date{

	my ($Date) = @_;
	
	#return undef so we can only return undef or 1, not undef, 1, or 0
	return undef if ! $Date || $Date !~ m{
					^
					(?:(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s*,\s*)?									#Start off with an optional day
					\d\d?\s(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s\d\d(?:\d\d)?\s+	#Followed by the date
					\d\d:\d\d(?::\d\d)?\s+															#Followed by the time
					(.+)																		#Followed by the time zone 
					$																			# (which we'll check separately)
				}x;	
	
	#now all we have left to check is the time zone.  We'll be lazy and let _valid_Tz do it for us
	return _valid_Tz($1)

};

sub _valid_Precedence {
	
	my ($Precedence) = @_;
	
	#we're gonna at least _try_ to make this thing have a mass mailing precedence.
	return 1 if $Precedence && $Precedence =~ /^(?:list|bulk|junk)$/;
};

sub _valid_email {

	#yeah, yeah, yeah I know that checking for a valid full RFC-822 e-mail address without a parser is a damn pain in the ass.
	#_valid_email tries its best, though.  :)
	#It's gotta be a mailbox.  No groups.  That's redundant.
	#You also have to have a full domain name (and all ultimate top domains end in two or three letters)
	#and _valid_email, unlike the rest of the validation routines, does not return 1 on success, it returns the e-mail
	#address.  Why's that, you ask?  That way we can use _valid_email to simultaneously extract out the actual jim3@psynet.net from
	#"Jim Thomason"<jim3@psynet.net>, for example.
	#
	#Set No_errors to 1 if you don't trust it.
	
	my ($email) = @_;

	$atom = q<[!#$%&'*+\-/=?^`{|}~\w]>;
	$qstring = q/"(?:[^"\\\\\015]|\\\.)+"/;
	$word = "($atom+|$qstring)";

	$email = _comment_killer($email);

	$email =~ m/^$word\s*\<\s*(.+)\s*\>\s*$/;			#match beginning phrases
	
	$email = $2 if $2;									#if we've got a phrase, we've extracted the e-mail address
														#and stuck it in $2, so set $email to it.
														#if we didn't have a phrase, the whole thing is the e-mail address
	
	return $1 if $email =~ m<
							^\s*($word					#any word (see above)
							(?:\.$word)*				#optionally followed by a dot, and more words, as many times as we'd like
							@							#and an at symbol
							$atom+						#followed by as many atoms as we want
							(?:\.$atom+)*				#optionally followed by a dot, and more atoms, as many times as we'd like
							\.[a-zA-Z]{2,3})\s*$		#followed by 2 or 3 letters, and an optional greater than
							>xo;						
};

#/validation

#normalization

sub _comment_killer {

	my ($email) = shift;
	
	while ($email =~ /\((?:[^()\\\015]|\\.)*\)/){$email =~ s/\((?:[^()\\\015]|\\.)*\)//};

	return $email;
};

sub _normalize_Message {
	
	#double periods, change the line ends, etc.
	
	my ($self) = shift;
	
	my (%map) = %{$self->Map} if $self->Map;
	my $ind_map = shift;


	foreach $individual (keys %{$ind_map}){$map{$individual} = $ind_map->{$individual}};

	my $Message = $self->Message;

	$Message =~ s/^\./../gm;
	$Message =~ s/[\r\n]/\015\012/g;

	foreach $item (keys %map){$Message =~ s/$item/$map{$item}/g};
	
	
	return $Message;
};



sub _fix {

	#lowercase the domain part, but _not_ the local part.  Why not?
	#Read the specs, you can't make assumptions about the local part, it is case sensitive
	#even though 99.999% of the net treats it as insensitive.

	my ($email) = shift;
	
	if ($email =~ /@/){
		my ($local, $domain) = split(/@/, $email);
		$email = "$local@" . lc $domain;
	};
	
	return $email;
	
};

#/normalization

sub new {

	my $class = shift;
	my $self = [];			#why not a hash?  An array is a smidgen bit faster and no one is gonna see the underlying structure anyway
	bless $self, $class;	#Hey!  What are you doing looking in here anyway?  Use the nice OO interface I wrote you!
	
	$self->_init(@_);
	
	return $self;
	
};


sub _init {

	my ($self, %init) = @_;

	#initialize the defaults
	#If we were given something, use it.  Otherwise, use the default.
	
	#error checking
	$self->No_errors	($init{"No_errors"} 	|| $def_No_errors);

	#message related
	$self->From			(_valid_email($init{"From"}) 	|| _valid_email($def_From) || "Postmaster");
	$self->Subject		($init{"Subject"} 	|| $def_Subject);
	$self->Message		($init{"Message"})	if defined $init{"Message"};
	$self->Map			($init{"Map"})		if defined $init{"Map"};
	
	#This is a band-aid to allow us to e-mail out messages with a name in the From field intact.
	$self->_name		((_valid_email($init{"From"}) && $init{"From"}) || (_valid_email($def_From) && $def_From) || "");

	#smtp related
	$self->Smtp			($init{"Smtp"}		|| $def_Smtp);
	$self->Port			($init{"Port"}		|| $def_Port);
	$self->Tries		($init{"Tries"}		|| $def_Tries);
	$self->Precedence	((_valid_Precedence && $init{"Precedence"}) || $def_Precedence);
	$self->Domain		($init{"Domain"}		|| undef);
	
	#file related
	$self->LIST			($init{"LIST"}		|| undef);
	$self->BAD			($init{"BAD"}		|| undef);
	$self->GOOD			($init{"GOOD"}		|| undef);
	$self->ERROR		($init{"ERROR"}		|| undef);
	$self->BANNED		($init{"BANNED"}	|| undef);
	$self->fmdl			($init{"fmdl"}		|| "::");
	$self->hfm			($init{"hfm"}		|| 0);

	#date related
	$self->Tz	(($self->No_errors && $init{"Tz"})		||	(_valid_Tz($init{"Tz"}) && $init{"Tz"})				|| _def_Tz);
	$self->Date (($self->No_errors && $init{"Date"})	|| 	(_valid_Date($init{"Date"}) && $init{"Date"})		|| "default");

	#initialize duplicate value checking
	$self->Duplicates	($init{"Duplicates"}			|| $def_Duplicates);

	#Initialize the additional headers hash.
	$self->[$headers] = {};
	
	#and remove those defaults
	delete @init{"From", "Subject", "Message", "Map", "Smtp", "Port", "Tries", "Precedence", "Domain", "LIST", "BAD",
					"GOOD", "ERROR", "BANNED", "fmdl", "hfm", "Tz", "Date"};
	
	#is there anything left?  We're gonna assume that they're headers for simplicity's sake.
	#These things will get bounced down to headset, in the accessor method section.  
	foreach $BULK_header (keys %init){
		$self->headset($BULK_header,$init{$BULK_header});
	};	
};

#accessor methods

sub accessor {
	my ($self) = shift;
	my ($prop) = shift;

	if (@_){$self->[$prop] = shift};

	return $self->[$prop];
};

#message related accessors
sub _name 		{ accessor(shift, $_name, @_)};
sub Subject		{ accessor(shift, $Subject, @_)};
sub Message		{ accessor(shift, $Message, @_)};
sub iMessage	{ accessor(shift, $iMessage, @_)};
sub Map			{ accessor(shift, $Map, @_ )};

#smtp related accessors
sub Smtp 		{ accessor(shift, $Smtp, @_)};
sub Port 		{ accessor(shift, $Port, @_)};
sub Tries		{ accessor(shift, $Tries, @_)};
sub Domain 		{ accessor(shift, $Domain, @_)};

#file related
sub LIST		{ accessor(shift, $LIST, @_)};
sub BAD			{ accessor(shift, $BAD, @_)};
sub GOOD		{ accessor(shift, $GOOD, @_)};
sub ERROR		{ accessor(shift, $ERROR, @_)};
sub fmdl		{ accessor(shift, $fmdl, @_)};
sub hfm			{ accessor(shift, $hfm, @_)};

#misc accessors
sub No_errors	{ accessor(shift, $No_errors, @_)};
sub Duplicates	{ accessor(shift, $Duplicates, @_)};

#calling an unnamed function?  We're gonna assume that you meant to call headset.  And we're gonna
#tell you about it.  Adamantly.	
sub AUTOLOAD {
	my ($self) = shift;
	
	($method = $AUTOLOAD) =~ s/^.*:://;

	print STDERR "Method \"$method()\" doesn't exist.  Did you mean to call headset?";

	$self->error("Method \"$method()\" doesn't exist.  Did you mean to call headset?");
	
	return 0;

};
				
sub headset {

	my ($self) = shift;
	my ($header) = shift;
	
	if ($header =~ /^(From|Subject|Precedence)$/){return $self->$header(@_)};

	if (@_){$self->[$headers]->{$header} = shift};

	return $self->[$headers]->{$header};

};

sub From { 

	my ($self, $new_From) = @_;
	
	if (defined $new_From){$new_From = $self->[$From] || _def_From unless $self->No_errors || _valid_email($new_From)};
	
	$self->[$From] = $new_From if defined $new_From;

	$self->_name((_valid_email($new_From) && $new_From) || undef) if defined($new_From);

	return $self->[$From];
	
};

sub Precedence { 

	my ($self, $new_Precedence) = @_;
	
	if (defined $new_Precedence){$new_Precedence = $self->[$Precedence] || _def_Precedence unless $self->No_errors || _valid_Precedence($new_Precedence)};
	
	$self->[$Precedence] = $new_Precedence if defined $new_Precedence;

	return $self->[$Precedence];
	
};

sub BANNED {
	
	my ($self) = shift;
	my %banned = ();
	
	if (@_){
		local *FILE;
		*FILE = shift;

		while (defined ($address = <FILE>)){
			chomp $address;
			$banned{lc $address}++;
			$self->[$BANNED] = \%banned;
		};
	}
	else {return $self->[$BANNED]};
	
};

sub Tz { 

	my ($self, $new_Tz) = @_;

	if (defined $new_Tz){$new_Tz = $self->[$Tz] || _def_Tz unless $self->No_errors || _valid_Tz($new_Tz)};
	
	$self->[$Tz] = $new_Tz if defined $new_Tz;

	return $self->[$Tz];
	
};

sub Date {

	my ($self, $new_Date) = @_;

	if (defined $new_Date){$new_Date = "default" unless $self->No_errors || _valid_Date($new_Date)};
	
	$self->[$Date] = $new_Date if defined $new_Date;
	
	return $self->_def_Date if $self->[$Date] eq "default";
	
	return $self->[$Date];
	
};


#/accessors

#mailing methods

sub connect {
	
	my ($self) = shift;	
	
	local *BULK;

	my ($s_tries, $c_tries) = ($self->Tries, $self->Tries);

	1 while ($s_tries-- && ! socket(BULK, PF_INET, SOCK_STREAM, getprotobyname('tcp')));
	return $self->error("Socket error $!") if $s_tries < 0;
	
	$remote_address = inet_aton($self->Smtp);
	$paddr = sockaddr_in($self->Port, $remote_address);
	1 while ! connect(BULK, $paddr) && $c_tries--;
	return $self->error("Connect error $!") if $c_tries < 0;
	
	#keep our bulk pipes piping hot.
	select((select(BULK), $| = 1)[0]);
	
	local $\ = "\015\012";
	local $/ = "\015\012";
	
	$response = <BULK> || "";
	return $self->error("No response from server: $response") if  ! $response || $response =~ /^[45]/;
	
	#We're either given a domain, or we'll build it based on who the message is from
	my $domain = $self->Domain || $self->From;
	
	#Make sure it's only domain information
	$domain =~ s/.+@//;
	
	print BULK "HELO $domain";
	
	$response = <BULK> || "";
	return $self->error("Server won't say HELO: $response") if ! $response || $response =~ /^[45]/;

	$self->[$connected] = 1;
	
	$self->[$bulk] = *BULK;
	
	return 1;
};

sub disconnect {
	
	my $self = shift;
	
	local $\ = "\015\012";
	local $/ = "\015\012";
	
	if ($self->[$bulk]){
		local *BULK;
		*BULK = $self->[$bulk];
	
		print BULK "quit";

		close BULK;
	};
	
	$self->[$connected] = 0;
	
};

#mail actually does everything.
sub mail {

	my $self		= shift;
	my $to	 		= shift;
	my $local_map = shift;
	
	#Why duplicate it?  So we can log it, of course!
	my $full_to 	= $to;
	
	my %map = %{$self->Map} if $self->Map;
	
	foreach $local_item (keys %{$local_map}){$map{$local_item} = $local_map->{$local_item}};
	
	my (%map) = %{$self->Map} if $self->Map;

	#Overwrite global map items with local map items
	foreach $local_item (keys %{$local_map}){$map{$local_item} = $local_map->{$local_item}};

	#Overwrite any globals with BULK_FILEMAP values, don't overwrite anything re-declared in a local map
	if (defined $map{"BULK_FILEMAP"}){
		my $delimiter = $self->fmdl;
		my @map = split(/\Q$delimiter\E/, $map{"BULK_FILEMAP"});
		my @values = split(/\Q$delimiter\E/, $to);
		
		foreach $item (@map){
			$value = shift @values;
			next if defined $local_map->{$item};
			$map{$item} = $value;
		};
		$to = $map{"BULK_EMAIL"} unless _valid_email($to);
	};
	
	_fix($to);		#lowercase the domain.

	#No point in going any further if it's an invalid e-mail address
	return $self->error("Invalid e-mail address: $to", $full_to, "BAD") if $self->No_errors || ! _valid_email($to);
	
	#Check for duplicate addresses unless we've been told otherwise
	unless ($self->Duplicates){
		return $self->error("Duplicate address: $to", $full_to, "BAD") if $duplicates{_fix(_comment_killer($to))}++;
	};
	
	#Check for banned addresses if we have them
	if ($self->BANNED){
		my $domain;
		return $self->error("Banned address: $to", $full_to, "BAD") if $self->BANNED->{lc $to};
		
		($domain = $to) =~ s/.*@//;
		return $self->error("Banned domain: $domain", $full_to, "BAD") if $self->BANNED->{lc $domain}; 
	};
	
	
	#Figure out any extra headers we may have
	my @headers = map {(my $h = $_) =~ s/^Mail::Bulkmail:://; "$h: $self->[$headers]->{$_}"} keys %{$self->[$headers]};
	
	#print @headers;
	#return;

	local $\ = "\015\012";
	local $/ = "\015\012";
	
	$self->connect if ! $self->[$connected];
		
	local *BULK;
	*BULK = $self->[$bulk];
	
	#First thing we're gonna do is reset it in case there's any garbage sitting there.
	print BULK "RSET";
	$response = <BULK> || "";
	return $self->error("Cannot reset connection: $response") if ! $response || $response =~ /^[45]/;
	if ($response =~ /^221/){
		$self->[$connected] = 0;
		close BULK; 
		return $self->error("Server disconnected: $response");
	};
	
	#Who's the message from?
	print BULK "MAIL FROM:<", $self->From, ">";
	$response = <BULK> || "";
	return $self->error("Invalid Sender: $response <$to>") if ! $response || $response =~ /^[45]/;
	if ($response =~ /^221/){
		$self->[$connected] = 0; 
		close BULK; 
		return $self->error("Server disconnected: $response");
	};
	
	#Who's the message to?
	print BULK "RCPT TO:<", $to, ">";
	$response = <BULK> || "";
	return $self->error("Invalid Recipient: $response <$to>") if ! $response || $response =~ /^[45]/;
	if ($response =~ /^221/){
		$self->[$connected] = 0;
		close BULK; 
		return $self->error("Server disconnected: $response");
	};
	
	#Let the server know we're gonna start sending data
	print BULK "DATA";
	$response = <BULK> || "";
	return $self->error("Not ready to accept data: $response") if ! $response || $response =~ /^[45]/;
	if ($response =~ /^221/){
		$self->[$connected] = 0; 
		close BULK; 
		return $self->error("Server disconnected: $response");
	};		
	
	if ($self->hfm){		#get headers from message
		$message = $self->_normalize_Message(\%map);
		$message =~ m/^(.*?)\015\012\015\012(.*)$/s;

		$self->iMessage($2);

		my %headers = split(/\s*:\s*|\015\012/, $1);
		$self->From($headers{"From"}) 					if defined $headers{"From"};
		$self->Subject($headers{"Subject"}) 			if defined $headers{"Subject"};
		$self->Date($headers{"Date"}) 					if defined $headers{"Date"};
		$self->Precedence($headers{"Precedence"}) 		if defined $headers{"Precedence"};

		delete @headers{"From", "Subject", "Date", "Precedence", "To"};
		foreach $header (keys %headers){push @headers, "$header: $headers{$header}"};
	}
	else {$self->iMessage($self->_normalize_Message(\%map))};

	
	
	#Print the headers that we care about
	print BULK "Date: "	 		, $self->Date;
	print BULK "From: "			, $self->_name;
	print BULK "Subject: "		, $self->Subject;
	print BULK "To: "			, $to;
	print BULK "Precedence: "	, $self->Precedence; 
	print BULK "X-Bulkmail: "	, "Mail Bulkmail $VERSION";
	
	#print out all the other headers
	if (@headers){foreach (@headers){print BULK}};
	
	print BULK "";
	
	#print out the message
	print BULK $self->iMessage;
	print BULK ".";
	
	$response = <BULK> || "";
	return $self->error("Message not accepted for delivery: $response") if ! $response || $response =~ /^[45]/;
	if ($response =~ /^221/){
		$self->[$connected] = 0; 
		close BULK; 
		return $self->error("Server disconnected: $response");
	};
	
	$self->_log($full_to, "GOOD");
	
	return 1;

};

sub bulkmail {

	my ($self) = shift;
	my $local_map = shift;

	local *LST;
	*LST = $self->LIST;

	while (<LST>){
		chomp;
		$_ =~ s/(?:^\s+|\s+$)//g;	#trash trailing and leading white space
		$self->mail($_, $local_map);
	};

	%duplicates = ();

};

#/mailing

#Make sure that we shut off the SMTP connection when we're destroyed.
sub DESTROY {
	my ($self) = shift;
	$self->disconnect;
};

#And a special method to handle errors
sub error {
	my ($self) = shift;
	
	if (@_){
		$self->[$error] = shift;
		
		$self->_log($self->[$error], "ERROR");
		
		#Did we call _error with any additional arguments?  If so, we want to log something else.
		#So let's log it:
		if (@_){
			my $what = shift;
			my $where = shift;
			
			$self->_log($what, $where);
		};
		
		return 0;
	}
	else {return $self->[$error]};
};

#and another special method to handle logging
sub _log {
	
	my ($self) = shift;
	my ($value) = shift;
	my ($file) = shift;
	
	if ($self->$file()){
		local *FILE;
		*FILE = $self->$file();
		select((select(FILE), $| = 1)[0]); 		#Make sure the file is piping hot!
		
		local $\ = undef;
		
		#get rid of those sendmail-ified carriage returns
		$value =~ s/\015\012$//g;
		
		print FILE $value, "\n";
	};
	
	return 1;
	
}
	
1;

__END__

=pod

=head1 NAME

Mail::Bulkmail - Platform independent mailing list module

=head1 AUTHOR

Jim Thomason jim3@psynet.net

=head1 SYNOPSIS

open (LIST, "./list.txt") 		|| die "Can't open list!";

 $bulk = Mail::Bulkmail->new(
	From	=> 'jimt@playboy.com',
	Subject	=> 'This is a test message!',
	Message	=> "Here is the text of my message!",
	'LIST'	=> *LIST,
 );

$bulk->bulkmail;

close LIST;

Be sure to set your default variables in the module, or set them
in each bulk mail object.  Otherwise, you'll be using the defaults.
(Not that that's necessarily bad)


=head1 DESCRIPTION

Mail::Bulkmail gives a fairly complete set of tools for managing
mass-mailing lists.  I wrote it because our existing tools were just
too damn slow for mailing out to thousands of recipients.

=head1 REQUIRES

Perl5.004, Socket

=head1 OBJECT METHODS

=head2 CREATION

New Mail::Bulkmail objects are created with the new() constructor.  For a minimalist 
creation, do this:

$object = Mail::Bulkmail->new();

You can also initialize values at creation time, such as:

 $object = Mail::Bulkmail->new(
			From	=>	'jim3@psynet.net',
			Smtp	=>	'some.smtp.com'
		);

=head2 BUILT IN ACCESSORS

Okay, here's where the fun stuff beings.  Since these are objects, the important stuff is how
you access your data.

Object methods work as you probably expect.

 $bulk->property
  Will return the value of "property" in $bulk

 $bulk->property("new value")
   Will set the value of "property" in $bulk to "new value" and return "new value"
   The property will not be set if $object->No_errors is 0 and the property has a
   validation check on it.  See Validated Accessors, below.

All accessor methods are case sensitive.  Be careful!

Here are all of the accessors that come built in to your Mail::Bulkmail objects.

=over 11

=item From

The e-mail address this list is coming from.  This can be either a simple e-mail address 
(jim3@psynet.net), or a name + e-mail address ("Jim Thomason"<jim3@psynet.net>).  This is validated
unless you turned off validation by setting No_errors.  See above.

=item Subject

The subject of the e-mail message.  If it's not set, you'll use the default.

=item Message

This is the actual text that will appear in the message body.  You can include control
fields that can be mapped into specific values.  See MAPPING, below

=item Map

This specifies a character map for the message text.  See MAPPING, below.

=item Smtp

This sets the SMTP server that you're going to connect to.  You'll probably just want to
use whatever you've set as your default SMTP server in the module.  You did set your default SMTP 
server when you double-checked all the other defaults, right?

=item Tries

This sets the number of times that you will attempt to connect to a server.  You'll probably
just want to use the default.

=item Precedence

This sets the precedence of the e-mail message.  This is validated unless you turn off
validation by setting No_errors.

=item Domain

You're going to be saying HELO to an SMTP server, you'd be be willing to give it a domain
as well.  You can explicitly set the Domain here, or choose not to.  If no Domain is set, the domain
of the From e-mail address will be used instead.  It doesn't do you any good to set Domain after
you've connected to a server.

=item LIST

This is a glob to a filehandle.  This is your actual list of e-mail addresses.  You can
either have one e-mail address per line, or have multiple delimited fields in addition to the 
e-mail address.  If you choose to use delimited fields, read the section on MAPPING, below.  This file
should be openned with read access.  Required if you're going to be bulkmailing.

The default delimiter is "::", read the section on MAPPING and the fmdl method below.

=item BAD

This is a glob to a filehandle.  Bulkmail will happily print out all failed addresses, exactly
as they appeared in LIST to this file.  This file should be openned with write or append access.  Totally optional.

=item GOOD

This is a glob to a filehandle.  Bulkmail will happily print out all successful addresses,
exactly as they appeared in LIST to this file.  This file should be openned with write or append access.
Totally optional. GOOD is much more useful than BAD since GOOD is a duplicate of your original 
list, with all invalid addresses weeded out.

=item ERROR

This is a glob to a filehandle.  Any errors that occur in Bulkmail will be printed out here.  Totally optional, but highly
recommended.  This file should be openned with write or append access.

=item BANNED

This is a glob to a filehandle.  BANNED allows you to weed your mailing list and not
mail to any e-mail addresses that you may have in your list that you don't want to.  For example,
you may not want to be able to send any e-mail to "president@whitehouse.gov", putting that into
your banned file will automatically skip that address while mailing.  Additionally, you can specify domains
so that no mail will go to "whitehouse.gov", for example.  A word of caution:  Subdomains are
banned recursively.  This means that "whitehouse.gov" will ban "staff.whitehouse.gov" but that 
"staff.whitehouse.gov" will allow e-mail to go through to "whitehouse.gov".  This file should
be openned with read access. 

=item Tz

This allows you to set the timezone.  See above.  You probably don't want to touch this.

=item Date

This allows you to set the date.  See above.  You probably don't want to touch this.

=item Duplicates

Duplicates is off by default.  Setting Duplicates to 1 will allow people with multiple
entries in your mailing list to receive multiple copies of the message.  Otherwise, they will
only receive one copy of the message.  Duplicate addresses are printed out to ERROR, if you specified
ERROR and you didn't turn Duplicates on.

=item headset

headset() is actually a method that pretends to be an accessor.  See ADDTIONAL ACCESSORS, below.

=item hfm

hfm (Headers From Message) will extract any valid headers from the message body.  A valid header is
of the form "Name:value", one per line with an empty line seperating the headers from the message.

It is B<much> better to explicitly set the headers using the headset method because it's a tougher 
to make mistakes using headset.  Nonetheless, setting hfm to any true value will cause the module to
look in the message for headers.  Any valid headers extracted from the message will override existing 
headers.  Headers extracted from the message will be removed from the message body.

But be perfectly sure you know what you're doing.

	$bulk->hfm(1);
	
	$bulk->Message(
		"This is my message.  I'm going to try sending it out to everyone that I know.
		Messages are cool, e-mailing software is neat, and everyone will love me for it.
		Oh happy day, happy happy day.
		Love,
		
		Jim";

Because hfm is set to true, the first four lines are extracted from the message and sent as headers.
The extent of the message that goes through is "Jim" (everything after the first blank line which separates
headers from message body).

hfm is off by default.

=item fmdl

fmdl (filemap delimiter) tells the module what delimiter to use in the file when using BULK_FILEMAPs
(see below)

fmdl is "::" by default.

=item No_errors

No_errors() lets you decide to turn of error checking.  By default, Mail::Bulkmail will only allow you
to use valid e-mail addresses (well, kinda see the _valid_email function for comments), valid dates, valid
timezones, and valid precedences.  No_errors is off by default.  Turn it on by setting it to some non-zero value.
This will bypass B<all> error checking.  You should probabaly just leave it off so you can check for valid e-mails,
dates, etc.  But you have the option, at least.

=back


=head2 ADDITIONAL ACCESSORS

You're perfectly welcome to access any additional data that you'd like.  We're gonna assume that you're accessing
or setting a header other than the standard ones that are provided.  You even get a special method to access them:
headset().  Using it is a piece of cake:

$bulk->headset('Reply-to', 'jim3@psynet.net');

Will set a "Reply-to" header to the value of "jim3@psynet.net".  Want to access it?

$bulk->headset('Reply-to');

What's that you ask?  Why don't we set *all* headers this way?  Well, truth be told you can set them using headset.

$bulk->headset('From', 'jim3@psynet.net');

Is the same as:

$bulk->From('jim3@psynet.net');

Note that you can only set other _headers_ this way.  The headers that have their own methods are From, Subject, and
Precedence.  Calling headset on something else, though (like "Smtp") will set a header with that value, which is probably
not what you want to do (a "Smtp: your.server.com" header is reeeeeal useful).  I'd recommend just using the provided
From, Subject, and Precedence headers.  That's what they're there for.

What's that?  Why the hell can't you just say $bulk->my_header('some value')?  It's because you may want to have a header
with a non-word character in it (like "Reply-to"), and methods with non-word characters are a Perl no-no.  So since it's
not possible for me to check every damn header to see if it has a non-word character in it (things get stripped and messed
up and the original value is lost), you'll just have to use headset to set or access additional headers.

OR--You can just set your headers at object construction.  Realistically, you're going to be setting all of your headers
at construction time, so this is not a problem.  Just remember to quote those things with non-word characters in them.

 $bulk->Mail::Bulkmail->new(
 		From		=> 	'jim3@psynet.net',
 		Subject		=>	'Some mass message',
 		'Reply-to'	=>	'jimt@playboy.com'
 	);

If you don't quote headers with non-word characters, all sorts of nasty errors may pop up.  And they're tough to track down.
So don't do it.  You've been warned.


=head2 VALIDATED ACCESSORS

The properties that have validation checks are "From", "Precedence", "Date", and "Tz" to try
to keep you from making mistakes.  The only one that should really ever concern you is perhaps "From"

=over 11

=item From

This checks the return e-mail address against RFC 822 standards.
The validation routine is not perfect as it's really really hard to be perfect, but
it should accept any valid non-group non-commented e-mail address.
There is one bug in the routine that will allow "Jim<jim3@psynet.net" to pass as valid,
but it's a nuisance to fix so I'm not going to.  :-)

=item Precedence

We are doing bulkmail here, so the precedence should always be "list", "bulk",
or "junk" and nothing else.  We might as well be polite and not make our servers
think that we're sending out 60,000 first-class or special-delivery messages.
You probably don't want to fiddle with this.

=item Date

This checks that the date set is a valid RFC 822 date.  You probably don't ever want
to set the date, since it will be automagically inserted to each e-mail message as it
is sent.  Nonetheless, if you just have to use some other random date, set it here.
But follow the spec, please.

=item Tz

This checks that the timezone set is a valid RFC 822 Time zone.  The only time I can
think of where you'd want to set the time zone is if your machine is off and you want
to correct it.  For example, several of our servers seem to think that they're on 
Pacific Time instead of Central Time, which is annoying.  Fix the time zone here if you
need to.

=back

If you don't want to do any validation checks, then set No_errors equal to 1 (see METHODS, below).
That will bypass all validation checks and allow you to insert "Garbonzo" as your date if you desire.
It's recommended that you leave error checking on.  It's pretty good.  And you have more important things
to worry about.

=head2 Methods

There are several methods you are allowed to invoke upon your bulkmail object.

=over 10

=item bulkmail (no arguments)

This method is where the magic is.  This method starts up your mailing, sending 
your message to every person specified in LIST.  bulkmail returns nothing.  
bulkmail merely loops through everything in your LIST file and calls mail on each entry.

=item mail (email address, [map hashref]?)

Okay, maybe mail is really where the magic is.  This method sends out a message to a single address.
You can use this method if you want to send out a message to only one person, though arguably 
there are better ways to send e-mail to a single individual than using Mail::Bulkmail.  The 
first argument to mail is the e-mail address of the recipient.  The second argument is an optional 
local map.  See MAPPING below.  Further arguments are optional headers.  Calling mail directly 
is really only useful if you need to do preprocessing of your list before sending your message or if your
list of addresses is stored in an array or some other non-filehandle location.

Returns 1 on success, 0 on failure.

=item connect (no arguments)

This method connects to your SMTP server.  It is called by mail (and in turn, bulkmail).
You should never need to directly call this unless you want to merely test SMTP connectivity.

Returns 1 on success, 0 on failure.

=item disconnect (no arguments)

This method disconnects from your SMTP server.  It is called at object destruction, or
explicitly if you wish to disconnect earlier.  You should never need to call this method.  Returns
nothing.

=item error (no arguments)

error is where the last error message is kept.  Can be used as follows:

$object->connect || die $object->error;

All error messages will be logged if you specifed an ERROR file.

=back

=head1 MAPPING

Finally, the mysterious mapping section so often alluded to.

You are sending out bulk e-mail to any number of people, but perhaps you would like to personalize
the message to some degree.  That's where mapping comes in handy.  You are able to define a map
to replace certain characters (control strings) in an e-mail message with certain other characters
(values).

Maps can be global so that all control strings in all messages will be replaced with the same value
or local so that control strings are replaced with different values depending upon the recipient.

Maps are declared at object constrution or by using the Map accessor.  Map values are either
anonymous hashes or references to hashes.  For example:

At constrution:

 	$bulk = Mail::Bulkmail->new(
 				From	=>	jim3@psynet.net,
 				Map		=> {
 								'DATE' => 'today',
 								'company' => 'Playboy Enterprises'
 							}
 			);

Or using the accessor:

 	$bulk->Map({'DATE'=>yesterday});
 	
Global maps are not terribly useful beyond setting generic values, such as today's date within a message
template.  Local maps are much more helpful since they allow values to be set individually in each
message.  Local maps can be declared either in a call to the mail method or by using the BULK_FILEMAP
key.  Local maps are declared with the same keyword (Map) as global maps.

As a call to mail:

 	$bulk->mail(
 			'jim3@psynet.net',
 			{
 				'ID'   => '36373',
 				'NAME' => 'Jim Thomason',
 			}
 		);
 
Using BULK_FILEMAP

 	$bulk->Map({'BULK_FILEMAP'=>'BULK_EMAIL::ID::NAME'});
 	
Be careful with your control strings to make sure that you don't accidentally replace text in the message
that you didn't mean to.  Control strings are case sensitive, so that "name" in a message from the 
above example would not be replaced by "Jim Thomason" but "NAME" would be.

BULK_FILEMAP will be explained more below.

=head2 BULK_FILEMAP

Earlier we learned that LIST files may be in two formats, either a single e-mail address per line,
or a delimited list of values, one of which must be an e-mail address.

Delimited lists _must_ be used in conjunction with a BULK_FILEMAP parameter to Map.  BULK_FILEMAP
allows you to specify that each e-mail message will have unique values inserted for control strings
without having to loop through the address list yourself and specify a new local map for every message.
BULK_FILEMAP may only be set in a global map, its presence is ignored in local maps.

 If your list file is this:
   jim3@psynet.net::36373::Jim Thomason
   
You can have a corresponding map as follows:

 $bulk->Map({
 		'BULK_FILEMAP'=>'BULK_EMAIL::ID::NAME'
 		});

This BULK_FILEMAP will operate the same way that the local map above operated.  "BULK_EMAIL" is the
only required item, it is case sensitive.  This is where in your delimited line the e-mail
address of the recipient is.  "BULK_EMAIL" _is_ used as a control string in your message.  Be careful.
So if you want to include someone's e-mail address within the text of your message, put the string
"BULK_EMAIL" in your message body wherever you'd like to insert it.

Everything else may be anything you'd like, these are the control
strings that will be substituted for the values at that location in the line in the file.
You may use global maps, BULK_FILEMAPs and local maps simultaneously.

BULK_FILEMAPs are declared as delimited by the fmdl method (or "::" by default), the data in the actual file
is also delimited by the fmdl method.  The default delimiter is "::", but as of version 1.10, 
you may use fmdl to choose any arbitrary delimiter in the file.

For example:

	$bulk->fmdl("-+-");
	
	$bulk->Map({'BULK_FILEMAP'=>'BULK_EMAIL-+-ID-+-NAME'});
	
	(in your list file)
	jim3@psynet.net-+-ID #1-+-Jim Thomason
	jimt@playboy.com-+-ID #2-+-Jim Thomason
	

=head2 Map precedence

BULK_FILEMAP values will override global map values.  local map values will override anything else.
Evaluation of map control strings is 

 local value -> BULK_FILEMAP value -> global value

where the first value found is the one that is used.

=head1 CLASS VARIABLES

 $def_From		= 'Postmaster';
 $def_Smtp		= 'your.smtp.com';
 $def_Port 		= '25';
 $def_Tries		= '5';
 $def_Subject		= "(no subject)";
 $def_Precedence 	= "list";
 $def_No_errors		= 0;
 $def_Duplicates	= 0;

The default values. for various items.  All of which may be overridden in individual objects.

=over 10

=item def_From

Who will this message be from if no return address is specified or if it's invalid?

=item def_Smtp

What's the default SMTP server to connect to?
B<You really should set this variable!>  If you don't, you'll have to specify an SMTP
server in every bulkmail object you set up.  "your.smtp.com" doesn't work, it's example only.

=item def_Port

What port on that machine should we try to connect to?

=item def_Tries

How many times should we try to reconnect if we fail?

=item def_Subject

What should the subject of the message be if we don't have one?

=item def_Precedence

What should the precedence for these messages be?

=item def_No_errors

Should we allow error checking? 
if No_errors is true, then we won't check for valid dates, 
time zones, email addresses, and precedences

=item def_Duplicates

If someone is on a list more than once, 
should they receive multiple copies of the message?
=back

=head1 DIAGNOSTICS

Bulkmail doesn't directly generate any errors.  If something fails, it will return 0
and set the ->error property of the bulkmail object.  If you've provided an error log file,
the error will be printed out to the log file.

Check the return type of your functions, if it's 0, check ->error to find out what happened.

=head1 HISTORY

=over 14

=item - 1.11 11/09/99

Banned addresses now checks entire address case insensitively instead of leaving the local part
alone.  Better safe than sorry.

$self->fmdl is now used to split BULK_FILEMAP

Various fixes suggested by Chris Nandor to make -w shut up.

Changed the way to provide local maps to mail and bulkmail so it's more intuitive.

=item - 1.10 09/08/99 

Several little fixes.

The module will now re-connect if it receives a 221 (connection terminated) message from the server.

Fixed a potential near-infinite loop in the _valid_email routine.

_valid_email now merrily strips away comments (even nested ones).  :)

hfm (headers from message) method added.

fmdl (filemap delimiter) method added.

=item - 1.01 09/01/99

E-mail validation and date generation bug fixes

=item - 1.00 08/18/99 

First public release onto CPAN

=item - 0.93 08/12/99

Re-vamped the documentation substantially.

=item - 0.92 08/12/99

Started adding a zero in front of the version name, just like I always should have

Changed accessing of non-standard headers so that they have to be accessed and retrieved

via the "headset" method.  This is because methods cannot have non-word characters in them.

From, Subject, and Precedence headers may also be accessed via headset, if you so choose.

AUTOLOAD now complains loudly (setting ->error and printing to STDERR) if it's called.

=item - 0.91 08/11/99

Fixed bugs in setting values which require validation checks.
Fixed accessing of non-standard headers so that the returns are identical to every other accesor method.

=item - 0.90

08/10/99 Initial "completed" release.  First release available to general public.

=back

=head1 EXAMPLES

=head2 bulkmailing

Here's how we use Bulkmail in one of our programs:

 use Mail::Bulkmail;

 open (LIST,   "./list.txt") 		|| die "Can't open list!";
 open (GOOD,   ">./good_list.txt") || die "Can't open good list!";
 open (BAD,    ">./baddata.txt") 	|| die "Can't open bad list!";
 open (ERROR,  ">./error.txt") 		|| die "Can't open error file!";
 open (BANNED, "./banned.txt") 		|| die "Can't open banned list!";


 $bulk = Mail::Bulkmail->new(
	From	=> $from,
	Subject	=> $subject,
	Message	=> $message,
	X-Header=> "Rockin' e-mail!",
	Map		=> {
				'<DATE>'		=> $today,
				BULK_FILEMAP	=>	"email::<ID>::<NAME>::<ADDRESS>"
				},
	'LIST'	=> *LIST,
	'GOOD'	=> *GOOD,
	'BAD'	=> *BAD,
	'ERROR'	=> *ERROR,
	'BANNED'=> *BANNED,
 );

That example will set up a new bulkmail object, fill in who it's from, the subject, and the message,
as well as a "X-header" header which is set to "Rockin' e-mail!".
It will also define a map to turn "<DATE>" control strings into the $today string, a BULK_FILEMAP to map 
in the name, id number, and address of the user.  It defined the LIST as the LIST file openned earlier,
and sets up GOOD, BAD, and ERROR files for logging.  It also uses a BANNED list.

This list is then mailed to by simply calling

$bulk->bulkmail();

Easy as pie.  Especially considering that when we had to write all of this code out in our original
implementation, it took up well over 100 lines (and was 400x slower).

=head2 Single mailing

 use Mail::Bulkmail;
 
 $bulk = Mail::Bulkmail->new(
 	From	=>	$from,
 	Subject	=>	$Subject,
 	Message	=>	$message,
 	X-Header=>	"Rockin' e-mail!"
 );
 
 $bulk->mail(
 		'jim3@psynet.net',
 		{
 			'<DATE>'	=> $today,
 			'<ID>'		=> 36373,
 			'<NAME>'	=> 'Jim Thomason',
 			'<ADDRESS>'	=> 'Chicago, IL'
 		}
 	);

This will e-mail out a message identical to the one we bulkmailed up above, but it'll only go to
jim3@psynet.net

=head1 FAQ

B<So just how fast is this thing, anyway?>

Really fast.  Really stupendously incredibly fast.

The largest list that I have data on has 91,140 people on it.  This list runs through to I<completion> in about
an hour and 43 minutes, which means that Mail::Bulkmail can process (at least) 884 messages per minute or about
53,100 per hour.

B<So? How big were the individual messages sent out?  Total data transferred is what counts, not total recipients!>

How right you are.  The last message sent out was 4,979 bytes.  4979 x 91,140 people is 453,786,060 bytes of data 
transferred, or about 453.786 megabytes in 1 hour and 43 minutes.  This is a sustained transfer rate of about 4.4 megabytes
per minute, or 264.34 megabytes per hour.

B<Am I going to see transfer speeds that fast?>

Maybe, maybe not.  It depends on how busy your SMTP server is.  If you have a relatively unused SMTP server with a fair amount
of horsepower, you can easily get these speeds or beyond.  If you have a relatively busy and/or low powered SMTP server, you're
not going to reach speeds that fast.

B<How much faster will Mail::Bulkmail be than my current system?>

This is a very tough question to answer, since it depends highly upon what your current system is.  For the sake of argument,
let's assume that for your current system, you open an SMTP connection to your server, send a message, and close the connection.
And then repeat.  Open, send, close, etc.

Mail::Bulkmail will I<always> be faster than this approach since it opens one SMTP connection and send every single message across
on that one connection.  How much faster depends on how busy your server is as well as the size of your list.

Lets assume (for simplicity's sake) that you have a list of 100,000 people.  We'll also assume that you have a pretty busy
SMTP server and it takes (on average) 25 seconds for the server to respond to a connection request.  We're making 100,000
connection requests (with your old system).  That means 100,000 x 25 seconds = almost 29 days waiting just to make connections
to the server!  Mail::Bulkmail makes one connection, takes 25 seconds for it, and ends up being 100,000x faster!

But, now lets assume that you have a very unbusy SMTP server and it responds to connection requests in .003 seconds.  We're making
100,000 connection requests.  That means 100,000 x 25 seconds = about 5 minutes waiting to make connections to the server.
Mail::Bulkmail makes on connection, takes .0003 seconds for it, and ends up only being 1666x faster.  But, even though being
1,666 times faster sounds impressive, the world won't stop spinning on its axis if you use your old system and take up an extra
5 minutes.

And this doesn't even begin to take into account systems that don't open and close SMTP connections for each message.

In short, there's no way to tell how much of a speed increase you'll see.

B<Have you benchmarked it against anything else?>

Not scientifically.  I've heard that Mail::Bulkmail is about 4-5x faster than Listcaster from Mustang Software, but I don't
have any hard numbers.  

If you want to benchmark it against some other system and let me know the results, it'll be much appreciated.  :-)

B<Wait a minute!  You said up there that Mail::Bulkmail opens one connection and sends all the messages through.  What happens
if the connection is dropped midway through?>

Well, either something good or something bad depending on what happens.  If it's something good, the server will send a 221 message
(server closing) which Mail::Bulkmail should pick up and some point, realize its disconnected and then reconnect for the next
message.  If it's something bad, the server will just stop replying and Mail::Bulkmail will sit there forever wondering why
the server won't talk to it anymore.  

Realistically, if your server bellyflopped and is not responding at all and won't even alert that it's disconnected, you probably
have something serious to worry about.

A future release will probably have a time-out option so Mail::Bulkmail will bow out and assume its disconnected after a
certain period of time. 

B<What about multipart messages? (MIME attachments)>

I may add this in in the future, I may not.  It has its benefits, but realistically multipart messages should only
very rarely come up in legit bulkmail.  If your attachment is all text, you should probably stick it all into the
message body.  If your attachment is a graphic, you'll probably bury your server with the load.

You should probably be able to insert MIME into the message yourself, but you'll have to define your own headers,
boundaries, etc.  It I<should> work just fine, but I don't know of anyone that's tried it.

B<I'd like to send out a mass-mailing that has different From and To fields in the message and the envelope.  Can I do this?>

Nope.  Nor will you ever be able to.  This is a feature that I'm never going to add into the module.  I can't think
of any legitimate business use where you'd want to have the message headers and envelope differ.  I can, however, think
of about 3,000 spam usages for this feature.  Since this ability would make the module much much more attractive to
spammers, it ain't gonna be added in ever.

B<So what is it with these version numbers anyway?>

I'm going to I<try> to be consistent in how I number the releases.

The B<hundredths> digit will indicate bug fixes, etc.

The B<tenths> digit will indicate new and/or better functionality, as well as some minor new features.

The B<ones> digit will indicate a major new feature or re-write.

Basically, if you have x.ab and x.ac comes out, you want to get it guaranteed.  Same for x.ad, x.ae, etc.

If you have x.ac and x.ba comes out, you'll probably want to get it.  Invariably there will be bug fixes from the last "hundredths"
release, but it'll also have additional features.  These will be the releases to be sure to read up on to make sure that nothing
drastic has changes.

If you have x.ac and y.ac comes out, it will be the same as x.ac->x.ba but on a much larger scale.

B<Anything else you want to tell me?>

Sure, anything you need to know.  Just drop me a message.

=head1 MISCELLANEA

Mail::Bulkmail will automatically set three headers for you.

=over 4

=item 1

Who the message is from (From:....)

=item 2

The subject of the message (Subject:...)

=item 3

The precedence of the message (Precedence:...)

=back

The defaults will be set unless you give them new values, but regardless these headers I<will> be set.  No way
around it.  Additional headers are set solely at the descretion of the user.

Also, this module was originally written to make my life easier by including in one place all the goodies that I
used constantly.  That's not to say that there aren't goodies that I haven't included that would be beneficial to add.
If there's something that you feel would be worthwhile to include, please let me know and I'll consider adding it.

How do you know what's a worthwhile addition?  Basically, if you need to do some sort of pre-processing to your e-mail
addresses so that you have to use your own loop and calls to mail() instead of using bulkmail(), and you're using said
loop and processing in several routines, it may be a useful addition.  Definitely let me know about those.  

That's not to say that random suggestions wouldn't be good, those I'll listen to as well.  But something big like that
is probably a useful thing to have so I'd be most interested in hearing about them.

=head1 COPYRIGHT (again)

Copyright (c) 1999 James A Thomason III (jim3@psynet.net). All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 CONTACT INFO

So you don't have to scroll all the way back to the top, I'm Jim Thomason (jim3@psynet.net) and feedback is appreciated.
Bug reports/suggestions/questions/etc.  Hell, drop me a line to let me know that you're using the module and that it's
made your life easier.  :-)

=cut
