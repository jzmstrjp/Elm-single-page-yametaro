module Page.Regist exposing (Model, Msg, init, update, view)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { title : String
    , state : State
    }


type State
    = Hoge


init : ( Model, Cmd Msg )
init =
    ( { title = "ユーザー登録ページ"
      , state = Hoge
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Msg1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg1 ->
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
        Hoge ->
            div []
                [ text "データが取得できませんでした。"
                ]
