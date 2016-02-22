module Page.Forum.NewTopic.Update where

import Task exposing (Task, succeed, andThen)
import Effects exposing (Effects, Never, none, map)
import Response exposing (..)
import Json.Encode as Json

import Form

import Page.Forum.Decoders exposing (..)
import Page.Forum.NewTopic.Model exposing (..)
import ServerApi exposing (getJson, postJson)


update : Action -> Model -> Response Model Action
update action ({form, loading} as model) =
  case action of

    FormAction fa ->
      let
        newForm = Form.update fa model.form
      in
        res { model | form = newForm } none

    Submit newTopic ->
      taskRes { model | loading = True } (createTopic newTopic)

    SubmitResult result ->
      res { model | loading = False } none

    NoOp ->
      res model none


createTopic : NewTopic -> Task Never Action
createTopic {title, content} =
  let
    body = Json.object
      [ ("title", Json.string title)
      , ("content", Json.string content)
      ]
  in
    postJson topicDecoder "/api/forum/topics" body
      |> Task.map SubmitResult
