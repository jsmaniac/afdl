#lang racket/base

(provide configure)

(require (only-in afdl/reader use-afdl-readtable))

(define (configure data)
  (use-afdl-readtable))

