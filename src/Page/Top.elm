module Page.Top exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { title : String
    , count : Int
    }


type Msg
    = Increment
    | Decrement


init : Model
init =
    { title = "トップページ"
    , count = 0
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Decrement ->
            ( { model | count = model.count - 1 }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| "カウント: " ++ String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Increment ] [ text "+" ]
        ]
