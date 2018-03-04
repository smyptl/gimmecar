class Array
  def pluck(key)
    map { |hash| hash[key] }
  end
end
