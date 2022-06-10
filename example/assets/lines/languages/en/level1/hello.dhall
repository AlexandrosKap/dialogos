let package = ../package.dhall
let names = ../names.dhall
let emotions = ../emotions.dhall

let none = package.print names.none emotions.none
let alex = package.print names.alex emotions.none

in  [ alex "Hello world."
    , alex "This is a big Big BIG line and has many Many MANY characters."
    , alex "I love you."
    , alex "Bye."
    , none "The end."
    ]
