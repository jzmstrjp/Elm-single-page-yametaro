module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Top
import Page.Users
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
    , page : Page
    }


type Page
    = NotFound
    | TopPage Page.Top.Model
    | UsersPage Page.Users.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key (TopPage Page.Top.init), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TopMsg Page.Top.Msg
    | UsersMsg Page.Users.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            goTo (Route.parse url) model

        TopMsg topMsg ->
            case model.page of
                TopPage topModel ->
                    let
                        ( newTopModel, topCmd ) =
                            Page.Top.update topMsg topModel
                    in
                    ( { model | page = TopPage newTopModel }
                    , Cmd.map TopMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )

        UsersMsg usersMsg ->
            case model.page of
                UsersPage usersModel ->
                    let
                        ( newUsersModel, usersCmd ) =
                            Page.Users.update usersMsg usersModel
                    in
                    ( { model | page = UsersPage newUsersModel }
                    , Cmd.map UsersMsg usersCmd
                    )

                _ ->
                    ( model, Cmd.none )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage Page.Top.init }
            , Cmd.none
            )

        Just Route.Users ->
            let
                ( usersModel, usersCmd ) =
                    Page.Users.init
            in
            ( { model | page = UsersPage usersModel }
            , Cmd.map UsersMsg usersCmd
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = getTitle model.page
    , body =
        [ header [ class "gHeader" ]
            [ div [ class "inner" ]
                [ h1 []
                    [ a [ href "/" ] [ text "Elm SPA Demo" ]
                    ]
                ]
            ]
        , nav [ class "gNav" ]
            [ div [ class "inner" ]
                [ ul []
                    [ li [] [ a [ href "/user/" ] [ text "ユーザー 一覧" ] ]
                    , li [] [ a [ href "/notfound" ] [ text "無いページ" ] ]
                    ]
                ]
            ]
        , main_ []
            [ div [ class "inner" ]
                [ h2 [] [ text (getTitle model.page) ]
                , div [ class "content" ] (content model)
                ]
            ]
        ]
    }


getTitle : Page -> String
getTitle page =
    case page of
        NotFound ->
            "Not Found"

        TopPage model ->
            model.title

        UsersPage model ->
            "ユーザー 一覧"


content : Model -> List (Html Msg)
content model =
    case model.page of
        NotFound ->
            viewNotFound

        TopPage topPageModel ->
            [ Page.Top.view topPageModel |> Html.map TopMsg ]

        UsersPage usersPageModel ->
            [ Page.Users.view usersPageModel |> Html.map UsersMsg ]


viewNotFound : List (Html Msg)
viewNotFound =
    [ div []
        [ p []
            [ text "このページは存在しません"
            ]
        , p []
            [ a [ href "/" ] [ text "ホームに戻る" ]
            ]
        ]
    ]
