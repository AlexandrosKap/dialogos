let Line = ./Line.dhall

let newLine : Double -> Text -> Text -> Text -> Text -> Text -> Line =
    \(pause : Double) ->
    \(event : Text) ->
    \(sound : Text) ->
    \(name  : Text) ->
    \(emotion : Text) ->
    \(text  : Text) ->
        { code = ""
        , emotion
        , event
        , name
        , number = 0
        , pause
        , scene = ""
        , sound
        , text
        }

in  newLine
