module Route exposing (Route(..), parse, parser)

import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string, top)


type alias UserId =
    String


type Route
    = Top
    | Users
    | User UserId



--| User Id


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Top top
        , map Users (s "user")
        , map User (s "user" </> string)
        ]


parse : Url.Url -> Maybe Route
parse url =
    Url.Parser.parse parser url
