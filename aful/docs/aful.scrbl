#lang scribble/manual

@(require scribble/eval
          scribble-code-examples
          (for-label (except-in racket/base
                                read read-syntax)
                     (except-in aful/reader
                                read read-syntax)))

@title{aful}

@;; example: @aful-code{(map #λ(+ % 1) '(1 2 3))}
@(define-syntax-rule @aful-code[stuff ...]
   @code[#:lang "aful racket" stuff ...])

source code: @url["https://github.com/AlexKnauth/aful"]

@section{#lang aful}

@defmodulelang[aful]{
The @racketmodname[aful] language is a lang-extension like @racketmodname[at-exp]
that adds @racketmodname[rackjure]-like anonymous function literals to a language.  
@margin-note{see @secref["func-lit" #:doc '(lib "rackjure/rackjure.scrbl")]}

For example, @racket[@#,hash-lang[] @#,racketmodname[aful] @#,racketmodname[racket/base]]
adds anonymous function literals to @racketmodname[racket/base], so that
@codeblock{
#lang aful racket/base}
@code-examples[#:lang "aful racket/base" #:context #'here]|{
(map #λ(+ % 1) '(1 2 3))
(map #λ(+ % %2) '(1 2 3) '(1 2 3))
}|

For the @racketmodname[aful] language to work properly for a module, the module
has to depend on @racketmodname[racket/base] in some way, although that does not
mean it has to explicitly require it or that the language it uses has to provide
anything from it.  It does mean that for instance
@racket[@#,hash-lang[] @#,racketmodname[aful] @#,racketmodname[racket/kernel]]
won't work properly.  
}

@section{aful/reader}

@defmodule[aful/reader]

@deftogether[(@defproc[(aful-read [in input-port? (current-input-port)]
                                 [#:arg-str arg-str string? (current-arg-string)]) any]{}
              @defproc[(aful-read-syntax [source-name any/c (object-name in)]
                                        [in input-port? (current-input-port)]
                                        [#:arg-str arg-str string? (current-arg-string)])
                       (or/c syntax? eof-object?)]{})]{
These procedures implement the @racketmodname[aful] reader.  They do so by
constructing a readtable based on the current one, and using that
for reading.

The @racket[arg-str] argument lets you specify something else to use as a placeholder instead of
@racket[%].

@examples[
  (require aful/reader)
  (aful-read (open-input-string "#λ(+ % %2)"))
  (aful-read (open-input-string "#λ(+ _ _2)") #:arg-str "_")
]

@racketmodname[aful/reader] also exports these functions under the names @racket[read] and
@racket[read-syntax].
}

@defproc[(make-aful-readtable [orig-readtable readtable? (current-readtable)]
                             [#:outer-scope outer-scope (-> syntax? syntax?)]
                             [#:arg-str arg-str string? (current-arg-string)]) readtable?]{
makes an @racketmodname[aful] readtable based on @racket[orig-readtable].

The @racket[outer-scope] argument should be a function that introduce scopes to preserve hygiene,
normally produced by @racket[make-syntax-introducer] and similar functions. For versions of racket
that support it, these should generally be specified as use-site scopes.

The @racket[arg-str] argument lets you specify something else to use as a placeholder instead of
@racket[%], just like for @racket[aful-read].
}

@defproc[(use-aful-readtable [orig-readtable readtable? (current-readtable)]
                            [#:arg-str arg-str string? (current-arg-string)]) void?]{
passes arguments to @racket[make-aful-readtable] and sets the @racket[current-readtable] parameter to
the resulting readtable.
It also enables line counting for the @racket[current-input-port] via @racket[port-count-lines!].

This is mostly useful for the REPL.

@verbatim{
Examples:

> @aful-code{(require aful/reader)}
> @aful-code{(use-aful-readtable)}
> @aful-code{(map #λ(+ % %2) '(1 2 3) '(1 2 3))}
@racketresult['(2 4 6)]
> @aful-code{(use-aful-readtable #:arg-str "_")}
> @aful-code{(map #λ(+ _ _2) '(1 2 3) '(1 2 3))}
@racketresult['(2 4 6)]
}}

@defparam[current-arg-string arg-str string?]{
a parameter that controls default values of the @racket[arg-str] arguments to @racket[aful-read] etc.
}