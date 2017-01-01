#lang racket
(provide aful-scribble-render)

(define (aful-scribble-render self)
  (syntax-case self ()
    [(_ _ _ body)
     #`(let ()
         (local-require scribble-enhanced/with-manual)
         (elem (list (seclink "_lang_aful" #:doc '(lib "aful/docs/aful.scrbl")
                              (tt "#λ"))
                     (racket body))))]))