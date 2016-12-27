class Lib::NilObject

  def method_missing(*_)
    nil
  end

  def respond_to_missing?(*_)
    true
  end
end
