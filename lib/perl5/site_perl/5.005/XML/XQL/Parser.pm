#########################################################################
#
#      This file was generated using Parse::Yapp version 0.16.
#
#          Don't edit this file, use source file instead.
#
#               ANY CHANGE MADE HERE WILL BE LOST !
#
#########################################################################
package XML::XQL::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '0.16',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildQName' => 18,
			'WildNCName' => 17,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 5,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 25,
			'Query' => 26,
			'Intersection' => 14,
			'Bang' => 29,
			'Sequence' => 30,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 1
		ACTIONS => {
			"[" => 35
		},
		DEFAULT => -51,
		GOTOS => {
			'Subscript_2' => 36
		}
	},
	{#State 2
		DEFAULT => -43
	},
	{#State 3
		ACTIONS => {
			'MATCH' => 39,
			'COMPARE' => 38
		},
		GOTOS => {
			'ComparisonOp' => 37
		}
	},
	{#State 4
		ACTIONS => {
			"or" => 40
		},
		DEFAULT => -21
	},
	{#State 5
		ACTIONS => {
			'SeqOp' => 41
		},
		DEFAULT => -19
	},
	{#State 6
		DEFAULT => -66
	},
	{#State 7
		DEFAULT => -59
	},
	{#State 8
		DEFAULT => -42
	},
	{#State 9
		ACTIONS => {
			'COMPARE' => -37,
			'MATCH' => -37
		},
		DEFAULT => -33
	},
	{#State 10
		ACTIONS => {
			"*" => 28,
			'NCName' => 24
		},
		GOTOS => {
			'WildQName' => 42,
			'WildNCName' => 17
		}
	},
	{#State 11
		DEFAULT => -62
	},
	{#State 12
		DEFAULT => -67
	},
	{#State 13
		ACTIONS => {
			"*" => 28,
			'NCName' => 24,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"(" => 27,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 2,
			'LValue' => 43,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 44,
			'Subscript' => 34
		}
	},
	{#State 14
		ACTIONS => {
			'UnionOp' => 45
		},
		DEFAULT => -27
	},
	{#State 15
		ACTIONS => {
			'XQLName_Paren' => -17,
			"\@" => -17,
			'NCName' => -17,
			"(" => -17,
			"*" => -17,
			"." => -17
		},
		DEFAULT => -44
	},
	{#State 16
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 46,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 17
		ACTIONS => {
			":" => 47
		},
		DEFAULT => -4
	},
	{#State 18
		DEFAULT => -10
	},
	{#State 19
		ACTIONS => {
			"*" => 28,
			'NCName' => 24,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"(" => 27,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 2,
			'LValue' => 48,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 44,
			'Subscript' => 34
		}
	},
	{#State 20
		DEFAULT => -25
	},
	{#State 21
		ACTIONS => {
			'NCName' => 24,
			'TEXT' => 49,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			")" => 53,
			"*" => 28,
			'NUMBER' => 50,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			'INTEGER' => 52,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 51,
			'Invocation_2' => 54,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'Param' => 55,
			'RelativeTerm' => 11,
			'Negation' => 25,
			'AttributeName' => 12,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 22
		DEFAULT => -18
	},
	{#State 23
		ACTIONS => {
			"*" => 28,
			'NCName' => 24,
			'XQLName_Paren' => 21,
			"." => 33,
			"(" => 27,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 56,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'Subscript' => 34
		}
	},
	{#State 24
		DEFAULT => -2
	},
	{#State 25
		ACTIONS => {
			"and" => 57
		},
		DEFAULT => -23
	},
	{#State 26
		ACTIONS => {
			'' => 58
		}
	},
	{#State 27
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 5,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 25,
			'Query' => 59,
			'Intersection' => 14,
			'Bang' => 29,
			'Sequence' => 30,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 28
		DEFAULT => -3
	},
	{#State 29
		ACTIONS => {
			"//" => 22,
			"/" => 60
		},
		DEFAULT => -46,
		GOTOS => {
			'PathOp' => 61
		}
	},
	{#State 30
		DEFAULT => -1
	},
	{#State 31
		DEFAULT => -65
	},
	{#State 32
		ACTIONS => {
			"intersect" => 62
		},
		DEFAULT => -29
	},
	{#State 33
		DEFAULT => -64
	},
	{#State 34
		ACTIONS => {
			"!" => 63
		},
		DEFAULT => -48
	},
	{#State 35
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			'INTEGER' => 64,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'Subquery' => 66,
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 5,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Range' => 67,
			'Path' => 9,
			'IndexArg' => 68,
			'RelativeTerm' => 11,
			'IndexList' => 65,
			'AttributeName' => 12,
			'Negation' => 25,
			'Query' => 69,
			'Intersection' => 14,
			'Bang' => 29,
			'Sequence' => 30,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 36
		DEFAULT => -50
	},
	{#State 37
		ACTIONS => {
			'NCName' => 24,
			'TEXT' => 70,
			"(" => 27,
			"*" => 28,
			'NUMBER' => 71,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			'INTEGER' => 73,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 2,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 72,
			'Subscript' => 34,
			'RValue' => 74
		}
	},
	{#State 38
		DEFAULT => -31
	},
	{#State 39
		DEFAULT => -32
	},
	{#State 40
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 75,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 25,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 41
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 5,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 25,
			'Intersection' => 14,
			'Bang' => 29,
			'Sequence' => 76,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 42
		DEFAULT => -11
	},
	{#State 43
		ACTIONS => {
			'MATCH' => 39,
			'COMPARE' => 38
		},
		GOTOS => {
			'ComparisonOp' => 77
		}
	},
	{#State 44
		DEFAULT => -37
	},
	{#State 45
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 78,
			'RelativePath' => 2,
			'LValue' => 3,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 46
		DEFAULT => -26
	},
	{#State 47
		ACTIONS => {
			"*" => 28,
			'NCName' => 24
		},
		GOTOS => {
			'WildNCName' => 79
		}
	},
	{#State 48
		ACTIONS => {
			'MATCH' => 39,
			'COMPARE' => 38
		},
		GOTOS => {
			'ComparisonOp' => 80
		}
	},
	{#State 49
		DEFAULT => -9
	},
	{#State 50
		DEFAULT => -8
	},
	{#State 51
		DEFAULT => -6
	},
	{#State 52
		DEFAULT => -7
	},
	{#State 53
		DEFAULT => -13
	},
	{#State 54
		DEFAULT => -12
	},
	{#State 55
		ACTIONS => {
			"," => 82
		},
		DEFAULT => -15,
		GOTOS => {
			'Invocation_3' => 81
		}
	},
	{#State 56
		DEFAULT => -45
	},
	{#State 57
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 83,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Negation' => 25,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 58
		DEFAULT => -0
	},
	{#State 59
		ACTIONS => {
			")" => 84
		}
	},
	{#State 60
		DEFAULT => -17
	},
	{#State 61
		ACTIONS => {
			"*" => 28,
			'NCName' => 24,
			'XQLName_Paren' => 21,
			"." => 33,
			"(" => 27,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 85,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'Subscript' => 34
		}
	},
	{#State 62
		ACTIONS => {
			'NCName' => 24,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'RelativePath' => 2,
			'LValue' => 3,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Intersection' => 86,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 63
		ACTIONS => {
			'XQLName_Paren' => 21
		},
		GOTOS => {
			'Invocation' => 87
		}
	},
	{#State 64
		ACTIONS => {
			"to" => 88
		},
		DEFAULT => -56
	},
	{#State 65
		ACTIONS => {
			"]" => 89
		}
	},
	{#State 66
		ACTIONS => {
			"]" => 90
		}
	},
	{#State 67
		DEFAULT => -57
	},
	{#State 68
		ACTIONS => {
			"," => 92
		},
		DEFAULT => -54,
		GOTOS => {
			'IndexList_2' => 91
		}
	},
	{#State 69
		DEFAULT => -61
	},
	{#State 70
		DEFAULT => -41
	},
	{#State 71
		DEFAULT => -40
	},
	{#State 72
		DEFAULT => -38
	},
	{#State 73
		DEFAULT => -39
	},
	{#State 74
		DEFAULT => -34
	},
	{#State 75
		DEFAULT => -22
	},
	{#State 76
		DEFAULT => -20
	},
	{#State 77
		ACTIONS => {
			'NCName' => 24,
			'TEXT' => 70,
			"(" => 27,
			"*" => 28,
			'NUMBER' => 71,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			'INTEGER' => 73,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 2,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 72,
			'Subscript' => 34,
			'RValue' => 93
		}
	},
	{#State 78
		DEFAULT => -28
	},
	{#State 79
		DEFAULT => -5
	},
	{#State 80
		ACTIONS => {
			'NCName' => 24,
			'TEXT' => 70,
			"(" => 27,
			"*" => 28,
			'NUMBER' => 71,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			'INTEGER' => 73,
			"\@" => 10
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'RelativeTerm' => 11,
			'AttributeName' => 12,
			'Filter' => 1,
			'Bang' => 29,
			'RelativePath' => 2,
			'Invocation' => 31,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 72,
			'Subscript' => 34,
			'RValue' => 94
		}
	},
	{#State 81
		ACTIONS => {
			")" => 95
		}
	},
	{#State 82
		ACTIONS => {
			'NCName' => 24,
			'TEXT' => 49,
			"(" => 27,
			"any" => 13,
			"all" => 19,
			"*" => 28,
			'NUMBER' => 50,
			'XQLName_Paren' => 21,
			"." => 33,
			"//" => 22,
			"/" => 15,
			"\@" => 10,
			'INTEGER' => 52,
			"not" => 16
		},
		GOTOS => {
			'WildNCName' => 17,
			'WildQName' => 18,
			'Filter' => 1,
			'Union' => 20,
			'RelativePath' => 2,
			'LValue' => 3,
			'Conjunction' => 4,
			'Disjunction' => 51,
			'ElementName' => 6,
			'Grouping' => 7,
			'PathOp' => 23,
			'AbsolutePath' => 8,
			'Path' => 9,
			'Param' => 96,
			'RelativeTerm' => 11,
			'Negation' => 25,
			'AttributeName' => 12,
			'Intersection' => 14,
			'Bang' => 29,
			'Invocation' => 31,
			'Comparison' => 32,
			'Subscript' => 34
		}
	},
	{#State 83
		DEFAULT => -24
	},
	{#State 84
		DEFAULT => -63
	},
	{#State 85
		DEFAULT => -47
	},
	{#State 86
		DEFAULT => -30
	},
	{#State 87
		DEFAULT => -49
	},
	{#State 88
		ACTIONS => {
			'INTEGER' => 97
		}
	},
	{#State 89
		DEFAULT => -52
	},
	{#State 90
		DEFAULT => -60
	},
	{#State 91
		DEFAULT => -53
	},
	{#State 92
		ACTIONS => {
			'INTEGER' => 64
		},
		GOTOS => {
			'IndexArg' => 98,
			'Range' => 67
		}
	},
	{#State 93
		DEFAULT => -35
	},
	{#State 94
		DEFAULT => -36
	},
	{#State 95
		DEFAULT => -14
	},
	{#State 96
		ACTIONS => {
			"," => 82
		},
		DEFAULT => -15,
		GOTOS => {
			'Invocation_3' => 99
		}
	},
	{#State 97
		DEFAULT => -58
	},
	{#State 98
		ACTIONS => {
			"," => 92
		},
		DEFAULT => -54,
		GOTOS => {
			'IndexList_2' => 100
		}
	},
	{#State 99
		DEFAULT => -16
	},
	{#State 100
		DEFAULT => -55
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'Query', 1, undef
	],
	[#Rule 2
		 'WildNCName', 1, undef
	],
	[#Rule 3
		 'WildNCName', 1, undef
	],
	[#Rule 4
		 'WildQName', 1,
sub {
 [ Name => $_[1] ]; 
}
	],
	[#Rule 5
		 'WildQName', 3,
sub {
 
			[ NameSpace => $_[1], Name => $_[2]]; 
}
	],
	[#Rule 6
		 'Param', 1, undef
	],
	[#Rule 7
		 'Param', 1,
sub {
 new XML::XQL::Number ($_[1]); 
}
	],
	[#Rule 8
		 'Param', 1,
sub {
 new XML::XQL::Number ($_[1]); 
}
	],
	[#Rule 9
		 'Param', 1,
sub {
 new XML::XQL::Text ($_[1]); 
}
	],
	[#Rule 10
		 'ElementName', 1,
sub {
 new XML::XQL::Element (@{$_[1]}); 
}
	],
	[#Rule 11
		 'AttributeName', 2,
sub {
 new XML::XQL::Attribute (@{$_[2]}); 
}
	],
	[#Rule 12
		 'Invocation', 2,
sub {

			my ($func, $type) = $_[0]->{Query}->findFunctionOrMethod ($_[1], $_[2]);

			new XML::XQL::Invocation (Name => $_[1], 
						  Args => $_[2],
						  Func => $func,
						  Type => $type); 
}
	],
	[#Rule 13
		 'Invocation_2', 1,
sub {
 [] 
}
	],
	[#Rule 14
		 'Invocation_2', 3,
sub {
 unshift @{$_[2]}, $_[1]; $_[2]; 
}
	],
	[#Rule 15
		 'Invocation_3', 0,
sub {
 [] 
}
	],
	[#Rule 16
		 'Invocation_3', 3,
sub {
 unshift @{$_[3]}, $_[2]; $_[3]; 
}
	],
	[#Rule 17
		 'PathOp', 1, undef
	],
	[#Rule 18
		 'PathOp', 1, undef
	],
	[#Rule 19
		 'Sequence', 1, undef
	],
	[#Rule 20
		 'Sequence', 3,
sub {

		    new XML::XQL::Sequence (Left => $_[1], Oper => $_[2], 
					    Right => $_[3]); 
}
	],
	[#Rule 21
		 'Disjunction', 1, undef
	],
	[#Rule 22
		 'Disjunction', 3,
sub {
 
		    new XML::XQL::Or (Left => $_[1], Right => $_[3]); 
}
	],
	[#Rule 23
		 'Conjunction', 1, undef
	],
	[#Rule 24
		 'Conjunction', 3,
sub {
 
		    new XML::XQL::And (Left => $_[1], Right => $_[3]); 
}
	],
	[#Rule 25
		 'Negation', 1, undef
	],
	[#Rule 26
		 'Negation', 2,
sub {
 new XML::XQL::Not (Left => $_[2]); 
}
	],
	[#Rule 27
		 'Union', 1, undef
	],
	[#Rule 28
		 'Union', 3,
sub {
 
		    new XML::XQL::Union (Left => $_[1], Right => $_[3]); 
}
	],
	[#Rule 29
		 'Intersection', 1, undef
	],
	[#Rule 30
		 'Intersection', 3,
sub {
 
		    new XML::XQL::Intersect ($_[1], $_[3]); 
}
	],
	[#Rule 31
		 'ComparisonOp', 1,
sub {

		  [ $_[1], $_[0]->{Query}->findComparisonOperator ($_[1]) ]; 
}
	],
	[#Rule 32
		 'ComparisonOp', 1,
sub {

		  [ $_[1], $_[0]->{Query}->findComparisonOperator ($_[1]) ]; 
}
	],
	[#Rule 33
		 'Comparison', 1, undef
	],
	[#Rule 34
		 'Comparison', 3,
sub {

			new XML::XQL::Compare (All => 0, Left => $_[1], 
				Oper => $_[2]->[0], Func => $_[2]->[1], 
				Right => $_[3]); 
}
	],
	[#Rule 35
		 'Comparison', 4,
sub {

			new XML::XQL::Compare (All => 0, Left => $_[2], 
				Oper => $_[3]->[0], Func => $_[3]->[0],
				Right => $_[4]); 
}
	],
	[#Rule 36
		 'Comparison', 4,
sub {

			new XML::XQL::Compare (All => 1, Left => $_[2], 
				Oper => $_[3]->[0], Func => $_[3]->[0],
				Right => $_[4]); 
}
	],
	[#Rule 37
		 'LValue', 1, undef
	],
	[#Rule 38
		 'RValue', 1, undef
	],
	[#Rule 39
		 'RValue', 1,
sub {
 new XML::XQL::Number ($_[1]); 
}
	],
	[#Rule 40
		 'RValue', 1,
sub {
 new XML::XQL::Number ($_[1]); 
}
	],
	[#Rule 41
		 'RValue', 1,
sub {
 new XML::XQL::Text ($_[1]); 
}
	],
	[#Rule 42
		 'Path', 1, undef
	],
	[#Rule 43
		 'Path', 1, undef
	],
	[#Rule 44
		 'AbsolutePath', 1,
sub {
 new XML::Root; 
}
	],
	[#Rule 45
		 'AbsolutePath', 2,
sub {
 
		    new XML::XQL::Path (PathOp => $_[1], Right => $_[2]); 
}
	],
	[#Rule 46
		 'RelativePath', 1, undef
	],
	[#Rule 47
		 'RelativePath', 3,
sub {
 
		    new XML::XQL::Path (Left => $_[1], PathOp => $_[2], 
				        Right => $_[3]); 
}
	],
	[#Rule 48
		 'Bang', 1, undef
	],
	[#Rule 49
		 'Bang', 3,
sub {

		    XML::XQL::parseError ("only methods (not functions) can be used after the Bang (near '!" . $_[3]->{Name} . "'")
			unless $_[3]->isMethod;

		    new XML::XQL::Bang (Left => $_[1], 
				        Right => $_[3]); 
}
	],
	[#Rule 50
		 'Subscript', 2,
sub {
 
		    defined($_[2]) ? 
			new XML::XQL::Subscript (Left => $_[1], 
					    IndexList => $_[2]) : $_[1]; 
}
	],
	[#Rule 51
		 'Subscript_2', 0, undef
	],
	[#Rule 52
		 'Subscript_2', 3,
sub {
 $_[2]; 
}
	],
	[#Rule 53
		 'IndexList', 2,
sub {
 push (@{$_[1]}, @{$_[2]}); $_[1]; 
}
	],
	[#Rule 54
		 'IndexList_2', 0,
sub {
 [] 
}
	],
	[#Rule 55
		 'IndexList_2', 3,
sub {
 push (@{$_[2]}, @{$_[3]}); $_[2]; 
}
	],
	[#Rule 56
		 'IndexArg', 1,
sub {
 [ $_[1], $_[1] ]; 
}
	],
	[#Rule 57
		 'IndexArg', 1, undef
	],
	[#Rule 58
		 'Range', 3,
sub {

		    # Syntactic Constraint 9:
		    # If both integers are positive or if both integers are 
		    # negative, the first integer must be less than or
          	    # equal to the second integer. 

		    XML::XQL::parseError (
			"$_[1] should be less than $_[3] in '$_[1] $_[2] $_[3]'")
				if ($_[1] > $_[3] && ($_[1] < 0) == ($_[3] < 0));
		    [ $_[1], $_[3] ]; 
}
	],
	[#Rule 59
		 'Filter', 1, undef
	],
	[#Rule 60
		 'Filter', 4,
sub {
 
			new XML::XQL::Filter (Left => $_[1], Right => $_[3]); 
}
	],
	[#Rule 61
		 'Subquery', 1, undef
	],
	[#Rule 62
		 'Grouping', 1, undef
	],
	[#Rule 63
		 'Grouping', 3,
sub {
 $_[2]; 
}
	],
	[#Rule 64
		 'RelativeTerm', 1,
sub {
 new XML::XQL::Current; 
}
	],
	[#Rule 65
		 'RelativeTerm', 1, undef
	],
	[#Rule 66
		 'RelativeTerm', 1, undef
	],
	[#Rule 67
		 'RelativeTerm', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}



1;
