local Animation = { Meta = { } } ; Animation.Meta.__index = Animation.Meta

function Animation.new(affected, origin, target, easing, duration, playing)
    return setmetatable( { affected = affected
                         , origin   = origin
                         , target   = target
                         , easing   = easing
                         , duration = duration
                         , playing  = playing
                         , finished = false
                         , elapsed  = 0.0 }
                       , Animation.Meta )
end

function Animation.Meta:update(deltaTime)

    if self.finished or not self.playing then return end

    self.finished = self.elapsed >= self.duration

    for property, target_value in pairs(self.target) do

        local origin_value =  self.origin[property]
        local resolution   = #self.easing
        local index        = math.min(math.floor(1 + (self.elapsed / self.duration) * resolution), resolution)

        self.affected[property] = origin_value + (target_value - origin_value) * self.easing[ index ]
    end

    self.elapsed = self.elapsed + deltaTime

end

return Animation
