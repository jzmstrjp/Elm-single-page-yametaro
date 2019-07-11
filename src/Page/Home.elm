module Page.Home exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias ModelForView =
    { title : String
    }


view : ModelForView -> List (Html msg)
view model =
    [ p [] [ text (model.title ++ "内容") ]
    ]
