class Lib::Attributes::Parser

  attr_reader :attributes

  class << self
    def attribute_types(*types)
      types.each do |type|
        define_method(type) do |name, **options|
          attributes[name] = { type: type, options: options }
        end
      end
    end

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

  attribute_types :string,
                  :symbol,
                  :boolean,
                  :date,
                  :time,
                  :integer,
                  :signature,
                  :document,
                  :image,
                  :value

  def nested(name, options = {})
    form = Lib::Attributes::Parser.new
    yield form
    attributes[name] = { type: :nested, options: options, attributes: form.retrieve }
  end

  def retrieve
    attributes
  end
end
