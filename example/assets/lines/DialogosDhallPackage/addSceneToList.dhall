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
        , pause = indexedLine.value.pause
        , scene = indexedLine.value.scene
        , sound = indexedLine.value.sound
        , text = indexedLine.value.text
        }

let addSceneToLine : Text -> Line -> Line =
    \(scene : Text) -> 
    \(line : Line) ->
        { code = "${scene}${line.code}"
        , emotion = line.emotion
        , event = line.event
        , name = line.name
        , number = line.number
        , pause = line.pause
        , scene
        , sound = line.sound
        , text = line.text
        }

let addSceneToList : Text -> List Line -> List Line =
    \(scene : Text) ->
    \(lines : List Line) ->
        let addSceneToLine = addSceneToLine scene

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
            addSceneToLine
            part1

        in  part2

in  addSceneToList
