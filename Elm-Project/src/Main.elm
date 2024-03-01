module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Http
import Json.Decode as De
import Model exposing (..)
import Model.Event as Event
import Model.Event.Category as EventCategory
import Model.PersonalDetails as PersonalDetails
import Model.Repo as Repo
import Json.Decode exposing (list)


type Msg
    = GetRepos
    | GotRepos (Result Http.Error (List Repo.Repo))
    | SelectEventCategory EventCategory.EventCategory
    | DeselectEventCategory EventCategory.EventCategory


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel
    , Cmd.batch
        [ Cmd.none
        , Http.get
            { url = "https://api.github.com/users/karinairini/repos"
            , expect = Http.expectJson GotRepos (list Repo.decodeRepo)
            }
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetRepos ->
            (model, Cmd.none)

        GotRepos (Ok repos) ->
            ({ model | repos = repos }, Cmd.none)

        GotRepos (Err _) ->
            (model, Cmd.none)

        SelectEventCategory category ->
            let
                updatedCategories =
                    EventCategory.set category True model.selectedEventCategories
            in
            ({ model | selectedEventCategories = updatedCategories }, Cmd.none)

        DeselectEventCategory category ->
            let
                updatedCategories =
                    EventCategory.set category False model.selectedEventCategories
            in
            ({ model | selectedEventCategories = updatedCategories }, Cmd.none)



eventCategoryToMsg : ( EventCategory.EventCategory, Bool ) -> Msg
eventCategoryToMsg ( event, selected ) =
    if selected then
        SelectEventCategory event

    else
        DeselectEventCategory event


reposViewHelper : List (Html Msg) -> Html Msg
reposViewHelper items =
    div [ style "padding" "10px"]  items

view : Model -> Html Msg
view model =
    let
        eventCategoriesView =
            EventCategory.view model.selectedEventCategories |> Html.map eventCategoryToMsg

        eventsView =
            model.events
                |> List.filter (.category >> (\cat -> EventCategory.isEventCategorySelected cat model.selectedEventCategories))
                |> List.map Event.view
                |> div []
                |> Html.map never

        reposView =
            model.repos
                |> Repo.sortByStars
                |> List.take 6
                |> List.map Repo.view
                |> reposViewHelper  -- Use the defined reposView function with the style attribute
    in
    div []
        [ PersonalDetails.view model.personalDetails
        , h2 [] [ text "Experience" ]
        , eventCategoriesView
        , eventsView
        , h2 [] [ text "My top repositories " ]
        , reposView
        ]
