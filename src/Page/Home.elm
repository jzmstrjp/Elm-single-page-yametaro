module Page.Home exposing (Model, Msg(..), Route(..), view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


type Route
    = Home
    | Page1
    | Page2
    | Page3
    | User String
    | NotFound


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , title : String
    , route : Route
    }


view : Model -> List (Html Msg)
view model =
    [ p [] [ text "model.title" ]
    , p [] [ text "Homeのページのview関数" ]
    ]
