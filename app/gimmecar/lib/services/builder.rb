class Lib::Services::Builder

  class_attribute :_output
  self._output = nil

  class << self
    def component
      n = self.new(type: :component, name: nil, options: {})
      yield n
      self._output = n.retrieve
    end

    def retrieve
      self._output.fetch(:attributes)
    end

    def object(name, options = {})
      n = self.new(type: :object, name: name, options: options)
      yield n if block_given?
      n.retrieve
    end

    def collection(name, options = {})
      n = self.new(type: :collection, name: name, options: options)
      yield n if block_given?
      n.retrieve
    end
  end

  def initialize(type: nil, name: nil, options: {})
    @_output = {}
    @_output[:type]       = type
    @_output[:name]       = name
    @_output[:options]    = options
    @_output[:attributes] = {}

    component(options[:component]) if options[:component]
  end

  def object(name, options = {})
    generator = Lib::Services::Builder.new
    generator.component(options[:component]) if options[:component]
    yield generator if block_given?
    add_attribute(name, { name: name, type: :object, options: options, attributes: generator.retrieve.fetch(:attributes) })
  end

  def collection(name, options = {})
    generator = Lib::Services::Builder.new
    generator.component(options[:component]) if options[:component]
    yield generator if block_given?
    add_attribute(name, { name: name, type: :collection, options: options, attributes: generator.retrieve.fetch(:attributes) })
  end

  def component(klass)
    @_output[:attributes] = klass.retrieve.deep_merge(@_output[:attributes])
  end

  def values(args, options = {})
    args.each do |arg|
      value(arg, options)
    end
  end

  def value(name, options = {})
    add_attribute(name, { :name => name, :type => :value, :options => options })
  end

  def id(as = nil)
    add_attribute(:id, { :name => :id, :type => :value, :options => { :as => as }})
  end

  def retrieve
    @_output
  end

  private

  def add_attribute(name, options)
    @_output.fetch(:attributes)[name.to_sym] = options
  end
end
