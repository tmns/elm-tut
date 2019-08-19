module Main exposing (..)
import Html exposing (..)


-- MODEL

type Model
  = DisplayingRoom DoorState AlarmState
  | Failure String

type DoorState
  = Opened
  | Closed
  | Locked

type AlarmState
  = Armed
  | Disarmed
  | Triggered

-- UPDATE

type Msg
  = Open
  | Close
  | Lock
  | Unlock
  | Arm
  | Disarm

update : Msg -> Model -> Model
update msg model =
  case model of
    DisplayingRoom doorState alarmState ->
      case doorState of
        Opened ->
          case msg of
            Close ->
              DisplayingRoom Closed alarmState
            _ ->
              Failure "Unexpected message received while door was in Opened state."
        Closed ->
          case msg of
            Open ->
              case alarmState of
                Armed ->
                  DisplayingRoom Opened Triggered
                _ ->
                  DisplayingRoom Opened alarmState
            Lock ->
              DisplayingRoom Locked alarmState
            Arm ->
              DisplayingRoom Closed Armed
            Disarm ->
              DisplayingRoom Closed Disarmed
            _ ->
              Failure "Unexpected message received while door was in Closed state."
        Locked ->
          case msg of
            Unlock ->
              DisplayingRoom Closed alarmState
            Arm ->
              DisplayingRoom Locked Armed
            Disarm ->
              DisplayingRoom Locked Disarmed
            _ ->
              Failure "Unexpected message received while door was in Locked state."
    Failure errorMessage ->
      model

-- VIEW

failure message =
  div []
    [ p [] [ text message ] ]