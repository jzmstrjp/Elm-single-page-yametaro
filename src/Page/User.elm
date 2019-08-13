module Page.User exposing (Model, Msg, init, update, view)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { title : String
    , state : State
    }


type State
    = Failure
    | Loading
    | Success Api.User


init : Api.UserId -> ( Model, Cmd Msg )
init userId =
    ( { title = "ユーザー: " ++ userId ++ "のページ"
      , state = Loading
      }
    , Api.getUser userId
    )



-- UPDATE


type alias Msg =
    Api.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Api.GotUser result ->
            case result of
                Ok user ->
                    ( { model | state = Success user }, Cmd.none )

                Err _ ->
                    let
                        _ =
                            Debug.log "Err: " msg
                    in
                    ( { model | state = Failure }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model.state of
        Failure ->
            div []
                [ text "データが取得できませんでした。"
                ]

        Loading ->
            text "Loading..."

        Success user ->
            ul []
                [ li [] [ text <| "ID: " ++ user.id ]
                , li [] [ text <| "名前: " ++ user.name ]
                ]
