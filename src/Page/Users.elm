module Page.Users exposing (Model, Msg, init, update, view)

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
    | Success (List Api.User)


init : ( Model, Cmd Msg )
init =
    ( { title = "ユーザー 一覧"
      , state = Loading
      }
    , Api.getUsers
    )



-- UPDATE


type alias Msg =
    Api.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Api.GotUsers result ->
            case result of
                Ok users ->
                    ( { model | state = Success users }, Cmd.none )

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

        Success users ->
            ul [] (List.map viewUser users)


viewUser : Api.User -> Html Msg
viewUser user =
    li []
        [ ul []
            [ li [] [ a [ href <| "/user/" ++ user.id ] [ text <| "名前: " ++ user.name ] ]
            ]
        ]
