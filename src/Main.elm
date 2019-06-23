module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , title : String
    , route : Route
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url "SPA練習" Home, Cmd.none )


type Route
    = Home
    | Page1
    | Page2
    | Page3
    | User String
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Page1 (s "page1")
        , map Page2 (s "page2")
        , map Page3 (s "page3")
        , map User (s "user" </> string)
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault NotFound (Url.Parser.parse routeParser url)


routeToTitle : Route -> String
routeToTitle route =
    case route of
        Home ->
            "トップページ"

        Page1 ->
            "ページ1"

        Page2 ->
            "ページ2"

        Page3 ->
            "ページ3"

        User string ->
            string ++ "のページ"

        NotFound ->
            "Not Found"



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        newTitle =
                            routeToTitle <| toRoute url
                    in
                    ( { model | title = newTitle, route = toRoute url }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = model.title
    , body =
        [ div [ class "wrapper" ]
            [ h1 []
                [ a [ href "/" ] [ text "Elm SPA Demo" ]
                ]
            , nav []
                [ ul [ class "gNav" ]
                    [ li [] [ a [ href "/page1" ] [ text "ページ1" ] ]
                    , li [] [ a [ href "/page2" ] [ text "ページ2" ] ]
                    , li [] [ a [ href "/page3" ] [ text "ページ3" ] ]
                    , li [] [ a [ href "/user/yametaro" ] [ text "やめ太郎について" ] ]
                    , li [] [ a [ href "/notfound" ] [ text "無いページ" ] ]
                    ]
                ]
            , section []
                [ h2 [] [ text model.title ]
                , case model.route of
                    NotFound ->
                        div []
                            [ p []
                                [ text "このページは存在しません"
                                ]
                            , p []
                                [ a [ href "/" ] [ text "ホームに戻る" ]
                                ]
                            ]

                    User string ->
                        div [ class "body" ]
                            [ p [] [ text "ワイについて書く" ]
                            ]

                    _ ->
                        div [ class "body" ]
                            [ p [] [ text "内容" ]
                            ]
                ]
            ]
        ]
    }
