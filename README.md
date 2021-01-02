# Eva language

A dynamic programming language with simple syntax, functional heart and OOP support.
Eva interpreter is AST interpreter with recursive nature. Ruby interpreter is taken as a virtual machine.
Realisation based on [eva-source](https://github.com/DmitrySoshnikov/eva-source).

### Language specification

Number:

    <number>

String:

    "<chars>"

Binary operations:
Math:

    (+ <number> <number>)
    (* <number> <number>)
    (- (/<number> <number>) <number>)

Comparision:

    (< <number> <number>)
    (>= <number> <number>)

Logical:

    (or <variable> <variable>)
    (and <variable> <variable>)
    (not <variable>)

Variable declaration:

    (var <name> <value>)

Assignment expressions:

    (set <name> <value>)

Variable access:

    <name>

Block expression

    (begin <sequence>)

Branches: if

    (if <condition>
        <consequent>
        <alternate>)

Branches: switch

    (switch (<condition1> <block1>)
            ...
            (<conditionN> <blockN>)
            (else <alternate>))

Loops: while

    (while <condition>
           <block>)

Loops: for

    (for <init>
         <condition>
         <modifier>
         <expression>)

Lambda functions

    (lambda <args> <body>)

Function declaration

    (def <name> <args> <body>)

Function calls

    (<fn> <args>)

Classes

    (class <name> <parent> <body>)

Class instantiation

    (new <class> <args>)

Modules

    (module <name> <body>)

import

    (import <name>)

### Installation

Ruby must be installed. Next, you need to install the **gem bundler** and run the command `$ bundle install`.
Run tests. Everything is ready :)

```sh
$ bin/eva -e '(var x 10) (print x)'
10

$ bin/eva -e '(var x 10) (print (* x 15))'
150

$ bin/eva -f "./test.eva"
10
3D point calc value:
60
Test app version:
0.0.1
```

License
----

MIT