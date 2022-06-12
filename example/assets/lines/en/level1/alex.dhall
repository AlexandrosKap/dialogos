let package = ../package.dhall
let names = ../names.dhall
let emotions = ../emotions.dhall

let none = package.print names.none emotions.none
let alex = package.print names.alex emotions.none
let john = package.print names.john emotions.none

in  [ alex "My name is..."
    , alex "Alex."
    , john "Yes. His name is Alex."
    , john "Me?"
    , john "I'm just a rando called John."
    , john "..."
    , john "Ok, bye."
    , none "The end."
    ]
