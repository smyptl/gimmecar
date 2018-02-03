class Lib::Services::Builder

  class_attribute :_output
  self._output = nil

  class << self
    def output
      n = self.new
      yield n
      self._output = n.fetch[:attributes]
    end

    def fetch
      self._output
    end

    def object(name, options = {})
      n = self.new(type: :object, name: name, options: options)
      yield n
      n.fetch
    end

    def collection(name, options = {})
      n = self.new(type: :collection, name: name, options: options)
      yield n
      n.fetch
    end
  end

  def initialize(type: nil, name: nil, options: {})
    @_output = ActiveSupport::HashWithIndifferentAccess.new
    @_output[:type]       = type
    @_output[:name]       = name
    @_output[:options]    = options
    @_output[:attributes] = {}
  end

  def object(name, options = {})
    generator = output[:output] || Lib::Services::Generator.new
    yield generator if block_given?
    add_attributes(name, { :type => :object, :options => options, :attributes => generator.fetch })
  end

  def collection(name, options = {})
    generator = options[:output] || Lib::Services::Generator.new
    yield generator if block_given?
    add_attributes(name, { :type => :collection, :options => options, :attributes => generator.fetch })
  end

  def component(klass, options = {})
    @_output[:attributes] = klass.fetch.deep_merge(@_output[:attributes])
  end

  def values(args, options = {})
    args.each do |arg|
      value(arg, options)
    end
  end

  def value(name, options = {})
    add_attribute(name, { :type => :value, :options => options })
  end

  def id(as = nil)
    add_attribute(:id, { :type => :value, :options => { :as => as }})
  end

  def fetch
    @_output
  end

  private

  def add_attribute(name, options)
    @_output[:attributes][name.to_sym] = options
  end
end
