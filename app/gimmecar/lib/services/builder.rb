class Lib::Services::Builder

  class_attribute :_output

  class << self
    def component
      n = self.new(type: :component, name: nil, options: {})
      yield n
      self._output = n.retrieve_attributes
    end

    def retrieve_attributes
      self._output
    end

    def nested(name, **options)
      n = self.new(type: :nested, name: name, **options)
      yield n if block_given?
      self._output = n.retrieve
    end

    def object(name, **options)
      n = self.new(type: :object, name: name, **options)
      yield n if block_given?
      self._output = n.retrieve
    end

    def collection(name, **options)
      n = self.new(type: :collection, name: name, **options)
      yield n if block_given?
      self._output = n.retrieve
    end
  end

  attr_reader :output

  def initialize(name: nil, type: nil, **options)
    @output = {
      name: name,
      type: type,
      options: options,
      attributes: {},
      links: []
    }

    component(options[:component]) if options[:component]
  end

  def object(name, **options, &block)
    builder(name, :object, options, &block)
  end

  def collection(name, **options, &block)
    builder(name, :collection, options, &block)
  end

  def nested(name, **options, &block)
    builder(name, :nested, options, &block)
  end

  def component(klass)
    output[:attributes] = klass.retrieve_attributes.deep_merge(retrieve_attributes)
  end

  def attributes(*args, **options)
    args.each do |arg|
      attribute(arg, options)
    end
  end

  def attribute(name, **options)
    name = name.to_sym

    add_attribute(name, { name: name, type: :attribute, options: options })
  end

  def id(as = nil)
    add_attribute(:id, { name: :id, type: :attribute, options: { as: as }})
  end

  def retrieve
    output
  end

  def retrieve_attributes
    output.fetch(:attributes)
  end

  private

  def builder(name, type, **options, &block)
    add_attribute(name, {
      name: name,
      type: type,
      options: options,
      attributes: new_builder(options[:component], &block).retrieve_attributes
    })
  end

  def new_builder(component, &block)
    builder = Lib::Services::Builder.new
    builder.component(component) if component

    yield builder if block_given?

    builder
  end

  def add_attribute(name, options)
    output[:attributes][name.to_sym] = options
  end
end
