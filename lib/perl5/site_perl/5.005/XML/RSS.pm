# 
# Copyright (c) 1999 Jonathan Eisenzopf <eisen@pobox.com>
# XML::RSS is free software. You can redistribute it and/or
# modify it under the same terms as Perl itself.

package XML::RSS;

use strict;
use Carp;
use XML::Parser;
use vars qw($VERSION $AUTOLOAD @ISA);

$VERSION = '0.8';
@ISA = qw(XML::Parser);

my %v0_9_ok_fields = (
    channel => { 
	title       => '',
	description => '',
	link        => '',
	},
    image  => { 
	title => '',
	url   => '',
	link  => '' 
	},
    textinput => { 
	title       => '',
	description => '',
	name        => '',
	link        => ''
	},
    items => [],
    num_items => 0,
    version         => '',
    encoding        => ''
);

my %v0_9_1_ok_fields = (
    channel => { 
	title          => '',
	copyright      => '',
	description    => '',
	docs           => '',
	language       => '',
	lastBuildDate  => '',
	'link'         => '',
	managingEditor => '',
	pubDate        => '',
	rating         => '',
	webMaster      => ''
	},
    image  => { 
	title       => '',
	url         => '',
	'link'      => '',
	width       => '',
	height      => '',
	description => ''
	},
    skipDays  => {
	day         => ''
	},
    skipHours => {
	hour        => ''
	},
    textinput => {
	title       => '',
	description => '',
	name        => '',
	'link'      => ''
	},
    items           => [],
    num_items       => 0,
    version         => '',
    encoding        => '',
    category        => ''
);

my %languages = (
    'af'    => 'Afrikaans',
    'sq'    => 'Albanian',
    'eu'    => 'Basque',
    'be'    => 'Belarusian',
    'bg'    => 'Bulgarian',
    'ca'    => 'Catalan',
    'zh-cn' => 'Chinese (Simplified)',
    'zh-tw' => 'Chinese (Traditional)',
    'hr'    => 'Croatian',
    'cs'    => 'Czech',
    'da'    => 'Danish',
    'nl'    => 'Dutch',
    'nl-be' => 'Dutch (Belgium)',
    'nl-nl' => 'Dutch (Netherlands)',
    'en'    => 'English',
    'en-au' => 'English (Australia)',
    'en-bz' => 'English (Belize)',
    'en-ca' => 'English (Canada)',
    'en-ie' => 'English (Ireland)',
    'en-jm' => 'English (Jamaica)',
    'en-nz' => 'English (New Zealand)',
    'en-ph' => 'English (Phillipines)',
    'en-za' => 'English (South Africa)',
    'en-tt' => 'English (Trinidad)',
    'en-gb' => 'English (United Kingdom)',
    'en-us' => 'English (United States)',
    'en-zw' => 'English (Zimbabwe)',
    'fo'    => 'Faeroese',
    'fi'    => 'Finnish',
    'fr'    => 'French',
    'fr-be' => 'French (Belgium)',
    'fr-ca' => 'French (Canada)',
    'fr-fr' => 'French (France)',
    'fr-lu' => 'French (Luxembourg)',
    'fr-mc' => 'French (Monaco)',
    'fr-ch' => 'French (Switzerland)',
    'gl'    => 'Galician',
    'gd'    => 'Gaelic',
    'de'    => 'German',
    'de-at' => 'German (Austria)',
    'de-de' => 'German (Germany)',
    'de-li' => 'German (Liechtenstein)',
    'de-lu' => 'German (Luxembourg)',
    'el'    => 'Greek',
    'hu'    => 'Hungarian',
    'is'    => 'Icelandic',
    'in'    => 'Indonesian',
    'ga'    => 'Irish',
    'it'    => 'Italian',
    'it-it' => 'Italian (Italy)',
    'it-ch' => 'Italian (Switzerland)',
    'ja'    => 'Japanese',
    'ko'    => 'Korean',
    'mk'    => 'Macedonian',
    'no'    => 'Norwegian',
    'pl'    => 'Polish',
    'pt'    => 'Portuguese',
    'pt-br' => 'Portuguese (Brazil)',
    'pt-pt' => 'Portuguese (Portugal)',
    'ro'    => 'Romanian',
    'ro-mo' => 'Romanian (Moldova)',
    'ro-ro' => 'Romanian (Romania)',
    'ru'    => 'Russian',
    'ru-mo' => 'Russian (Moldova)',
    'ru-ru' => 'Russian (Russia)',
    'sr'    => 'Serbian',
    'sk'    => 'Slovak',
    'sl'    => 'Slovenian',
    'es'    => 'Spanish',
    'es-ar' => 'Spanish (Argentina)',
    'es-bo' => 'Spanish (Bolivia)',
    'es-cl' => 'Spanish (Chile)',
    'es-co' => 'Spanish (Colombia)',
    'es-cr' => 'Spanish (Costa Rica)',
    'es-do' => 'Spanish (Dominican Republic)',
    'es-ec' => 'Spanish (Ecuador)',
    'es-sv' => 'Spanish (El Salvador)',
    'es-gt' => 'Spanish (Guatemala)',
    'es-hn' => 'Spanish (Honduras)',
    'es-mx' => 'Spanish (Mexico)',
    'es-ni' => 'Spanish (Nicaragua)',
    'es-pa' => 'Spanish (Panama)',
    'es-py' => 'Spanish (Paraguay)',
    'es-pe' => 'Spanish (Peru)',
    'es-pr' => 'Spanish (Puerto Rico)',
    'es-es' => 'Spanish (Spain)',
    'es-uy' => 'Spanish (Uruguay)',
    'es-ve' => 'Spanish (Venezuela)',
    'sv'    => 'Swedish',
    'sv-fi' => 'Swedish (Finland)',
    'sv-se' => 'Swedish (Sweden)',
    'tr'    => 'Turkish',
    'uk'    => 'Ukranian'
		 );

# define required elements for RSS 0.9
my $_REQ_v0_9 = {
    channel => {
	"title"          => [1,40],
	"description"    => [1,500],
	"link"           => [1,500]
	},
    image => {
	"title"          => [1,40],
	"url"            => [1,500],
	"link"           => [1,500]
	},
    item => {
	"title"          => [1,100],
	"link"           => [1,500]
	},
    textinput => {
	"title"          => [1,40],
	"description"    => [1,100],
	"name"           => [1,500],
	"link"           => [1,500]
	}
};

# define required elements for RSS 0.91
my $_REQ_v0_9_1 = {
    channel => {
	"title"          => [1,100],
	"description"    => [1,500],
	"link"           => [1,500],
	"language"       => [1,5],
	"rating"         => [0,500],
	"copyright"      => [0,100],
	"pubDate"        => [0,100],
	"lastBuildDate"  => [0,100],
	"docs"           => [0,500],
	"managingEditor" => [0,100],
	"webMaster"      => [0,100],
    },
    image => {
	"title"          => [1,100],
	"url"            => [1,500],
	"link"           => [0,500],
	"width"          => [0,144],
	"height"         => [0,400],
	"description"    => [0,500]
	},
    item => {
	"title"          => [1,100],
	"link"           => [1,500],
	"description"    => [0,500]
	},
    textinput => {
	"title"          => [1,100],
	"description"    => [1,500],
	"name"           => [1,20],
	"link"           => [1,500]
	},
    skipHours => {
	"hour"           => [1,23]
	},
    skipDays => {
	"day"            => [1,10]
	}
};

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(Handlers => { Char    => \&handle_char,
					        XMLDecl => \&handle_dec,
					        Start   => \&handle_start});
    bless ($self,$class);
    $self->_initialize(@_);
    return $self;
}

sub _initialize {
    my $self = shift;
    my %hash = @_;

    # init num of items to 0
    $self->{num_items} = 0;

    # adhere to Netscape limits; no by default
    $self->{'strict'} = 0;

    # initialize items
    $self->{items} = [];

    #get version info
    (exists($hash{version}))
	? ($self->{version} = $hash{version})
	    : ($self->{version} = '0.91');

    # encoding
    (exists($hash{encoding})) 
	? ($self->{encoding} = $hash{encoding})
	    : ($self->{encoding} = 'UTF-8');

    # initialize RSS data structure
    # RSS version 0.9
    if ($self->{version} eq '0.9') {
	# Copy the hashes instead of using them directly to avoid
        # problems with multiple XML::RSS objects being used concurrently
        foreach my $i (qw(channel image textinput)) {
	    my %template=%{$v0_9_ok_fields{$i}};
	    $self->{$i} = \%template;
        }

    # RSS version 0.91
    } else {
	foreach my $i (qw(channel image textinput skipDays skipHours)) {
	    my %template=%{$v0_9_1_ok_fields{$i}};
	    $self->{$i} = \%template;
        }
    }
}

sub add_item {
    my $self = shift;
    my $hash = {@_};

    # strict Netscape Netcenter length checks
    if ($self->{'strict'}) {
	# make sure we have a title and link
	croak "title and link elements are required" 
	    unless ($hash->{title} && $hash->{'link'});
	
	# check string lengths
	croak "title cannot exceed 100 characters in length" 
	    if (length($hash->{title}) > 100);
	croak "link cannot exceed 500 characters in length" 
	    if (length($hash->{'link'}) > 500);
	croak "description cannot exceed 500 characters in length"
	    if (exists($hash->{description}) 
		&& length($hash->{description}) > 500);

	# make sure there aren't already 15 items
	croak "total items cannot exceed 15 " if (@{$self->{items}} >= 15);
    }

    # add the item to the list
    if (defined($hash->{mode}) && $hash->{mode} eq 'insert') {
	unshift (@{$self->{items}}, $hash);
    } else {
	push (@{$self->{items}}, $hash);
    }

    # return reference to the list of items
    return $self->{items};
}

sub as_string {
    my $self = shift;
    my $output;

    ##########################
    # output RSS 0.9 headers #
    ##########################
    if ($self->{version} eq '0.9') {
	# XML declaration
	$output .= '<?xml version="1.0"?>'."\n";

	# RDF root element
	$output .= '<rdf:RDF'."\n".'xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"'."\n";
	$output .= 'xmlns="http://my.netscape.com/rdf/simple/0.9/">'."\n\n";
	
    ###########################
    # output RSS 0.91 headers #
    ###########################
    } else {
	# XML declaration
	$output .= '<?xml version="1.0" encoding="'.$self->{encoding}.'"?>'."\n\n";

	# DOCTYPE
	$output .= '<!DOCTYPE rss PUBLIC "-//Netscape Communications//DTD RSS 0.91//EN"'."\n";
	$output .= '            "http://my.netscape.com/publish/formats/rss-0.91.dtd">'."\n\n"; 
	
	# RSS root element 
	$output .= '<rss version="0.91">'."\n\n";
    }

    ###################
    # Channel Element #
    ###################
    $output .= '<channel>'."\n";
    $output .= '<title>'.$self->{channel}->{title}.'</title>'."\n";
    $output .= '<link>'.$self->{channel}->{'link'}.'</link>'."\n";
    $output .= '<description>'.$self->{channel}->{description}.'</description>'."\n";

    # additional elements for RSS 0.91
    if ($self->{version} eq '0.91') {
	# language
	$output .= '<language>'.$self->{channel}->{language}.'</language>'."\n";

	# PICS rating
	$output .= '<rating>'.$self->{channel}->{rating}.'</rating>'."\n"
	    if $self->{channel}->{rating};

	# copyright
	$output .= '<copyright>'.$self->{channel}->{copyright}.'</copyright>'."\n"
	    if $self->{channel}->{copyright};

	# publication date
	$output .= '<pubDate>'.$self->{channel}->{pubDate}.'</pubDate>'."\n"
	    if $self->{channel}->{pubDate};

	# last build date
	$output .= '<lastBuildDate>'.$self->{channel}->{lastBuildDate}.'</lastBuildDate>'."\n"
	    if $self->{channel}->{lastBuildDate};

	# external CDF URL
	$output .= '<docs>'.$self->{channel}->{docs}.'</docs>'."\n"
	    if $self->{channel}->{docs};

	# managing editor
	$output .= '<managingEditor>'.$self->{channel}->{managingEditor}.'</managingEditor>'."\n"
	    if $self->{channel}->{managingEditor};

	# webmaster
	$output .= '<webMaster>'.$self->{channel}->{webMaster}.'</webMaster>'."\n"
	    if $self->{channel}->{webMaster};

	$output .= "\n";

    # end channel for RSS 0.9
    } else {
	# end channel element
	$output .= '</channel>'."\n\n";
    }

    #################
    # image element #
    #################
    if ($self->{image}->{url}) {
	$output .= '<image>'."\n";

	# title
	$output .= '<title>'.$self->{image}->{title}.'</title>'."\n";

	# url
	$output .= '<url>'.$self->{image}->{url}.'</url>'."\n";

	# link
	$output .= '<link>'.$self->{image}->{'link'}.'</link>'."\n"
	    if $self->{image}->{link};

	# additional elements for RSS 0.91
	if ($self->{version} eq '0.91') {
	    # image width
	    $output .= '<width>'.$self->{image}->{width}.'</width>'."\n"
	    if $self->{image}->{width};

	    # image height
	    $output .= '<height>'.$self->{image}->{height}.'</height>'."\n"
	    if $self->{image}->{height};

	    # description
	    $output .= '<description>'.$self->{image}->{description}.'</description>'."\n"
	    if $self->{image}->{description};
	}
	
	# end image element
	$output .= '</image>'."\n\n";
    }

    ################
    # item element #
    ################
    foreach my $item (@{$self->{items}}) {
	if ($item->{title}) {
	    $output .= '<item>'."\n";
	    $output .= '<title>'.$item->{title}.'</title>'."\n";
	    $output .= '<link>'.$item->{'link'}.'</link>'."\n";

	    # additional elements for RSS 0.91
	    if ($self->{version} eq '0.91') {
		$output .= '<description>'.$item->{description}.'</description>'."\n"
		    if $item->{description};
	    }

	    # end image element
	    $output .= '</item>'."\n\n";
	}
    }

    #####################
    # textinput element #
    #####################
    if ($self->{textinput}->{'link'}) {
	$output .= '<textinput>'."\n";
	$output .= '<title>'.$self->{textinput}->{title}.'</title>'."\n";
	$output .= '<description>'.$self->{textinput}->{description}.'</description>'."\n";
	$output .= '<name>'.$self->{textinput}->{name}.'</name>'."\n";
	$output .= '<link>'.$self->{textinput}->{'link'}.'</link>'."\n";
	$output .= '</textinput>'."\n\n";
    }

    #####################
    # skipHours element #
    #####################
    if ($self->{skipHours}->{hour}) {
	$output .= '<skipHours>'."\n";
	$output .= '<hour>'.$self->{skipHours}->{hour}.'</hour>'."\n";
	$output .= '</skipHours>'."\n\n";
    }

    ####################
    # skipDays element #
    ####################
    if ($self->{skipDays}->{day}) {
	$output .= '<skipDays>'."\n";
	$output .= '<day>'.$self->{skipDays}->{day}.'</day>'."\n";
	$output .= '</skipDays>'."\n\n";
    }

    ##############
    # end of RSS #
    ##############
    # RSS 0.9
    if ($self->{version} eq '0.9') {
	$output .= '</rdf:RDF>';
    # RSS 0.91
    } else {
	# end channel element
	$output .= '</channel>'."\n";
	$output .= '</rss>';
    }

    return $output;
}

sub handle_char {
    my ($self,$cdata) = (@_);
    #return unless $cdata =~ /\S+/;
	# image element
    if ($self->within_element("image")) {
	$self->{image}->{$self->current_element} .= $cdata;

	# item element
    } elsif ($self->within_element("item")) {
	$self->{'items'}->[$self->{num_items}-1]->{$self->current_element} .= $cdata;

	# textinput element
    } elsif ($self->within_element("textinput")) {
	$self->{'textinput'}->{$self->current_element} .= $cdata;

	# skipHours element
    } elsif ($self->within_element("skipHours")) {
	$self->{'skipHours'}->{$self->current_element} .= $cdata;

	# skipDays element
    } elsif ($self->within_element("skipDays")) {
	$self->{'skipDays'}->{$self->current_element} .= $cdata;

	# channel element
    } elsif ($self->within_element("channel")) {
	$self->{channel}->{$self->current_element} .= $cdata;
    }
}

sub handle_dec {
    my ($self,$version,$encoding,$standalone) = (@_);
    $self->{encoding} = $encoding;
    #print "ENCODING: $encoding\n";
}

sub handle_start {
    my $self = shift;
    my $el   = shift;
    my %attribs = @_;
   
    # beginning of RSS 0.91 
    if ($el eq 'rss') {
	#print "VERSION: $attribs{version}\n";
	$self->{version} = $attribs{version} if exists($attribs{version});

    # beginning of RSS 0.9
    } elsif ($el eq 'rdf:RDF') {
	#print "VERSION: 0.9\n";
	$self->{version} = '0.9';

    # beginning of item element
    } elsif ($el eq 'item') {
        # increment item count
	$self->{num_items}++;
    }
}

sub parse { 
    my $self = shift;
    $self->SUPER::parse(shift);
}

sub parsefile {
    my $self = shift;
    $self->SUPER::parsefile(shift);
}

sub save {
    my ($self,$file) = @_;
    open(OUT,">$file") || croak "Cannot open file $file for write: $!";
    print OUT $self->as_string;
    close OUT;
}

sub strict {
    my ($self,$value) = @_;
    $self->{'strict'} = $value;
}

sub AUTOLOAD {
    my $self = shift;
    my $type = ref($self) || croak "$self is not an object\n";
    my $name = $AUTOLOAD;
    $name =~ s/.*://;
    
    croak "Unregistered entity: Can't access $name field in object of class $type"
	unless (exists $self->{$name});

    # return reference to RSS structure
    if (@_ == 1) {
	return $self->{$name}->{$_[0]} if defined $self->{$name}->{$_[0]};
	
    # we're going to set values here
    } elsif (@_ > 1) {
	my %hash = @_;
	my $_REQ;

	# make sure we have required elements and correct lengths
	if ($self->{'strict'}) {
	    ($self->{version} eq '0.9')
		? ($_REQ = $_REQ_v0_9)
		    : ($_REQ = $_REQ_v0_9_1);
	}
	    
	# store data in object
	foreach my $key (keys(%hash)) {
	    if ($self->{'strict'}) {
		my $req_element = $_REQ->{$name}->{$key};
		confess "$key cannot exceed " . $req_element->[1] . " characters in length"
		    if defined $req_element->[1] && length($hash{$key}) > $req_element->[1];
	    }
	    $self->{$name}->{$key} = $hash{$key};
	}
       
	# return value
	return $self->{$name};
	
    # otherwise, just return a reference to the whole thing
    } else {
	return $self->{$name};
    }
    return 0;

    # make sure we have all required elements
	#foreach my $key (keys(%{$_REQ->{$name}})) {
	    #my $element = $_REQ->{$name}->{$key};
	    #croak "$key is required in $name" 
		#if ($element->[0] == 1) && (!defined($hash{$key}));
	    #croak "$key cannot exceed ".$element->[1]." characters in length"
		#unless length($hash{$key}) <= $element->[1];
	#}
}


1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

XML::RSS - creates and updates RSS files

=head1 SYNOPSIS

 # create an RSS 0.91 file
 use XML::RSS;
 $rss->channel(title          => 'freshmeat.net',
               link           => 'http://freshmeat.net',
               language       => 'en', 
               description    => 'the one-stop-shop for all your Linux software needs',
               rating         => '(PICS-1.1 "http://www.classify.org/safesurf/" 1 r (SS~~000 1))',
               copyright      => 'Copyright 1999, Freshmeat.net',
               pubDate        => 'Thu, 23 Aug 1999 07:00:00 GMT',
               lastBuildDate  => 'Thu, 23 Aug 1999 16:20:26 GMT',
               docs           => 'http://www.blahblah.org/fm.cdf',
               managingEditor => 'scoop@freshmeat.net',
               webMaster      => 'scoop@freshmeat.net'
               );

 $rss->image(title       => 'freshmeat.net',
             url         => 'http://freshmeat.net/images/fm.mini.jpg',
             link        => 'http://freshmeat.net',
             width       => 88,
             height      => 31,
             description => 'This is the Freshmeat image stupid'
             );

 $rss->add_item(title => "GTKeyboard 0.85",
                link  => "http://freshmeat.net/news/1999/06/21/930003829.html",
		description => 'blah blah'
                );

 $rss->skipHours(hour => 2);
 $rss->skipDays(day => 1);

 $rss->textinput(title => "quick finder",
                 description => "Use the text input below to search freshmeat",
                 name  => "query",
                 link  => "http://core.freshmeat.net/search.php3"
                 );

 # create an RSS 0.9 file
 use XML::RSS;
 $rss->channel(title => "freshmeat.net",
               link  => "http://freshmeat.net",
               description => "the one-stop-shop for all your Linux software needs",
               );

 $rss->image(title => "freshmeat.net",
             url   => "http://freshmeat.net/images/fm.mini.jpg",
             link  => "http://freshmeat.net"
             );

 $rss->add_item(title => "GTKeyboard 0.85",
                link  => "http://freshmeat.net/news/1999/06/21/930003829.html"
                );

 $rss->textinput(title => "quick finder",
                 description => "Use the text input below to search freshmeat",
                 name  => "query",
                 link  => "http://core.freshmeat.net/search.php3"
                 );

 # print the RSS as a string
 print $rss->as_string;

 # or save it to a file
 $rss->save("fm.rdf");

 # insert an item into an RSS file and removes the oldest item if
 # there are already 15 items
 my $rss = new XML::RSS;
 $rss->parsefile("fm.rdf");
 pop(@{$rss->{'items'}}) if (@{$rss->{'items'}} == 15);
 $rss->add_item(title => "MpegTV Player (mtv) 1.0.9.7",
                link  => "http://freshmeat.net/news/1999/06/21/930003958.html",
                mode  => 'insert'
                );

 # parse a string instead of a file
 $rss->parse($string);

 # print the title and link of each RSS item
 foreach my $item (@{$rss->{'items'}}) {
     print "title: $item->{'title'}\n";
     print "link: $item->{'link'}\n\n";
 }

=head1 DESCRIPTION

This module provides a basic framework for creating and maintaining 
RDF Site Summary (RSS) files. This distribution also contains several 
examples that allow you to generate HTML from an RSS file. 
This might be helpful if you want to include news feeds on your Web 
site from sources like Slashot and Freshmeat.

XML::RSS currently supports both version 0.9 and 0.91 of RSS.
See http://my.netscape.com/publish/help/mnn20/quickstart.html
for information on RSS 0.91. See http://my.netscape.com/publish/help/
for RSS 0.9.

RSS is primarily used by content authors who want to create a 
Netscape Netcenter channel, however, that doesn't exclude us from using it
in other applications.
For example, you may want to distribute daily news headlines to partners and 
customers who convert it to some other format, like HTML.

=head1 METHODS

=over 4

=item new XML::RSS (version=>$version, encoding=>$encoding)

Constructor for XML::RSS. It returns a reference to an XML::RSS object.
You may also pass the RSS version and the XML encoding to use. The default
B<version> is 0.91. The default B<encoding> is UTF-8.

=item add_item (title=>$title, link=>$link, description=>$desc, mode=>$mode)

Adds an item to the XML::RSS object. B<mode> and B<description> are optional. 
The default B<mode> 
is append, which adds the item to the end of the list. To insert an item, set the mode
to B<insert>. 

The items are stored in the array @{$obj->{'items'}} where
B<$obj> is a reference to an XML::RSS object.

=item as_string;

Returns a string containing the RSS for the XML::RSS object. 

=item channel (title=>$title, link=>$link, description=>$desc,
language=>$language, rating=>$rating, copyright=>$copyright,
pubDate=>$pubDate, lastBuildDate=>$lastBuild, docs=>$docs,
managingEditor=>$editor, webMaster=>$webMaster)


Channel information is required in RSS. The B<title> cannot
be more the 40 characters, the B<link> 500, and the B<description>
500. B<title>, B<link>, B<description>, and B<language> are required.
The other parameters are optional.

To retreive the values of the channel, pass the name of the value
(title, link, or description) as the first and only argument
like so:

$title = channel('title');

=item image (title=>$title, url=>$url, link=>$link, width=>$width,
height=>$height, description=>$desc)

Adding an image is not required. B<url> is the URL of the
image, B<link> is the URL the image is linked to. B<title>, B<url>,
and B<link> parameters are required if you are going to
use an image in your RSS file.

The method for retrieving the values for the image is the same as it
is for B<channel()>.

=item parse ($string)

Parses an RDF Site Summary which is passed into B<parse()> as the first parameter.

=item parsefile ($file)

Same as B<parse()> except it parses a file rather than a string.

=item save ($file)

Saves the RSS to a specified file.

=item skipHours (hour=>$hour)

Specifies the number of hours that a server should wait before retrieving
the RSS file. The B<hour> parameter is required if the skipHours method
is used.

=item skipDays (day=>$day)

Specified the number of days that a server should wait before retrieving
the RSS file. The B<day> parameter is required if the skipDays method
is used.

=item strict ($boolean)

If it's set to 1, it will adhere to the lengths as specified
by Netscape Netcenter requirements. It's set to 0 by default.
Use it if the RSS file you're generating is for Netcenter.

=item textinput (title=>$title, description=>$desc, name=>$name, link=>$link);

This RSS element is also optional. Using it allows users to submit a Query
to a program on a Web server via an HTML form. B<name> is the HTML form name
and B<link> is the URL to the program. Content is submitted using the GET
method.

Access to the B<textinput> values is the the same as B<channel()> and 
B<image()>.

=head1 AUTHOR

Jonathan Eisenzopf <eisen@pobox.com>

=head1 CREDITS

 Wojciech Zwiefka <wojtekz@cnt.pl>
 Chris Nandor <pudge@pobox.com>
 Jim Hebert <jim@cosource.com>
 Randal Schwartz <merlyn@stonehenge.com>
 rjp@browser.org

=head1 SEE ALSO

perl(1), XML::Parser(3).

=cut
