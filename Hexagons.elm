-- module Main exposing (..)


module Main exposing (..)

import Graphics.Render
    exposing
        ( Shape
        , Point
        , polygon
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


{-| For the purposes of this demo, an AbstractShape is a poygon
-}
type alias AbstractShape =
    { points : List Point, angle : Float }


render r =
    let
        s =
            polygon r.points
                |> bordered
                    1.0
                    (solid <| rgb 204 82 0)
                |> opacity 0.7
    in
        s


render2 r =
    let
        s =
            polygon r.points
                |> bordered
                    1.0
                    (solid <| rgb 0 0 255)
                |> opacity 0.7
    in
        s


addPoints : Point -> Point -> Point
addPoints a b =
    ( Tuple.first a + Tuple.first b, Tuple.second a + Tuple.second b )


scalePoint : Float -> Float -> Point -> Point
scalePoint kx ky point =
    ( kx * (Tuple.first point), ky * (Tuple.second point) )


rotatePoint : Float -> Point -> Point
rotatePoint angle point =
    let
        x =
            Tuple.first point

        y =
            Tuple.second point

        theta =
            rad angle

        xx =
            x * (cos theta) - y * (sin theta)

        yy =
            x * (sin theta) + y * (cos theta)
    in
        ( xx, yy )


rad deg =
    (3.1416 / 180.0) * deg


{-| Tranlsate a shape by tx, ty.
-}
translate : Float -> Float -> AbstractShape -> AbstractShape
translate tx ty s =
    let
        points =
            s.points

        newPoints =
            List.map (addPoints ( tx, ty )) points
    in
        AbstractShape newPoints s.angle


scale : Float -> Float -> AbstractShape -> AbstractShape
scale kx ky s =
    let
        points =
            s.points

        newPoints =
            List.map (scalePoint kx ky) points
    in
        AbstractShape newPoints s.angle


rotate : Float -> AbstractShape -> AbstractShape
rotate angle s =
    let
        points =
            s.points

        newPoints =
            List.map (rotatePoint angle) points
    in
        AbstractShape newPoints s.angle


a =
    (sqrt 3) / 2.0


baseShape =
    AbstractShape [ ( 0, 0 ), ( 1, 0 ), ( 1.5, a ), ( 1, 2 * a ), ( 0, 2 * a ), ( -0.5, a ) ] 0.0
        |> scale 100.0 100.0
        |> rotate 20


shapes =
    orbit ((rotate -10) >> (scale 0.95 0.95)) 80 baseShape
        |> List.map (translate 300 300)
        |> List.map render


main =
    group shapes |> svg 0 0 500 500
