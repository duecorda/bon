module CustomUtils
 
  def self.hexToRGB(hex)
    hex = hex.gsub(/^#/,'')[0,6]
    hex.scan(/.{2}/).collect do |cc|
      cc.to_i(16)
    end
  end

  def self.rgbToHsv(r,g,b)
    r = r / 255.0
    g = g / 255.0
    b = b / 255.0
    max = [r,g,b].max
    min = [r,g,b].min
    delta = max - min
    v = max * 100
    s = max.zero? ? 0.0 : delta / max * 100

    if s.zero?
      h = 0.0
    else
    end

    if delta.zero?
      h = s = 0.0;
    else
      h = case max
        when r
          (g - b) / delta
        when g
          2 + (b - r) / delta
        when b
          4 + (r - g) / delta
      end

      h = h * 60.0;
      if(h < 0)
        h += 360.0
      end
    end

    [h,s,v]
  end

  def self.rgbToHsl(r,g,b)
    r = r / 255.0
    g = g / 255.0
    b = b / 255.0
    max = [r,g,b].max
    min = [r,g,b].min
    delta = max - min

    l = (max + min) / 2 * 100;

    if delta.zero?
      h = s = 0.0;
    else
      s = (l > 0.5 ? delta / (2 - max - min) : delta / (max + min)) * 100
      h = case max
        when r
          (g - b) / delta
        when g
          2 + (b - r) / delta
        when b
          4 + (r - g) / delta
      end

      h = h * 60.0;
      if(h < 0)
        h += 360.0
      end
    end

    [h,s,l]
  end

end
