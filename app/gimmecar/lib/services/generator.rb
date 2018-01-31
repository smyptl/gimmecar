class Lib::Services::Generator

  attr_reader :attributes

  class << self
    def object
    end

    def collection
    end
  end

  def initialize()
    @attributes = ActiveSupport::HashWithIndifferentAccess.new
  end

  def object(name, as: nil)
    generator = Lib::Services::Generator.new
    yield generator if block_given?
    @attributes[name] = { type: :object, as: as, value: generator.fetch }
    self
  end

  def collection(name, as: nil)
    generator = Lib::Services::Generator.new
    yield generator if block_given?
    @attributes[name] = { type: :collection, as: as, value: generator.fetch }
    self
  end

  def generated_at(value = true)
  end

  def values(*args)
  end

  def value
  end

  def id(as)
    @attributes[:id] = { type: value, as: as }
    self
  end

  def fetch
    @attributes
  end
end
