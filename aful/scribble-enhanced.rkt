#lang racket
(provide aful-scribble-render)

(require phc-toolkit/stx)

(define (aful-scribble-render self id code typeset-code uncode d->s stx-prop)
  (syntax-case self ()
    [(_ _ _ body)
     ; #λ(body) reads as:
     ; (lambda args
     ;   (define-syntax % (make-rename-transformer #'%1))
     ;   body)
     (with-syntax ([uncode (datum->syntax uncode (syntax-e uncode) self)])
       (syntax/top-loc self
         ((uncode(let ()
                   (local-require scribble-enhanced/with-manual)
                   (seclink "_lang_aful"
                            #:doc '(lib "aful/docs/aful.scrbl")
                            (tt "#λ"))))
          body)))]))