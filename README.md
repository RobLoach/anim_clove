Usage
-------

Simple and easy to use library for animations 
written in Lua for (C)Love(see github).

For documentation see anim.lua

```lua
require "anim"

    function love.load() 
        currentAnim = aim.create(love.graphics.newImage("myimg.png"), 16, 16)
        currentAnim:add(1, 3, .3)
    end

    function love.update(dt)
        currentAnim:play()
    end

    function love.draw()
        currentAnim:draw(100, 100)
    end

```
