let package = ../package.dhall
let print = package.print
let menu = package.menu
let position = package.position
let goto = package.goto

let none = print ""
let bob = print "Bob"

in  [ bob "Hi."
    , bob "Do you like apples?"
    , menu "yes||no" "Yes! Apples are great.||No, I only like oranges."

    , position "yes"
    , bob "Apple enjoyer detected."
    , bob "Niceee."
    , goto "end"

    , position "no"
    , bob "Orange enjoyer detected."
    , bob "Cooool."
    , goto "end"

    , position "end"
    , none "The end."
    ]
