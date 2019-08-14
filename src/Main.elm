module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Regist
import Page.Top
import Page.User
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
    = NotFound { title : String }
    | TopPage Page.Top.Model
    | UsersPage Page.Users.Model
    | UserPage Page.User.Model
    | RegistPage Page.Regist.Model


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key (TopPage Page.Top.init)
        |> goTo (Route.parse url)



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TopMsg Page.Top.Msg
    | UsersMsg Page.Users.Msg
    | UserMsg Page.User.Msg
    | RegistMsg Page.Regist.Msg


makeModelAndCmdTuple :
    ( pageModel, Cmd pageMsg )
    -> (pageMsg -> Msg)
    -> (pageModel -> Page)
    -> Model
    -> ( Model, Cmd Msg )
makeModelAndCmdTuple ( pageModel, pageCmd ) msgType pageType model =
    ( { model | page = pageType pageModel }
    , Cmd.map msgType pageCmd
    )


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

        _ ->
            case ( msg, model.page ) of
                ( TopMsg pageMsg, TopPage pageModel ) ->
                    makeModelAndCmdTuple (Page.Top.update pageMsg pageModel) TopMsg TopPage model

                ( UsersMsg pageMsg, UsersPage pageModel ) ->
                    makeModelAndCmdTuple (Page.Users.update pageMsg pageModel) UsersMsg UsersPage model

                ( UserMsg pageMsg, UserPage pageModel ) ->
                    makeModelAndCmdTuple (Page.User.update pageMsg pageModel) UserMsg UserPage model

                ( RegistMsg pageMsg, RegistPage pageModel ) ->
                    makeModelAndCmdTuple (Page.Regist.update pageMsg pageModel) RegistMsg RegistPage model

                ( _, _ ) ->
                    ( model, Cmd.none )


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound { title = "Not Found" } }, Cmd.none )

        Just Route.Top ->
            ( { model | page = TopPage Page.Top.init }
            , Cmd.none
            )

        Just Route.Users ->
            makeModelAndCmdTuple Page.Users.init UsersMsg UsersPage model

        Just (Route.User userId) ->
            makeModelAndCmdTuple (Page.User.init userId) UserMsg UserPage model

        Just Route.Regist ->
            makeModelAndCmdTuple Page.Regist.init RegistMsg RegistPage model



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
                    [ li [] [ a [ href "/user" ] [ text "ユーザー 一覧" ] ]
                    , li [] [ a [ href "/regist" ] [ text "ユーザー 登録" ] ]
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
        NotFound { title } ->
            title

        TopPage model ->
            model.title

        UsersPage model ->
            model.title

        UserPage model ->
            model.title

        RegistPage model ->
            model.title


content : Model -> List (Html Msg)
content model =
    case model.page of
        NotFound _ ->
            viewNotFound

        TopPage topPageModel ->
            [ Page.Top.view topPageModel |> Html.map TopMsg ]

        UsersPage usersPageModel ->
            [ Page.Users.view usersPageModel |> Html.map UsersMsg ]

        UserPage userPageModel ->
            [ Page.User.view userPageModel |> Html.map UserMsg ]

        RegistPage registPageModel ->
            [ Page.Regist.view registPageModel |> Html.map RegistMsg ]


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
