module Game.RenderSvg.Tiles where

import Game.Models exposing (..)
import Models exposing (..)

import Game.Grid as Grid exposing (getTilesList)

import Game.Render.SvgUtils exposing (..)
import Game.Render.Utils exposing (..)
import Game.RenderSvg.Gates exposing (..)

import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Lazy exposing (..)

lazyRenderTiles : Grid -> Svg
lazyRenderTiles grid =
  lazy renderTiles grid

renderTiles : Grid -> Svg
renderTiles grid =
  let
    tiles = List.map renderTile (getTilesList grid)
  in
    g [ ] tiles

renderTile : Tile -> Svg
renderTile {kind, coords} =
  let
    (x,y) = Grid.hexCoordsToPoint coords
    color = tileKindColor kind
    hex = polygon
      [ points verticesPoints
      , fill color
      , stroke color
      , strokeWidth "1"
      ]
      []
    label = text'
      [ fill "black"
      , textAnchor "middle"
      , fontSize "10px"
      ]
      [ text (toString coords) ]
  in
    g [ transform ("translate(" ++ toString x ++ ", " ++ toString y ++ ")") ]
      [ hex ]

tileKindColor : TileKind -> String
tileKindColor kind =
  case kind of
    Water -> colorToSvg colors.water
    Grass -> colorToSvg colors.grass
    Rock -> colorToSvg colors.rock

verticesPoints : String
verticesPoints =
  toSvgPoints vertices

vertices : List Point
vertices =
  let
    (w,h) = Grid.hexDims
    w2 = w / 2
    h2 = h / 2
    h4 = h / 4
  in
    [ (-w2, -h4)
    , (0, -h2)
    , (w2, -h4)
    , (w2, h4)
    , (0, h2)
    , (-w2, h4)
    ]

toSvgPoints : List Point -> String
toSvgPoints points =
  points
    |> List.map (\(x, y) -> toString x ++ "," ++ toString y)
    |> String.join " "

