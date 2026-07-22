module MessageConfig
  VERY_SMALL_FONT_NAME          = "Power Green Small"
  VERY_SMALL_FONT_SIZE          = 10
  VERY_SMALL_FONT_Y_OFFSET      = 0
  @@verySmallFont       = nil

  def self.pbDefaultVerySmallFontName
    return MessageConfig.pbTryFonts(VERY_SMALL_FONT_NAME)
  end

  def self.pbGetVerySmallFontName
    @@verySmallFont = pbDefaultVerySmallFontName if !@@verySmallFont
    return @@verySmallFont
  end

  def self.pbSetVerySmallFontName(value)
    @@verySmallFont = MessageConfig.pbTryFonts(value)
    @@verySmallFont = MessageConfig.pbDefaultVerySmallFontName if @@verySmallFont == ""
  end

  def self.pbSetVerySmallFont(bitmap)
    return if !bitmap
    bitmap.font.name = pbGetVerySmallFontName
    bitmap.font.size = VERY_SMALL_FONT_SIZE
    bitmap.text_offset_y = VERY_SMALL_FONT_Y_OFFSET
    bitmap.font.shadow = false if bitmap.font.respond_to?("shadow")
  end
  
end