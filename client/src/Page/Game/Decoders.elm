module Page.Game.Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Decoders exposing (..)
import Game.Decoders exposing (..)
import Page.Game.Model exposing (..)
import Page.Game.Chat.Model as Chat


decodeStringMsg : String -> Msg
decodeStringMsg raw =
    Json.decodeString Json.value raw
        |> Result.map decodeMsg
        |> Result.withDefault NoOp


decodeMsg : Json.Value -> Msg
decodeMsg value =
    case Json.decodeValue msgDecoder value of
        Err e ->
            NoOp

        Ok msg ->
            msg


msgDecoder : Decoder Msg
msgDecoder =
    (field "tag" string) |> andThen specificMsgDecoder


specificMsgDecoder : String -> Decoder Msg
specificMsgDecoder tag =
    case tag of
        "NoOp" ->
            succeed NoOp

        "RaceUpdate" ->
            map RaceUpdate (field "raceUpdate" raceInputDecoder)

        "LiveTrack" ->
            map UpdateLiveTrack (field "liveTrack" liveTrackDecoder)

        "Message" ->
            map (ChatMsg << Chat.AddMessage) (field "message" messageDecoder)

        _ ->
            fail <| tag ++ " is not a recognized tag for msgs"
