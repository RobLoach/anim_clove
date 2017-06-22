Usage
-------

Simple and easy to use library for animations 
written in Lua for (C)Love(see github).

For documentation see anim.lua

```lua
require "anim"

    function love.load() 
        -- image to load, width of frame, height of frame
        currentAnim = aim.create(love.graphics.newImage("myimg.png"), 16, 16)
        -- startFrame, stopFrame, speed
        currentAnim:add(1, 3, .3)
    end

    function love.update(dt)
        -- pass true if you want it to be looped
        currentAnim:play()
    end

    function love.draw()
        -- x, y, rot, sx, sy, kx, ky
        currentAnim:draw(100, 100)
    end

```
