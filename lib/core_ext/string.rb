class String

  def to_slug
    #strip the string
    ret = self.strip.downcase

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with dash
     ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'

     #convert double underscores to single dash
     ret.gsub! /_+/,"-"

     #strip off leading/trailing underscore
     ret.gsub! /\A[_\.]+|[_\.]+\z/, ""

     ret
  end

  def possessive
    return self if self.empty?
    self + ('s' == self[-1,1] ? "'" : "'s")
  end
end
