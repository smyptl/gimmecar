class DateTime

  def before?(date)
    self < date
  end

  def after?(date)
    self > date
  end
end