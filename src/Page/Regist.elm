module Page.Regist exposing (Model, Msg, init, update, view)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Encode


type alias Model =
    { title : String
    , newUserInfo : Api.User
    , resultUserInfo : Api.User
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
            , age = 0
            }
      , resultUserInfo =
            { id = ""
            , name = ""
            , age = 0
            }
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SubmitPost
    | PostComplete Api.Msg
    | UpdateAge String
    | UpdateName String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitPost ->
            let
                newUserInfo : Json.Encode.Value
                newUserInfo =
                    Json.Encode.object
                        [ ( "name", Json.Encode.string model.newUserInfo.name )
                        , ( "age", Json.Encode.int model.newUserInfo.age )
                        ]
            in
            ( model, Cmd.map PostComplete <| Api.postUser newUserInfo )

        PostComplete postCompleteMsg ->
            let
                newResultUserInfo : Api.User
                newResultUserInfo =
                    case postCompleteMsg of
                        Api.PostComplete result ->
                            case result of
                                Ok userInfo ->
                                    userInfo

                                Err _ ->
                                    model.resultUserInfo

                        _ ->
                            model.resultUserInfo
            in
            --,
            ( { model | state = Registed, resultUserInfo = newResultUserInfo }, Cmd.none )

        UpdateAge str ->
            let
                prevStateNewUserInfo =
                    model.newUserInfo

                newStateNewUserInfo =
                    { prevStateNewUserInfo | age = Maybe.withDefault 0 <| String.toInt str }
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
        [ viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model.state of
        Start ->
            div []
                [ p [] [ label [] [ text "名前", input [ onInput UpdateName ] [] ] ]
                , p [] [ label [] [ text "年齢", input [ onInput UpdateAge ] [] ] ]
                , p [] [ button [ onClick SubmitPost ] [ text "登録" ] ]
                ]

        Registed ->
            div []
                [ p [] [ text "登録しました。" ]
                , p [] [ text <| "名前：" ++ model.resultUserInfo.name ]
                , p [] [ text <| "年齢：" ++ String.fromInt model.resultUserInfo.age ]
                ]
