class Lib::Forms::Attributes::Base

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
        Lib::Forms::Attributes::TypeCast.send(settings.fetch(:type), (value))
      end
    end

    # def parse_nested(value, settings)
    #   if settings.fetch(:options)[:array]
    #     return [] if value.blank?
    #
    #     value = value.map do |attribute|
    #       new_values = ActiveSupport::HashWithIndifferentAccess.new
    #
    #       rules.each do |name, settings|
    #         if attribute.is_a?(Hash)
    #           value = attribute[name.to_sym]
    #         else
    #           value = attribute.send(name)
    #         end
    #         new_values[name.to_sym] = parse_attribute(value, settings[:type], settings[:options])
    #       end
    #       new_values.compact.blank? ? nil : new_values
    #     end
    #     value.compact
    #   else
    #     output = []
    #     values.each do |value|
    #       return if value.nil?
    #       typecasted_values = {}
    #       rules.each do |k, v|
    #         typecasted_value = typecast_attribute(value.fetch(k, nil), v.to_s)
    #         typecasted_values[k] = typecasted_value unless typecasted_value.blank?
    #       end
    #       output << typecasted_values unless typecasted_values.blank?
    #     end unless values.blank?
    #     output
    #   end
    # end
  end

  def initialize
    @attributes = ActiveSupport::HashWithIndifferentAccess.new
  end

  def string(name, options = {})
    @attributes[name] = { :type => :string, :options => options }
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

  def nested(name, options = {})
    form = Lib::Forms::Attributes::Base.new
    yield form
    @attributes[name] = { :type => :nested, :options => options, :attributes => forms.fetch }
  end

  def fetch
    attributes
  end
end
