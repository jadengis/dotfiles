; extends

; import/export statements -> TypeScript
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "typescript"))

((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "tsx"))

; inline JSX element starting a line -> TSX
((inline) @injection.content
  (#lua-match? @injection.content "^<")
  (#set! injection.language "tsx"))

; multi-line JSX body parsed as an indented code block -> TSX
((indented_code_block) @injection.content
  (#lua-match? @injection.content "^%s*<")
  (#set! injection.language "tsx")
  (#set! injection.include-children))

; JSX block elements -> TSX
((html_block) @injection.content
  (#set! injection.language "tsx")
  (#set! injection.include-children))
