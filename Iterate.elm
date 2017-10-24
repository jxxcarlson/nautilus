module Iterate exposing (iterate, extend, orbit)

{-| Module Iterate giveś an easy way to

(1) compute f^n(a)

(2) compute orbits, e.g., [a, f(a), f(f(a)), ...]

-}


{-| iterate n f a: Compute f^n(a)

  Example:
  > import Iterate as I
  > I.iterate (\x -> 2*x) 5 1
  32 : number

-}
iterate : (a -> a) -> Int -> a -> a
iterate f n a =
    if n == 0 then
        a
    else
        iterate f (n - 1) (f a)


{-| extend f list: Apply the function f to the head of the list and then cons it to the
    head of the list.  Used to contruct lists like [f(f(f(a))), f(f(a)), f(a), a].

    Given: f has type a -> a
    Then:  extend f has type List a -> List a

    Example:
    > foo = [1]
    > f n = 2*n -- a function a -> a
    > g = I.extend f -- promote f to a function : List a -> List a

    > I.iterate 4 g foo
    [16,8,4,2,1] : List number

-}
extend : (a -> a) -> List a -> List a
extend f list =
    let
        h =
            List.head list
    in
        case h of
            Nothing ->
                list

            Just x ->
                f (x) :: list


{-| orbit f n a = [a, f(a), f^2(n), .., f^n(a)]

Example:
> I.orbit (\x -> 2*x) 5 1
[1,2,4,8,16,32] : List number

-}
orbit : (a -> a) -> Int -> a -> List a
orbit f n a =
    let
        g =
            extend f

        oo =
            iterate g n [ a ]
    in
        List.reverse oo
