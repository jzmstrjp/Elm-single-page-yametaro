module Page.Home exposing (Model, Msg(..), view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Url


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , title : String
    , route : Route
    }


type Msg
    = Increment
    | Decrement


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text (model.title ++ "内容") ]
        , button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Increment ] [ text "+" ]
        ]
