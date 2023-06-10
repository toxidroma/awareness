import abs, min, max, floor, random
    Clamp from math

class MeterLabel extends LLabelCompute
    new: (...) =>
        super ...
        @origin = 
            x: 0
            y: 0
    Compute: =>
        data = @GetParent!\ComputeData!
        @lastData = data unless @lastData
        if data != @lastData
            @TextColor[k] = floor min(v*1.666, 255) for k, v in pairs @TextColor
            @SetColor @TextColor
            @jitter = abs(data - @lastData)
        @lastData = data
        "#{data}%"
    Think: =>
        super!
        @TextColor[k] = Clamp floor(Lerp FrameTime!*.13, v, @GetParent!.TextColor[k]), 0, 255 for k, v in pairs @TextColor
        if @jitter
            @jitter = Lerp FrameTime!*2.3, @jitter, 0
            @SetPos floor(@origin.x + random -@jitter, @jitter), floor(@origin.y + random -@jitter, @jitter)

class Meter extends LFrame
    Font: 'CloseCaption_Bold'
    TextColor: Color 200, 200, 200, 255
    ComputeData: =>
    new: (...) =>
        super ...
        @SetTitle @@__name
        with @lblData = MeterLabel!
            @Add @lblData
            \Center!
            x, y = \GetPos!
            .origin =
                :x
                :y
            \SetContentAlignment 5
            c = @TextColor
            \SetTextColor Color c.r, c.g, c.b, c.a
            \SetFont @Font
    
class Health extends Meter
    ComputeData: => LocalPlayer!\Health!
    TextColor: Color 128, 0, 0, 255

class Armor extends Meter
    ComputeData: => LocalPlayer!\Armor!
    TextColor: Color 0, 0, 128, 255

{
    :Health
    :Armor
}