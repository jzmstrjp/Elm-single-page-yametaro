module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Home as Home
import Route exposing (Route)
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
    let
        route =
            toRoute url

        title =
            routeToTitle route
    in
    ( Model key url title route, Cmd.none )


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Route.Home top
        , map Route.User (s "user" </> string)
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault Route.NotFound (Url.Parser.parse routeParser url)


routeToTitle : Route -> String
routeToTitle route =
    case route of
        Route.Home ->
            "トップページ"

        Route.User string ->
            string ++ "のページ"

        Route.NotFound ->
            "Not Found"



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg


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

        HomeMsg homeMsg ->
            case homeMsg of
                Home.Increment ->
                    ( { model | title = model.title ++ "Inc" }
                    , Cmd.none
                    )

                Home.Decrement ->
                    ( { model | title = model.title ++ "Dec" }
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
                    [ li [] [ a [ href "/user/yametaro" ] [ text "やめ太郎について" ] ]
                    , li [] [ a [ href "/notfound" ] [ text "無いページ" ] ]
                    ]
                ]
            , section []
                [ h2 [] [ text model.title ]
                , div [ class "body" ]
                    (case model.route of
                        Route.NotFound ->
                            [ div []
                                [ p []
                                    [ text "このページは存在しません"
                                    ]
                                , p []
                                    [ a [ href "/" ] [ text "ホームに戻る" ]
                                    ]
                                ]
                            ]

                        Route.Home ->
                            [ Home.view model |> Html.map HomeMsg ]

                        Route.User string ->
                            [ p [] [ text "ワイについて書く" ] ]
                    )
                ]
            ]
        ]
    }
