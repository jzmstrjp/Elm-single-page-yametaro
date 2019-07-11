module Page.Home exposing (view)

-- import Browser.Navigation as Nav
-- import Html.Attributes exposing (..)

import Browser
import Html exposing (..)
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url



-- type Route
--     = Home
--     | Page1
--     | Page2
--     | Page3
--     | User String
--     | NotFound
-- type alias Model =
--     { key : Nav.Key
--     , url : Url.Url
--     , title : String
--     , route : Route
--     }


view : String
view =
    "Homeのページのview文字列"



-- [ p [] [ text model.title ]
-- , p [] [ text "Homeのページのview関数" ]
-- ]
