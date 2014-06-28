parser grammar CiscoGrammar_acl;

import CiscoGrammarCommonParser;

options {
	tokenVocab = CiscoGrammarCommonLexer;
}

access_list_stanza
:
	standard_access_list_stanza
	| extended_access_list_stanza
;

access_list_ip_range
:
	(
		ip = IP_ADDRESS wildcard = IP_ADDRESS
	)
	| ANY
	| HOST ip = IP_ADDRESS
;

extended_access_list_null_tail
:
	(
		(
			access_list_action protocol access_list_ip_range port_specifier?
			access_list_ip_range port_specifier? REFLECT
		)
		| DYNAMIC
		| EVALUATE
		| REMARK
	) ~NEWLINE* NEWLINE
;

extended_access_list_stanza
:
	(
		ACCESS_LIST firstnum = ACL_NUM_EXTENDED
		(
			extended_access_list_tail
			| extended_access_list_null_tail
		)
		(
			ACCESS_LIST num = ACL_NUM_EXTENDED
			{$firstnum.text.equals($num.text)}?

			(
				extended_access_list_tail
				| extended_access_list_null_tail
			)
		)*
	)
	| ip_access_list_extended_stanza
;

extended_access_list_tail
:
	ala = access_list_action prot = protocol srcipr =
	access_list_ip_range
	(
		alps_src = port_specifier
	)? dstipr = access_list_ip_range
	(
		alps_dst = port_specifier
	)?
	(
		ECHO_REPLY
		| ECHO
		| ESTABLISHED
		| FRAGMENTS
		| LOG
		| LOG_INPUT
		| PACKET_TOO_BIG
		| PORT_UNREACHABLE
		| REDIRECT
		| TIME_EXCEEDED
		| TTL_EXCEEDED
		| UNREACHABLE
	)? NEWLINE
;

ip_access_list_extended_stanza
:
	IP ACCESS_LIST EXTENDED
	(
		name = VARIABLE
		| name = ACL_NUM_EXTENDED
	) NEWLINE
	(
		extended_access_list_tail
		| extended_access_list_null_tail
	)*
;

ip_access_list_standard_stanza
:
	IP ACCESS_LIST STANDARD
	(
		name = VARIABLE
		| name = ACL_NUM_STANDARD
	) NEWLINE
	(
		(
			standard_access_list_tail
			| standard_access_list_null_tail
		)+
		| closing_comment
	)
;

ip_as_path_access_list_stanza
:
	IP AS_PATH ACCESS_LIST name = DEC action = access_list_action
	(
		remainder += ~NEWLINE
	)+ NEWLINE
;

ip_community_list_expanded_stanza
:
	(
		(
			EXPANDED name = VARIABLE
		)
		| name = COMMUNITY_LIST_NUM_EXPANDED
	) ala = access_list_action
	(
		remainder += ~NEWLINE
	)+ NEWLINE
;

ip_community_list_standard_stanza
:
	(
		(
			STANDARD name = VARIABLE
		)
		| name = COMMUNITY_LIST_NUM_STANDARD
	) ala = access_list_action
	(
		communities += community
	)+ NEWLINE
;

ip_community_list_stanza
:
	IP COMMUNITY_LIST
	(
		ip_community_list_expanded_stanza
		| ip_community_list_standard_stanza
	)
;

ip_prefix_list_line_stanza
:
	IP PREFIX_LIST name = VARIABLE
	(
		SEQ DEC
	)? action = access_list_action prefix = IP_ADDRESS FORWARD_SLASH prefix_length
	= integer
	(
		(
			GE minpl = integer
		)
		|
		(
			LE maxpl = integer
		)
	)?
;

standard_access_list_null_tail
:
	REMARK ~NEWLINE* NEWLINE
;

standard_access_list_stanza
:
	(
		ACCESS_LIST firstnum = ACL_NUM_STANDARD
		(
			standard_access_list_tail
			| standard_access_list_null_tail
		)
		(
			ACCESS_LIST num = ACL_NUM_STANDARD
			{$firstnum.text.equals($num.text)}?

			(
				standard_access_list_tail
				| standard_access_list_null_tail
			)
		)*
	)
	| ip_access_list_standard_stanza
;

standard_access_list_tail
:
	ala = access_list_action ipr = access_list_ip_range LOG? NEWLINE
;

