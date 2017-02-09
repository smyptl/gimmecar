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

    #def parse_nested(values, settings)
      #return {} if values.blank?

      #output = {}

      #values.each do |value, setting|
        #return if value.nil?
        #typecasted_values = {}

        #setting..each do |k, v|
          #typecasted_value = typecast_attribute(value.fetch(k, nil), v.to_s)
          #typecasted_values[k] = typecasted_value unless typecasted_value.blank?
        #end
        #output << typecasted_values unless typecasted_values.blank?
      #end

      #output
    #end
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
    @attributes[name] = { :type => :nested, :options => options, :attributes => form.fetch }
  end

  def fetch
    attributes
  end
end
