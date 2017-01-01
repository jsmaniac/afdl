#lang racket
;(require (only-in scribble/base));scribble-enhanced/with-manual)

;(provide aful-scribble-render)

#;(define (aful-scribble-render self)
    (syntax-case self ()
      [(_ _ _ body)
       #`(elem (list (seclink "_lang_aful" #:doc '(lib "aful/docs/aful.scrbl")
                              (tt "#λ"))
                     (racket body)))]))