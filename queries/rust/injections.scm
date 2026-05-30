;extends

(
 [
	(raw_string_literal
		(string_content) @injection.content)

	(string_literal
		(string_content) @injection.content)
	]

 (#match? @injection.content "^(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP|WITH|PRAGMA)\\s")
 (#set! injection.language "sql")
 )
