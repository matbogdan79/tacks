module Screens.Layout where

import Html exposing (..)
import Html.Attributes exposing (..)

import Screens.Sidebar as Sidebar
import Constants exposing (..)
import AppTypes exposing (..)

import Transit


layoutWithNav : String -> Context -> List Html -> Html
layoutWithNav name ctx content =
  layout name
    (Sidebar.view ctx)
    [ div
        [ class "padded"
        , style (Transit.slideLeftStyle ctx.transition)
        ]
      content
    ]

layout : String -> List Html -> List Html -> Html
layout name sideContent mainContent =
  div
    [ class ("layout " ++ name) ]
    [ aside
        [ style [ ("width", toString sidebarWidth ++ "px") ] ]
        sideContent
    , main' [ ] mainContent
    ]

