--[[
--
--
--

Copyright 2017 Muresan Vlad Mihail

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.



--
--
--]]


anim = {}
anim.__index = anim

--constructor
-- width of the animation frame
-- height of the animation frame 
function anim.create(img,width,height)
    local self = {}

    self.img = img
    self.w = width
    self.h = height
    self.fx = 0
    self.fy = 0
    self.frames = {}
    self.imgW,self.imgH = img:getDimensions()
    self.currFrame = 0
    self.currSpeed = 0
    self.loop = true
    self.stop = false
    self.custom = false
    self.stopFrame = nil
    self.startFrame = 1
    self.f = 0
    return setmetatable(self,anim)
end

--private function,it should not be called by user
function anim:makeFrame()
    if self.f == 0 then
        self.f = math.floor(self.imgW / self.w * self.imgH / self.h)
    end
    self.fx = math.floor(self.imgW / self.w)
    for i =1, self.f do
        local row = math.floor((i-1)/self.fx)
        local column = (i-1)%self.fx
        table.insert(self.frames, love.graphics.newQuad(column*self.w,row*self.h,self.w,self.h,self.imgW,self.imgH))
    end
end

--Lets say you got an animation from frame eg: 1 through 4. If your current frame reached the end,in this case 4,
--then this func will return true. If the animation is looped you'll get multiple returns of "true" else only once
function anim:reached_end()
    if self.currFrame >= self.stopFrame then
        return true
    else
        return false
    end
end

--optional: set at what frame from your spritesheet you want to have the animation start at
function anim:setStartFrame(startFrame)
    self.startFrame = startFrame
    self.currFrame = self.startFrame
end

--optional: set at what frame from your spritesheet you want to have the animation stop at
function anim:setStopFrame(stopFrame)
    self.stopFrame = stopFrame
end

--set a start frame eg: 1 and a stop frame eg: 4 then the speed at which the frames should change
function anim:add(startFrame, stopFrame, speed)
    self.speed = speed or 0
    self:makeFrame()
    self.stopFrame = stopFrame or #self.frames
    self.startFrame = startFrame or 1
end

--set manually your quads in this case anim:add will not work.
--[[ e.g: 
local idle_shoot_quad = 
-{
love.graphics.newQuad(36*0,0,36,42,PLAYER_IMG:getDimensions()),
love.graphics.newQuad(36*2,0,36,42,PLAYER_IMG:getDimensions())
}
--]]
function anim:addf(frames, speed)
    self.speed = speed
    self.custom = true
    table.insert(self.frames, frames)
end

--draw your animation 
-- x and y are mandatory 
function anim:draw(x, y, rot, sx, sy, kx, ky)
    rot = rot or 0
    sx = sx or 1
    sy = sy or 1
    kx = kx or 0
    ky = ky or 0
    if self.frames then
        if not self.custom then
            love.graphics.draw(self.img,self.frames[self.currFrame],x,y,rot,sx,sy,kx,ky)
        else
            for i,v in pairs(self.frames) do
                love.graphics.draw(self.img,v[self.currFrame],x,y,rot,sx,sy,kx,ky)
            end
        end
    else
        love.graphics.draw(self.img, x, y, rot, sx, sy, kx, ky)
    end
end

--when you reach a certain frame stop the frame
function anim:stopAt(frame)
    if self.currFrame == frame then
        self.currFrame = frame
        self.stop = true
    end
end

function anim:getLength()
    return #self.frames
end 

--pause the current anim
function anim:pause()
    self.stop = true
end

--resume the last frame and continue doing the animation
function anim:resume()
    self.stop = false
end

--change your current active frame to something custom. Eg: Your current frame is at 2 this func allows you to change it at eg 10
function anim:setFrame(frame)
    self.currFrame = frame
end

--return the current frame
function anim:getFrame()
    return self.currFrame
end


--update method: loop = whether or not this anim should be looped
function anim:play(loop)
    if not self.stop then
        self.loop = loop
        self.currSpeed = self.currSpeed + love.timer.getDelta()
        --increment the currentFrame when needed
        if self.speed > 0 then
            if self.currFrame == 0 and self.startFrame >= 1 then
                self.currFrame = self.startFrame
            end
            if self.currSpeed >= self.speed then
                self.currFrame = self.currFrame + 1
                self.currSpeed = 0
            end
			--[[
			-- Note:
			-- When you have no speed attached to your animation that means
			-- you want to play only the first quad added in 'add' function
			--]]
		elseif self.speed == 0 then
			self.currFrame = self.startFrame
        end
        --do we have custom quads?
        if not self.custom then
            --we dont
            if self.stopFrame == nil then
                if self.currFrame > #self.frames then
                    if(self.loop) then
                        if self.startFrame >= 1 then
                            self.currFrame = self.startFrame
                        else
                            self.currFrame = 1
                        end
                    else
                        self.currFrame = #self.frames
                    end
                end
            else
                --we got a stopframe
                if self.currFrame > self.stopFrame then
                    if self.loop then
                        if self.startFrame > 0 then
                            self.currFrame = self.startFrame
                        end
                    else
                        self.currFrame = self.stopFrame
                    end
                end
            end
        else
            --we do
            for i,v in pairs(self.frames) do
                if self.currFrame > #v then
                    if(self.loop) then
                        self.currFrame = 1
                    else
                        self.currFrame = #v
                    end
                end
            end
        end
    end
end
