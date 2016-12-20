aful [![Build Status](https://travis-ci.org/jsmaniac/aful.png?branch=master)](https://travis-ci.org/jsmaniac/aful)
===

a lang-extension for adding rackjure-like [anonymous function literals](http://www.greghendershott.com/rackjure/index.html#%28part._func-lit%29) to a language, based on at-exp and rackjure

documentation: http://pkg-build.racket-lang.org/doc/aful/index.html

Example:
```racket
#lang aful racket/base
(map #λ(+ % 1) '(1 2 3)) ;=> '(2 3 4)
```

```racket
#lang aful/unhygienic racket/base
(map #λ(+ % 1) '(1 2 3)) ;=> '(2 3 4)
```
