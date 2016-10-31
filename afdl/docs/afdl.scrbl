#lang scribble/manual

@(require scribble/eval
          scribble-code-examples
          (for-label (except-in racket/base
                                read read-syntax)
                     (except-in afdl/reader
                                read read-syntax)))

@title{afdl}

@;; example: @afdl-code{(map #λ(+ % 1) '(1 2 3))}
@(define-syntax-rule @afdl-code[stuff ...]
   @code[#:lang "afdl racket" stuff ...])

source code: @url["https://github.com/AlexKnauth/afdl"]

@section{#lang afdl}

@defmodulelang[afdl]{
The @racketmodname[afdl] language is a lang-extension like @racketmodname[at-exp]
that adds @racketmodname[rackjure]-like anonymous function literals to a language.  
@margin-note{see @secref["func-lit" #:doc '(lib "rackjure/rackjure.scrbl")]}

For example, @racket[@#,hash-lang[] @#,racketmodname[afdl] @#,racketmodname[racket/base]]
adds anonymous function literals to @racketmodname[racket/base], so that
@codeblock{
#lang afdl racket/base}
@code-examples[#:lang "afdl racket/base" #:context #'here]|{
(map #λ(+ % 1) '(1 2 3))
(map #λ(+ % %2) '(1 2 3) '(1 2 3))
}|

For the @racketmodname[afdl] language to work properly for a module, the module
has to depend on @racketmodname[racket/base] in some way, although that does not
mean it has to explicitly require it or that the language it uses has to provide
anything from it.  It does mean that for instance
@racket[@#,hash-lang[] @#,racketmodname[afdl] @#,racketmodname[racket/kernel]]
won't work properly.  
}

@section{afdl/reader}

@defmodule[afdl/reader]

@deftogether[(@defproc[(afdl-read [in input-port? (current-input-port)]
                                 [#:arg-str arg-str string? (current-arg-string)]) any]{}
              @defproc[(afdl-read-syntax [source-name any/c (object-name in)]
                                        [in input-port? (current-input-port)]
                                        [#:arg-str arg-str string? (current-arg-string)])
                       (or/c syntax? eof-object?)]{})]{
These procedures implement the @racketmodname[afdl] reader.  They do so by
constructing a readtable based on the current one, and using that
for reading.

The @racket[arg-str] argument lets you specify something else to use as a placeholder instead of
@racket[%].

@examples[
  (require afdl/reader)
  (afdl-read (open-input-string "#λ(+ % %2)"))
  (afdl-read (open-input-string "#λ(+ _ _2)") #:arg-str "_")
]

@racketmodname[afdl/reader] also exports these functions under the names @racket[read] and
@racket[read-syntax].
}

@defproc[(make-afdl-readtable [orig-readtable readtable? (current-readtable)]
                             [#:outer-scope outer-scope (-> syntax? syntax?)]
                             [#:arg-str arg-str string? (current-arg-string)]) readtable?]{
makes an @racketmodname[afdl] readtable based on @racket[orig-readtable].

The @racket[outer-scope] argument should be a function that introduce scopes to preserve hygiene,
normally produced by @racket[make-syntax-introducer] and similar functions. For versions of racket
that support it, these should generally be specified as use-site scopes.

The @racket[arg-str] argument lets you specify something else to use as a placeholder instead of
@racket[%], just like for @racket[afdl-read].
}

@defproc[(use-afdl-readtable [orig-readtable readtable? (current-readtable)]
                            [#:arg-str arg-str string? (current-arg-string)]) void?]{
passes arguments to @racket[make-afdl-readtable] and sets the @racket[current-readtable] parameter to
the resulting readtable.
It also enables line counting for the @racket[current-input-port] via @racket[port-count-lines!].

This is mostly useful for the REPL.

@verbatim{
Examples:

> @afdl-code{(require afdl/reader)}
> @afdl-code{(use-afdl-readtable)}
> @afdl-code{(map #λ(+ % %2) '(1 2 3) '(1 2 3))}
@racketresult['(2 4 6)]
> @afdl-code{(use-afdl-readtable #:arg-str "_")}
> @afdl-code{(map #λ(+ _ _2) '(1 2 3) '(1 2 3))}
@racketresult['(2 4 6)]
}}

@defparam[current-arg-string arg-str string?]{
a parameter that controls default values of the @racket[arg-str] arguments to @racket[afdl-read] etc.
}