module Page.Regist exposing (Model, Msg, init, update, view)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { title : String
    , newUserInfo : Api.User
    , state : State
    }


type State
    = Start
    | Registed


init : ( Model, Cmd Msg )
init =
    ( { title = "ユーザー登録ページ"
      , state = Start
      , newUserInfo =
            { id = ""
            , name = ""
            }
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SubmitPost
    | UpdateId String
    | UpdateName String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitPost ->
            ( { model | state = Registed }, Cmd.none )

        UpdateId str ->
            let
                prevStateNewUserInfo =
                    model.newUserInfo

                newStateNewUserInfo =
                    { prevStateNewUserInfo | id = str }
            in
            ( { model | newUserInfo = newStateNewUserInfo }, Cmd.none )

        UpdateName str ->
            let
                prevStateNewUserInfo =
                    model.newUserInfo

                newStateNewUserInfo =
                    { prevStateNewUserInfo | name = str }
            in
            ( { model | newUserInfo = newStateNewUserInfo }, Cmd.none )



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
        Start ->
            div []
                [ p [] [ label [] [ text "ID", input [ name "id" ] [] ] ]
                , p [] [ label [] [ text "名前", input [ name "name" ] [] ] ]
                , p [] [ button [ onClick SubmitPost ] [ text "登録" ] ]
                ]

        Registed ->
            div []
                [ text "登録しました。"
                ]
