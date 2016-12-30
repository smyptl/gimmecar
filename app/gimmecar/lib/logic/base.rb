class Lib::Logic::Base

  class << self
    def wrap(collection)
      collection.map { |c| new(c) }
    end

    def model(name)
      define_method(name) { __model__ }
    end
  end

  def initialize(model)
    @__model__ = model
  end

  private

  def __model__
    @__model__
  end

  def method_missing(meth, *args)
    __model__.send(meth, *args)
  end
end
