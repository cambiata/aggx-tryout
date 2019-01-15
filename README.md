# Aggx Tryout

This is a testproject to get going with Gameduell's port (https://github.com/gameduell/aggx/) of the Antigrain Geometry Library (http://www.antigrain.com/)

According to Gameduell, the Aggx library isn't maintained anymore (https://github.com/gameduell/vectorx/issues/25#issuecomment-439914005) and the code is almost untouched since 2016. However, since it's a great library with font rendering (including kerning etc), SVG rendering etc, I find it worth a try to get it going.

As originally a part of Gameduell's multiplatform tooling system, it's not that easy to get started. I have tried some times to use the Duell build tools (installing the dependencies and compiling that way) and got it working a couple of years ago, but no success today. (To many errors that I don't have time to sort out.) 
As a result, the strategy here has been to strip away everything but the bare bones to get something running.

## Original demos and test

Please have a look at 
- types tests: https://github.com/gameduell/types/tree/master/tests/Source
- aggx examples: https://github.com/gameduell/aggx/tree/master/examples/source/tests


## Code changes and strategies

The original aggx files are put into the **src** folder. Haven't touched them except for changing some UInts to Ints to get flash target to compile.

The original aggx tests and demos rely heavily on Gameduell's multiplatform **types** library, including the Data class. The platform-common parts of the **types** lib have been moved into the **src** folder.

The original aggx demos use Gameduell's multiplatform **filesystem** library, wich is (and has to be) complicated. To avoid that, I'm just including the assets as haxe resources right now.

Gameduell also have the vectorx library (https://github.com/gameduell/vectorx) that builds on aggx.
This migth be worth looking into for the future.

## FontEngine example

Just one working example this far. It kicks of the fontengine and uses a simple test renderer just to see the resulting data (typeface outline coordinates, I suppose). No graphical output!

## SVG rendering example

Hope to find time to try this out soon.

## JS (node and browser) and Flash right now

I have only tried the examples using js and flash. Included in the Gameduell aggx lib are c++ specific implementations of the types library etc., so I guess that it will be quite easy to get something out using c++ also.

## OpenGL and Duell tools - further reading

The other day, I stumbled over the following bachelor work of Alexis Iakovenko-Marinitch, explaining how to use Haxe and Gameduell's build tools together with OpenGL. Great, I guess, if you want to explore the Duell infrastructure and knot aggx and OpenGL together.

[A Haxe Implementation of Essential
OpenGL Examples Using Duell Tool](http://www.mi.fu-berlin.de/inf/groups/ag-ki/Theses/Completed-theses/Bachelor-theses/2016/Iakovenko/Bachelor-Iakovenko.pdf)

# Credits

All credits to
- Maxim Shemanarev (http://www.antigrain.com)
- GameDuell GmbH (https://inside.gameduell.com/)
- [Sven Dens](https://github.com/nensanders), [Dejan Dragic](https://github.com/dejan-gd) and others and Gameduell


