------------------ Function is from: https://store.dhall-lang.org/Prelude-v21.1.0/List/map.dhall.html
let map
    : ∀(a : Type) → ∀(b : Type) → (a → b) → List a → List b
    = λ(a : Type) →
      λ(b : Type) →
      λ(f : a → b) →
      λ(xs : List a) →
        List/build
          b
          ( λ(list : Type) →
            λ(cons : b → list → list) →
              List/fold a xs list (λ(x : a) → cons (f x))
          )
------------------

let Line = ./Line.dhall

let IndexedLine =
    { index : Natural
    , value : Line
    }

let fromIndexedLineToLine : IndexedLine -> Line =
    \(indexedLine : IndexedLine) ->
        { code = "${Natural/show indexedLine.index}${indexedLine.value.code}"
        , emotion = indexedLine.value.emotion
        , event = indexedLine.value.event
        , name = indexedLine.value.name
        , number = indexedLine.index
        , pauseEnd = indexedLine.value.pauseEnd
        , pauseStart = indexedLine.value.pauseStart
        , scene = indexedLine.value.scene
        , set = indexedLine.value.set
        , sound = indexedLine.value.sound
        , text = indexedLine.value.text
        }

let addSetAndScene : Text -> Text -> Line -> Line =
    \(set : Text) ->
    \(scene : Text) -> 
    \(line : Line) ->
        { code = "${set}${line.code}"
        , emotion = line.emotion
        , event = line.event
        , name = line.name
        , number = line.number
        , pauseEnd = line.pauseEnd
        , pauseStart = line.pauseStart
        , scene
        , set
        , sound = line.sound
        , text = line.text
        }

let newLineSet : Text -> Text -> List Line -> List Line =
    \(set : Text) ->
    \(scene : Text) ->
    \(lines : List Line) ->
        let addSetAndScene = addSetAndScene set scene

        let part1 =
            map
            IndexedLine
            Line
            fromIndexedLineToLine
            (List/indexed Line lines)

        let part2 =
            map
            Line
            Line
            addSetAndScene
            part1

        in  part2

in  newLineSet
