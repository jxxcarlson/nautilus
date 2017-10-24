This is a demo of the Kwarrtz/render library.  We will make a Nautilus figure
by repeatedly rotating and scaling a base image with respect to one corner.
For this we use the `orbit` function in the `Iterate` module.

To generate the app, run `elm-make Nautilus.elm --output nautilus.html`, then open `nautilus.html` in a browser.

You can play around with this line in `Nautilus.elm`
```
shapes =
    orbit ((crotate -10) >> (cscale 0.95 0.95)) 80 baseShape |> List.map (translate 300 300)
```
Here `-10` means "rotate 10 degrees counterclockwise," `cscale 0.95 0.95` means
"scale the given figure by a factor of 0.95".  The `80` sets the number of transformed
shapes to be generated.

![Alt text](nautilus.png?raw=true "Nautilus")
