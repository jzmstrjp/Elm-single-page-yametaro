module Page.Users exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, map6)


type Model
    = Failure
    | Loading
    | Success (List User)


type alias User =
    { id : Int
    , name : String
    , avatar : String
    , age : Int
    , height : Int
    , width : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Loading, getUsers )



-- UPDATE


type Msg
    = GotData (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotData result ->
            case result of
                Ok users ->
                    ( Success users, Cmd.none )

                Err _ ->
                    -- let
                    --     _ =
                    --         Debug.log "Err: " msg
                    -- in
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div []
                [ text "データが取得できませんでした。"
                ]

        Loading ->
            text "Loading..."

        Success users ->
            ul [] (List.map viewUser users)


viewUser : User -> Html Msg
viewUser user =
    li []
        [ ul []
            [ li [] [ text ("ID: " ++ String.fromInt user.id) ]
            , li [] [ text ("名前: " ++ user.name) ]
            , li [] [ img [ src user.avatar ] [] ]
            , li [] [ text ("年齢: " ++ String.fromInt user.age) ]
            , li [] [ text ("身長: " ++ String.fromInt user.height) ]
            , li [] [ text ("体重: " ++ String.fromInt user.width) ]
            ]
        ]



-- HTTP


getUsers : Cmd Msg
getUsers =
    Http.get
        { url = "https://5d118a66bebb9800143d21f8.mockapi.io/users"
        , expect = Http.expectJson GotData usersDecorder
        }


usersDecorder : Decoder (List User)
usersDecorder =
    Json.Decode.list userDecorder


userDecorder : Decoder User
userDecorder =
    Json.Decode.map6 User
        (field "id" Json.Decode.int)
        (field "name" Json.Decode.string)
        (field "avatar" Json.Decode.string)
        (field "age" Json.Decode.int)
        (field "height" Json.Decode.int)
        (field "weight" Json.Decode.int)
