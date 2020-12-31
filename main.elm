import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)

main = Browser.sandbox{init=init, view=view, update=update}

type alias Model = {color:String, x:Int, y:Int, drag_now:Bool, offsetX:Int, offsetY:Int}

init : Model
init = {color = "#000000", x = 270, y = 270, drag_now = False, offsetX=0, offsetY=0}


type Msg = NoOp
         | Down
         | Up
         | Move Int Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    Down -> {model | drag_now = True}
    Up -> {model | drag_now = False}
    Move x y ->
      if not model.drag_now then
        {model | offsetX = x - model.x, offsetY = y - model.y}
      else
        {model | x = x - model.offsetX, y = y - model.offsetY}
    _ -> model

view : Model -> Html Msg
view model =
  div[ style "position" "relative"
    , style "background" "#eee"
    , style "height" "100vh"
    , on "mousemove" (map2 Move (field "clientX" int) (field "clientY" int))
    , onMouseUp Up
  ]
  [ div
    [ style "position" "absolute"
    , style "top" <| String.fromInt model.y ++ "px"
    , style "left" <| String.fromInt model.x ++ "px"
    , style "width" "60px"
    , style "height" "60px"
    --, style "border-radius" "50%"
    , style "background" model.color
    , onMouseDown Down
    ]
    []
  ]
