let package = ../package.dhall
let print = package.print
let menu = package.menu
let position = package.position
let goto = package.goto

let n = print ""
let s = print "Sylvie"
let m = print "Me"

in  [ position "start"
    , n ''
    It's only when I hear the sounds of shuffling feet
    and supplies being put away that I realize that the lecture's over.''
    , n ''
    Professor Eileen's lectures are usually interesting,
    but today I just couldn't concentrate on it.''
    , n ''
    I've had a lot of other thoughts
    on my mind...thoughts that culminate in a question.''
    , n ''
    It's a question that I've been meaning to ask a certain someone.''
    , n ''
    I've known Sylvie since we were kids.
    She's got a big heart and she's always been a good friend to me.''
    , n ''
    But recently... I've felt that I want something more.''
    , n ''
    More than just talking,
    more than just walking home together when our classes end.''
    , n "As soon as she catches my eye, I decide..."
    , menu "rightaway||later" "To ask her right away.||To ask her later."


    , position "rightaway"
    , s "Hi there! How was class?"
    , m "Good..."
    , n "I can't bring myself to admit that it all went in one ear and out the other."
    , m "Are you going home now? Wanna walk back with me?"
    , s "Sure!"
    , n "After a short while, we reach the meadows just outside the neighborhood where we both live."
    , n "It's a scenic view I've grown used to. Autumn is especially beautiful here."
    , n "When we were children, we played in these meadows a lot, so they're full of memories."
    , m "Hey... Umm..."
    , n "She turns to me and smiles. She looks so welcoming that I feel my nervousness melt away."
    , n "I'll ask her...!"
    , m "Ummm... Will you..."
    , m "Will you be my artist for a visual novel?"
    , n "Silence."
    , n "She looks so shocked that I begin to fear the worst. But then..."
    , s "Sure, but what's a \"visual novel?\""
    , menu "game||book" "It's a videogame.||It's an interactive book."


    , position "game"
    , m "It's a kind of videogame you can play on your computer or a console."
    , m "Visual novels tell a story with pictures and music."
    , m "Sometimes, you also get to make choices that affect the outcome of the story."
    , s "So it's like those choose-your-adventure books?"
    , m "Exactly! I've got lots of different ideas that I think would work."
    , m "And I thought maybe you could help me...since I know how you like to draw."
    , m "It'd be hard for me to make a visual novel alone."
    , s "Well, sure! I can try. I just hope I don't disappoint you."
    , m "You know you could never disappoint me, Sylvie."
    , goto "marry"


    , position "book"
    , m "It's like an interactive book that you can read on a computer or a console."
    , s "Interactive?"
    , m "You can make choices that lead to different events and endings in the story."
    , s "So where does the \"visual\" part come in?"
    , m "Visual novels have pictures and even music, sound effects, and sometimes voice acting to go along with the text."
    , s "I see! That certainly sounds like fun. I actually used to make webcomics way back when, so I've got lots of story ideas."
    , m "That's great! So...would you be interested in working with me as an artist?"
    , s "I'd love to!"
    , goto "marry"


    , position "marry"
    , n "And so, we become a visual novel creating duo."
    , n "Over the years, we make lots of games and have a lot of fun making them."
    , n "We take turns coming up with stories and characters and support each other to make some great games!"
    , n "And one day..."
    , s "Hey..."
    , m "Yes?"
    , s "Will you marry me?"
    , m "What? Where did this come from?"
    , s "Come on, how long have we been dating?"
    , m "A while..."
    , s "These last few years we've been making visual novels together, spending time together, helping each other..."
    , s "I've gotten to know you and care about you better than anyone else. And I think the same goes for you, right?"
    , m "Sylvie..."
    , s "But I know you're the indecisive type. If I held back, who knows when you'd propose?"
    , s "So will you marry me?"
    , m "Of course I will! I've actually been meaning to propose, honest!"
    , s "I know, I know."
    , m "I guess... I was too worried about timing. I wanted to ask the right question at the right time."
    , s "You worry too much. If only this were a visual novel and I could pick an option to give you more courage!"
    , n "We get married shortly after that."
    , n "Our visual novel duo lives on even after we're married...and I try my best to be more decisive."
    , n "Together, we live happily ever after even now."
    , n "Good Ending."
    , goto "end"

    
    , position "later"
    , n "I can't get up the nerve to ask right now. With a gulp, I decide to ask her later."
    , n "But I'm an indecisive person."
    , n "I couldn't ask her that day and I end up never being able to ask her."
    , n "I guess I'll never know the answer to my question now..."
    , n "Bad Ending."
    , goto "end"


    , position "end"
    ]
