; extends

;; Inject Go into raw HTML text between <| and |>
((document) @injection.content
 (#match? @injection.content "<\\|[^\\|]*\\|>")
 (#set! injection.language "go")
 (#set! injection.include-children true))
