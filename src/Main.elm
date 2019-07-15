module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
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


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key (TopPage Page.Top.init), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TopMsg Page.Top.Msg
    | UsersMsg Page.Users.Msg
    | UserMsg Page.User.Msg


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
                ( TopMsg topMsg, TopPage topModel ) ->
                    let
                        ( newTopModel, topCmd ) =
                            Page.Top.update topMsg topModel
                    in
                    ( { model | page = TopPage newTopModel }
                    , Cmd.map TopMsg topCmd
                    )

                ( UsersMsg usersMsg, UsersPage usersModel ) ->
                    let
                        ( newUsersModel, usersCmd ) =
                            Page.Users.update usersMsg usersModel
                    in
                    ( { model | page = UsersPage newUsersModel }
                    , Cmd.map UsersMsg usersCmd
                    )

                ( UserMsg userMsg, UserPage userModel ) ->
                    let
                        ( newUserModel, userCmd ) =
                            Page.User.update userMsg userModel
                    in
                    ( { model | page = UserPage newUserModel }
                    , Cmd.map UserMsg userCmd
                    )

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
            let
                ( usersModel, usersCmd ) =
                    Page.Users.init
            in
            ( { model | page = UsersPage usersModel }
            , Cmd.map UsersMsg usersCmd
            )

        Just (Route.User userId) ->
            let
                ( userModel, userCmd ) =
                    Page.User.init userId
            in
            ( { model | page = UserPage userModel }
            , Cmd.map UserMsg userCmd
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
        NotFound model ->
            model.title

        TopPage model ->
            model.title

        UsersPage model ->
            model.title

        UserPage model ->
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
