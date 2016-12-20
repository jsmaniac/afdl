#lang racket/base

(provide configure)

(require (only-in aful/reader use-aful-readtable))

(define (configure data)
  (use-aful-readtable))

