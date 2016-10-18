afdl [![Build Status](https://travis-ci.org/AlexKnauth/afdl.png?branch=master)](https://travis-ci.org/AlexKnauth/afdl)
===

a lang-extension for adding rackjure-like [anonymous function literals](http://www.greghendershott.com/rackjure/index.html#%28part._func-lit%29) to a language, based on at-exp and rackjure

documentation: http://pkg-build.racket-lang.org/doc/afdl/index.html

Example:
```racket
#lang afdl racket/base
(map #λ(+ % 1) '(1 2 3)) ;=> '(2 3 4)
```
