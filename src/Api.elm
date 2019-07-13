module Api exposing (Msg(..), User, UserId, getUser, getUsers, userDecorder, usersDecorder)

import Http
import Json.Decode exposing (Decoder, field, map6)


type alias User =
    { id : UserId
    , name : String
    , avatar : String
    , age : Int
    , height : Int
    , weight : Int
    }


type alias UserId =
    String


type Msg
    = GotUsers (Result Http.Error (List User))
    | GotUser (Result Http.Error User)


getUsers : Cmd Msg
getUsers =
    Http.get
        { url = "https://5d118a66bebb9800143d21f8.mockapi.io/users"
        , expect = Http.expectJson GotUsers usersDecorder
        }


getUser : UserId -> Cmd Msg
getUser userId =
    Http.get
        { url = "https://5d118a66bebb9800143d21f8.mockapi.io/users/" ++ userId
        , expect = Http.expectJson GotUser userDecorder
        }


usersDecorder : Decoder (List User)
usersDecorder =
    Json.Decode.list userDecorder


userDecorder : Decoder User
userDecorder =
    Json.Decode.map6 User
        (field "id" Json.Decode.string)
        (field "name" Json.Decode.string)
        (field "avatar" Json.Decode.string)
        (field "age" Json.Decode.int)
        (field "height" Json.Decode.int)
        (field "weight" Json.Decode.int)
