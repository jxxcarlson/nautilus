-- module Main exposing (..)


module Main exposing (..)

import Graphics.Render
    exposing
        ( Shape
        , group
        , angle
        , solid
        , rectangle
        , opacity
        , ellipse
        , filled
        , bordered
        , filledAndBordered
        , position
        , svg
        )
import Color exposing (rgb)
import Iterate exposing (orbit, iterate)


{-| For the purposes of this demo, an AbstractShape is a rectangle
-}
type alias AbstractShape =
    { x : Float, y : Float, w : Float, h : Float, angle : Float }


render r =
    let
        s =
            rectangle r.w r.h
                |> bordered 1 (solid <| rgb 0 0 0)
                |> position ( r.x, r.y )
    in
        (angle (rad r.angle) s)


{-| Tranlsate a shape by tx, ty.
-}
translate : Float -> Float -> AbstractShape -> AbstractShape
translate tx ty s =
    { s | x = s.x + tx, y = s.y + ty }


{-| Scale a shape by kx, ky
-}
scale : Float -> Float -> AbstractShape -> AbstractShape
scale kx ky s =
    { s | w = kx * s.w, h = ky * s.h }


{-| Scale a shape by kx, ky leaving the upper-right corner fixed.
-}
cscale : Float -> Float -> AbstractShape -> AbstractShape
cscale kx ky s =
    let
        phi =
            rad s.angle

        w =
            s.w * (cos phi) - s.h * (sin phi)

        h =
            s.w * (sin phi) + s.h * (cos phi)
    in
        { s | x = s.x - (1 - kx) * w / 2, y = s.y - (1 - ky) * h / 2, w = kx * s.w, h = ky * s.h }


{-| Rotate a shape by a given angle (in degrees), leaving the upper-right corner fixed.
-}
crotate : Float -> AbstractShape -> AbstractShape
crotate angle s =
    let
        phi =
            rad s.angle

        theta =
            rad angle

        w =
            s.w * (cos phi) - s.h * (sin phi)

        h =
            s.w * (sin phi) + s.h * (cos phi)

        dx =
            0.5 * (-w + w * (cos theta) - h * (sin theta))

        dy =
            0.5 * (-h + w * (sin theta) + h * (cos theta))
    in
        { s | x = s.x + dx, y = s.y + dy, angle = s.angle + angle }


{-| Conversion: degrees to radians
-}
rad deg =
    (3.1416 / 180.0) * deg


baseShape =
    AbstractShape 0 0 200 100 0


{-| Generate a figure by repeated;ly appling a transformation to a base shape.
In this case, the transformation is rotate by -10 degrees and scale by 0.95.
Eighty transforms of the base shape are generated.
-}
shapes =
    orbit ((crotate -10) >> (cscale 0.95 0.95)) 80 baseShape |> List.map (translate 300 300)


{-| Render the list of abstract shapes.
-}
main =
    group (List.map render shapes) |> svg 0 0 500 500
