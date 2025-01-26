local Interpolation =
    { Resolution =
      { Low      = 512
      , Medium   = 1024
      , High     = 2048
      , Ultra    = 4096 }
    , Tolerance  =
      { Low      = 0.001
      , Medium   = 0.0001
      , High     = 0.00001
      , Ultra    = 0.000001 }
    , Attempts   =
      { Low      = 64
      , Medium   = 128
      , High     = 256
      , Ultra    = 512 } }

function Interpolation.Cubic(a, b, c, d, t)
    return (1 - t) ^ 3 * a + 3 * (1 - t) ^ 2 * t * b + 3 * (1 - t) * t ^ 2 * c + t ^ 3 * d
end

function Interpolation.Derivative(a, b, c, d, t)
    return 3 * (1 - t) ^ 2 * (b - a) + 6 * (1 - t) * t * (c - b) + 3 * t ^ 2 * (d - c)
end

function Interpolation.SolveBinary(a, b, c, d, attempts, tolerance, progress)

    local t_low = 0
    local t_mid = 0.5
    local t_top = 1

    for _ = 1, attempts do

        local mid = Interpolation.Cubic(a, b, c, d, t_mid)

        if math.abs(mid - progress) < tolerance then break end

        if mid < progress then
            t_low = t_mid
        else
            t_top = t_mid
        end

        t_mid = (t_low + t_top) / 2

    end

    return t_mid

end

function Interpolation.SolveNewtonRaphson(a, b, c, d, attempts, tolerance, progress)

    local t = 0.5

    for _ = 1, attempts do

        local dx_t = Interpolation.Derivative(a, b, c, d, t)

        if dx_t == 0 then
            return Interpolation.SolveBinary(a, b, c, d, attempts, tolerance, progress) 
        end
        
        local x_t = Interpolation.Cubic(a, b, c, d, t)

        local dx_p = x_t - progress

        if math.abs(dx_p) < tolerance then break end

        t = t - (dx_p / dx_t)
    end

    return t

end

function Interpolation.Compile(a_x, a_y, b_x, b_y, attempts, tolerance, resolution)

    attempts   = attempts   or Interpolation.Attempts.Ultra
    tolerance  = tolerance  or Interpolation.Tolerance.Ultra
    resolution = resolution or Interpolation.Resolution.Ultra

    local compiled = { 0 }
    
    for step = 2, resolution - 1 do

        local t = (step - 1) / resolution

        compiled[step] =
            Interpolation.Cubic(0, a_y, b_y, 1,
                Interpolation.SolveNewtonRaphson(0, a_x, b_x, 1, attempts, tolerance, t))
    end

    compiled[resolution] = 1

    return compiled

end

return Interpolation
