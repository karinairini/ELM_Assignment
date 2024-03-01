module Model.PersonalDetails exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, id)
import Html.Attributes exposing (href)


type alias DetailWithName =
    { name : String
    , detail : String
    }


type alias PersonalDetails =
    { name : String
    , contacts : List DetailWithName
    , intro : String
    , socials : List DetailWithName
    }

view : PersonalDetails -> Html msg
view details =
    div []
        [ h1 [ id "name" ] [ text details.name ]
        , em [ id "intro" ] [ text details.intro ]
        , ul [] <| List.map contactView details.contacts
        , ul [] <| List.map socialView details.socials
        ]


contactView : DetailWithName -> Html msg
contactView contact =
    div [class "contact-detail"] [text contact.detail]


socialView : DetailWithName -> Html msg
socialView social =
    a [classList [("social-link", True)], href social.detail] [text social.name]

