Usage
-------

Simple and easy to use library for animations 
written in Lua for (C)Love.

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

```cl 
(do
  (love:window-setMode 800 600)

  (= image (love:graphics-newImage "quad.png"))

  (= a (anim:create image 8 16))
  (anim:add a 1 3 0.5)

  (= b (anim:create image 8 16))
  (anim:add b 1 3 1.5)


  (= running t)
  (loop (and (not (love:event-quit)) (eq running t)) 
		(love:graphics-clear)
		(love:graphics-origin)
		(love:keyboard-update)	
		(love:timer-step)
		
		(anim:draw a 200 200 0 1 1 0 0)
		(anim:play a t)

		(anim:draw b 250 250 0 1 1 0 0)
		(anim:play b t)



		; Trigger exit code 
		(when (eq (love:keyboard-keypressed) 27) (= running nil))

		(love:graphics-swap) )
 
)
```
