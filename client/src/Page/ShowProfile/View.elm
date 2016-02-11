module Page.ShowProfile.View where

import Html exposing (..)
import Html.Attributes exposing (..)

import AppTypes exposing (..)
import Models exposing (..)

import Page.ShowProfile.Model exposing (..)

import View.Utils exposing (..)
import View.Layout as Layout


view : Context -> Screen -> Html
view ctx {player} =
  Layout.layoutWithNav "show-profile" ctx
    [ container ""
      [ img [ class "avatar avatar-user", src (avatarUrl player), width 160, height 160 ] []
      , h1 [ ] [ text <| playerHandle player ]
      ]
    ]
