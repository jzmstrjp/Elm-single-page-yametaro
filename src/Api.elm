module Api exposing (Msg(..), User, UserId, getUser, getUsers, postUser, userDecorder, usersDecorder)

import Http
import Json.Decode exposing (Decoder, field, int, map3, string)
import Json.Encode


type alias User =
    { id : UserId
    , name : String
    , age : Int
    }


type alias UserId =
    String


type Msg
    = GotUsers (Result Http.Error (List User))
    | GotUser (Result Http.Error User)
    | PostComplete (Result Http.Error User)


apiUrl : String
apiUrl =
    "https://5d52c1833432e70014e6bc8e.mockapi.io/users"


getUsers : Cmd Msg
getUsers =
    Http.get
        { url = apiUrl
        , expect = Http.expectJson GotUsers usersDecorder
        }


getUser : UserId -> Cmd Msg
getUser userId =
    Http.get
        { url = apiUrl ++ "/" ++ userId
        , expect = Http.expectJson GotUser userDecorder
        }


postUser : Json.Encode.Value -> Cmd Msg
postUser value =
    Http.post
        { url = apiUrl
        , body = Http.jsonBody value
        , expect = Http.expectJson PostComplete userDecorder
        }


usersDecorder : Decoder (List User)
usersDecorder =
    Json.Decode.list userDecorder


userDecorder : Decoder User
userDecorder =
    map3 User
        (field "id" string)
        (field "name" string)
        (field "age" int)
