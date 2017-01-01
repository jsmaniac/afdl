#lang racket

;; Copied and adjusted from
;; https://github.com/AlexKnauth/hygienic-reader-extension
;;   /blob/master/hygienic-reader-extension/extend-reader.rkt

(provide extend-reader-unhygienic)

;; extend-reader : (-> (-> A ... Any)
;;                     (-> Readtable #:outer-scope (-> Syntax Syntax) Readtable)
;;                     (-> A ... Any))
(define (extend-reader-unhygienic proc extend-readtable #:hygiene? [hygiene? #t])
  (lambda args
    (define orig-readtable (current-readtable))
    (define outer-scope (make-syntax-introducer/use-site))
    (parameterize ([current-readtable (extend-readtable orig-readtable #:outer-scope outer-scope)])
      (define stx (apply proc args))
      (if (and (syntax? stx) hygiene?)
          (outer-scope stx)
          stx))))

;; make-syntax-introducer/use-site : (-> (-> Syntax Syntax))
(define (make-syntax-introducer/use-site)
  (cond [(procedure-arity-includes? make-syntax-introducer 1)
         (make-syntax-introducer #t)]
        [else
         (make-syntax-introducer)]))