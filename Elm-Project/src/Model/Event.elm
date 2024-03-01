module Model.Event exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Model.Event.Category exposing (EventCategory(..))
import Model.Interval as Interval exposing (Interval)
import Html.Attributes exposing (href)


type alias Event =
    { title : String
    , interval : Interval
    , description : Html Never
    , category : EventCategory
    , url : Maybe String
    , tags : List String
    , important : Bool
    }


categoryView : EventCategory -> Html Never
categoryView category =
    case category of
        Academic ->
            text "Academic"

        Work ->
            text "Work"

        Project ->
            text "Project"

        Award ->
            text "Award"


sortByInterval : List Event -> List Event
sortByInterval events =
    List.sortWith (\eventA eventB -> Interval.compare eventA.interval eventB.interval) events


view : Event -> Html Never
view event =
    let
        importantClass =
            if event.important then
                "event-important"
            else
                ""
    in
    div [ class ("event " ++ importantClass) ]
        [ h1 [ class "event-title" ] [ text event.title ]
        , p [ class "event-description" ] [ event.description ]
        , p [ class "event-interval" ] [ ]
        , h2 [ class "event-category" ] [ categoryView event.category ]
        , case event.url of
            Just url -> h2 [ class "event-url" ] [ a [ href url ] [ text "link: " ] ]
            Nothing -> h2 [ class "event-url" ] [ text "" ]
        ]
