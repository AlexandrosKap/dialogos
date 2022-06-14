let package = ../package.dhall
let print = package.print

let none = print ""
let alex = print "Alex"
let john = print "John"

in  [ alex "My name is..."
    , alex "Alex."
    , john "Yes. His name is Alex."
    , john "Me?"
    , john "I'm just a rando called John."
    , john "..."
    , john "Ok, bye."
    , none "The end."
    ]
