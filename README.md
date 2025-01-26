# Animate
A very simple and robust animations library implemented in Lua; intended to be used with [Love2D](https://www.love2d.org/).

# Interpolations
Import the Interpolation module:
```lua
local Interpolation = require "Animate.Interpolation"
```
Compile a Cubic Bézier-Curve of your liking (E.g. `(.5, 0); (.5, 1)`):
```lua
easeInOut = Interpolation.Compile(0.5, 0.0, 0.5, 1.0)
```

> [!WARNING]
> Be sure to compile curves only once on loading/setup, as curves can be re-utilized between animations and compiling 'on demand' is very costly.

> [!CAUTION]
> Extremely large values for Resolution, although creating better interpolations, will use a lot of memory. (8 Bytes per 1 Resolution; Ultra [4096] resolution will consume approximately 33KB).

# Animations
Import the Animation module:
```lua
local Animation = require "Animate.Animation"
```
Create an animation that is bound to a table (E.g. Opacity from 1 to 0 in 5 seconds, ease-in-out, already playing):
```lua
animation = Animation.new(bound_table, { opacity = 1 }, { opacity = 0 }, 5, easeInOut, true)
```

> [!NOTE]
> Here we are utilizing the pre-compiled easing table [`easeInOut`](#interpolations).

Lastly, update the animation in your Game Loop / Animation Loop by passing in Delta Time in seconds:
```lua
animation:update(deltaTime)
```
