class Lib::Attributes::Parser

  attr_reader :attributes

  class << self
    def parse(value, settings)
      if settings.fetch(:options)[:array]
        return [] if value.blank?
        value.map { |v| parse_value(v, settings) }.reject(&:blank?)
      else
        parse_value(value, settings)
      end
    end

    private

    def parse_value(value, settings)
      case settings.fetch(:type)
      when :nested
        parse_nested(value, settings)
      else
        Lib::Attributes::TypeCast.send(settings.fetch(:type), (value))
      end
    end

    def parse_nested(values, settings)
      return {} if values.blank?

      output = {}

      values.each do |attribute, value|
        value = parse_value(value, settings.fetch(:attributes).fetch(attribute))
        output[attribute] = value unless value.blank?
      end

      output
    end
  end

  def initialize
    @attributes = ActiveSupport::HashWithIndifferentAccess.new
  end

  def string(name, options = {})
    @attributes[name] = { :type => :string, :options => options }
  end

  def symbol(name, options = {})
    @attributes[name] = { :type => :symbol, :options => options }
  end

  def boolean(name, options = {})
    @attributes[name] = { :type => :boolean, :options => options }
  end

  def date(name, options = {})
    @attributes[name] = { :type => :date, :options => options }
  end

  def date_time(name, options = {})
    @attributes[name] = { :type => :date_time, :options => options }
  end

  def integer(name, options = {})
    @attributes[name] = { :type => :integer, :options => options }
  end

  def signature(name, options = {})
    @attributes[name] = { :type => :signature, :options => options }
  end

  def value(name, options = {})
    @attributes[name] = { :type => :value, :options => options }
  end

  def nested(name, options = {})
    form = Lib::Attributes::Parser.new
    yield form
    @attributes[name] = { :type => :nested, :options => options, :attributes => form.fetch }
  end

  def fetch
    attributes
  end
end
